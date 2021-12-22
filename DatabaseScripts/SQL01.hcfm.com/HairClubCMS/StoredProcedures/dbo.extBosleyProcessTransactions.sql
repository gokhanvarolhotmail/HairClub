/***********************************************************************

PROCEDURE:				extBosleyProcessTransactions

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		4/27/13

LAST REVISION DATE: 	4/17/20

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes transactions sent by Bosley.
	* 3/26/13 MVT - Created
	* 5/23/13 MLM - Added the ability to Process PostEXTSold
	* 5/28/13 MVT - Modified to raise an error if failure occurs during processing
	* 6/03/13 MVT - Added processing for PostEXTSold
	* 7/11/13 MLM - Changed to Processing back to PatientSlipClosed from ProcedureDone.   Does already processed should be excluded.
	* 7/16/13 MLM - Changed to Process on ProcedureDone.
	* 7/16/13 MLM - Payments will no longer be processed.
	* 10/30/13 MLM - Added the ability to add a new Client when Bosley sells a PostEXT Membership
	* 11/04/13 MVT - Added ability to process Siebel Replace transactions.
	* 03/17/14 MLM - Added Logic is to ignore EXT9 Refunds
	* 03/31/14 MLM - Change the Process to use the PatientSlipClosed instead of ProcedureDone.
	* 08/19/15 MVT - Modified to ignore requests with "IsRealTimeRequest" set to true
	* 09/09/15 MVT - Modified to check if more than 1 record exists with the same Bosley Request ID.  Stop processing
					if duplicate exists.
	* 10/21/15 MVT - Modified the call for Siebel replacement to use parameter names when calling the proc.
	* 02/11/16 DSL - Modified query to check value of @IsSuccessfullyProcessed prior to calling Client Update
					proc for Treatment Plan & Procedure Done processes.
	* 04/12/17 PRM - Added support for PatientSlipClosed & TreatmentPlan for Cool Sculpting & TriGen's
	* 06/01/17 PRM - Updated error handling logic since calling rollback transaction in a sub stored proc actually rolls back the entire transaction causing an error
	* 06/20/17 MVT - Added logic to ignore TreatmentPlanPRP (TFS 9172)
	* 01/27/20 MVT - Removed processing of CoolSculpting
	* 01/30/20 EJP - Added calls to extBosleyUpdateSalesforce for processes TreatmentPlan, TreatmentPlanTriGenEnh, and TreatmentPlanTriGenEnhBPS.
	* 04/17/20 EJP - Changed calls to extBosleyUpdateSalesforce to calls to extBosleyQueueSalesforceUpdate.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessTransactions]

***********************************************************************/

