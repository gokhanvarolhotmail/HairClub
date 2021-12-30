/* CreateDate: 11/04/2015 13:41:54.560 , ModifyDate: 11/04/2015 13:41:54.560 */
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Calculates the soundex for the provided company name.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_CalculateCompanyNameSoundex]
(
	@companyName	NVARCHAR(MAX)
)
RETURNS NCHAR(20) --WITH SCHEMABINDING
AS
BEGIN
	RETURN dbo.pso_Soundex_Calculate(@companyName, 'COMPANY', 5)
END
GO
