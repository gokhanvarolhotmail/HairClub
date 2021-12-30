/* CreateDate: 11/04/2015 13:41:54.547 , ModifyDate: 11/04/2015 13:41:54.547 */
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Applies the normalization rules to the provided value.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_Normalize]
(
	@value	NVARCHAR(MAX),
	@soundexMode		NCHAR(10)
)
RETURNS NVARCHAR(MAX) --WITH SCHEMABINDING
AS
BEGIN
	DECLARE @length INT
	DECLARE @source NVARCHAR(MAX)
	DECLARE @str1 NVARCHAR(MAX)
	DECLARE @str2 NVARCHAR(MAX)
	DECLARE @ls_prev NVARCHAR(MAX)
	DECLARE @lb_num BIT
	DECLARE @lsb NVARCHAR(MAX)
	SET @lsb = ''
	SET @str1 = ''
	SET @ls_prev = ''

	SET @source = dbo.pso_Soundex_Strip(@value)

	SET @length = LEN(@value)

	IF (@length < 2)
	BEGIN
		RETURN ''
	END

	WHILE (LEN(@source) > 0)
	BEGIN
		SET @str1 = LTRIM(RTRIM(dbo.pso_Soundex_GetToken(@source, ' ')))
		SET @source = LTRIM(SUBSTRING(@source, LEN(@str1) + 1, LEN(@source) - LEN(@str1)))

		IF (LEN(@str1) = 1)
		BEGIN
			SET @lb_num = 0
			CONTINUE
		END

		IF (dbo.pso_Soundex_IsInt(@str1) = 1)
		BEGIN
			SET @lb_num = 1
			CONTINUE
		END

		IF (@str1 IN ('ST','ND','RD','TH'))
		BEGIN
			IF (@lb_num = 1)
			BEGIN
				SET @lsb = @lsb + ' ' + @ls_prev + @str1
				SET @lb_num = 0
				CONTINUE
			END
		END
		SET @lb_num = 0

		SET @str2 = dbo.pso_Soundex_NormalizeToken(@str1, @soundexMode)

		IF (@str2 = '')
		BEGIN
			CONTINUE
		END

		SET @lsb = @lsb + ' ' + @str2
		SET @ls_prev = @str1
	END

	SET @str1 = LTRIM(RTRIM(@lsb))

	IF (@str1 = '')
	BEGIN
		SET @str1 = UPPER(SUBSTRING(@value, 1, 1))
	END

	RETURN @str1
END
GO
