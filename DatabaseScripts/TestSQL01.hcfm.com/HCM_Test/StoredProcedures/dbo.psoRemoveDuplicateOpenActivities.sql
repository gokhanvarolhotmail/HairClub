/* CreateDate: 01/03/2013 10:22:39.260 , ModifyDate: 03/14/2013 12:26:06.607 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[psoRemoveDuplicateOpenActivities]
	@ContactId NCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ActionCode NCHAR(10)
	DECLARE @Count		INT

	DECLARE actionCursor CURSOR FOR
		SELECT oncd_activity.action_code, COUNT(DISTINCT oncd_activity.activity_id)
		FROM oncd_contact WITH (NOLOCK)
		INNER JOIN oncd_activity_contact WITH (NOLOCK) ON
			oncd_contact.contact_id = oncd_activity_contact.contact_id
		INNER JOIN oncd_activity WITH (NOLOCK) ON
			oncd_activity_contact.activity_id = oncd_activity.activity_id
		WHERE
		oncd_contact.contact_id = @ContactId AND
		oncd_activity.result_code IS NULL AND
		oncd_activity.action_code NOT IN ('APPOINT')
		GROUP BY oncd_activity.action_code
		HAVING COUNT(DISTINCT oncd_activity.activity_id) > 1

	OPEN actionCursor

	FETCH NEXT FROM actionCursor
	INTO @ActionCode, @Count

	WHILE @@FETCH_STATUS = 0
	BEGIN

		WHILE (@Count > 1)
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
			VALUES ('Remove Activity', 'Removing: ' + @ActionCode)

			DELETE FROM oncd_activity
			WHERE activity_id =
			(	SELECT TOP 1 oncd_activity.activity_id
				FROM oncd_activity WITH (NOLOCK)
				INNER JOIN oncd_activity_contact WITH (NOLOCK) ON
					oncd_activity.activity_id = oncd_activity_contact.activity_id
				WHERE
					oncd_activity.action_code = @ActionCode AND
					oncd_activity.result_code IS NULL AND
					oncd_activity_contact.contact_id = @ContactId
				ORDER BY oncd_activity.creation_date ASC)

			SET @Count = @Count - 1
		END

		FETCH NEXT FROM actionCursor
		INTO @ActionCode, @Count
	END
	CLOSE actionCursor
	DEALLOCATE actionCursor

END
GO
