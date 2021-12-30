/* CreateDate: 10/19/2016 16:22:01.360 , ModifyDate: 10/19/2016 16:22:01.360 */
GO
/***********************************************************************
PROCEDURE:				spSvc_UpdateLeadTextStatusByUIDs
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APP:			Message Media Text Message SSIS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/07/2016
------------------------------------------------------------------------
NOTES:

Updates the corresponding batch records to the specified status.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_UpdateLeadTextStatusByUIDs 'invalidRecipient', NULL, 'DLVR-Fail', '4080,4132'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_UpdateLeadTextStatusByUIDs]
(
	@ErrorCode NVARCHAR(50) = NULL,
	@ErrorVerbiage NVARCHAR(255) = NULL,
	@TextMessageStatusDescriptionShort NVARCHAR(10),
	@UIDList VARCHAR(MAX)
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
		INNER JOIN dbo.fnSplit(@UIDList, ',') s_UID
			ON s_UID.item = LML.LeadMessageLogID
WHERE   TMS.TextMessageStatusDescriptionShort = 'PENDING'

END
GO
