/* CreateDate: 11/04/2015 13:41:54.497 , ModifyDate: 11/04/2015 13:41:54.497 */
GO
-- =============================================================================
-- Create date: 14 November 2011
-- Description:	Determines if the provided character is a whitespace character.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_IsWhiteSpace]
(
	@value NCHAR(1)
)
RETURNS BIT WITH SCHEMABINDING
AS
BEGIN
	IF (ASCII(@value) <> 32 AND (ASCII(@value) < 9 OR ASCII(@value) > 13) AND ASCII(@value) <> 160)
	BEGIN
		RETURN 0
	END

	RETURN 1
END
GO
