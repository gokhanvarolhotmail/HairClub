/* CreateDate: 11/04/2015 13:41:54.493 , ModifyDate: 11/04/2015 13:41:54.493 */
GO
-- =============================================================================
-- Create date: 14 November 2011
-- Description:	Determines if the provided character is a letter or digit.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_IsLetterOrDigit]
(
	-- Add the parameters for the function here
	@value	NCHAR(1)
)
RETURNS BIT WITH SCHEMABINDING
AS
BEGIN
	IF (@value IN ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','1','2','3','4','5','6','7','8','9','0'))
	BEGIN
		RETURN 1
	END

	RETURN 0
END
GO
