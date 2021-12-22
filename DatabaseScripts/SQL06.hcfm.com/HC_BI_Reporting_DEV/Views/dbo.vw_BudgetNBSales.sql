/* CreateDate: 09/19/2018 14:01:04.430 , ModifyDate: 09/20/2018 14:45:10.140 */
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
This view is used in Power BI for NB - Net Sales (Incl PEXT) #
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vw_BudgetNBSales]
***********************************************************************/
CREATE VIEW [dbo].[vw_BudgetNBSales]
AS


WITH Rolling2Years AS (
				SELECT DateKey
				,	DD.FullDate
				,	YearNumber
				,	YearMonthNumber
				FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
				WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
					  AND GETUTCDATE() -- Today
)
SELECT   C.CenterKey
				,	CMA.CenterManagementAreaDescription
				,    DD.FullDate
				,    SUM(ISNULL(CASE WHEN FA.AccountID IN (10231) THEN ROUND(ABS(FA.Budget), 0)ELSE 0 END, 0)) AS 'Bud_NB_NetSales_InclPEXT'
				,    SUM(ISNULL(CASE WHEN FA.AccountID IN (10231) THEN ROUND(ABS(FA.Flash), 0)ELSE 0 END, 0)) AS 'NB_NetSales_InclPEXT'
			   FROM   HC_Accounting.dbo.FactAccounting FA
					INNER JOIN Rolling2Years DD
						ON FA.DateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FA.CenterID = C.CenterSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = C.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON CMA.CenterManagementAreaSSID = C.CenterManagementAreaSSID
			   WHERE CT.CenterTypeDescriptionShort = 'C'
					AND C.Active = 'Y'
			   GROUP BY C.CenterKey
			   ,        DD.FullDate
			   ,		CMA.CenterManagementAreaDescription
GO
