/***********************************************************************

PROCEDURE:				extBosleyProcessProcedureUpdateTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/05/13

LAST REVISION DATE: 	06/05/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Procedure Update transactions sent by Bosley.
	* 06/05/13 MVT - Created
	* 08/16/13 MLM - Modified to handle BIO & PostExt Memberships
	* 10/01/13 MVT - Modified to add a warning instead of an error when current surgery membership
						is not active.
	* 6/1/17 PRM  - Removed try/catch and transactional logic and handling it in the main proc to avoid transactional errors
	* 05/24/18 MVT - Added logic to update email if sent by Bosley.
	* 01/27/20 MVT - Updated to set Bosley SF Account ID on the client record if not set or different. Moved reading of the Email Address from
					incoming request log to the top and modified query that updates email on client record to only update if not set on the client record. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Added error check to verify ConectID is specified
						* Added error check to stop processing if Reschedule and Procedure Date is in the past
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessProcedureUpdateTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessProcedureUpdateTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User nvarchar(10) = 'Bosley'

	DECLARE @EmailAddress AS nvarchar(100), @ClientGUID AS uniqueidentifier, @BosleySalesforceAccountID nvarchar(50)
	DECLARE @ProcedureDate datetime, @ProcedureStatus nvarchar(30), @IncomingRequestCreateDate datetime

	SELECT  @EmailAddress = irl.EmailAddress
			, @ClientGUID = c.ClientGUID
			, @BosleySalesforceAccountID = irl.BosleySalesforceAccountID
			, @ProcedureDate = irl.ProcedureDate
			, @ProcedureStatus = irl.ProcedureStatus
			, @IncomingRequestCreateDate = irl.CreateDate
	FROM datIncomingRequestLog irl
		INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
	WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

	-- Update Bosley Salesforce Account ID
	IF (@ClientGUID IS NOT NULL AND @BosleySalesforceAccountID IS NOT NULL AND LTRIM(RTRIM(@BosleySalesforceAccountID)) <> '')
	BEGIN
		UPDATE c SET
			BosleySalesforceAccountID = @BosleySalesforceAccountID
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = @User
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID
			AND (c.BosleySalesforceAccountID IS NULL OR
					(c.BosleySalesforceAccountID <> @BosleySalesforceAccountID))
	END


	IF (@ClientGUID IS NULL)
	BEGIN
		SET @IsSuccessfullyProcessed = 0
		-- Write Error Message to the IncomingRequestLog Table
		Update datIncomingRequestLog
			SET ErrorMessage = 'Unable to process, client not found.'
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
		FROM datIncomingRequestLog
		WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END
	ELSE IF (@ProcedureStatus = 'Rescheduled' AND DATEDIFF(dd, @ProcedureDate, @IncomingRequestCreateDate) >= 1)
	BEGIN
		SET @IsSuccessfullyProcessed = 0
		-- Write Error Message to the IncomingRequestLog Table
		Update datIncomingRequestLog
			SET ErrorMessage = 'Procedure Date for Reschedule is in the Past.'
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
		FROM datIncomingRequestLog
		WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END
	ELSE IF EXISTS (SELECT irl.* FROM datIncomingRequestLog irl
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
							AND irl.[ProcedureDate] is NULL)
	  BEGIN
			-- Skip this record since procedure date is not sent.
			-- add warning
			UPDATE irl SET
				WarningMessage = 'Record not processed since procedure date has not been sent.'
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
			FROM datIncomingRequestLog irl
				INNER JOIN datClient c ON c.ClientIdentifier = irl.ConectID
				INNER JOIN datClientMembership cm ON c.[CurrentExtremeTherapyClientMembershipGUID] = cm.ClientMembershipGuid
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
			SET @IsSuccessfullyProcessed = 1

	  END
	ELSE IF NOT EXISTS (SELECT *
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
						INNER JOIN datClientMembership cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
						INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
						INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND cms.ClientMembershipStatusDescriptionShort = 'A')
			BEGIN
				-- Skip this record since Surgery membership is not active.
				-- add warning
				Update datIncomingRequestLog
					SET WarningMessage = 'Record not processed. Surgery Membership is not in Active Status'
						,LastUpdate = GETDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
				SET @IsSuccessfullyProcessed = 1
			END
	ELSE
	  BEGIN
	  		UPDATE c SET
				EmailAddress = @EmailAddress
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
			FROM datClient c
			WHERE c.ClientGUID = @ClientGUID
				AND (c.EmailAddress IS NULL OR c.EmailAddress = '')
				AND (@EmailAddress IS NOT NULL AND @EmailAddress <> '')

			EXEC extBosleyUpdateProcedureAppointment @CurrentTransactionIdBeingProcessed
			SET @IsSuccessfullyProcessed = 1
	  END

END
