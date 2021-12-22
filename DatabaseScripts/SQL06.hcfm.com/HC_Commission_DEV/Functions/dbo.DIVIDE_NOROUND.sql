CREATE  FUNCTION [dbo].[DIVIDE_NOROUND] (@numerator MONEY, @denominator MONEY)
RETURNS FLOAT AS
BEGIN
RETURN(
CASE WHEN @denominator = 0
THEN 0
ELSE @numerator/ @denominator END
)
END
