/* CreateDate: 05/15/2013 13:59:08.300 , ModifyDate: 03/09/2020 15:11:42.550 */
GO
/***********************************************************************

PROCEDURE:				extRequestQueueUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		05/14/2013

LAST REVISION DATE: 	05/14/2013

--------------------------------------------------------------------------------------------------------
NOTES: 	Return RequestQueue Records to be processed

		05/14/13 - MLM	: Initial Creation
		01/28/20 - EJP	: Modified to update BosleySalesforceAccountID (instead of SiebelID) on datOutgoingRequestLog, datOutgoingResponseLog, and datClient. Starting with 2/3/2020 release
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

extRequestQueueUpdate 1, '1324'

***********************************************************************/
CREATE PROCEDURE [dbo].[extRequestQueueUpdate]
	@RequestQueueID int,
	@BosleySalesforceAccountID varchar(50),
	@ErrorMessage varchar(500)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRANSACTION
	BEGIN Try

		DECLARE @OutgoingRequestID int
				,@ClientIdentifier int

		SELECT @OutgoingRequestID = OutgoingRequestID
			,@ClientIdentifier =  ClientIdentifier
		FROM datOutgoingRequestLog
		WHERE RequestQueueID = @RequestQueueID

		--Update the RequestQueue
		Update datRequestQueue
			SET IsProcessedFlag = 1
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = 'sa'
		FROM datRequestQueue
		WHERE RequestQueueID = @RequestQueueID

		--Update the datOutgoingRequestLog
		Update datOutgoingRequestLog
			SET BosleySalesforceAccountID = @BosleySalesforceAccountID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = 'sa'
		FROM datOutgoingRequestLog
		WHERE OutgoingRequestID = @OutgoingRequestID

		--Write datOutgoingResponseLog
		INSERT INTO datOutgoingResponseLog(OutgoingRequestID, BosleySalesforceAccountID, ErrorMessage, ExceptionMessage, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		 VALUES(@OutgoingRequestID,@BosleySalesforceAccountID,@ErrorMessage,NULL,GETUTCDATE(),'sa',GETUTCDATE(),'sa')

		 --Update the datClient with the SiebelID
		 Update datClient
			SET BosleySalesforceAccountID = @BosleySalesforceAccountID --BoselySalesforceAccountId
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = 'sa'
		FROM datClient
		where ClientIdentifier = @ClientIdentifier


		COMMIT TRANSACTION

		IF rtrim(ltrim(ISNULL(@ErrorMessage,''))) <> ''
			BEGIN
				RAISERROR(N'Received an error during transmission.', 16, 1)
			END

	END Try

	BEGIN Catch

		RAISERROR(N'Failed to Retrieve RequestQueue Record', 16, 1)
		ROLLBACK TRANSACTION
	END Catch






END
GO
