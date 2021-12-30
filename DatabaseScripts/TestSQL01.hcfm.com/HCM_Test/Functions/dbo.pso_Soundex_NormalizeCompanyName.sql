/* CreateDate: 11/04/2015 13:41:54.503 , ModifyDate: 11/04/2015 13:41:54.503 */
GO
-- =============================================
-- Create date: 14 November 2011
-- Description:	Uses onca_company_normalization to normalize the Company Name.
-- =============================================
CREATE FUNCTION [dbo].[pso_Soundex_NormalizeCompanyName]
(
	@value NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX) WITH SCHEMABINDING
AS
BEGIN
	DECLARE @result NVARCHAR(MAX)
	DECLARE @count	INT

	SET @value = UPPER(RTRIM(@value))

	SET @count = (SELECT COUNT(1) FROM dbo.onca_company_normalization WHERE abbreviation = @value)

	IF (@count = 0)
	BEGIN
		SET @result = @value
	END
	ELSE
	BEGIN
		SET @result = (SELECT UPPER(RTRIM(MAX(full_word))) FROM dbo.onca_company_normalization WHERE abbreviation = @value)
	END

	IF (@result IS NULL)
	BEGIN
		SET @result = ''
	END

	-- Return the result of the function
	RETURN @result

END
GO
