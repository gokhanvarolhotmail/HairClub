/* CreateDate: 07/13/2011 09:58:39.517 , ModifyDate: 07/13/2011 09:58:39.517 */
GO
-- select dbo.DIVIDE(10,2)
CREATE  FUNCTION [dbo].[DIVIDE_DECIMAL] (@numerator decimal(18,2), @denominator decimal(18,2))
RETURNS decimal(18,2) AS
BEGIN
RETURN(

CASE WHEN @denominator = 0
THEN 0
ELSE @numerator / @denominator END

)
END
GO
