/* CreateDate: 11/28/2017 16:50:57.423 , ModifyDate: 11/28/2017 17:56:36.557 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmPhoneFlagAsProcessed
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/9/2017
DESCRIPTION:			11/9/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extSalesforceToHcmPhoneFlagAsProcessed 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmPhoneFlagAsProcessed]
(
	@BatchID INT
)
AS
BEGIN

SET NOCOUNT ON;


-- Exclude if it is part of the current batch and does not have a Contact Phone ID
UPDATE	SFDC_HCM_LeadPhone
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from upload to Salesforce because the record has no Contact Phone ID.'
WHERE	BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 0
		AND ISNULL(IsExcludedFlag, 0) = 0
		AND contact_phone_id IS NULL


---- Exclude records that do not have a lead status of Lead
--UPDATE	SFDC_HCM_LeadPhone
--SET		IsExcludedFlag = 1
--,		ExclusionMessage = 'Excluded from upload to Salesforce because the record does not belong to a Lead.'
--WHERE	BatchID = @BatchID
--		AND ISNULL(IsProcessedFlag, 0) = 0
--		AND ISNULL(IsExcludedFlag, 0) = 0
--		AND ISNULL(LeadStatus, '') <> 'Lead'


SELECT  contact_phone_id AS 'ContactPhoneID__c'
,       cst_sfdc_phone_id
,		0 AS 'ToBeProcessed__c'
,       GETUTCDATE() AS 'LastProcessedDate__c'
FROM    SFDC_HCM_LeadPhone
WHERE   BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 1
        AND ISNULL(IsExcludedFlag, 0) = 0
ORDER BY cst_sfdc_phone_id

END
GO
