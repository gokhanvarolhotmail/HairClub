/* CreateDate: 11/04/2015 13:41:54.500 , ModifyDate: 11/04/2015 13:41:54.500 */
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Calculates the soundex for the provided value.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_CalculateSoundex]
(
	@value NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX) WITH SCHEMABINDING
AS
BEGIN
	DECLARE @result NVARCHAR(MAX)
	DECLARE @character	NCHAR(1)
	DECLARE @soundexDigit NCHAR(1)
	DECLARE @previousDigit NCHAR(1)
	DECLARE @index INT
	DECLARE @digitIndex INT

	IF (LEN(@value) = 0)
	BEGIN
		RETURN '0000'
	END

	SET @previousDigit = '1'
	SET @result = ' '
	Set @digitIndex = -1
	SET @index = 1

	WHILE (@index <= LEN(@value))
	BEGIN
		SET @character = SUBSTRING(@value, @index, 1)
		SET @index = @index + 1

		IF (@character IN ('B','F','P','V'))
		BEGIN
			SET @soundexDigit = '1'
		END
		ELSE IF (@character IN ('C','G','J','K','Q','S','X','Z'))
		BEGIN
			SET @soundexDigit = '2'
		END
		ELSE IF (@character IN ('D','T'))
		BEGIN
			SET @soundexDigit = '3'
		END
		ELSE IF (@character IN ('L'))
		BEGIN
			SET @soundexDigit = '4'
		END
		ELSE IF (@character IN ('M','N'))
		BEGIN
			SET @soundexDigit = '5'
		END
		ELSE IF (@character IN ('R'))
		BEGIN
			SET @soundexDigit = '6'
		END
		ELSE
		BEGIN
			SET @soundexDigit = '0'
		END

		IF (@digitIndex = -1)
		BEGIN
			SET @result = @character
			SET @digitIndex = @digitIndex + 1
			SET @previousDigit = @soundexDigit

			CONTINUE
		END

		IF (@soundexDigit = @previousDigit)
		BEGIN
			CONTINUE
		END

		SET @previousDigit = @soundexDigit

		IF (@soundexDigit = '0')
		BEGIN
			CONTINUE
		END

		SET @digitIndex = @digitIndex + 1

		SET @result = @result + @soundexDigit

		IF (@digitIndex > 3)
		BEGIN
			BREAK
		END
	END

	-- Return the result of the function
	RETURN SUBSTRING(LTRIM(RTRIM(@result)) + '0000', 1, 4)
END
GO
