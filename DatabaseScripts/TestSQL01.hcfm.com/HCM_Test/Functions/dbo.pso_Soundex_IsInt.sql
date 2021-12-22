/* CreateDate: 11/04/2015 13:41:54.463 , ModifyDate: 11/04/2015 13:41:54.463 */
GO
-- =============================================================================
-- Create date: 14 November 2011
-- Description:	Determines if the provided value is an integer
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_IsInt]
(
	@value NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
	IF (ISNUMERIC(@value) = 0)
	BEGIN
		RETURN 0
	END

	DECLARE @char NCHAR(1)
	DECLARE @index INT
	SET @index = 1

	WHILE (@index < LEN(@value))
	BEGIN
		SET @char = SUBSTRING(@value, @index, 1)
		SET @index = @index + 1

		IF (dbo.pso_Soundex_IsInt(@char)= 0)
		BEGIN
			RETURN 0
		END

	END

	RETURN 1
END
GO
