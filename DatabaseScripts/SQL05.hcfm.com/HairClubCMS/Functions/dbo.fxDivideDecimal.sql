/* CreateDate: 02/27/2017 09:26:24.387 , ModifyDate: 02/27/2017 09:26:24.387 */
GO
-- select dbo.DIVIDE(10,2)
CREATE  FUNCTION [dbo].[fxDivideDecimal] (@numerator decimal(18,2), @denominator decimal(18,2)) RETURNS decimal(18,2) AS
BEGIN
	RETURN(
		CASE WHEN @denominator = 0
		THEN 0
		ELSE @numerator / @denominator END
	)
END
GO
