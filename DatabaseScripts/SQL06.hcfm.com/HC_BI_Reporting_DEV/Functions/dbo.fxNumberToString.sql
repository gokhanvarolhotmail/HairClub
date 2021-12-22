CREATE FUNCTION [dbo].[fxNumberToString] (
	@Number INT)
RETURNS varchar(120)
AS
BEGIN
	RETURN SUBSTRING(CONVERT(VARCHAR, CAST(@Number AS MONEY), 1), 1, LEN(CONVERT(VARCHAR, CAST(@Number AS MONEY), 1)) - 3)
END
