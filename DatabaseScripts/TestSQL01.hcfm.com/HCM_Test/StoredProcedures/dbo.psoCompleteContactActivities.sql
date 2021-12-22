/* CreateDate: 01/03/2013 10:22:39.247 , ModifyDate: 01/03/2013 10:22:39.247 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 29 October 2012
-- Description:	Completes the provided Contact's Activities with the provided Action
--				to have the provided Result.
-- =============================================
CREATE PROCEDURE [dbo].[psoCompleteContactActivities]
	@ContactId	NCHAR(10),		-- The Contact owning the Activities to be processed.
	@UserCode	NCHAR(20),		-- The User to complete the Activities.
	@ActionCode NCHAR(10),		-- The Action of the Activities.
	@ResultCode NCHAR(10),		-- The Result to be set.
	@NoFollowUp NCHAR(1) = 'N'	-- The No Follow Up to be set.
AS
BEGIN
	UPDATE oncd_activity
	SET
		oncd_activity.result_code = @ResultCode,
		oncd_activity.completion_date = dbo.psoGetBaseDate(GETDATE()),
		oncd_activity.completion_time = dbo.psoGetBaseTime(GETDATE()),
		oncd_activity.completed_by_user_code = @UserCode,
		oncd_activity.updated_date = dbo.psoGetBaseDate(GETDATE()),
		oncd_activity.updated_by_user_code = @UserCode,
		oncd_activity.cst_no_followup_flag = @NoFollowUp
	WHERE
		oncd_activity.action_code = @ActionCode AND
		oncd_activity.result_code IS NULL AND
		oncd_activity.activity_id IN (
			SELECT
				oncd_activity_contact.activity_id
			FROM oncd_activity_contact
			WHERE
				oncd_activity_contact.contact_id = @ContactId AND
				oncd_activity_contact.primary_flag = 'Y')
END
GO
