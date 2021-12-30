/* CreateDate: 04/13/2017 17:04:38.423 , ModifyDate: 02/02/2021 10:59:39.413 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_KPISummary]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		04/13/2017

==============================================================================
DESCRIPTION:	This is a rewrite of the Warboard Driver Summary
==============================================================================
NOTES:	@Filter = 2 is Area Managers, 3 is By Centers
@TimeFilter = 1 for Monthly, 2 for Quarterly, 3 for YTD
@Time is the detail of the timeframe, specific month or quarter selected
==============================================================================
CHANGE HISTORY:
01/09/2020 - RH - (TFS 13688) Added Accounts for Surgery and RestorInk to NetNB1Count, NetNB1Revenue and TotalRevenue - Actual and Budget
02/10/2020 - RH - (TrackIT 5246) Changed 10530 to 10536 in the Total Actual section (per Rev)
03/16/2020 - RH - (TrackIT 7697) Added S_PRPCnt to NB_NetNBCnt; changed NetNB1CountActual to NetNB1Count from #Sales; changed NetNB1RevenueActual to NetNB1Amount from #Sales
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_KPISummary] 2,2020,1,1  --Monthly
EXEC [spRpt_KPISummary] 3,2020,1,12

EXEC [spRpt_KPISummary] 2,2020,2,1  --By Quarter
EXEC [spRpt_KPISummary] 3,2020,2,1

EXEC [spRpt_KPISummary] 2,2020,3,0  --YTD
EXEC [spRpt_KPISummary] 3,2020,3,0
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_KPISummary] (
	@Filter	INT
,	@Year	INT
,	@Timeframe INT
,	@Time	INT

)
AS
BEGIN
	SET FMTONLY OFF


/******************** Create a start date and end date to use for the drill-downs in the report ***/
DECLARE @Month INT
DECLARE @Quarter INT

DECLARE @StartDate DATETIME
	,	@EndDate DATETIME

IF @Timeframe = 1																	--Monthly
	BEGIN
	SET @Month = @Time
	SET @StartDate = CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
	SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(month,1,@StartDate) ))

	--PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	--PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))
END

ELSE IF @Timeframe = 2																--Quarterly
BEGIN
	SET @Quarter = @Time
	IF @Quarter = 1
		BEGIN
		SET @StartDate = CAST('1/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('3/31/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END
	ELSE IF @Quarter = 2
		BEGIN
		SET @StartDate = CAST('4/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('6/30/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END
	ELSE IF @Quarter = 3
		BEGIN
		SET @StartDate = CAST('7/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('9/30/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END
	ELSE IF @Quarter = 4
		BEGIN
		SET @StartDate = CAST('10/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('12/31/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END

	--PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	--PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))
END

ELSE IF @Timeframe = 3																--YTD
BEGIN
	SET @StartDate = CAST('1/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
	SET @EndDate = GETUTCDATE()
	SET @Time = 0

	--PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	--PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))
END

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription  VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(103)
)



/********************************** Get list of centers *************************************/

IF @Filter = 2												--By Corporate Areas
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON	CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.Active = 'Y'
END
IF @Filter = 3												-- By Corporate Centers
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterNumber AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroupDescription'
		,		NULL AS 'MainGroupSortOrder'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON	CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.Active = 'Y'
END




/********* Find Retail Sales based on Transaction Center **************************************************/


SELECT  ctr.MainGroupID
	,	ctr.MainGroupDescription
	,	ctr.CenterNumber
	,	SUM(ISNULL(t.RetailAmt, 0)) AS 'RetailActual'
INTO	#Retail
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON t.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON t.CenterKey = c.CenterKey
		INNER JOIN #Centers ctr
            ON c.CenterSSID = ctr.CenterSSID
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON t.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   d.FullDate BETWEEN @StartDate AND @EndDate
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
GROUP BY ctr.MainGroupID
	,	ctr.MainGroupDescription
	,	ctr.CenterNumber

/********* Find Budget and Actual Amounts **************************************************/

