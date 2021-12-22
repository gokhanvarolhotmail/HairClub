/* CreateDate: 06/10/2008 11:58:05.830 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceLevelsDeleteMedia] (
	@LevelNum		tinyint
,	@Code			varchar(10)
,	@Name			varchar(50)
,	@MediaID		smallint	)
AS
BEGIN
	IF @LevelNum = 2
		BEGIN
			DELETE
			FROM MediaSourceLevel02
			WHERE
				Level02LocationCode = @Code
			and	Level02Location = @Name
			and MediaID = @MediaID
		END
	IF @LevelNum = 3
		BEGIN
			DELETE
			FROM MediaSourceLevel03
			WHERE
				Level03LanguageCode = @Code
			and	Level03Language = @Name
			and MediaID = @MediaID
		END
	IF @LevelNum = 4
		BEGIN
			DELETE
			FROM MediaSourceLevel04
			WHERE
				Level04FormatCode = @Code
			and Level04Format = @Name
			and MediaID = @MediaID
		END
	END
GO
