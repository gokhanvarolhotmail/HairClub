/* CreateDate: 01/03/2013 10:22:39.250 , ModifyDate: 01/03/2013 10:22:39.250 */
GO
-- =============================================
-- Create date: 30 October 2012
-- Description:	Implements the business rules associated with a Do Not Call Result.
-- =============================================
CREATE PROCEDURE [dbo].[psoProcessDoNotCallResult]
	@ContactId	NCHAR(10),	-- The Contact assigned to the Activity.
	@UserCode	NCHAR(20)	-- The User who completed the Activity.
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Message NVARCHAR(MAX)
	SET @Message = 'Contact ''' + @ContactId + ''' resulted as Do Not Call.'
	EXEC psoLog @Message

	UPDATE oncd_contact
	SET
		cst_do_not_call = 'Y',
		updated_by_user_code = @UserCode,
		updated_date = dbo.psoGetBaseDate(GETDATE())
	WHERE
		contact_id = @ContactId

	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'OUTCALL', 'NOCALL'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'BROCHCALL', 'NOCALL'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'CANCELCALL', 'NOCALL'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'NOSHOWCALL', 'NOCALL'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'CONFIRM', 'NOCALL'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'OUTSELECT', 'NOCALL'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'SHNOBUYCAL', 'NOCALL'

END
GO
