/* CreateDate: 05/09/2018 15:29:50.797 , ModifyDate: 04/02/2020 16:20:01.633 */
GO
/******************************************************************************************************************************
PROCEDURE:				[spRpt_KPIReportForMonthlyReviews_NB_YTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Sales KPI Review Year to Date
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/04/2018
--------------------------------------------------------------------------------------------------------------------------------
NOTES: This is used in the report Sales KPI Review.  The IC version is for New Business.
--------------------------------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
11/01/2018 - RH - Changed CenterSSID to CenterNumber for JOIN since CenterID for Colorado Springs is 238 in FactAccounting
01/10/2019 - RH - Changed Bud_NBCount and NB Count to use AccountID = 10231
01/25/2019 - RH - Removed Surgery from NB Revenue (Case #7101)
01/25/2019 - RH - Added NB_MDP revenue to NB revenue (Case #7507)
06/24/2019 - JL - (TFS 12573) Laser Report adjustment
12/30/2019 - RH - (TFS 13648) Added AccountID 10231 back into the WHERE clause - NB Counts were missing
01/02/2020 - RH - (TrackIT 5077 TFS 13648) Combined queries pulling from FactSalesTransaction; pull budgets only from FactAccounting; match the NB Flash
03/13/2020 - RH - TrackIT 7697 Added S_PRPCnt to NetNBCount, SurgeryCount and NetNB1Count
04/01/2020 - RH - (TrackIT 7257) Added Budget for [10320 - NB - Surgery Sales $] AND [10891 - NB - RestorInk $]

--------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_KPIReportForMonthlyReviews_NB_YTD] 201,12,2019

********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_KPIReportForMonthlyReviews_NB_YTD]
(
	@CenterNumber INT
,	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;
/************************************************************************************/


--Find dates
DECLARE
	@StartDate DATETIME
,	@FirstDateOfMonth DATETIME
,	@EndDate DATETIME
,	@DecPreviousPCP DATETIME


SET @StartDate = CAST('1/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)										--Beginning of the year
SET @FirstDateOfMonth = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)	--Beginning of the selected month
SET @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@FirstDateOfMonth)) + '23:59:000'								--End of the selected month
SET @DecPreviousPCP = DATEADD(Month,-1,@StartDate)															--Dec 2017


--PRINT '@StartDate = ' +	CAST(@StartDate AS NVARCHAR(12))
--PRINT '@FirstDateOfMonth = ' +	CAST( @FirstDateOfMonth AS NVARCHAR(12))
--PRINT '@EndDate  = ' +	CAST(@EndDate AS NVARCHAR(12))
--PRINT '@DecPreviousPCP = ' +	CAST( @DecPreviousPCP AS NVARCHAR(12))


IF @CenterNumber = 1002											--This value is being passed from the aspx page and is 1002 for Colorado Springs
BEGIN
SET @CenterNumber = 238
END


/*********************** Find Standard for XTR+ PCP Growth which is 1 per month ********/

DECLARE @PCPGrowth INT
SET @PCPGrowth = (SELECT MONTH(@FirstDateOfMonth))



/*************************** Create temp tables ****************************************/

CREATE TABLE #Sales(
	CenterNumber INT
,	CenterKey INT
,	NBCount INT
,	NBRevenue DECIMAL(18,4)
,	NetNB1Count INT
,	XtrPlusNBCount INT
,	PostEXTCount INT
,	SurgeryCount INT
)



CREATE TABLE #NB (
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(100)
,	CenterTypeDescription NVARCHAR(25)
,	Bud_NBCount INT
,	Bud_NBRevenue DECIMAL(18,4)
,	Bud_NBApps INT
,	NBApps INT
)


/******************** Find Consultations to match the NB Flash *****************************************/
/********************************** Get consultations and bebacks *************************************/


--INSERT  INTO #Consultations
SELECT DC.CenterNumber
,	SUM(CASE WHEN Consultation = 1 THEN 1 ELSE 0 END) AS 'Consultations'
INTO #Consultations
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON FAR.CenterKey = DC.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FAR.ActivityDueDateKey = DD.DateKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DC.CenterNumber = @CenterNumber
		AND FAR.BeBack <> 1
		AND FAR.Show=1
GROUP BY DC.CenterNumber

