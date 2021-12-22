/* CreateDate: 09/19/2018 13:59:08.240 , ModifyDate: 09/19/2018 13:59:08.240 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vw_BudgetNBSales]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		10/30/2015
------------------------------------------------------------------------
NOTES:
This view is used in Power BI
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vw_BudgetNBSales]
***********************************************************************/
CREATE VIEW [dbo].[vw_BudgetNBSales]
AS

WITH Rolling1Month AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	MAX(DD.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				, DD.YearNumber
			 )
SELECT   C.CenterSSID
				,    DD.FullDate
				,    SUM(ISNULL(CASE WHEN FA.AccountID IN (10233) THEN ROUND(ABS(FA.Budget), 0)ELSE 0 END, 0)) AS 'NB_NetSales_InclPEXT'
			   FROM   HC_Accounting.dbo.FactAccounting FA
					INNER JOIN Rolling1Month DD
						ON FA.DateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FA.CenterID = C.CenterSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = C.CenterTypeKey
			   WHERE DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
							AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
					AND CT.CenterTypeDescriptionShort = 'C'
					AND C.Active = 'Y'
			   GROUP BY C.CenterSSID
			   ,        DD.FullDate
GO
