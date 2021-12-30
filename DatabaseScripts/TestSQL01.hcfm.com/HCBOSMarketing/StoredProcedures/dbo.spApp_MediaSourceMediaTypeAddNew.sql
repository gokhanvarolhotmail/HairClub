/* CreateDate: 06/09/2008 09:37:32.930 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
CREATE PROCEDURE spApp_MediaSourceMediaTypeAddNew (
	@MediaCode		varchar(50)
,	@Media			varchar(50)	)
AS
DECLARE
	@ReturnValue	int
,	@ErrorNum		int
,	@ErrorMessage	nvarchar(1000)
BEGIN
	IF EXISTS (SELECT MediaCode FROM MediaSourceMediaTypes WHERE MediaCode = @MediaCode)
		BEGIN
			SET @ReturnValue = 2
			RETURN @ReturnValue
		END
	ELSE IF EXISTS (SELECT Media FROM MediaSourceMediaTypes WHERE Media = @Media)
		BEGIN
			SET @ReturnValue = 3
			RETURN @ReturnValue
		END
	ELSE
		BEGIN
			BEGIN TRY
				INSERT INTO MediaSourceMediaTypes (
					MediaCode
				,	Media	)
				VALUES (
					@MediaCode
				,	@Media	)
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
