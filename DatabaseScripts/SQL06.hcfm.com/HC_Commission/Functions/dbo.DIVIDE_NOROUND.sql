/* CreateDate: 03/13/2019 10:37:54.793 , ModifyDate: 03/13/2019 10:37:54.793 */
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
