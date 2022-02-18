/* CreateDate: 03/06/2013 14:22:22.060 , ModifyDate: 03/06/2013 14:22:22.060 */
GO
--select dbo.DivideNumeric(0.15385, 0.39946)

create FUNCTION [dbo].[DivideNumeric] (@numerator numeric(20, 5), @denominator numeric(20, 5))
RETURNS numeric(38, 5) AS
BEGIN
RETURN(

CASE WHEN @denominator = 0
THEN 0
ELSE @numerator / @denominator END

)
END
GO
