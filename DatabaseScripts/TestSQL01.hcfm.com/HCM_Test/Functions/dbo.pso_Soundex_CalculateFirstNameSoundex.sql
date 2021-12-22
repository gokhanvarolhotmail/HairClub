/* CreateDate: 11/04/2015 13:41:54.587 , ModifyDate: 11/04/2015 13:41:54.587 */
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Calculates the soundex for the provided first name.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_CalculateFirstNameSoundex]
(
	@firstName	NVARCHAR(MAX)
)
RETURNS NCHAR(4) --WITH SCHEMABINDING
AS
BEGIN
	RETURN dbo.pso_Soundex_Calculate(@firstName, 'FIRST_NAME', 1)
END
GO
