/* CreateDate: 01/03/2013 10:22:39.240 , ModifyDate: 01/03/2013 10:22:39.240 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.psoIsDoNotEmail
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @DoNotEmail NCHAR(1)

	SELECT TOP 1
	@DoNotEmail = cst_do_not_email
	FROM oncd_contact
	WHERE contact_id = @ContactId

	RETURN @DoNotEmail
END
GO
