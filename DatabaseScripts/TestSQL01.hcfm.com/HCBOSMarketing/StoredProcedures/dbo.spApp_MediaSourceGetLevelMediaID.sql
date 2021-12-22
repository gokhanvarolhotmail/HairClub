/* CreateDate: 06/12/2008 11:44:16.097 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
CREATE PROCEDURE spApp_MediaSourceGetLevelMediaID (
	@LevelNum		tinyint
,	@Code			varchar(10)
,	@Name			varchar(50)	)
AS
BEGIN
	IF @LevelNum = 2
		BEGIN
			SELECT
				MediaID
			FROM MediaSourceLevel02
			WHERE
				Level02LocationCode = @Code
			and Level02Location = @Name
		END
	IF @LevelNum = 3
		BEGIN
			SELECT
				MediaID
			FROM MediaSourceLevel03
			WHERE
				Level03LanguageCode = @Code
			and	Level03Language = @Name
		END
	IF @LevelNum = 4
		BEGIN
			SELECT
				MediaID
			FROM MediaSourceLevel04
			WHERE
				Level04FormatCode = @Code
			and	Level04Format = @Name
		END
END
GO
