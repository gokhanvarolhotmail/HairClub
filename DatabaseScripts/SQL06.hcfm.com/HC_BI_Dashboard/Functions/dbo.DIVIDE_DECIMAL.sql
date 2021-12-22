/* CreateDate: 03/25/2019 13:45:22.740 , ModifyDate: 03/25/2019 13:45:22.740 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
