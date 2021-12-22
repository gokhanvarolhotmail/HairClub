/* CreateDate: 07/28/2014 16:14:44.980 , ModifyDate: 01/26/2015 14:12:52.707 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardRegionalSalesManagers

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		07/28/2014

==============================================================================
DESCRIPTION:
==============================================================================
NOTES:
12/16/2014 - RH - Changed source of RetailSales to be Transaction Center based.
01/26/2015 - RH - (WO#111085) In order to match Regional Directors - Removed 10555 (RetailSales$), found RetailSales$ in a temp table from FactSalesTransaction
					and then updated TotalRevenueActual = SubTotalRevenueActual + RetailSales
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardRegionalSalesManagers] 1, 2015
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardRegionalSalesManagers] (
	@Month			TINYINT
,	@Year			SMALLINT)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	CREATE TABLE #Centers (
		CenterID INT
	)

	INSERT INTO #Centers
	SELECT c.CenterSSID
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
	WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'

	/********* Find Retail Sales based on Transaction Center --12/16/2014 RH *********************************/

	SELECT  CTR.ReportingCenterSSID AS 'CenterID'
	,       SUM(CASE WHEN DSCD.SalesCodeDivisionSSID = 30 THEN FST.ExtendedPrice ELSE 0 END) AS 'RetailSales'
	INTO	#Retail
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
				ON FST.CenterKey = CTR.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
				ON FST.SalesCodeKey = DSC.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
				ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
	WHERE   DD.MonthNumber = @Month
			AND DD.YearNumber = @Year
			AND ( DSCD.SalesCodeDivisionSSID IN (30)
				  OR DSC.SalesCodeDescriptionShort IN ( 'HM3V5', 'EXTPMTLC', 'EXTPMTLCP' ) )
	GROUP BY CTR.ReportingCenterSSID


	--Find Regional Sales Managers
	SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'EmployeeKey'
		,	ISNULL(DC.RegionNB1, 'Unknown, Unknown')AS 'RegionalSalesManager'
		,	DC.CenterSSID
		,	DC.CenterDescriptionNumber
		,	DCT.CenterTypeDescriptionShort
	INTO #Managers
	FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DC.CenterTypeKey = DCT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
			ON DC.RegionSSID = DR.RegionKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON DC.RegionRSMNBConsultantSSID = DE.EmployeeSSID
	WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
		AND DC.Active = 'Y'
	ORDER BY ISNULL(DC.RegionNB1, 'Unknown, Unknown')

	--SELECT * FROM #Managers

	SELECT FA.CenterID
	,	man.RegionalSalesManager
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN Flash ELSE 0 END, 0)) AS 'NetNB1CountActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN Budget ELSE 0 END, 0)) END AS 'NetNB1CountBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325) THEN Flash ELSE 0 END, 0)) AS 'NetNb1RevenueActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) END AS 'NetNb1RevenueBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'ApplicationsActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 0)) END AS 'ApplicationsBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10440) THEN Flash ELSE 0 END, 0)) AS 'ConversionsActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10440) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10440) THEN Budget ELSE 0 END, 0)) END AS 'ConversionsBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10530) THEN Flash ELSE 0 END, 0)) AS 'PCPRevenueActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10530, 10535) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10530, 10535) THEN Budget ELSE 0 END, 0)) END AS 'PCPRevenueBudget'
		--,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325, 10530, 10525) THEN Flash ELSE 0 END, 0)) + SUM(R.RetailSales) AS 'TotalRevenueActual' --12/16/2014 RH Removed 01/12/2015
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325, 10530, 10535, 10525) THEN Flash ELSE 0 END, 0)) = 0
			THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325, 10530, 10535, 10525) THEN Flash ELSE 0 END, 0)) END AS 'SubTotalRevenueActual' --Remove 10555 = RetailSales$ To be added below RH 1/26/2015

	,	NULL AS 'TotalRevenueActual'

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325, 10530, 10535, 10525,10555) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325, 10530, 10535, 10525,10555) THEN Budget ELSE 0 END, 0)) END AS 'TotalRevenueBudget'
	INTO #Accounting
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterID
		INNER JOIN #Managers man
			ON C.CenterID = man.CenterSSID
	WHERE MONTH(FA.PartitionDate)=@Month
	  AND YEAR(FA.PartitionDate)=@Year
	GROUP BY FA.CenterID
	,	man.RegionalSalesManager

	UPDATE ACCT  --Added statement RH 1/26/2015
	SET ACCT.TotalRevenueActual = (ACCT.SubTotalRevenueActual + R.RetailSales)
	FROM #Accounting ACCT
	INNER JOIN #Retail R ON ACCT.CenterID = R.CenterID
	WHERE ACCT.TotalRevenueActual IS NULL


	SELECT A.CenterID
	,	C.CenterDescriptionNumber
	,	A.RegionalSalesManager
	,	A.NetNB1CountActual
	,	A.NetNB1CountBudget
	,	A.NetNB1CountActual - A.NetNB1CountBudget AS 'NetNB1CountDiff'
	,	dbo.DIVIDE_DECIMAL(A.NetNB1CountActual, A.NetNB1CountBudget) AS 'NetNB1CountPercent'
	,	A.NetNb1RevenueActual
	,	A.NetNb1RevenueBudget
	,	A.NetNb1RevenueActual - A.NetNb1RevenueBudget AS 'NetNB1RevenueDiff'
	,	dbo.DIVIDE_DECIMAL(A.NetNb1RevenueActual, A.NetNb1RevenueBudget) AS 'NetNB1RevenuePercent'
	,	A.ApplicationsActual
	,	A.ApplicationsBudget
	,	A.ApplicationsActual - A.ApplicationsBudget AS 'ApplicationDiff'
	,	dbo.DIVIDE_DECIMAL(A.ApplicationsActual, A.ApplicationsBudget) AS 'ApplicationPercent'
	,	A.ConversionsActual
	,	A.ConversionsBudget
	,	A.ConversionsActual - A.ConversionsBudget AS 'ConversionDiff'
	,	dbo.DIVIDE_DECIMAL(A.ConversionsActual, A.ConversionsBudget) AS 'ConversionPercent'
	,	A.PCPRevenueActual
	,	A.PCPRevenueBudget
	,	A.PCPRevenueActual - A.PCPRevenueBudget AS 'PCPDiff'
	,	dbo.DIVIDE_DECIMAL(A.PCPRevenueActual, A.PCPRevenueBudget) AS 'PCPPercent'
	,	A.TotalRevenueActual
	,	A.TotalRevenueBudget
	,	A.TotalRevenueActual - A.TotalRevenueBudget AS 'TotalDiff'
	,	dbo.DIVIDE_DECIMAL(A.TotalRevenueActual, A.TotalRevenueBudget) AS 'TotalPercent'
	FROM #Accounting A
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON a.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	GROUP BY A.CenterID
	,	C.CenterDescriptionNumber
	,	A.RegionalSalesManager
	,	A.NetNB1CountActual
	,	A.NetNB1CountBudget
	,	A.NetNb1RevenueActual
	,	A.NetNb1RevenueBudget
	,	A.ApplicationsActual
	,	A.ApplicationsBudget
	,	A.ConversionsActual
	,	A.ConversionsBudget
	,	A.PCPRevenueActual
	,	A.PCPRevenueBudget
	,	A.TotalRevenueBudget
	,	A.TotalRevenueActual
	ORDER BY A.RegionalSalesManager
		,	A.CenterID


END
GO
