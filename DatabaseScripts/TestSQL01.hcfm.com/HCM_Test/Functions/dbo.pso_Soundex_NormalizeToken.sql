/* CreateDate: 11/04/2015 13:41:54.537 , ModifyDate: 11/04/2015 13:41:54.537 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Create date: 14 November 2011
-- Description:	Calls the appropriate normalization routine based on the mode.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_NormalizeToken]
(
	@value NVARCHAR(MAX),
	@soundexMode NCHAR(10)
)
RETURNS NVARCHAR(MAX) WITH SCHEMABINDING
AS
BEGIN
	DECLARE @result NVARCHAR(MAX)

	SET @value = UPPER(@value)
	SET @result = @value

	IF (@soundexMode =  'FIRST_NAME')
	BEGIN
		RETURN dbo.pso_Soundex_NormalizeFirstName(@value)
	END
	ELSE IF (@soundexMode =  'COMPANY')
	BEGIN
		RETURN dbo.pso_Soundex_NormalizeCompanyName(@value)
	END
	ELSE IF (@soundexMode =  'ADDRESS')
	BEGIN
		RETURN dbo.pso_Soundex_NormalizeAddress(@value)
	END

	RETURN @result
END
GO
