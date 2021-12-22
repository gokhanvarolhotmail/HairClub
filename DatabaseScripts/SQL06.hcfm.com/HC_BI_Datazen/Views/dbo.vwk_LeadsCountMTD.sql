/* CreateDate: 07/21/2015 15:39:14.860 , ModifyDate: 08/10/2015 16:10:53.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_LeadsCountMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/10/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_LeadsCountMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_LeadsCountMTD]
AS




SELECT
	SUM(ISNULL(FL.Leads,0)) AS 'Actual'
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FL.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FL.LeadCreationDateKey = dd.DateKey
		WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
		AND C.CenterSSID LIKE '[278]%'
GO
