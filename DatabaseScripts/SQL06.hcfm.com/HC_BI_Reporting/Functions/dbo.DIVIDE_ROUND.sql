/* CreateDate: 03/15/2021 12:27:00.027 , ModifyDate: 03/15/2021 12:27:00.027 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select dbo.DIVIDE(10,2)
CREATE FUNCTION dbo.DIVIDE_ROUND (@numerator DECIMAL(18, 2), @denominator DECIMAL(18, 2))
RETURNS DECIMAL(18, 2)
AS
BEGIN
	RETURN (CASE WHEN @denominator = 0 THEN 0 ELSE ROUND((@numerator / @denominator),0) END)
END
GO
