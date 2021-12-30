/* CreateDate: 11/28/2017 16:41:47.490 , ModifyDate: 12/27/2017 15:51:11.610 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmLeadFlagToBeProcessed
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/31/2017
DESCRIPTION:			10/31/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extSalesforceToHcmLeadFlagToBeProcessed 6501
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmLeadFlagToBeProcessed]
(
	@BatchID INT
)
AS
BEGIN

---- Set any unprocessed lead records to processed. We want the processing of leads to be driven by this procedure.
--UPDATE	SFDC_HCM_Lead
--SET		IsProcessedFlag = 1


SELECT DISTINCT
        lt.cst_sfdc_lead_id
,       1 AS 'ToBeProcessed__c'
FROM    SFDC_HCM_LeadTask lt
WHERE   lt.BatchID = @BatchID
		AND ISNULL(lt.IsProcessedFlag, 0) = 0
        AND ISNULL(lt.IsExcludedFlag, 0) = 0
        AND LEFT(lt.cst_sfdc_lead_id, 3) = '00Q'
        AND ISNULL(lt.LeadStatus, '') = 'Lead'
UNION
SELECT DISTINCT
        lp.cst_sfdc_lead_id
,       1 AS 'ToBeProcessed__c'
FROM    SFDC_HCM_LeadPhone lp
WHERE   lp.BatchID = @BatchID
		AND ISNULL(lp.IsProcessedFlag, 0) = 0
        AND ISNULL(lp.IsExcludedFlag, 0) = 0
        AND LEFT(lp.cst_sfdc_lead_id, 3) = '00Q'
		AND ISNULL(lp.LeadStatus, '') = 'Lead'
UNION
SELECT DISTINCT
        le.cst_sfdc_lead_id
,       1 AS 'ToBeProcessed__c'
FROM    SFDC_HCM_LeadEmail le
WHERE   le.BatchID = @BatchID
		AND ISNULL(le.IsProcessedFlag, 0) = 0
        AND ISNULL(le.IsExcludedFlag, 0) = 0
        AND LEFT(le.cst_sfdc_lead_id, 3) = '00Q'
		AND ISNULL(le.LeadStatus, '') = 'Lead'
UNION
SELECT DISTINCT
        la.cst_sfdc_lead_id
,       1 AS 'ToBeProcessed__c'
FROM    SFDC_HCM_LeadAddress la
WHERE   la.BatchID = @BatchID
		AND ISNULL(la.IsProcessedFlag, 0) = 0
        AND ISNULL(la.IsExcludedFlag, 0) = 0
        AND LEFT(la.cst_sfdc_lead_id, 3) = '00Q'
		AND ISNULL(la.LeadStatus, '') = 'Lead'
ORDER BY cst_sfdc_lead_id

END
GO
