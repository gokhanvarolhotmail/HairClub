/* CreateDate: 07/30/2015 15:51:15.040 , ModifyDate: 07/30/2015 15:51:15.040 */
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
