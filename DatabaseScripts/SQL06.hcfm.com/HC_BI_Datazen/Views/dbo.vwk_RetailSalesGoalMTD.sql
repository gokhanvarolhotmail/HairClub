/* CreateDate: 07/27/2015 11:26:11.630 , ModifyDate: 07/27/2015 12:11:42.773 */
GO
/***********************************************************************
VIEW:					vwk_RetailSalesGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_RetailSalesGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_RetailSalesGoalMTD]
AS


SELECT 	(-1 * SUM(ISNULL(FA.Budget,0))) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
WHERE   DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
			AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
	AND FA.CenterID LIKE '[2]%'
	AND FA.AccountID in(3090,3096)  --To match Center Flash
GO