SELECT C.MainGroupID
	,	C.MainGroupDescription
	,	C.CenterNumber

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10205,10206,10210,10215,10220,10225,10901) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10205,10206,10210,10215,10220,10225,10901) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'NetNB1CountBudget'

--,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891) THEN Flash ELSE 0 END, 0)) AS 'NetNb1RevenueActual'

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'NetNb1RevenueBudget'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'ApplicationsActual'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'ApplicationsBudget'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BIOConversionsActual'  --BIO only
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'BIOConversionsBudget'	--BIO only

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Flash ELSE 0 END, 0)) AS 'EXTConversionsActual'  --EXT only
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'EXTConversionsBudget'	--EXT only

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Flash ELSE 0 END, 0)) AS 'XtrandsConversionsActual'  --Xtrands only
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'XtrandsConversionsBudget'	--Xtrands only


,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN Flash ELSE 0 END, 0)) AS 'PCPRevenueActual'						--BIO,EXT and Xtrands
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'PCPRevenueBudget'	--BIO,EXT and Xtrands

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10536,10540,10551,10552,10575,10891) THEN Flash ELSE 0 END, 0)) = 0
		THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10536,10540,10551,10552,10575,10891) THEN Flash ELSE 0 END, 0))
		END AS 'SubTotalRevenueActual'  --Retail (10555) is not included here

,	NULL AS 'TotalRevenueActual'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10536,10540,10551,10552,10555,10575,10891) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10536,10540,10551,10552,10555,10575,10891) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'TotalRevenueBudget' --Retail (10555) is here

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10555) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10555) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'RetailBudget'

INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber
	WHERE FA.PartitionDate BETWEEN @StartDate AND @EndDate
GROUP BY C.MainGroupID
	,	C.MainGroupDescription
	,	C.CenterNumber


--Add Retail from #Retail to the SubTotalRevenueActual  --Retail is from the transaction center, not the home center

UPDATE ACCT
SET ACCT.TotalRevenueActual = (ACCT.SubTotalRevenueActual + R.RetailActual)
FROM #Accounting ACCT
INNER JOIN #Retail R ON ACCT.CenterNumber = R.CenterNumber
WHERE ACCT.TotalRevenueActual IS NULL

/************************* Find previous months PCP Count to use for the PMC budget ********************************/
--The target is 2% of the PCP count (Xtr+ only)
/*Example for November:
November PMC volume / October Xtr+ PCP count = %  (if this percentage is greater than or equal to 2%, metric goes green)
*/
-- Get Closing PCP data - which is for the preceding month
 IF OBJECT_ID('tempdb..#ClosePCP') IS NOT NULL
 BEGIN
 	DROP TABLE #ClosePCP
 END

SELECT  b.CenterID AS 'CenterNumber'   --CenterID matches CenterNumber in FactAccounting
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate)) AS 'PCPEnd'
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate)) AS 'YearPCPEnd'
,   SUM(b.Flash) AS 'ClosePCP'
INTO #ClosePCP
FROM    HC_Accounting.dbo.FactAccounting b
        INNER JOIN #Centers c
            ON b.CenterID = c.CenterNumber
WHERE   MONTH(b.PartitionDate) = MONTH(@EndDate)
        AND YEAR(b.PartitionDate) = YEAR(@EndDate)
        AND b.AccountID = 10400
GROUP BY b.CenterID
,	MONTH(b.PartitionDate)
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate))
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate))
,	YEAR(b.PartitionDate)


/*************************** Find consultations ********************************************************************/
SELECT	DC.CenterNumber
,		A.ActivityKey
,		A.ActionCodeSSID
,		A.ResultCodeSSID
,		DD.FullDate
,		DAD.Performer
,		CASE WHEN Consultation = 1 THEN 1 ELSE 0 END AS 'Consultations'
,		CASE WHEN ISNULL(FAR.Accomodation, 'In Person Consult') = 'In Person Consult' AND Consultation = 1 THEN 1 ELSE 0 END AS 'InPersonConsultations'
,		CASE WHEN ISNULL(FAR.Accomodation, 'In Person Consult') <> 'In Person Consult' AND Consultation = 1 THEN 1 ELSE 0 END AS 'VirtualConsultations'
,		CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN CASE WHEN DD.FullDate < '12/1/2020' THEN 0 ELSE 1 END END AS 'ExcludeFromConsults'
INTO	#Cons
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FAR.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FAR.ActivityDueDateKey = DD.DateKey
		INNER JOIN #Centers CTR
			ON DC.CenterNumber = CTR.CenterNumber
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
			ON A.ActivityKey = FAR.ActivityKey
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD  WITH (NOLOCK)
			ON DAD.SFDC_TaskID = A.SFDC_TaskID
