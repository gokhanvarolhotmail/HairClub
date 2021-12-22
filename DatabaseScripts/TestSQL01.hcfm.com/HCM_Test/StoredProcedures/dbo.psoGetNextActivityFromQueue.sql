/* CreateDate: 10/28/2014 16:36:48.987 , ModifyDate: 04/13/2016 09:57:53.670 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2014-10-27
-- Description:	Select results set of candidate activities from Queue
--				Replaces GetNextActivityFromQueue logic previously done in CRM Agent
--				Eliminate expensive TimeBetween call from central select
--
--	2016-03-09	MJW - Workwise, LLC
--		Eliminate use of BOTH language_code
-- =============================================
CREATE PROCEDURE [dbo].[psoGetNextActivityFromQueue]
	@UserCode NCHAR(10),
	@QueueId NCHAR(10),
	@CallTimeEarliest DATETIME,
	@CallTimeLatest DATETIME,
	@UserTimeZoneOffset INT,
	@UserLanguageCode NCHAR(10),
	@SortBy NVARCHAR(max)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql nvarchar(max)

	--We need a temp table so we can apply the ORDER BY later
	CREATE TABLE #temp (activity_id NCHAR(10))

	IF (@QueueId = 'B1GK18X6N1') -- INTERNET HOT 11 LEADS
		INSERT INTO #temp SELECT
		activity_id FROM
		(
		SELECT oncd_activity.activity_id, dbo.TimeBetween(dbo.TimeForContact(GETDATE(), @UserTimeZoneOffset, oncd_activity.cst_time_zone_code), @CallTimeEarliest, @CallTimeLatest) isbetween
		FROM oncd_activity
		INNER JOIN oncd_activity_contact ON
			oncd_activity.activity_id = oncd_activity_contact.activity_id
		INNER JOIN oncd_contact ON
			oncd_activity_contact.contact_id = oncd_contact.contact_id
--		INNER JOIN onca_action ON
--			oncd_activity.action_code = onca_action.action_code
		WHERE
		(1=1) AND
		oncd_activity.result_code IS NULL AND oncd_activity.cst_queue_id = @QueueId AND
		(oncd_activity.cst_lock_by_user_code IS NULL OR oncd_activity.cst_lock_by_user_code = @UserCode)
		AND	oncd_contact.cst_do_not_call = 'N' AND oncd_contact.do_not_solicit = 'N'
--		AND	(oncd_contact.cst_language_code = @UserLanguageCode OR @UserLanguageCode = 'BOTH')
		AND oncd_contact.cst_language_code IN (SELECT language_code FROM csta_user_language WHERE user_code = @UserCode)
		) temp
		WHERE isbetween = 1
	ELSE --Ones just coming due
		INSERT INTO #temp SELECT
		activity_id FROM
		(
		SELECT oncd_activity.activity_id, dbo.TimeBetween(dbo.TimeForContact(GETDATE(), @UserTimeZoneOffset, oncd_activity.cst_time_zone_code), @CallTimeEarliest, @CallTimeLatest) isbetween
		FROM oncd_activity
		INNER JOIN oncd_activity_contact ON
			oncd_activity.activity_id = oncd_activity_contact.activity_id
		INNER JOIN oncd_contact ON
			oncd_activity_contact.contact_id = oncd_contact.contact_id
--		INNER JOIN onca_action ON
--			oncd_activity.action_code = onca_action.action_code
		WHERE
		(dbo.CombineDates(oncd_activity.due_date, oncd_activity.start_time) < GETDATE()) AND
		oncd_activity.result_code IS NULL AND oncd_activity.cst_queue_id = @QueueId AND
		(oncd_activity.cst_lock_by_user_code IS NULL OR oncd_activity.cst_lock_by_user_code = @UserCode)
		AND oncd_contact.cst_do_not_call = 'N' AND oncd_contact.do_not_solicit = 'N'
--		AND (oncd_contact.cst_language_code = @UserLanguageCode OR @UserLanguageCode = 'BOTH')
		AND oncd_contact.cst_language_code IN (SELECT language_code FROM csta_user_language WHERE user_code = @UserCode)
		) temp
		WHERE isbetween = 1

		--Apply ORDER BY logic which can be arbitrary
		SET @sql = 'SELECT #temp.activity_id FROM #temp
					INNER JOIN oncd_activity WITH (NOLOCK)
						ON oncd_activity.activity_id = #temp.activity_id
					INNER JOIN oncd_activity_contact WITH (NOLOCK)
						ON oncd_activity.activity_id = oncd_activity_contact.activity_id
					INNER JOIN oncd_contact WITH (NOLOCK) ON
						oncd_activity_contact.contact_id = oncd_contact.contact_id '
		SET @sql = @sql + ' ORDER BY ' + @SortBy

		EXEC (@sql)
END
GO