CREATE   PROCEDURE [dbo].[extBosleyProcessTransactions]
AS
BEGIN

	SET NOCOUNT ON;

	-- Constants for all processes
	DECLARE @Process_TreatmentPlan nvarchar(25) = N'TreatmentPlan';
	DECLARE @Process_TreatmentPlanPRP nvarchar(25) = N'TreatmentPlanPRP';  -- Ignore
	DECLARE @Process_TreatmentPlanCS nvarchar(25) = N'TreatmentPlanCS';
	DECLARE @Process_TreatmentPlanTriGenEnh nvarchar(25) = N'TreatmentPlanTriGenEnh';
	DECLARE @Process_TreatmentPlanTriGenEnhBPS nvarchar(25) = N'TreatmentPlanTriGenEnhBPS';

	DECLARE @Process_ProcedureDone nvarchar(25) = N'ProcedureDone';
	DECLARE @Process_PostEXTSold nvarchar(25) = N'PostEXTSold';
	DECLARE @Process_PatientSlipClosed nvarchar(25) = N'PatientSlipClosed';
	DECLARE @Process_PatientSlipClosedCS nvarchar(25) = N'PatientSlipClosedCS';
	DECLARE @Process_PatientSlipClosedPRP nvarchar(25) = N'PatientSlipClosedPRP';

	DECLARE @Process_Skip nvarchar(25) = N'Skip';
	DECLARE @Process_Payment nvarchar(25) = N'Payment';
	DECLARE @Process_EXT9BOSRFD nvarchar(25) = N'EXT9BOSRFD';
	DECLARE @Process_ProcedureDonePRP nvarchar(25) = N'ProcedureDonePRP';
	DECLARE @Process_ProcedureDoneCS nvarchar(25) = N'ProcedureDoneCS';

	DECLARE @Process_ConsultUpdate nvarchar(25) = N'ConsultUpdate';
	DECLARE @Process_ProcedureUpdate nvarchar(25) = N'ProcedureUpdate';
	DECLARE @Process_ProcedureUpdateCS nvarchar(25) = N'ProcedureUpdateCS';
	DECLARE @Process_ProcedureUpdatePRP nvarchar(25) = N'ProcedureUpdatePRP';
	DECLARE @Process_BosleySoldEXT nvarchar(25) = N'EXT9Bos';
	DECLARE @Process_BosleySiebelReplace nvarchar(25) = N'SiebelRpl';

	DECLARE @AddOn_TGE nvarchar(25) = N'TGE';
	DECLARE @AddOn_TGE9BPS nvarchar(25) = N'TGE9BPS';

	DECLARE @LastProcessedTransactionId int;
	DECLARE @CurrentTransactionIdBeingProcessed int;
	DECLARE @IsCurrentTransactionFound bit;
	DECLARE @IsSuccessfullyProcessed bit;
	DECLARE @CurrentProcess nvarchar(25);
	DECLARE @IsRealTimeRequest bit;

	DECLARE @UpdateUser nvarchar(25) = N'Bosley-Main';


	-- Get last transaction processed
	SELECT @LastProcessedTransactionId = ISNULL(MAX(BosleyRequestID), 0) FROM datIncomingRequestLog WHERE IsProcessedFlag = 1;
	SELECT ISNULL(MAX(BosleyRequestID), 0) FROM datIncomingRequestLog WHERE IsProcessedFlag = 1;

	-- Determine next transaction to process.
	SET @CurrentTransactionIdBeingProcessed = @LastProcessedTransactionId + 1;

	-- Check if exists
	SET @IsCurrentTransactionFound = (SELECT COUNT(1) FROM datIncomingRequestLog WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed);


	WHILE (@IsCurrentTransactionFound = 1)
	BEGIN
		BEGIN TRANSACTION;
		BEGIN TRY

			SELECT @CurrentProcess = r.ProcessName, @IsRealTimeRequest = IsRealTimeRequest
			FROM datIncomingRequestLog r
			WHERE r.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			--Create a separate proc for each process
			IF (SELECT COUNT(1) FROM datIncomingRequestLog WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed) > 1
			BEGIN
				SET @IsSuccessfullyProcessed = 0;

				-- Update Transaction as Processed
				UPDATE
					datIncomingRequestLog
				SET
					ErrorMessage = 'Another record with a duplicate Bosley Request ID exists.',
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @UpdateUser
				WHERE
					BosleyRequestID = @CurrentTransactionIdBeingProcessed;
			END

			ELSE IF @IsRealTimeRequest = 1
			BEGIN
				-- Real Time requests should have been already processed.  If not, then the client making the request should have
				-- received an error.  Skip over real time transactions.
				SET @IsSuccessfullyProcessed = 1;
			END

			ELSE IF (@CurrentProcess = @Process_Skip OR -- used to fill in gaps in sequence if necessary.
					@CurrentProcess = @Process_Payment OR
					@CurrentProcess = @Process_EXT9BOSRFD OR
					@CurrentProcess = @Process_ProcedureDonePRP OR
					@CurrentProcess = @Process_ProcedureDoneCS OR
					@CurrentProcess = @Process_TreatmentPlanPRP OR
					@CurrentProcess = @Process_TreatmentPlanCS OR
					@CurrentProcess = @Process_PatientSlipClosedCS OR
					@CurrentProcess = @Process_ProcedureUpdateCS)
			BEGIN
				SET @IsSuccessfullyProcessed = 1;
			END

			ELSE IF @CurrentProcess = @Process_TreatmentPlan
            BEGIN
				EXEC extBosleyProcessTreatmentPlanTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;

				IF @IsSuccessfullyProcessed = 1
				BEGIN
					EXEC extBosleyProcessClientUpdate @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;
					EXEC extBosleyQueueSalesforceUpdate @CurrentTransactionIdBeingProcessed = @CurrentTransactionIdBeingProcessed;
				END
			END

			ELSE IF (@CurrentProcess = @Process_TreatmentPlanTriGenEnh OR @CurrentProcess = @Process_TreatmentPlanTriGenEnhBPS)
            BEGIN
				DECLARE @AddOn_Main nvarchar(10),
						@AddOn_Alt nvarchar(10);

				IF @CurrentProcess = @Process_TreatmentPlanTriGenEnh
				BEGIN
					SET @AddOn_Main = @AddOn_TGE;
					SET @AddOn_Alt = @AddOn_TGE9BPS;
				END
				ELSE
				BEGIN
					SET @AddOn_Main = @AddOn_TGE9BPS;
					SET @AddOn_Alt = @AddOn_TGE;
				END

				EXEC extBosleyProcessTreatmentPlanTransactionTriGen @CurrentTransactionIdBeingProcessed, @AddOn_Main, @AddOn_Alt, @IsSuccessfullyProcessed OUTPUT;

				IF @IsSuccessfullyProcessed = 1
				BEGIN
					EXEC extBosleyProcessClientUpdate @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;
					EXEC extBosleyQueueSalesforceUpdate @CurrentTransactionIdBeingProcessed = @CurrentTransactionIdBeingProcessed;
				END
			END

			ELSE IF @CurrentProcess = @Process_ProcedureDone
			BEGIN
				EXEC extBosleyProcessProcedureDoneTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;
			END

			ELSE IF @CurrentProcess = @Process_PatientSlipClosed
			BEGIN
				EXEC extBosleyProcessPatientSlipClosedTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;

				IF @IsSuccessfullyProcessed = 1
					EXEC extBosleyProcessClientUpdate @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;
            END

			ELSE IF @CurrentProcess = @Process_PatientSlipClosedPRP
			BEGIN
				EXEC extBosleyProcessPatientSlipClosedPRPTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;

				IF @IsSuccessfullyProcessed = 1
					EXEC extBosleyProcessClientUpdate @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;
            END

			ELSE IF @CurrentProcess = @Process_PostEXTSold
				EXEC extBosleyProcessPostEXTSoldTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;

			ELSE IF @CurrentProcess = @Process_ConsultUpdate
            BEGIN
				EXEC extBosleyProcessConsultUpdateTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;
				EXEC extBosleyProcessClientUpdate @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;
			END

			ELSE IF @CurrentProcess = @Process_ProcedureUpdate
                EXEC extBosleyProcessProcedureUpdateTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;

            ELSE IF @CurrentProcess = @Process_ProcedureUpdatePRP
                EXEC extBosleyProcessProcedureUpdateTransactionPRP @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;

			ELSE IF @CurrentProcess = @Process_BosleySoldEXT
				EXEC extBosleyProcessBosleySoldEXTTransaction @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT;

			ELSE IF @CurrentProcess = @Process_BosleySiebelReplace
				EXEC extBosleyProcessSiebelReplaceTransaction @CurrentTransactionIdBeingProcessed=@CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed=@IsSuccessfullyProcessed OUTPUT;

            ELSE -- Unknown Process
                SET @IsSuccessfullyProcessed = 0;


			-- If successfull  then update request as processed.
			IF @IsSuccessfullyProcessed = 1 AND @IsRealTimeRequest = 0
			BEGIN
				-- Update Transaction as Processed
				UPDATE
					datIncomingRequestLog
				SET
					IsProcessedFlag = 1,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @UpdateUser
				WHERE
					BosleyRequestID = @CurrentTransactionIdBeingProcessed;
			END

			-- if successfull, get next transaction to process
			IF @IsSuccessfullyProcessed = 1
			BEGIN
				-- Determine next transaction to process.
				SET @CurrentTransactionIdBeingProcessed = @CurrentTransactionIdBeingProcessed + 1;

				-- Check if next transaction exists
				SET @IsCurrentTransactionFound = (SELECT COUNT(1) FROM datIncomingRequestLog WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed)
			END

			ELSE
				SET @IsCurrentTransactionFound = 0;

		COMMIT TRANSACTION;

		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;

			SET @IsCurrentTransactionFound = 0;

			-- Write Error Message to the IncomingRequestLog Table
			UPDATE
				datIncomingRequestLog
			SET
				ErrorMessage = Error_Procedure() + ':' + Error_Message(),
				LastUpdate = GETDATE(),
				LastUpdateUser = @UpdateUser
			WHERE
				BosleyRequestID = @CurrentTransactionIdBeingProcessed;

			DECLARE @ErrorMessage nvarchar(4000);
			DECLARE @ErrorSeverity int;
			DECLARE @ErrorState int;

			SELECT @ErrorMessage = ERROR_MESSAGE(),
				   @ErrorSeverity = ERROR_SEVERITY(),
				   @ErrorState = ERROR_STATE();

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

		END CATCH
		END

		DECLARE @RequestID nvarchar(20) = Cast(@CurrentTransactionIdBeingProcessed AS nvarchar(20));
		DECLARE @ErrorMsg nvarchar(200);

		IF @IsSuccessfullyProcessed = 0 AND EXISTS (SELECT 1 FROM datIncomingRequestLog WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed)
		BEGIN
			SET @ErrorMsg = 'Failed Processing Request. Incoming Request ID: ' + @RequestID;
			RAISERROR (@ErrorMsg, 16, 1);
		END

		ELSE IF @IsCurrentTransactionFound = 0 AND EXISTS (SELECT 1 FROM datIncomingRequestLog WHERE BosleyRequestID > @CurrentTransactionIdBeingProcessed)
		BEGIN
			SET @ErrorMsg = 'Gap in the sequence. Missing Request ID: ' + @RequestID;
			RAISERROR (@ErrorMsg, 16, 1);
		END

END
