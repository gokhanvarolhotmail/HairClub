/* CreateDate: 08/21/2015 12:55:53.113 , ModifyDate: 08/21/2015 13:04:16.987 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_RetailByEmployee
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_RetailByEmployee
***********************************************************************/
CREATE VIEW [dbo].[vwd_RetailByEmployee]
AS


WITH Rolling1Month AS (
	SELECT DateKey, DD.FullDate, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(month,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
		AND DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0) )) --Today at 11:59PM
)


	SELECT DD.FullDate
		,	CE.CenterSSID
		,	E.EmployeeFullName
		,	E.EmployeeInitials
		,	SUM(ISNULL(FST.RetailAmt,0)) AS 'RetailAmt'
	FROM HC_BI_CMS_DDS.BI_CMS_DDS.FactSalesTransaction FST
		INNER JOIN Rolling1Month DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN [HC_BI_CMS_DDS].[BI_CMS_DDS].DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_DDs.DimCenter CE
			ON FST.CenterKey = CE.CenterKey
	WHERE CE.CenterSSID LIKE '[2]%'
		AND RetailAmt <> '0.00'
	GROUP BY DD.FullDate
		,	CE.CenterSSID
		,	E.EmployeeFullName
		,	E.EmployeeInitials
GO
