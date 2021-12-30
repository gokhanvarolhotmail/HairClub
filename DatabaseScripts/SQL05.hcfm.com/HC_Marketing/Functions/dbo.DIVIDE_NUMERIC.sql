/* CreateDate: 11/16/2019 12:11:04.170 , ModifyDate: 11/16/2019 12:11:04.170 */
GO
CREATE	FUNCTION dbo.DIVIDE_NUMERIC (@numerator NUMERIC(20, 5), @denominator NUMERIC(20, 5))
RETURNS NUMERIC(38, 5)
AS
BEGIN
	RETURN (CASE WHEN @denominator = 0 THEN 0 ELSE @numerator / @denominator END)
END
GO