WHERE	DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.Show = 1


SELECT	DC.CenterNumber
,		A.ActivityKey
,		A.ActionCodeSSID
,		A.ResultCodeSSID
,		DD.FullDate
,		CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN 1 ELSE 0 END AS 'BeBacks'
INTO	#BB
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FAR.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FAR.ActivityDueDateKey = DD.DateKey
		INNER JOIN #Centers CTR
			ON DC.CenterNumber = CTR.CenterNumber
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
			ON A.ActivityKey = FAR.ActivityKey
WHERE	DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.Show = 1


--Get consultations
SELECT	c.CenterNumber
,		SUM(c.Consultations) AS 'Consultations'
,		SUM(CASE WHEN ISNULL(c.ExcludeFromConsults, 0) = 1 THEN 1 ELSE 0 END) AS 'BeBacksToExclude'
INTO	#Consultations
FROM	#Cons c
GROUP BY c.CenterNumber


SELECT	b.CenterNumber
,		SUM(b.BeBacks) AS 'BeBacks'
INTO	#BeBacks
FROM	#BB b
GROUP BY b.CenterNumber


/********************** Find Sales *********************************************************************************/
SELECT	CTR.MainGroupID
,		CTR.MainGroupDescription
,		CTR.CenterNumber
,		SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0)) + SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.NB_XTRCnt, 0)) + SUM(ISNULL(FST.S_SurCnt, 0)) + SUM(ISNULL(FST.NB_MDPCnt, 0)) + SUM(ISNULL(FST.S_PRPCnt, 0)) AS 'NetNB1Count'
,		SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) + SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.S_PostExtAmt, 0))
		+ SUM(ISNULL(FST.NB_XTRAmt, 0)) + SUM(ISNULL(FST.S_SurAmt, 0)) + SUM(ISNULL(FST.NB_MDPAmt, 0)) + SUM(ISNULL(FST.S_PRPAmt, 0))
		+ SUM(ISNULL(FST.NB_LaserAmt, 0)) AS 'NetNB1Amount'
,		SUM(ISNULL(FST.NB_MDPAmt, 0)) AS NB_MDPAmt
,		SUM(ISNULL(FST.NB_MDPCnt, 0)) AS NB_MDPCnt
,		SUM(ISNULL(FST.PCP_UpgCnt, 0)) AS PMCActual
,		SUM(ISNULL(FST.NB_LaserAmt, 0)) AS LaserAmt
INTO	#Sales
FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C --Keep HomeCenter-based like the NB Flash
			ON CM.CenterKey = C.CenterKey
		INNER JOIN #Centers CTR
			ON C.CenterNumber = CTR.CenterNumber
WHERE	DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND SOD.IsVoidedFlag = 0
		AND (
				ISNULL(FST.NB_TradCnt, 0) <> 0
				OR ISNULL(FST.NB_ExtCnt, 0) <> 0
				OR ISNULL(FST.NB_XTRCnt, 0) <> 0
				OR ISNULL(FST.NB_GradCnt, 0) <> 0
				OR ISNULL(FST.S_PostExtCnt, 0) <> 0
				OR ISNULL(FST.NB_MDPCnt, 0) <> 0
				OR ISNULL(FST.PCP_UpgCnt, 0) <> 0
				OR ISNULL(FST.S_SurCnt, 0) <> 0
				OR ISNULL(FST.S_PRPCnt, 0) <> 0
				OR ISNULL(FST.NB_TradAmt, 0) <> 0
				OR ISNULL(FST.NB_GradAmt, 0) <> 0
				OR ISNULL(FST.NB_ExtAmt, 0) <> 0
				OR ISNULL(FST.S_PostExtAmt, 0) <> 0
				OR ISNULL(FST.NB_XTRAmt, 0) <> 0
				OR ISNULL(FST.S_SurAmt, 0) <> 0
				OR ISNULL(FST.NB_MDPAmt, 0) <> 0
				OR ISNULL(FST.S_PRPAmt, 0) <> 0
				OR ISNULL(FST.NB_LaserAmt, 0) <> 0
			)
