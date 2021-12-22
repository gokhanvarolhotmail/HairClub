/* CreateDate: 05/12/2014 16:47:32.850 , ModifyDate: 05/28/2018 22:05:17.230 */
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessClientUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		5/09/14

LAST REVISION DATE: 	5/09/14

--------------------------------------------------------------------------------------------------------
NOTES: 	Update Client record as part of Bosley import.
	* 05/09/14 SAL - Created
	* 05/23/18 MVT - Updated to also update Client EMail if we don't have one specified on the client record.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

DECLARE @IsSuccessfullyProcessed bit = 0
exec [extBosleyProcessClientUpdate] 123456789, @IsSuccessfullyProcessed OUTPUT
***********************************************************************/
CREATE PROCEDURE [dbo].[extBosleyProcessClientUpdate]
	@CurrentTransactionIdBeingProcessed INT,
	@IsSuccessfullyProcessed BIT OUTPUT

AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @User nvarchar(10) = 'Bosley'

		IF EXISTS (SELECT *
			FROM datIncomingRequestLog irl
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed)
		BEGIN
			DECLARE @ConectId int
			DECLARE @ProcedureOffice nvarchar(50)
			DECLARE @ConsultOffice nvarchar(50)
			DECLARE @EmailAddress nvarchar(100)

			SELECT @ConectId = irl.ConectId,
					@ProcedureOffice = irl.ProcedureOffice,
					@ConsultOffice = irl.ConsultOffice,
					@EmailAddress = irl.EmailAddress
			FROM datIncomingRequestLog irl
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			IF @ConectId IS NOT NULL
			BEGIN
				IF EXISTS(SELECT *
					FROM datClient c
					WHERE c.ClientIdentifier = @ConectId)
				BEGIN
					UPDATE c
						SET BosleyProcedureOffice = @ProcedureOffice
							,BosleyConsultOffice = @ConsultOffice
							,EmailAddress = CASE WHEN c.EmailAddress IS NULL OR c.EmailAddress = '' THEN @EmailAddress ELSE EmailAddress END
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = @User
					FROM datClient c
					WHERE c.ClientIdentifier = @ConectId

					SET @IsSuccessfullyProcessed = 1
				END
			END
		END

		ELSE
		BEGIN
			SET @IsSuccessfullyProcessed = 0
		END

	END TRY

	BEGIN CATCH
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = Error_Procedure() + ':' + Error_Message()
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END CATCH

END
GO
