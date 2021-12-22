/* CreateDate: 06/09/2008 10:12:17.437 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spApp_MediaSourceMediaTypeUpdate (
	@MediaID		smallint
,	@MediaCode		varchar(50)
,	@Media			varchar(50)	)
AS
DECLARE
	@ReturnValue	int
,	@ErrorNum		int
,	@ErrorMessage	nvarchar(1000)
BEGIN
	IF EXISTS (SELECT MediaCode FROM MediaSourceMediaTypes WHERE MediaCode = @MediaCode and MediaID != @MediaID)
		BEGIN
			SET @ReturnValue = 2
			RETURN @ReturnValue
		END
	ELSE IF EXISTS (SELECT Media FROM MediaSourceMediaTypes WHERE Media = @Media and MediaID != @MediaID)
		BEGIN
			SET @ReturnValue = 3
			RETURN @ReturnValue
		END
	ELSE
		BEGIN
			BEGIN TRY
				UPDATE MediaSourceMediaTypes
				SET
					MediaCode = @MediaCode
				,	Media = @Media
				WHERE MediaID = @MediaID

				SET @ReturnValue = 0
				RETURN @ReturnValue
			END TRY

			BEGIN CATCH
				SELECT @ErrorNum = ERROR_NUMBER()
				SELECT @ErrorMessage = ERROR_MESSAGE()
				RAISERROR(@ErrorMessage, 16, 1)
				SET @ReturnValue = 1
				RETURN @ReturnValue
			END CATCH
		END
	END
GO