GROUP BY CTR.MainGroupID
,		CTR.MainGroupDescription
,		CTR.CenterNumber


/****************************  Final Select  ************************************************************************/
SELECT C.MainGroupID
,	C.MainGroupDescription
,	C.CenterNumber
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	ROUND(ISNULL(S.NetNB1Count,0),0)  AS 'NetNB1CountActual'

,	CASE WHEN ROUND(ISNULL(A.NetNB1CountBudget,0),0)= 0 THEN 1 ELSE ROUND(ISNULL(A.NetNB1CountBudget,0),0) END AS 'NetNB1CountBudget'
,	CASE WHEN ROUND(ISNULL(A.NetNB1CountBudget,0),0)= 0 THEN (ROUND(ISNULL(S.NetNB1Count,0),0)) ELSE (ROUND(ISNULL(S.NetNB1Count,0),0) - ROUND(ISNULL(A.NetNB1CountBudget,0),0)) END AS 'NetNB1CountDiff'
,	CASE WHEN ROUND(ISNULL(A.NetNB1CountBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(S.NetNB1Count,0),0), 1)
		ELSE dbo.DIVIDE_DECIMAL( ROUND(ISNULL(S.NetNB1Count,0),0), ROUND(ISNULL(A.NetNB1CountBudget,0),0) ) END AS 'NetNB1CountPercent'

,	ROUND(ISNULL(S.NetNB1Amount,0),0)  AS 'NetNb1RevenueActual'
,	CASE WHEN ROUND(ISNULL(A.NetNb1RevenueBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.NetNb1RevenueBudget,0),0) END AS 'NetNb1RevenueBudget'
,	CASE WHEN ROUND(ISNULL(A.NetNb1RevenueBudget,0),0) = 0 THEN (ROUND(ISNULL(S.NetNB1Amount,0),0)) - 1 ELSE ROUND(ISNULL(S.NetNB1Amount,0),0) - ROUND(ISNULL(A.NetNb1RevenueBudget,0),0)END AS 'NetNB1RevenueDiff'
,	CASE WHEN ROUND(ISNULL(A.NetNb1RevenueBudget,0),0) = 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(S.NetNB1Amount,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(S.NetNB1Amount,0),0), ROUND(ISNULL(A.NetNb1RevenueBudget,0),0))	END AS 'NetNB1RevenuePercent'


,	ROUND(ISNULL(A.ApplicationsActual,0),0) AS 'ApplicationsActual'
,	CASE WHEN ROUND(ISNULL(A.ApplicationsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.ApplicationsBudget,0),0) END  AS 'ApplicationsBudget'
,	CASE WHEN ROUND(ISNULL(A.ApplicationsBudget,0),0) = 0 THEN (ROUND(ISNULL(A.ApplicationsActual,0),0) - 1) ELSE ROUND(ISNULL(A.ApplicationsActual,0),0) - ROUND(ISNULL(A.ApplicationsBudget,0),0)END AS 'ApplicationDiff'
,	CASE WHEN ROUND(ISNULL(A.ApplicationsBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.ApplicationsActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.ApplicationsActual,0),0), ROUND(ISNULL(A.ApplicationsBudget,0),0))	END AS 'ApplicationPercent'

