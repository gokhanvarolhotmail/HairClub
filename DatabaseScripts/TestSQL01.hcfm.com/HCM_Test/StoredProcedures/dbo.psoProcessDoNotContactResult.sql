/* CreateDate: 01/03/2013 10:22:39.303 , ModifyDate: 01/03/2013 10:22:39.303 */
GO
-- =============================================
-- Create date: 30 October 2012
-- Description:	Implements the business rules associated with a Do Not Contact Result.
-- =============================================
CREATE PROCEDURE [dbo].[psoProcessDoNotContactResult]
	@ContactId	NCHAR(10),	-- The Contact assigned to the Activity.
	@UserCode	NCHAR(20)	-- The User who completed the Activity.
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Message NVARCHAR(MAX)

	SET @Message = 'Contact ''' + @ContactId + ''' resulted as Do Not Contact.'

	EXEC psoLog @Message

	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'OUTCALL', 'NOCONTACT'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'BROCHCALL', 'NOCONTACT'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'CANCELCALL', 'NOCONTACT'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'NOSHOWCALL', 'NOCONTACT'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'CONFIRM', 'NOCONTACT'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'OUTSELECT', 'NOCONTACT'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'SHNOBUYCAL', 'NOCONTACT'

END
GO
