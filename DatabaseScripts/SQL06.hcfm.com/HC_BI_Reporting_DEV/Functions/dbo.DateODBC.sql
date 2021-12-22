CREATE FUNCTION [dbo].[DateODBC] (@Date datetime)
RETURNS varchar(20)
AS
BEGIN
	RETURN CONVERT(varchar(20), @Date, 120)
END
