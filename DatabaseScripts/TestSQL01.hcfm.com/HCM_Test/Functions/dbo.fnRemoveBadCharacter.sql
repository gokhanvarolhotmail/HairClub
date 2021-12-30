/* CreateDate: 06/05/2013 08:42:06.667 , ModifyDate: 06/05/2013 08:42:06.667 */
GO
CREATE FUNCTION [dbo].[fnRemoveBadCharacter] (
	@BadString nvarchar(500) )
RETURNS nvarchar(20) AS
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
