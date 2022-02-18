/* CreateDate: 11/28/2017 16:45:49.093 , ModifyDate: 11/28/2017 17:53:55.540 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmAddressFlagAsProcessed
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

EXEC extSalesforceToHcmAddressFlagAsProcessed 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmAddressFlagAsProcessed]
(
	@BatchID INT
)
AS
BEGIN

SET NOCOUNT ON;


-- Exclude if it is part of the current batch and does not have a Contact Address ID
UPDATE	SFDC_HCM_LeadAddress
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from upload to Salesforce because the record has no Contact Address ID.'
WHERE	BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 0
		AND ISNULL(IsExcludedFlag, 0) = 0
		AND contact_address_id IS NULL


---- Exclude records that do not have a lead status of Lead
--UPDATE	SFDC_HCM_LeadAddress
--SET		IsExcludedFlag = 1
--,		ExclusionMessage = 'Excluded from upload to Salesforce because the record does not belong to a Lead.'
--WHERE	BatchID = @BatchID
--		AND ISNULL(IsProcessedFlag, 0) = 0
--		AND ISNULL(IsExcludedFlag, 0) = 0
--		AND ISNULL(LeadStatus, '') <> 'Lead'


SELECT  contact_address_id AS 'OncContactAddressID__c'
,       cst_sfdc_address_id
,		0 AS 'ToBeProcessed__c'
,       GETUTCDATE() AS 'LastProcessedDate__c'
FROM    SFDC_HCM_LeadAddress
WHERE   BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 1
        AND ISNULL(IsExcludedFlag, 0) = 0
ORDER BY cst_sfdc_address_id

END
GO
