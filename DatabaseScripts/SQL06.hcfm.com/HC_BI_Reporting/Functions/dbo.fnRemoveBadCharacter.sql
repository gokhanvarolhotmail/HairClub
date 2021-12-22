/* CreateDate: 02/07/2014 14:54:44.120 , ModifyDate: 02/07/2014 14:58:59.500 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnRemoveBadCharacter] (
	@BadString nvarchar(500) )
RETURNS nvarchar(500) AS
BEGIN
	DECLARE @nPos INTEGER
	SELECT @nPos = PATINDEX('%[^a-zA-Z0-9_]%', @BadString)
	WHILE @nPos > 0
	BEGIN
		SELECT @BadString = STUFF(@BadString, @nPos, 1, '')
		SELECT @nPos = PATINDEX('%[^a-zA-Z0-9_]%', @BadString)
	END
	RETURN @BadString
END
GO
