-- select dbo.DIVIDE(10,2)
CREATE  FUNCTION [dbo].[DIVIDE_DECIMAL] (@numerator DECIMAL(18,2), @denominator DECIMAL(18,2))
RETURNS DECIMAL(18,2) AS
BEGIN
RETURN(

CASE WHEN @denominator = 0
THEN 0
ELSE @numerator / @denominator END

)
END
