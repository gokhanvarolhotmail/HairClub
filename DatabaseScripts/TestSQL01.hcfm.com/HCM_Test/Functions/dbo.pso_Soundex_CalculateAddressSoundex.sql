/* CreateDate: 11/04/2015 13:41:54.563 , ModifyDate: 11/04/2015 13:41:54.563 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Calculates the soundex for the provided address line.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_CalculateAddressSoundex]
(
	@address	NVARCHAR(MAX)
)
RETURNS NCHAR(20)
AS
BEGIN
	RETURN dbo.pso_Soundex_Calculate(@address, 'ADDRESS', 5)
END
GO
