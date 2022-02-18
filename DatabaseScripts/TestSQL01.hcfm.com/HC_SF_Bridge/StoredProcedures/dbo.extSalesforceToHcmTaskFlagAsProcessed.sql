/* CreateDate: 11/28/2017 16:43:27.233 , ModifyDate: 08/16/2019 23:36:09.367 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmTaskFlagAsProcessed
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

EXEC extSalesforceToHcmTaskFlagAsProcessed 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmTaskFlagAsProcessed]
(
	@BatchID INT
)
AS
BEGIN

SET NOCOUNT ON;


-- Exclude records that do not have an Activity ID.
UPDATE	SFDC_HCM_LeadTask
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from upload to Salesforce because the record has no Activity ID.'
WHERE	BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 0
		AND ISNULL(IsExcludedFlag, 0) = 0
		AND activity_id IS NULL


---- Exclude records that do not have a lead status of Lead
--UPDATE	SFDC_HCM_LeadTask
--SET		IsExcludedFlag = 1
--,		ExclusionMessage = 'Excluded from upload to Salesforce because the record does not belong to a Lead.'
--WHERE	BatchID = @BatchID
--		AND ISNULL(IsProcessedFlag, 0) = 0
--		AND ISNULL(IsExcludedFlag, 0) = 0
--		AND ISNULL(LeadStatus, '') <> 'Lead'


SELECT  activity_id AS 'ActivityID__c'
,       cst_sfdc_task_id
,		0 AS 'ToBeProcessed__c'
,       GETUTCDATE() AS 'LastProcessedDate__c'
FROM    SFDC_HCM_LeadTask
WHERE   BatchID = @BatchID
		AND ISNULL(IsProcessedFlag, 0) = 1
        AND ISNULL(IsExcludedFlag, 0) = 0
GROUP BY activity_id
,		cst_sfdc_task_id
ORDER BY cst_sfdc_task_id

END
GO
