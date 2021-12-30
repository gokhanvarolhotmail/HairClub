/* CreateDate: 10/19/2016 16:24:08.607 , ModifyDate: 10/19/2016 16:24:08.607 */
GO
/***********************************************************************
PROCEDURE:				spSvc_UpdateLeadTextBatchStatusForPending
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

EXEC spSvc_UpdateLeadTextBatchStatusForPending '7A7FEAB9-159F-4C8A-BE53-1CDBED18005A', 1, 'DLVR-Sucss', NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_UpdateLeadTextBatchStatusForPending]
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


UPDATE	LML
SET		TextMessageStatusID = @TextMessageStatusID
,		ErrorCode = @ErrorCode
,		ErrorVerbiage = @ErrorVerbiage
,		LastUpdate = GETUTCDATE()
,		LastUpdateUser = 'LDText-HCM'
FROM    datLeadMessageLog LML
		INNER JOIN lkpTextMessageStatus TMS
			ON TMS.TextMessageStatusID = LML.TextMessageStatusID
WHERE   LML.SessionGUID = @SessionID
		AND LML.BatchID = @BatchID
		AND TMS.TextMessageStatusDescriptionShort = 'PENDING'

END
GO
