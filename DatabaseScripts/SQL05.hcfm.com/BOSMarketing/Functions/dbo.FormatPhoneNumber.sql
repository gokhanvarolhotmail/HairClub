/* CreateDate: 07/30/2015 15:51:14.903 , ModifyDate: 07/30/2015 15:51:14.903 */
GO
CREATE FUNCTION [dbo].[FormatPhoneNumber] (
	@Phone			varchar(10)	)
RETURNS varchar(14)
AS
BEGIN
	RETURN '(' + SUBSTRING(@Phone, 1, 3) + ') ' + SUBSTRING(@Phone, 4, 3) + '-' + SUBSTRING(@Phone, 7, 4)
END
GO
