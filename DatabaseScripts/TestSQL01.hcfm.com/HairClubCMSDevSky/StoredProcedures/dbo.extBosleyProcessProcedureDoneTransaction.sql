/* CreateDate: 06/10/2013 20:12:27.243 , ModifyDate: 06/05/2017 06:25:53.453 */
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessProcedureDoneTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/05/13

LAST REVISION DATE: 	06/05/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Procedure Done transactions sent by Bosley.
	* 6/05/13 MVT - Created
	* 8/16/13 MLM - Added Check for a Current Surgery Client Membership
	* 6/1/17 PRM  - Removed try/catch and transactional logic and handling it in the main proc to avoid transactional errors
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessProcedureDoneTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessProcedureDoneTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User nvarchar(10) = 'Bosley'

		--Must have a Current Surgery Client Membership
		IF EXISTS(Select *
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND c.CurrentSurgeryClientMembershipGUID IS NULL)
			BEGIN
				SET @IsSuccessfullyProcessed = 0
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, no Treatment Plan received'
						,LastUpdate = GETDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			END
		ELSE
			BEGIN

				IF EXISTS (SELECT irl.* FROM datIncomingRequestLog irl
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
				ELSE
				  BEGIN
						EXEC extBosleyUpdateProcedureAppointment @CurrentTransactionIdBeingProcessed
				  END


				SET @IsSuccessfullyProcessed = 1
			END

END
GO
