/* CreateDate: 08/03/2011 09:25:14.267 , ModifyDate: 08/03/2011 09:25:14.267 */
GO
SET ANSI_NULLS OFF
GO
CREATE  FUNCTION [dbo].[DIVIDE_NOROUND] (@numerator smallmoney, @denominator smallmoney)
RETURNS float AS
BEGIN
RETURN(

CASE WHEN @denominator = 0
THEN 0
ELSE @numerator/ @denominator END

)
END
GO
