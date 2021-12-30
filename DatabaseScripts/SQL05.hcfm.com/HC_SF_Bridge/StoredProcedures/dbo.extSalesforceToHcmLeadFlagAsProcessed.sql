/* CreateDate: 11/28/2017 16:40:57.707 , ModifyDate: 11/28/2017 16:40:57.707 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmLeadFlagAsProcessed
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

EXEC extSalesforceToHcmLeadFlagAsProcessed 1
***********************************************************************/
CREATE PROCEDURE [dbo].extSalesforceToHcmLeadFlagAsProcessed
(
	@BatchID INT
)
AS
BEGIN

SET NOCOUNT ON;


-- Exclude if it is part of the current batch and does not have a contact_id
UPDATE	SFDC_HCM_Lead
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from upload to Salesforce because the record has no Contact ID.'
WHERE	BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 0
		AND ISNULL(IsExcludedFlag, 0) = 0
		AND contact_id IS NULL


SELECT  contact_id AS 'ContactID__c'
,       cst_sfdc_lead_id
,		0 AS 'ToBeProcessed__c'
,       GETUTCDATE() AS 'LastProcessedDate__c'
FROM    SFDC_HCM_Lead
WHERE   BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 1
        AND ISNULL(IsExcludedFlag, 0) = 0
        AND ISNULL(IsConvertedFlag, 0) = 0
GROUP BY contact_id
,		cst_sfdc_lead_id
ORDER BY cst_sfdc_lead_id

END
GO
