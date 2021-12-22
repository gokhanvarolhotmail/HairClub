/* CreateDate: 01/03/2013 10:22:39.210 , ModifyDate: 01/03/2013 10:22:39.210 */
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.psoIsDoNotContact
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @DoNotContact NCHAR(1)

	SELECT TOP 1
	@DoNotContact = do_not_solicit
	FROM oncd_contact
	WHERE contact_id = @ContactId

	RETURN @DoNotContact
END
GO