,	ROUND(ISNULL(A.BIOConversionsActual,0),0) AS 'BIOConversionsActual'
,	CASE WHEN ROUND(ISNULL(A.BIOConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.BIOConversionsBudget,0),0) END AS 'BIOConversionsBudget'
,	CASE WHEN ROUND(ISNULL(A.BIOConversionsBudget,0),0) = 0 THEN (ROUND(ISNULL(A.BIOConversionsActual,0),0) - 1) ELSE ROUND(ISNULL(A.BIOConversionsActual,0),0) - ROUND(ISNULL(A.BIOConversionsBudget,0),0)END AS 'BIOConversionDiff'
,	CASE WHEN ROUND(ISNULL(A.BIOConversionsBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.BIOConversionsActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.BIOConversionsActual,0),0), ROUND(ISNULL(A.BIOConversionsBudget,0),0))	END AS 'BIOConversionPercent'

,	ROUND(ISNULL(A.EXTConversionsActual,0),0) AS 'EXTConversionsActual'
,	CASE WHEN ROUND(ISNULL(A.EXTConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.EXTConversionsBudget,0),0) END AS 'EXTConversionsBudget'
,	CASE WHEN ROUND(ISNULL(A.EXTConversionsBudget,0),0) = 0 THEN (ROUND(ISNULL(A.EXTConversionsActual,0),0) - 1) ELSE ROUND(ISNULL(A.EXTConversionsActual,0),0) - ROUND(ISNULL(A.EXTConversionsBudget,0),0) END AS 'EXTConversionDiff'
,	CASE WHEN ROUND(ISNULL(A.EXTConversionsBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.EXTConversionsActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.EXTConversionsActual,0),0), ROUND(ISNULL(A.EXTConversionsBudget,0),0))	END AS 'EXTConversionPercent'

,	ROUND(ISNULL(A.XtrandsConversionsActual,0),0) AS 'XtrandsConversionsActual'
,	CASE WHEN ROUND(ISNULL(A.XtrandsConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.XtrandsConversionsBudget,0),0) END AS 'XtrandsConversionsBudget'
,	CASE WHEN ROUND(ISNULL(A.XtrandsConversionsBudget,0),0) = 0 THEN (ROUND(ISNULL(A.XtrandsConversionsActual,0),0) - 1) ELSE ROUND(ISNULL(A.XtrandsConversionsActual,0),0) - ROUND(ISNULL(A.XtrandsConversionsBudget,0),0)END AS 'XtrandsConversionDiff'
,	CASE WHEN ROUND(ISNULL(A.XtrandsConversionsBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.XtrandsConversionsActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.XtrandsConversionsActual,0),0), ROUND(ISNULL(A.XtrandsConversionsBudget,0),0))	END AS 'XtrandsConversionPercent'

,	ROUND(ISNULL(A.PCPRevenueActual,0),0) AS 'PCPRevenueActual'
,	CASE WHEN ROUND(ISNULL(A.PCPRevenueBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.PCPRevenueBudget,0),0) END AS 'PCPRevenueBudget'
,	CASE WHEN ROUND(ISNULL(A.PCPRevenueBudget,0),0) = 0 THEN (ROUND(ISNULL(A.PCPRevenueActual,0),0) - 1) ELSE ROUND(ISNULL(A.PCPRevenueActual,0),0) - ROUND(ISNULL(A.PCPRevenueBudget,0),0)END AS 'PCPDiff'
,	CASE WHEN ROUND(ISNULL(A.PCPRevenueBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.PCPRevenueActual,0),0),1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.PCPRevenueActual,0),0), ROUND(ISNULL(A.PCPRevenueBudget,0),0)) 	END AS 'PCPPercent'

,	ROUND(ISNULL(A.TotalRevenueActual,0),0) AS 'TotalRevenueActual'
,	CASE WHEN ROUND(ISNULL(A.TotalRevenueBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.TotalRevenueBudget,0),0) END  AS 'TotalRevenueBudget'
,	CASE WHEN ROUND(ISNULL(A.TotalRevenueBudget,0),0) = 0 THEN (ROUND(ISNULL(A.TotalRevenueActual,0),0)- 1) ELSE (ROUND(ISNULL(A.TotalRevenueActual,0),0) ) - ROUND(ISNULL(A.TotalRevenueBudget,0),0) END AS 'TotalDiff'
,	CASE WHEN ROUND(ISNULL(A.TotalRevenueBudget,0),0) = 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(A.TotalRevenueActual,0),0) , 1) ELSE dbo.DIVIDE_DECIMAL((ROUND(ISNULL(A.TotalRevenueActual,0),0) ), ROUND(ISNULL(A.TotalRevenueBudget,0),0)) 	END AS 'TotalPercent'

