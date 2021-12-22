/* CreateDate: 10/05/2012 08:55:03.770 , ModifyDate: 10/05/2012 14:21:23.087 */
GO
CREATE FUNCTION [dbo].[DateODBC] (@Date datetime)
RETURNS varchar(20)
AS
BEGIN
	RETURN CONVERT(varchar(20), @Date, 120)
END
GO
