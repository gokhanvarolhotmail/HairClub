/* CreateDate: 03/12/2019 10:40:36.580 , ModifyDate: 02/10/2020 17:14:52.240 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_KPISummaryDetails_PCP]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		03/12/2019

==============================================================================
DESCRIPTION:	This KPI Summary detail report is for @Type	= 36 for PCP Revenue Actual; 37 for Total Center Revenue Actual
==============================================================================
NOTES:	@Type	= 36 for PCP Revenue Actual; 37 for Total Center Revenue Actual
		@Filter = 2 for Areas; 3 for Centers
==============================================================================
CHANGE HISTORY:
06/19/2019 - JL - (TFS 12573) Laser Report adjustment
07/23/2019 - RH - Corrected Retail Amount
01/09/2020 - RH - TrackIT 5115 Added Surgery Amount to Total Center Sales
02/10/2020 - RH - TrackIT 5246 Changed AccountID IN(10531,10532,10535) to AccountID = 10536 for Total PCP Revenue Actual; changed 10530 to 10536 in the Total Actual section (per Rev)
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_KPISummaryDetails_PCP]  201, 36, '01/1/2020', '01/31/2020'
EXEC [spRpt_KPISummaryDetails_PCP]  236, 37, '01/1/2020', '01/31/2020'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_KPISummaryDetails_PCP] (
	@CenterNumber INT
,	@Type INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

/**************************** Create temp tables **********************************************/

CREATE TABLE #Centers (
	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,	MainGroupKey INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
)


CREATE TABLE #Retail(
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,	RetailSales DECIMAL(18,4)
)


CREATE TABLE #Accounting(
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,	PartitionDate DATETIME
,	AccountID INT
,	AccountDescription NVARCHAR(150)
,	Actual  DECIMAL(18,4)
,	Budget  DECIMAL(18,4)
,	Total DECIMAL(18,4)
)

CREATE TABLE #Final(
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,	PartitionDate DATETIME
,	AccountID INT
,	AccountDescription NVARCHAR(150)
,	Actual  DECIMAL(18,4)
,	Budget  DECIMAL(18,4)
,	Total DECIMAL(18,4)
)

-- Find Partition Date for FactAccounting

DECLARE @StartPartitionDate DATETIME
SET @StartPartitionDate = CAST(CAST(MONTH(@StartDate) AS NVARCHAR(2)) + '/1/' + CAST(YEAR(@StartDate) AS NVARCHAR(4)) AS DATETIME)

PRINT @StartDate

/********************************** Get list of centers *************************************/

INSERT INTO #Centers
SELECT DC.CenterKey
,	DC.CenterSSID
,	DC.CenterNumber
,	DC.CenterDescriptionNumber
,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionKey ELSE CMA.CenterManagementAreaKey END AS MainGroupKey
,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionDescription ELSE CMA.CenterManagementAreaDescription END AS MainGroupDescription
,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionSortOrder ELSE CMA.CenterManagementAreaSortOrder END AS MainGroupSortOrder
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DCT.CenterTypeKey = DC.CenterTypeKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
			ON DR.RegionKey = DC.RegionKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
WHERE   DC.CenterNumber = @CenterNumber
		AND DC.Active = 'Y'



/********* Find Retail Sales based on Transaction Center **************************************************/


INSERT INTO #Retail
SELECT  C.CenterNumber
	,	C.CenterDescriptionNumber
	,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailSales'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Centers C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND ( DSCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND DSC.SalesCodeDepartmentSSID <> 3065)
GROUP BY C.CenterNumber
,		C.CenterDescriptionNumber

/*********************--Query for @Type = 36 'PCP Revenue Actual'  *******************************/

IF @Type = 36
BEGIN

INSERT INTO #Accounting
SELECT FA.CenterID AS 'CenterNumber'
	,	CTR.CenterDescriptionNumber
     , FA.PartitionDate
	 , ACC.AccountID
     , ACC.AccountDescription
     , ISNULL(FA.Flash,0)  AS 'Actual'
	 , ABS(FA.Budget) AS 'Budget'
	 ,	 NULL AS Total
FROM HC_Accounting.dbo.FactAccounting FA
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
	ON ACC.AccountID = FA.AccountID
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FA.CenterID = CTR.CenterNumber    --CenterID in FactAccounting is 238 for Colorado Springs
WHERE FA.CenterID = @CenterNumber
--AND FA.AccountID IN (10531,10532,10535)
AND FA.AccountID = 10536
AND FA.PartitionDate = @StartPartitionDate



INSERT INTO #Final
SELECT ACCT.CenterNumber
     ,	CenterDescriptionNumber
     ,	PartitionDate
     ,	AccountID
     ,	AccountDescription
     ,	Actual
     ,	Budget
	 ,	CASE WHEN Budget = 0 THEN 0 ELSE (Actual / Budget) END AS Total
FROM #Accounting ACCT
END

ELSE IF @Type = 37
BEGIN

/****************--Query for @Type = 37 'Total Revenue Actual'****************************************/

INSERT INTO #Accounting
SELECT FA.CenterID AS CenterNumber
,	CTR.CenterDescriptionNumber
,	FA.PartitionDate
,	ACC.AccountID
,	ACC.AccountDescription
,	CASE WHEN FA.AccountID = 10555 THEN 0 ELSE ISNULL(FA.Flash,0) END AS 'Actual' --we don't want AccountID = 10555 for Retail, we want Actual Retail from the temp table above (so it will match Flash Recurring Business)
,	ABS(FA.Budget) AS 'Budget'
,	CASE WHEN FA.AccountID = 10555 THEN 0
		WHEN ABS(FA.Budget) = 0 THEN 0
		ELSE ISNULL(FA.Flash,0)/ABS(FA.Budget) END AS 'Total'
FROM HC_Accounting.dbo.FactAccounting FA
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
	ON ACC.AccountID = FA.AccountID
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FA.CenterID = CTR.CenterNumber
WHERE FA.CenterID = @CenterNumber
AND FA.AccountID IN (10305,10306,10310,10315,10320,10325,10536,10540,10551,10552,10555,10575,10891) --Use 10555 as a placeholder for Retail
AND FA.PartitionDate = @StartPartitionDate

UPDATE ACCT												-- Retail Sales from the temp table #Retail
SET ACCT.Actual = R.RetailSales
FROM #Accounting ACCT
INNER JOIN #Retail R ON ACCT.CenterNumber = R.CenterNumber
WHERE ACCT.AccountID = 10555
AND ACCT.Actual = 0



INSERT INTO #Final
SELECT CenterNumber
,	CenterDescriptionNumber
,	PartitionDate
,	AccountID
,	AccountDescription
,	Actual
,	Budget
,	CASE WHEN Budget = 0 THEN 0 ELSE (Actual/ Budget) END  AS Total
FROM #Accounting


END

SELECT * FROM #Final


END
GO
