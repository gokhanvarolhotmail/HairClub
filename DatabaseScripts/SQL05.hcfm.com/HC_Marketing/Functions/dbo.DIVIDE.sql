/* CreateDate: 11/16/2019 12:11:30.583 , ModifyDate: 11/16/2019 12:11:30.583 */
GO
CREATE	FUNCTION dbo.DIVIDE (@numerator NUMERIC, @denominator NUMERIC)
RETURNS FLOAT
AS
BEGIN
	DECLARE @fProduct AS FLOAT

	IF @denominator = 0
		SET @fProduct = 0
	ELSE
		SET @fProduct = (SUM(CONVERT(MONEY, @numerator)) / SUM(CONVERT(MONEY, @denominator)))

	RETURN @fProduct

END
GO
