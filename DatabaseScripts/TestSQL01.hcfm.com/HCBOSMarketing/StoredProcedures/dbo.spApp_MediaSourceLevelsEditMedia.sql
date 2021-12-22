/* CreateDate: 10/09/2008 16:11:07.217 , ModifyDate: 01/25/2010 08:13:27.387 */
GO
-- EXEC spApp_MediaSourceLevelsEditMedia 4, 'nweb type', 'new web type', 9, 'nweb type', 'new web type'

CREATE PROCEDURE [dbo].[spApp_MediaSourceLevelsEditMedia] (
	@LevelNum		tinyint
,	@Code			varchar(20)
,	@Name			varchar(50)
,	@MediaID		SMALLINT
,	@OldCode		VARCHAR(20)
,	@OldName		VARCHAR(50)	)
AS
BEGIN
	IF @LevelNum = 2
		BEGIN
			IF NOT EXISTS (
				SELECT Level02ID
				FROM MediaSourceLevel02
				WHERE
					Level02LocationCode = @OldCode
				and	Level02Location = @OldName
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
			UPDATE [MediaSourceLevel02]
			SET [Level02Location] = @Name
			,	[Level02LocationCode] = @Code
			WHERE
				[Level02Location] = @OldName
			AND [Level02LocationCode] = @OldCode
		END
	IF @LevelNum = 3
		BEGIN
			IF NOT EXISTS (
				SELECT Level03ID
				FROM MediaSourceLevel03
				WHERE
					Level03LanguageCode = @OldCode
				and Level03Language = @OldName
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
			UPDATE [MediaSourceLevel03]
			SET [Level03Language] = @Name
			,	[Level03LanguageCode] = @Code
			WHERE
				[Level03Language] = @OldName
			and	[Level03LanguageCode] = @OldCode
		END
	IF @LevelNum = 4
		BEGIN
			IF NOT EXISTS (
				SELECT Level04ID
				FROM MediaSourceLevel04
				WHERE
					Level04FormatCode = @OldCode
				and	Level04Format = @OldName
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
		UPDATE [MediaSourceLevel04]
		SET [Level04Format] = @Name
		,	[Level04FormatCode] = @Code
		WHERE
			Level04FormatCode = @OldCode
			and	Level04Format = @OldName
		END
	END
GO
