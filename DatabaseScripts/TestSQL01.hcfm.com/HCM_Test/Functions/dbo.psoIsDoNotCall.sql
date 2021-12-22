/* CreateDate: 01/03/2013 10:22:39.220 , ModifyDate: 01/03/2013 10:22:39.220 */
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.psoIsDoNotCall
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @DoNotCall NCHAR(1)

	SELECT TOP 1
	@DoNotCall = cst_do_not_call
	FROM oncd_contact
	WHERE contact_id = @ContactId

	RETURN @DoNotCall
END
GO
