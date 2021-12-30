/* CreateDate: 10/03/2019 23:03:43.073 , ModifyDate: 10/03/2019 23:03:43.073 */
GO
create  FUNCTION [dbo].[DIVIDE] (@numerator numeric, @denominator numeric)
RETURNS float

AS

	BEGIN
		DECLARE @fProduct AS FLOAT

		IF  @denominator = 0
			SET @fProduct = 0
		ELSE
			SET @fProduct = (SUM(CONVERT(money, @numerator)) / SUM(CONVERT(money, @denominator)))

		RETURN @fProduct

	END
GO
