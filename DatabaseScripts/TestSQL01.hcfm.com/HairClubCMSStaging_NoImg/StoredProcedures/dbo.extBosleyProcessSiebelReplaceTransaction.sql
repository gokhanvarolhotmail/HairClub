/* CreateDate: 11/05/2013 10:45:09.490 , ModifyDate: 03/09/2020 15:11:19.530 */
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessSiebelReplaceTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		11/04/13

LAST REVISION DATE: 	11/04/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Siebel Replace transactions sent by Bosley.
	* 11/04/13 MVT - Created
	* 10/20/15 MVT - Modified process to handle Siebel ID updates in OnContact
	* 11/10/15 MVT - Updated to use stored procs in OnContact to Get Siebel ID and to Update SiebelID
	* 05/24/2018 MVT - Added logic to update email if sent by Bosley.
	* 09/10/2019 MVT - Removed logic to update OnContact with new Siebel ID (TFS #13032).
	* 10/02/2019 SAL - Updated to removed commented out code that is referencing OnContact and synonyms
						being deleted (TFS #13144)
	* 01/23/20 MVT - Updated to modify Bosley SF Account ID instead of Siebel ID (TFS #13773)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

DECLARE @IsSuccessfullyProcessed bit
exec [extBosleyProcessSiebelReplaceTransaction] 48773,50165, @IsSuccessfullyProcessed OUTPUT
Print @IsSuccessfullyProcessed

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessSiebelReplaceTransaction]
	  @CurrentTransactionIdBeingProcessed INT = NULL,
	  @IncomingRequestID INT = NULL,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS

SET NOCOUNT ON;

DECLARE @User nvarchar(10) = 'Bosley-SU'

BEGIN TRANSACTION

	BEGIN TRY

		DECLARE @NewSiebelID nvarchar(15)
		DECLARE @CurrentSiebelID nvarchar(15)
		DECLARE @ClientIdentifier int
		DECLARE @IsRealTimeRequest bit
		DECLARE @EmailAddress nvarchar(100)
		DECLARE @BosleySalesforceAccountID nvarchar(50)

		SELECT @NewSiebelID = irl.SiebelID,
				@CurrentSiebelID = c.SiebelID,
				@ClientIdentifier = irl.ConectID,
				@IsRealTimeRequest = ISNULL(irl.IsRealTimeRequest,0),
				@EmailAddress = irl.EmailAddress,
				@BosleySalesforceAccountID = irl.BosleySalesforceAccountID
			FROM datIncomingRequestLog irl
				LEFT JOIN datClient c ON c.ClientIdentifier = irl.ConectId
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				OR irl.IncomingRequestID = @IncomingRequestID

		IF @ClientIdentifier IS NULL
		BEGIN
			 RAISERROR (N'cONEct ID must be specified.', -- Message text.
               16, -- Severity.
               1 -- State.
			   );
		END

		IF @ClientIdentifier IS NOT NULL
		BEGIN

			-- Update Client Record
			UPDATE datClient SET
--				SiebelId = @NewSiebelID,
				BosleySalesforceAccountID = @BosleySalesforceAccountID,
				EmailAddress = CASE WHEN EmailAddress IS NULL OR EmailAddress = '' THEN @EmailAddress ELSE EmailAddress END,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			WHERE ClientIdentifier = @ClientIdentifier

			-- Update Incoming Request Log
			UPDATE datIncomingRequestLog SET
				--SiebelId = @NewSiebelID,
				BosleySalesforceAccountID = @BosleySalesforceAccountID,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			WHERE ConectId = @ClientIdentifier
				AND BosleyRequestID <> @CurrentTransactionIdBeingProcessed


			-- Update Outgoing Request Log
			UPDATE datOutgoingRequestLog SET
				--SiebelId = @NewSiebelID,
				BosleySalesforceAccountID = @BosleySalesforceAccountID,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			WHERE ClientIdentifier = @ClientIdentifier
				AND SiebelId = @CurrentSiebelID


			-- Update Outgoing Response Log
			UPDATE res SET
				--res.SeibelId = @NewSiebelID,
				BosleySalesforceAccountID = @BosleySalesforceAccountID,
				res.LastUpdate = GETUTCDATE(),
				res.LastUpdateUser = @User
			FROM datOutgoingResponseLog res
				INNER JOIN datOutgoingRequestLog rl ON rl.OutgoingRequestID = res.OutgoingRequestID
			WHERE rl.ClientIdentifier = @ClientIdentifier

		END

		IF @IsRealTimeRequest = 1
		BEGIN
			UPDATE datIncomingRequestLog SET
					IsProcessedFlag = 1
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
				OR IncomingRequestID = @IncomingRequestID
		END

        COMMIT TRANSACTION

		SET @IsSuccessfullyProcessed = 1

	END TRY

	BEGIN CATCH

            ROLLBACK TRANSACTION

			SET @IsSuccessfullyProcessed = 0
			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;
			DECLARE @ErrorProcedure NVARCHAR(200);

			SELECT @ErrorMessage = ERROR_MESSAGE(),
				   @ErrorSeverity = ERROR_SEVERITY(),
				   @ErrorState = ERROR_STATE(),
				   @ErrorProcedure = ERROR_PROCEDURE();

			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = @ErrorProcedure + ':' + @ErrorMessage
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
				OR IncomingRequestID = @IncomingRequestID

			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

	END CATCH
GO
