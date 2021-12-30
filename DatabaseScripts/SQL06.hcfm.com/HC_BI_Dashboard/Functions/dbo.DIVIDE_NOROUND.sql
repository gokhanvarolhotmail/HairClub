/* CreateDate: 03/25/2019 13:45:18.243 , ModifyDate: 03/25/2019 13:45:18.243 */
GO
SET ANSI_NULLS OFF
GO
CREATE  FUNCTION [dbo].[DIVIDE_NOROUND] (@numerator MONEY, @denominator MONEY)
RETURNS FLOAT AS
BEGIN
RETURN(

CASE WHEN @denominator = 0
THEN 0
ELSE @numerator/ @denominator END

)
END
GO
