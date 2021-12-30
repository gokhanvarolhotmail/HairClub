/* CreateDate: 08/24/2015 16:43:15.833 , ModifyDate: 08/25/2015 16:15:45.470 */
GO
/***********************************************************************
VIEW:					vwd_RetailSalesByProduct
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/24/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_RetailSalesByProduct
***********************************************************************/
CREATE VIEW [dbo].[vwd_RetailSalesByProduct]
AS


WITH Rolling1Month AS (
	SELECT DateKey, DD.FullDate, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
		AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
)
,	PreviousYear AS (

	SELECT DATEADD(YEAR,1,DD.FullDate) AS 'FullDate'
		,	CE.CenterSSID
		,	SalesCodeDepartmentDescription
		,	SUM(ISNULL(FST.RetailAmt,0)) AS 'PY_RetailAmt'
	FROM HC_BI_CMS_DDS.BI_CMS_DDS.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		    ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_DDs.DimCenter CE
			ON FST.CenterKey = CE.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
	WHERE CE.CenterSSID LIKE '[2]%'
		AND FullDate BETWEEN DATEADD(YEAR,-1,DATEADD(MONTH,-2, DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()),0))) --Two months ago one year ago
			AND DATEADD(YEAR,-1,DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) ))) --11:59 PM today one year ago
		AND RetailAmt <> '0.00'
		AND DSC.SalesCodeDepartmentSSID IN(3010,3020,3030,3040,3050,3060,3070,3080)
	GROUP BY DATEADD(YEAR,1,DD.FullDate)
		,	CE.CenterSSID
		,	SalesCodeDepartmentDescription
)


	SELECT DD.FullDate
		,	DD.YearNumber
		,	CE.CenterSSID
		,	R.RegionDescription
		,	DSCD.SalesCodeDepartmentDescription
		,	SUM(ISNULL(FST.RetailAmt,0)) AS 'RetailAmt'
		,	ISNULL(PY_RetailAmt,0) AS 'PY_RetailAmt'
	FROM HC_BI_CMS_DDS.BI_CMS_DDS.FactSalesTransaction FST
		INNER JOIN Rolling1Month DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_DDs.DimCenter CE
			ON FST.CenterKey = CE.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON CE.RegionKey = R.RegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
		LEFT JOIN PreviousYear PY
			ON CE.CenterSSID = PY.CenterSSID
				AND DD.FullDate = PY.FullDate
				AND DSCD.SalesCodeDepartmentDescription = PY.SalesCodeDepartmentDescription
	WHERE CE.CenterSSID LIKE '[2]%'
		AND RetailAmt <> '0.00'
		AND DSC.SalesCodeDepartmentSSID IN(3010,3020,3030,3040,3050,3060,3070,3080)
	GROUP BY DD.FullDate
		,	DD.YearNumber
		,	CE.CenterSSID
		,	R.RegionDescription
		,	DSCD.SalesCodeDepartmentDescription
		,	ISNULL(PY_RetailAmt,0)
GO