/******************* Find Sales from FactSalesTransaction to match the NB Flash *************************/
INSERT INTO #Sales
SELECT C.CenterNumber
		,	C.CenterKey
		,		(	SUM(ISNULL(FST.NB_TradCnt, 0))
					+ SUM(ISNULL(FST.NB_GradCnt, 0))
					+ SUM(ISNULL(FST.NB_ExtCnt, 0))
					+ SUM(ISNULL(FST.S_PostExtCnt, 0))
					+ SUM(ISNULL(FST.NB_XTRCnt, 0))
					+ SUM(ISNULL(FST.S_SurCnt, 0))
					+ SUM(ISNULL(FST.NB_MDPCnt, 0))
					+ SUM(ISNULL(FST.S_PRPCnt, 0))
					) AS 'NBCount'
        ,       (SUM(ISNULL(FST.NB_TradAmt, 0))
					+ SUM(ISNULL(FST.NB_GradAmt, 0))
					+ SUM(ISNULL(FST.NB_ExtAmt, 0))
					+ SUM(ISNULL(FST.S_PostExtAmt, 0))
					+ SUM(ISNULL(FST.NB_XTRAmt, 0))
					+ SUM(ISNULL(FST.NB_MDPAmt, 0))
					+ SUM(ISNULL(FST.NB_LaserAmt, 0))
					+ SUM(ISNULL(FST.S_SurAmt, 0))
					+ SUM(ISNULL(FST.S_PRPAmt, 0))
					)  AS 'NBRevenue'
		,		SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
				+ SUM(ISNULL(FST.S_PRPCnt, 0))
               AS 'NetNB1Count'																--Remove PostEXT for the Hair Sales Mix % to match the NB Flash
	,	SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XtrPlusNBCount'
	,	SUM(ISNULL(FST.S_PostExtCnt,0)) AS 'PostEXTCount'
	,      SUM(ISNULL( FST.S_SurCnt,0)) + SUM(ISNULL(FST.S_PRPCnt, 0)) AS 'SurgeryCount'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
            ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON cm.MembershipKey = m.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C  --Keep HomeCenter-based
            ON cm.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND C.CenterNumber = @CenterNumber
        AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
GROUP BY C.CenterNumber
,	C.CenterKey


/************************ Find Budget values from Fact Accounting ******************************/

INSERT INTO #NB
SELECT CenterNumber
,	CenterDescriptionNumber
,	CenterTypeDescription
,	SUM(q.Bud_NBCount) AS Bud_NBCount
,	SUM(q.Bud_NBRevenue) AS Bud_NBRevenue
,	SUM(q.Bud_NBApps) AS Bud_NBApps
,	SUM(q.NBApps) AS NBApps
FROM
(
	SELECT
		FA.CenterID AS CenterNumber
		,	C.CenterDescriptionNumber
		,	CT.CenterTypeDescription
		,	FA.PartitionDate
		,	SUM(CASE WHEN ACC.AccountID = 10231 THEN ISNULL(FA.Budget,0) END) AS 'Bud_NBCount'
		,	SUM(CASE WHEN ACC.AccountID IN(10305,10306,10310,10315,10320,10325,10552,10891) THEN ISNULL(FA.Budget,0) END) AS 'Bud_NBRevenue'
		,	SUM(CASE WHEN ACC.AccountID IN (10240) THEN ISNULL(FA.Budget,0) END) AS 'Bud_NBApps'
		,	SUM(CASE WHEN ACC.AccountID IN (10240) THEN ISNULL(FA.Flash,0) END) AS 'NBApps'
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FA.CenterID = C.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
			ON FA.AccountID = ACC.AccountID
	WHERE FA.AccountID IN(10190,10231,10240,10305,10306,10310,10315,10320,10325,10552,10891)
		AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
		AND FA.CenterID = @CenterNumber
	GROUP BY FA.CenterID
		,   C.CenterDescriptionNumber
		,   CT.CenterTypeDescription
		,   FA.PartitionDate

		 )q
GROUP BY q.CenterNumber
,	q.CenterDescriptionNumber
,	q.CenterTypeDescription




--Find Sales Mix %

SELECT MIX.CenterNumber
, dbo.DIVIDE_NOROUND(SUM(MIX.XtrPlusNBCount),SUM(MIX.NetNB1Count)) AS 'XTRPlusHairSalesMix'
INTO #HairSalesMix
FROM #Sales MIX
GROUP BY MIX.CenterNumber



/************************ Final Select ********************************************************************/
SELECT #NB.CenterNumber
,	#NB.CenterDescriptionNumber
,	#NB.CenterTypeDescription
,	.45 AS 'Bud_ClosingRate_inclPEXT'
,	#NB.Bud_NBCount
,	s.NBCount
,	CON.Consultations
,	CASE WHEN CON.Consultations = 0 THEN 0 ELSE dbo.DIVIDE_NOROUND(s.NBCount,CON.Consultations) END AS ClosingRate_inclPEXT
,	#NB.Bud_NBRevenue
,	s.NBRevenue
,	s.PostEXTCount
,	s.SurgeryCount
,	.5 AS 'Bud_XTRPlusHairSalesMix'
,	hsm.XTRPlusHairSalesMix
,	#NB.Bud_NBApps
,	#NB.NBApps
,	@PCPGrowth AS 'PCPGrowthStandard'
,	@StartDate AS StartDate
,	@EndDate AS EndDate
FROM #NB
LEFT JOIN #Consultations CON
	ON CON.CenterNumber = #NB.CenterNumber
LEFT JOIN #Sales s
	ON s.CenterNumber = #NB.CenterNumber
LEFT JOIN #HairSalesMix hsm
	ON hsm.CenterNumber = #NB.CenterNumber




END
GO
