/***********************************************************************
VIEW:					vwk_ServiceSalesGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT Goal FROM vwk_ServiceSalesGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_ServiceSalesGoalMTD]
AS


SELECT 	SUM(ISNULL(FA.Budget,0)) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
WHERE   DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
			AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
	AND FA.CenterID LIKE '[2]%'
	AND FA.AccountID = 10575
