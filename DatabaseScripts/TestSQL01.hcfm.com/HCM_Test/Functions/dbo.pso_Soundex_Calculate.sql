/* CreateDate: 11/04/2015 13:41:54.553 , ModifyDate: 11/04/2015 13:41:54.553 */
GO
-- =============================================
-- Create date: 10 Novemeber 2011
-- Description:	Calculates the Soundex.
-- Parameters : @source
--					The value the soundex should be calculated for.
--				@soundexMode
--					The normalization rules that should be applied when calulating the soundex.
--					Supported values are:
--						FIRST_NAME	- Contact First Name
--						LAST_NAME	- Contact Last Name
--						ADDRESS		- Contact/Company Address Line 1/2
--						CITY		- Contact/Company Address City
--						COMPANY		- Company Name 1/2
--				@numberOfTokens
--					The number of 4 chracter groups that should be returned.
-- =============================================
CREATE FUNCTION [dbo].[pso_Soundex_Calculate]
(
	@source NVARCHAR(MAX),
	@soundexMode NCHAR(10),
	@numberOfTokens INT
)
RETURNS NVARCHAR(MAX)
BEGIN
	DECLARE @token NVARCHAR(MAX)
	DECLARE @result NVARCHAR(MAX)
	DECLARE @tokenCount INT
	DECLARE @normalizedSource NVARCHAR(MAX)

	SET @result = ''
	SET @tokenCount = 0
	SET @normalizedSource = dbo.pso_Soundex_Normalize(@source, @soundexMode)

	IF (NOT (@numberOfTokens > 1))
	BEGIN
		SET @numberOfTokens = 1
		SET @normalizedSource = REPLACE(@normalizedSource, ' ', '')
		RETURN dbo.pso_Soundex_CalculateSoundex(@normalizedSource)
	END

	WHILE (LEN(@normalizedSource) > 0)
	BEGIN
		SET @normalizedSource = LTRIM(RTRIM(@normalizedSource))

		SET @token = dbo.pso_Soundex_GetToken(@normalizedSource, ' ')
		SET @normalizedSource = SUBSTRING(@normalizedSource, LEN(@token) + 1, LEN(@normalizedSource) - LEN(@token))

		SET @result = @result + dbo.pso_Soundex_CalculateSoundex(@token)
		SET @tokenCount = @tokenCount + 1

		IF (@tokenCount >= @numberOfTokens)
		BEGIN
			BREAK
		END
	END

	WHILE (LEN(@result) < 4 * @numberOfTokens)
	BEGIN
		SET @result = @result + '0'
	END

	-- Return the result of the function
	RETURN @result

END
GO
