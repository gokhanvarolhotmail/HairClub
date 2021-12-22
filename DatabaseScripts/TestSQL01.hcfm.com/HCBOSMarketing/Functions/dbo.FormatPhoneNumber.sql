/* CreateDate: 06/05/2008 14:01:48.973 , ModifyDate: 06/05/2008 14:01:48.973 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.FormatPhoneNumber (
	@Phone			varchar(10)	)
RETURNS varchar(14)
AS
BEGIN
	RETURN '(' + SUBSTRING(@Phone, 1, 3) + ') ' + SUBSTRING(@Phone, 4, 3) + '-' + SUBSTRING(@Phone, 7, 4)
END
GO
