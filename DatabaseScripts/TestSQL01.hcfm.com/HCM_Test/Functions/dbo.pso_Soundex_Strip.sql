/* CreateDate: 11/04/2015 13:41:54.510 , ModifyDate: 11/04/2015 13:41:54.510 */
GO
-- =============================================================================
-- Create date: 14 November 2011
-- Description:	Removes dashes and adjacent whitespace characters from the provided value.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_Strip]
(
	@value	NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX) WITH SCHEMABINDING
AS
BEGIN
	DECLARE @lsb	NVARCHAR(MAX)
	DECLARE @li_tot	INT
	SET @li_tot = LEN(@value)
	DECLARE @li_cur INT
	DECLARE @lb_lastCharIsSpace bit
	DECLARE @lchar NCHAR

	SET @li_cur = 1
	SET @lsb = ''

	WHILE (@li_cur <= @li_tot)
	BEGIN
		SET @lchar = SUBSTRING(@value, @li_cur, 1)
		SET @li_cur = @li_cur + 1

		IF (@lchar = '-' OR dbo.pso_Soundex_IsWhiteSpace(@lchar) = 1)
		BEGIN
			SET @lchar = ' '
		END

		IF (@lchar = ' ')
		BEGIN
			IF (@lb_lastCharIsSpace = 1)
			BEGIN
				CONTINUE
			END

			SET @lb_lastCharIsSpace = 1
			SET @lsb = @lsb + ' '
			CONTINUE
		END

		SET @lb_lastCharIsSpace = 0
		IF (dbo.pso_Soundex_IsLetterOrDigit(@lchar) = 1)
		BEGIN
			SET @lsb = @lsb + @lchar
		END
	END

	RETURN @lsb

END
GO
