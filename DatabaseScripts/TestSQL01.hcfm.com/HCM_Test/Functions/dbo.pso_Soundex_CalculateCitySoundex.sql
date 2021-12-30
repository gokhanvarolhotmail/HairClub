/* CreateDate: 11/04/2015 13:41:54.560 , ModifyDate: 11/04/2015 13:41:54.560 */
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Calculates the soundex for the provided city.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_CalculateCitySoundex]
(
	@city	NVARCHAR(MAX)
)
RETURNS NCHAR(20)-- WITH SCHEMABINDING
AS
BEGIN
	RETURN dbo.pso_Soundex_Calculate(@city, 'CITY', 5)
END
GO
