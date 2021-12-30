/* CreateDate: 06/10/2008 13:45:15.177 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceLevelsAddMedia] (
	@LevelNum		tinyint
,	@Code			varchar(10)
,	@Name			varchar(50)
,	@MediaID		smallint	)
AS
BEGIN
	IF @LevelNum = 2
		BEGIN
			IF NOT EXISTS (
				SELECT Level02ID
				FROM MediaSourceLevel02
				WHERE
					Level02LocationCode = @Code
				and	Level02Location = @Name
				and MediaID = @MediaID)
			BEGIN
				INSERT INTO MediaSourceLevel02 (
					Level02LocationCode
				,	Level02Location
				,	MediaID	)
				VALUES	(
					@Code
				,	@Name
				,	@MediaID	)
			END
		END
	IF @LevelNum = 3
		BEGIN
			IF NOT EXISTS (
				SELECT Level03ID
				FROM MediaSourceLevel03
				WHERE
					Level03LanguageCode = @Code
				and Level03Language = @Name
				and MediaID = @MediaID)
			BEGIN
				INSERT INTO MediaSourceLevel03 (
					Level03LanguageCode
				,	Level03Language
				,	MediaID	)
				VALUES	(
					@Code
				,	@Name
				,	@MediaID	)
			END
		END
	IF @LevelNum = 4
		BEGIN
			IF NOT EXISTS (
				SELECT Level04ID
				FROM MediaSourceLevel04
				WHERE
					Level04FormatCode = @Code
				and	Level04Format = @Name
				and	MediaID = @MediaID)
			BEGIN
				INSERT INTO MediaSourceLevel04 (
					Level04FormatCode
				,	Level04Format
				,	MediaID	)
				VALUES	(
					@Code
				,	@Name
				,	@MediaID	)
			END
		END
	END
GO
