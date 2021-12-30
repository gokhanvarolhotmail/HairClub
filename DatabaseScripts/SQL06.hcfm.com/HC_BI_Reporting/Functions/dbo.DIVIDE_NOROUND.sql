/* CreateDate: 08/03/2011 09:25:37.043 , ModifyDate: 11/06/2012 14:02:58.583 */
GO
SET ANSI_NULLS OFF
GO
CREATE  FUNCTION [dbo].[DIVIDE_NOROUND] (@numerator MONEY, @denominator MONEY)
RETURNS float AS
BEGIN
RETURN(

CASE WHEN @denominator = 0
THEN 0
ELSE @numerator/ @denominator END

)
END
GO
