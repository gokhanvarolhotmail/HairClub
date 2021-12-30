/* CreateDate: 11/28/2017 16:48:34.977 , ModifyDate: 11/28/2017 17:55:48.737 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmEmailFlagAsProcessed
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

EXEC extSalesforceToHcmEmailFlagAsProcessed 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmEmailFlagAsProcessed]
(
	@BatchID INT
)
AS
BEGIN

SET NOCOUNT ON;


-- Exclude if it is part of the current batch and does not have a Contact Email ID
UPDATE	SFDC_HCM_LeadEmail
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from upload to Salesforce because the record has no Contact Email ID.'
WHERE	BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 0
		AND ISNULL(IsExcludedFlag, 0) = 0
		AND contact_email_id IS NULL


---- Exclude records that do not have a lead status of Lead
--UPDATE	SFDC_HCM_LeadEmail
--SET		IsExcludedFlag = 1
--,		ExclusionMessage = 'Excluded from upload to Salesforce because the record does not belong to a Lead.'
--WHERE	BatchID = @BatchID
--		AND ISNULL(IsProcessedFlag, 0) = 0
--		AND ISNULL(IsExcludedFlag, 0) = 0
--		AND ISNULL(LeadStatus, '') <> 'Lead'


SELECT  contact_email_id AS 'OncContactEmailID__c'
,       cst_sfdc_email_id
,		0 AS 'ToBeProcessed__c'
,       GETUTCDATE() AS 'LastProcessedDate__c'
FROM    SFDC_HCM_LeadEmail
WHERE   BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 1
        AND ISNULL(IsExcludedFlag, 0) = 0
ORDER BY cst_sfdc_email_id

END
GO
