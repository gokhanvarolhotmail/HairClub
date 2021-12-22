/* CreateDate: 11/04/2015 13:41:54.563 , ModifyDate: 11/04/2015 13:41:54.563 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Calculates the soundex for the provided last name.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_CalculateLastNameSoundex]
(
	@lastName	NVARCHAR(MAX)
)
RETURNS NCHAR(4) --WITH SCHEMABINDING
AS
BEGIN
	RETURN dbo.pso_Soundex_Calculate(@lastName, 'LAST_NAME', 1)
END
GO
