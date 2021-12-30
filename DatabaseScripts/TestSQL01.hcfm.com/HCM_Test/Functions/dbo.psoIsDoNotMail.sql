/* CreateDate: 01/03/2013 10:22:39.243 , ModifyDate: 01/03/2013 10:22:39.243 */
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.psoIsDoNotMail
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @DoNotMail NCHAR(1)

	SELECT TOP 1
	@DoNotMail = cst_do_not_mail
	FROM oncd_contact
	WHERE contact_id = @ContactId

	RETURN @DoNotMail
END
GO
