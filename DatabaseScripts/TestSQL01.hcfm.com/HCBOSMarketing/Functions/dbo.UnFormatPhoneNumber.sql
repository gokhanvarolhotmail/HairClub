/* CreateDate: 06/06/2008 12:41:21.663 , ModifyDate: 06/06/2008 12:41:21.663 */
GO
CREATE FUNCTION [dbo].[UnFormatPhoneNumber] (
	@Phone			varchar(14)	)
RETURNS varchar(10)
AS
BEGIN
	SET @Phone = REPLACE(@Phone, '(', '')
	SET @Phone = REPLACE(@Phone, ')', '')
	SET @Phone = REPLACE(@Phone, ' ', '')
	SET @Phone = REPLACE(@Phone, '-', '')
	RETURN @Phone
END
GO
