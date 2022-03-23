/* CreateDate: 02/23/2022 09:44:18.210 , ModifyDate: 02/23/2022 09:44:18.210 */
GO
CREATE FUNCTION [dbo].[DIVIDE_DECIMAL_Inline]( @numerator DECIMAL(18, 2), @denominator DECIMAL(18, 2))
RETURNS TABLE
AS
RETURN
SELECT CAST(CASE WHEN @denominator = 0 THEN 0 ELSE @numerator / @denominator END AS DECIMAL(18, 2)) AS [OutVal] ;
GO
