/* CreateDate: 01/03/2013 10:22:39.237 , ModifyDate: 01/03/2013 10:22:39.237 */
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.psoIsDoNotText
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @DoNotText NCHAR(1)

	SELECT TOP 1
	@DoNotText = cst_do_not_text
	FROM oncd_contact
	WHERE contact_id = @ContactId

	RETURN @DoNotText
END
GO
