/* CreateDate: 08/13/2019 09:20:12.623 , ModifyDate: 08/13/2019 09:20:12.623 */
GO
/***********************************************************************
PROCEDURE:				spSvc_HC_BI_MKTG_DDS_Cleanup
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_MKTG_DDS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/13/2019
DESCRIPTION:			8/13/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_HC_BI_MKTG_DDS_Cleanup
***********************************************************************/
CREATE PROCEDURE spSvc_HC_BI_MKTG_DDS_Cleanup
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DELETE	far
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults far
WHERE   far.ActivityKey NOT IN ( SELECT da.ActivityKey FROM bi_mktg_dds.DimActivity da )


SELECT	dc.SFDC_LeadID
INTO	#DuplicateLead
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
WHERE	dc.SFDC_LeadID IS NOT NULL
GROUP BY dc.SFDC_LeadID
HAVING COUNT(*) > 1


SELECT	ROW_NUMBER() OVER ( PARTITION BY dl.SFDC_LeadID ORDER BY dc.ContactKey ) AS 'RowID'
,		dc.ContactKey
,		dl.SFDC_LeadID
INTO	#Lead
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
		INNER JOIN #DuplicateLead dl
			ON dl.SFDC_LeadID = dc.SFDC_LeadID


SELECT	l.RowID
,		l.ContactKey
,		l.SFDC_LeadID
INTO	#Cleanup
FROM	#Lead l
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity fa
			ON fa.ContactKey = l.ContactKey
WHERE	fa.ActivityKey IS NULL


SELECT	c.SFDC_LeadID
INTO	#DuplicateCleanup
FROM	#Cleanup c
GROUP BY c.SFDC_LeadID
HAVING COUNT(*) > 1


DELETE	dc
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
		INNER JOIN #Cleanup c
			ON c.ContactKey = dc.ContactKey
		LEFT OUTER JOIN #DuplicateCleanup d
			ON d.SFDC_LeadID = c.SFDC_LeadID
WHERE	d.SFDC_LeadID IS NULL


DELETE	fl
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		INNER JOIN #Cleanup c
			ON c.ContactKey = fl.ContactKey
		LEFT OUTER JOIN #DuplicateCleanup d
			ON d.SFDC_LeadID = c.SFDC_LeadID
WHERE	d.SFDC_LeadID IS NULL


DELETE	dc
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
		INNER JOIN #Cleanup c
			ON c.ContactKey = dc.ContactKey
		INNER JOIN #DuplicateCleanup d
			ON d.SFDC_LeadID = c.SFDC_LeadID
WHERE	c.RowID = 2


DELETE	fl
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		INNER JOIN #Cleanup c
			ON c.ContactKey = fl.ContactKey
		INNER JOIN #DuplicateCleanup d
			ON d.SFDC_LeadID = c.SFDC_LeadID
WHERE	c.RowID = 2


END
GO
