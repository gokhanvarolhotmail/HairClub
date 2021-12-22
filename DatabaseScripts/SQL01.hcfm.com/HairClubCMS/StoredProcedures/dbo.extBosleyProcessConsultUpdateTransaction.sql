/***********************************************************************

PROCEDURE:				extBosleyProcessConsultUpdateTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/05/13

LAST REVISION DATE: 	06/05/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Consult Update transactions sent by Bosley.
	* 6/05/13 MVT - Created
	* 8/16/13 MLM - Added Check for Surgery Membership on the Cline
	* 6/1/17 PRM  - Removed try/catch and transactional logic and handling it in the main proc to avoid transactional errors
	* 05/24/18 MVT - Added logic to update email if sent by Bosley.
	* 01/27/20 MVT - Updated to set Bosley SF Account ID on the client record if not set or different. Moved reading of the Email Address from
					incoming request log to the top and modified query that updates email on client record to only update if not set on the client record. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Added error check to verify ConectID is specified
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessConsultUpdateTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessConsultUpdateTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User nvarchar(10) = 'Bosley'
	DECLARE @EmailAddress AS nvarchar(100), @ClientGUID AS uniqueidentifier, @BosleySalesforceAccountID nvarchar(50)

	SELECT  @EmailAddress = irl.EmailAddress
			, @ClientGUID = c.ClientGUID
			, @BosleySalesforceAccountID = irl.BosleySalesforceAccountID
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

	  END
	ELSE IF EXISTS(Select *
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
					WhERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND c.CurrentSurgeryClientMembershipGUID IS NULL)
		BEGIN
				-- Skip this record since there is no Surgery membership for the client
			-- add warning
			UPDATE irl SET
				WarningMessage = 'Record not processed since there is no surgery membership for client '
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
			FROM datIncomingRequestLog irl
				INNER JOIN datClient c ON c.ClientIdentifier = irl.ConectID
				INNER JOIN datClientMembership cm ON c.[CurrentExtremeTherapyClientMembershipGUID] = cm.ClientMembershipGuid
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
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
	  END


	SET @IsSuccessfullyProcessed = 1

END
