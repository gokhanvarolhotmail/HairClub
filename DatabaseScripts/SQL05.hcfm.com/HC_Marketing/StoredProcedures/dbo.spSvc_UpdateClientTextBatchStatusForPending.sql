/* CreateDate: 10/19/2016 16:29:45.563 , ModifyDate: 10/19/2016 16:29:45.563 */
GO
/***********************************************************************
PROCEDURE:				spSvc_UpdateClientTextBatchStatusForPending
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APP:			Message Media Text Message SSIS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/07/2016
------------------------------------------------------------------------
NOTES:

Updates all PENDING records for a batch to the specified status.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_UpdateClientTextBatchStatusForPending '7A7FEAB9-159F-4C8A-BE53-1CDBED18005A', 1, 'DLVR-Sucss', NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].spSvc_UpdateClientTextBatchStatusForPending
(
	@SessionID NVARCHAR(100),
	@BatchID INT,
	@TextMessageStatusDescriptionShort NVARCHAR(10),
	@ErrorCode VARCHAR(50) = NULL,
	@ErrorVerbiage VARCHAR(255) = NULL
)
AS
BEGIN


DECLARE @TextMessageStatusID INT


SET @TextMessageStatusID = (SELECT TextMessageStatusID FROM lkpTextMessageStatus TMS WHERE TMS.TextMessageStatusDescriptionShort = @TextMessageStatusDescriptionShort)


UPDATE	CML
SET		TextMessageStatusID = @TextMessageStatusID
,		ErrorCode = @ErrorCode
,		ErrorVerbiage = @ErrorVerbiage
,		LastUpdate = GETUTCDATE()
,		LastUpdateUser = 'LDText-HCM'
FROM    datClientMessageLog CML
		INNER JOIN lkpTextMessageStatus TMS
			ON TMS.TextMessageStatusID = CML.TextMessageStatusID
WHERE   CML.SessionGUID = @SessionID
		AND CML.BatchID = @BatchID
		AND TMS.TextMessageStatusDescriptionShort = 'PENDING'

END
GO
