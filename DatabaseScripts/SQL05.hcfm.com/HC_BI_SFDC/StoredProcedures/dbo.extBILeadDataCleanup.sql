/* CreateDate: 05/31/2018 11:56:05.397 , ModifyDate: 06/17/2020 11:27:47.903 */
GO
/***********************************************************************
PROCEDURE:				extBILeadDataCleanup
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/31/2018
DESCRIPTION:			5/31/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extBILeadDataCleanup
***********************************************************************/
CREATE PROCEDURE [dbo].[extBILeadDataCleanup]
AS
BEGIN

SET NOCOUNT ON;


SELECT  l.Id
,       l.ContactID__c
,       l.FirstName
,       l.LastName
,       CASE WHEN l.Source_Code_Legacy__c = 'DGEMAEXDREM11680' THEN 'Prospect' ELSE l.Status END AS 'Status'
,       l.ReportCreateDate__c
INTO	#LeadCleanup
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
        INNER JOIN HC_BI_SFDC.dbo.Lead l
            ON l.Id = dc.SFDC_LeadID
				AND l.ContactID__c = dc.ContactSSID
WHERE   ( dc.ContactStatusSSID <> CASE WHEN l.Status NOT IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'Invalid', 'Test', 'Deleted', 'Merged' ) THEN 'Lead' ELSE l.Status END
			OR CAST(dc.CreationDate AS DATE) <> CAST(l.ReportCreateDate__c AS DATE) )


UPDATE  dc
SET     dc.CreationDate = l.ReportCreateDate__c
,       dc.ContactStatusSSID = UPPER(CASE WHEN l.Status NOT IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'Invalid', 'Test', 'Deleted', 'Merged' ) THEN 'Lead' ELSE l.Status END)
,       dc.ContactStatusDescription = CASE WHEN l.Status NOT IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'Invalid', 'Test', 'Deleted', 'Merged' ) THEN 'Lead' ELSE l.Status END
,       dc.ContactMethodSSID = UPPER(CASE WHEN l.Status NOT IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'Invalid', 'Test', 'Deleted', 'Merged' ) THEN 'Lead' ELSE l.Status END)
,       dc.ContactMethodDescription = ''
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
        INNER JOIN #LeadCleanup l
            ON l.ContactID__c = dc.ContactSSID


UPDATE	fl
SET		fl.Leads = 0
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
			ON c.ContactKey = fl.ContactKey
WHERE	c.ContactStatusSSID IN ( 'MERGED', 'DELETED', 'INVALID', 'TEST', '-1', '' )
		AND fl.Leads <> 0


UPDATE	fl
SET		fl.LeadCreationDateKey = d.DateKey
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
			ON c.ContactKey = fl.ContactKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = CAST(c.CreationDate AS DATE)
WHERE	fl.LeadCreationDateKey <> d.DateKey

END
GO
