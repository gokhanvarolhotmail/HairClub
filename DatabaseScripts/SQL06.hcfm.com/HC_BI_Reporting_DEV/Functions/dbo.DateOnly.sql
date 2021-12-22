CREATE FUNCTION [dbo].[DateOnly] (@Date datetime)
RETURNS varchar(12)
AS
BEGIN
	RETURN CONVERT(varchar(12), @Date, 101)
END
