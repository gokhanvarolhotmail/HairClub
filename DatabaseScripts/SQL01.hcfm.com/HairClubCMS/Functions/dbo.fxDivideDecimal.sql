/* CreateDate: 10/04/2010 12:09:07.770 , ModifyDate: 02/27/2017 09:49:37.987 */
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