,	ROUND(ISNULL(Cons.Consultations,0),0) AS 'Consultations'
,	ROUND(ISNULL(bb.BeBacks,0),0) AS 'BeBacks'
,	ROUND(ISNULL(Cons.BeBacksToExclude,0),0) AS 'BeBacksToExclude'
,	dbo.DIVIDE(ROUND(ISNULL(S.NetNB1Count,0),0) , ( ISNULL(Cons.Consultations, 0) - ISNULL(Cons.BeBacksToExclude, 0) ) ) AS 'ClosePercent'


,	ROUND(ISNULL(RetailActual,0),0) AS RetailActual
,	CASE WHEN ROUND(ISNULL(A.RetailBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.RetailBudget,0),0) END  AS 'RetailBudget'
,	CASE WHEN ROUND(ISNULL(A.RetailBudget,0),0) = 0 THEN (ROUND(ISNULL(R.RetailActual,0),0) - 1) ELSE ROUND(ISNULL(R.RetailActual,0),0) - ROUND(ISNULL(A.RetailBudget,0),0)END AS 'RetailDiff'
,	CASE WHEN ROUND(ISNULL(A.RetailBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(R.RetailActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(R.RetailActual,0),0), ROUND(ISNULL(A.RetailBudget,0),0))	END AS 'RetailPercent'

,	ROUND(ISNULL(S.PMCActual,0),0) AS PMCActual
,	CASE WHEN ROUND(ISNULL(PCP.ClosePCP,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(PCP.ClosePCP,0),0) END  AS 'ClosePCP'
,	CASE WHEN ROUND(ISNULL(PCP.ClosePCP,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(S.PMCActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(S.PMCActual,0),0), ROUND(ISNULL(PCP.ClosePCP,0),0))	END AS 'PMCPercent'

,	@StartDate AS 'StartDate'
,	@EndDate AS 'EndDate'
FROM #Accounting A
	INNER JOIN #Centers C
		ON A.CenterNumber = C.CenterNumber
	LEFT OUTER JOIN #Sales S
		ON C.CenterNumber = S.CenterNumber
	LEFT OUTER JOIN #Consultations Cons
		ON C.CenterNumber = Cons.CenterNumber
	LEFT OUTER JOIN #BeBacks bb
		ON C.CenterNumber = bb.CenterNumber
	LEFT OUTER JOIN #Retail R
		ON C.CenterNumber = R.CenterNumber
	LEFT OUTER JOIN #ClosePCP PCP
		ON C.CenterNumber = PCP.CenterNumber
GROUP BY C.MainGroupID
,	C.MainGroupDescription
,	C.CenterNumber
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	S.NetNB1Count
,	A.NetNB1CountBudget
,	S.NetNB1Amount
,	S.NB_MDPAmt
,   S.NB_MDPCnt
,   S.LaserAmt
,	A.NetNb1RevenueBudget
,	S.NetNB1Amount
,	A.ApplicationsActual
,	A.ApplicationsBudget
,	A.BIOConversionsActual
,	A.BIOConversionsBudget
,	A.EXTConversionsActual
,	A.EXTConversionsBudget
,	A.XtrandsConversionsActual
,	A.XtrandsConversionsBudget
,	A.PCPRevenueActual
,	A.PCPRevenueBudget
,	A.TotalRevenueActual
,	A.TotalRevenueBudget
,	ISNULL(S.NetNB1Count,0)
,	ROUND(ISNULL(S.NetNB1Count,0),0)
,	ISNULL(Cons.Consultations,0)
,	ISNULL(bb.BeBacks, 0)
,	ISNULL(Cons.BeBacksToExclude,0)
,	R.RetailActual
,	A.RetailBudget
,	S.PMCActual
,	PCP.ClosePCP

END
GO
