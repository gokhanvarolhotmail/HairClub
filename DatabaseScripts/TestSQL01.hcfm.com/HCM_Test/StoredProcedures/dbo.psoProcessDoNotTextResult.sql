/* CreateDate: 01/03/2013 10:22:39.253 , ModifyDate: 01/03/2013 10:22:39.253 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 30 October 2012
-- Description:	Implements the business rules associated with a Do Not Text Result.
-- =============================================
CREATE PROCEDURE [dbo].[psoProcessDoNotTextResult]
	@ContactId	NCHAR(10),	-- The Contact assigned to the Activity.
	@UserCode	NCHAR(20)	-- The User who completed the Activity.
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Message NVARCHAR(MAX)
	SET @Message = 'Contact ''' + @ContactId + ''' resulted as Do Not Text.'
	EXEC psoLog @Message

	UPDATE oncd_contact
	SET
		cst_do_not_text = 'Y',
		updated_by_user_code = @UserCode,
		updated_date = dbo.psoGetBaseDate(GETDATE())
	WHERE
		contact_id = @ContactId
END
GO
