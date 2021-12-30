/* CreateDate: 11/28/2017 16:30:55.003 , ModifyDate: 11/28/2017 16:30:55.003 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmBatchHeaderUpdate
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
RELATED APPLICATION:	Salesforce to HCM Data Sync
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/10/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extSalesforceToHcmBatchHeaderUpdate 1
***********************************************************************/
CREATE PROCEDURE [dbo].extSalesforceToHcmBatchHeaderUpdate
(
	@BatchID INT
)
AS
BEGIN

-- Create Audit Record
INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  l.BatchID
        ,       'SFDC_HCM_Lead'
        ,       l.cst_sfdc_lead_id
		,		l.contact_id
        ,       'Excluded Record'
		,		4
        FROM    SFDC_HCM_Lead l
        WHERE   l.BatchID = @BatchID
				AND ISNULL(l.IsExcludedFlag, 0) = 1


INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  lt.BatchID
        ,       'SFDC_HCM_LeadTask'
        ,       lt.cst_sfdc_task_id
		,		lt.activity_id
        ,       'Excluded Record'
		,		4
        FROM    SFDC_HCM_LeadTask lt
        WHERE   lt.BatchID = @BatchID
				AND ISNULL(lt.IsExcludedFlag, 0) = 1


INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  lp.BatchID
        ,       'SFDC_HCM_LeadPhone'
        ,       lp.cst_sfdc_phone_id
		,		lp.contact_phone_id
        ,       'Excluded Record'
		,		4
        FROM    SFDC_HCM_LeadPhone lp
        WHERE   lp.BatchID = @BatchID
				AND ISNULL(lp.IsExcludedFlag, 0) = 1


INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  le.BatchID
        ,       'SFDC_HCM_LeadEmail'
        ,       le.cst_sfdc_email_id
		,		le.contact_email_id
        ,       'Excluded Record'
		,		4
        FROM    SFDC_HCM_LeadEmail le
        WHERE   le.BatchID = @BatchID
				AND ISNULL(le.IsExcludedFlag, 0) = 1


INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  la.BatchID
        ,       'SFDC_HCM_LeadAddress'
        ,       la.cst_sfdc_address_id
		,		la.contact_address_id
        ,       'Excluded Record'
		,		4
        FROM    SFDC_HCM_LeadAddress la
        WHERE   la.BatchID = @BatchID
				AND ISNULL(la.IsExcludedFlag, 0) = 1


UPDATE	SFDC_HCM_Batch
SET		Status = 'Processed'
,		CET = LSET
WHERE	BatchID = @BatchID

END
GO
