/* CreateDate: 11/04/2015 13:41:54.483 , ModifyDate: 11/04/2015 13:41:54.483 */
GO
-- =============================================================================
-- Create date: 10 November 2011
-- Description:	Gets the token prior to the separator.
-- =============================================================================
CREATE FUNCTION [dbo].[pso_Soundex_GetToken]
(
	@value NVARCHAR(MAX),
	@separator NCHAR(1)
)
RETURNS NVARCHAR(MAX) WITH SCHEMABINDING
AS
BEGIN
	DECLARE @position INT
	DECLARE @result NVARCHAR(MAX)

	SET @position = CHARINDEX(@separator, @value)

	IF (@position > 0)
	BEGIN
		SET @result = SUBSTRING(@value, 0, @position)
	END
	ELSE
	BEGIN
		SET @result = @value
	END

	RETURN @result
END
GO
