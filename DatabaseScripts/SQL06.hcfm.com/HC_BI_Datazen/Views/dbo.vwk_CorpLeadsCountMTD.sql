/***********************************************************************
VIEW:					vwk_CorpLeadsCountMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_CorpLeadsCountMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_CorpLeadsCountMTD]
AS




SELECT
	SUM(ISNULL(FL.Leads,0)) AS 'Actual'
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FL.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FL.LeadCreationDateKey = dd.DateKey
		WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
		AND C.CenterSSID LIKE '[2]%'
