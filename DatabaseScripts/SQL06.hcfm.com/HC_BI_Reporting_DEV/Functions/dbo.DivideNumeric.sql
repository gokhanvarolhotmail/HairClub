/* CreateDate: 01/19/2016 17:20:33.407 , ModifyDate: 01/19/2016 17:20:33.407 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select dbo.DivideNumeric(0.15385, 0.39946)

CREATE FUNCTION [dbo].[DivideNumeric] (@numerator numeric(20, 5), @denominator numeric(20, 5))
RETURNS numeric(38, 5) AS
BEGIN
RETURN(

CASE WHEN @denominator = 0
THEN 0
ELSE @numerator / @denominator END

)
END
GO
