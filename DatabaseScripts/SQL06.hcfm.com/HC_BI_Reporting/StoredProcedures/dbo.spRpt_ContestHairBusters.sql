/* CreateDate: 06/02/2016 16:38:48.153 , ModifyDate: 06/16/2016 09:05:14.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ContestHairBusters
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Cloned spRpt_HairebrationContest
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/02/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_ContestHairBusters]

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestHairBusters]

AS
BEGIN

DECLARE @ContestSSID INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'HairBusters')
SET @StartDate = '6/15/2016'
SET @EndDate = '7/31/2016'

----For testing
--SET @StartDate = '5/15/2016'
--SET @EndDate = '6/30/2016'


SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create Temp Table Objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupImage VARCHAR(100)
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterType VARCHAR(50)
,	TargetRevenue MONEY
,	TargetSales INT
,	CenterSortOrder INT
)

CREATE TABLE #Sales (
	CenterSSID INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NB_TradCnt INT
,	NB_TradAmt MONEY
,	NB_XtrCnt INT
,	NB_XTRAmt MONEY
,	NB_EXTCnt INT
,	NB_EXTAmt MONEY
,	NB_GradCnt INT
,	NB_GradAmt MONEY
,	S_SurCnt INT
,	S_SurAmt MONEY
--,	S_PostEXTCnt INT
,	S_PostExtAmt MONEY
,	NB_AppsCnt INT
)

CREATE TABLE #Consultations(
	CenterSSID INT
,	Consultations INT
)


/********************************** Get List of Centers *************************************/
INSERT  INTO #Centers
		SELECT  CRG.ContestReportGroupSSID
		,		CRG.GroupDescription
		,		CRG.GroupImage
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		CCT.TargetRevenue
		,		CCT.TargetSales   --Count
		,		CCRG.CenterSortOrder
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN ContestCenterReportGroup CCRG
					ON DC.CenterSSID = CCRG.CenterSSID
						AND CCRG.ContestSSID = @ContestSSID
				INNER JOIN ContestReportGroup CRG
					ON CCRG.ContestReportGroupSSID = CRG.ContestReportGroupSSID
						AND CRG.ContestSSID = @ContestSSID
				INNER JOIN ContestCenterTarget CCT
					ON DC.CenterSSID = CCT.CenterSSID
						AND CCT.ContestSSID = @ContestSSID
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
				AND DC.Active = 'Y'

/********************************** Get consultations  *************************************/
INSERT  INTO #Consultations
        SELECT DC.CenterSSID
		,	SUM(CASE WHEN Consultation = 1 THEN 1 ELSE 0 END) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterSSID = CTR.CenterSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.BeBack <> 1
		AND FAR.Show=1
	GROUP BY DC.CenterSSID
/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  c.CenterSSID
        ,       SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Count'
        ,		SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Count'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'NetNB1Sales'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'NB_TradCnt'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NB_TradAmt'
		,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NB_XtrCnt'
        ,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NB_XtrAmt'
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NB_ExtCnt'
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NB_ExtAmt'
        ,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NB_GradCnt'
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NB_GradAmt'
        ,       SUM(ISNULL(FST.S_SurCnt, 0)) AS 'S_SurCnt'
        ,       SUM(ISNULL(FST.S_SurAmt, 0)) AS 'S_SurAmt'
        --,       SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'S_PostExtCnt'
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'S_PostExtAmt'
        ,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB_AppsCnt'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                    ON FST.ClientMembershipKey = cm.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                    ON cm.CenterKey = c.CenterKey
                INNER JOIN #Centers
                    ON C.CenterSSID = #Centers.CenterSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
                    ON C.CenterTypeKey = CT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
                    ON C.RegionKey = r.RegionKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
        WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
							/*	'Removal - New Member'
								,	'NEW MEMBER TRANSFER'
								,	'Transfer Member Out'
								,	'Update Membership'	*/
                AND SOD.IsVoidedFlag = 0
        GROUP BY c.CenterSSID


/********************************** Display By Main Group/Center *************************************/

--Find the percent Revenue and percent Sales Volume; and then the Grand Total
SELECT q.CenterType
,		q.MainGroupID
,		q.MainGroup
,		q.MainGroupImage
,		q.CenterSSID
,		q.CenterDescription
,		q.CenterDescriptionNumber
,		ActualBioMix
,		TargetBioMix
,		ActualRevCollected
,		TargetRevenue
,		PercentRevenue
--,		ActualSales
--,		TargetSales
--,		PercentSalesVolume
,		ClosePct
,		ClosePctTarget
,		ClosePctTargetPercent
,		((PercentRevenue*.5)+(ClosePctTargetPercent*.5)) AS 'GrandTotal'
,		CenterSortOrder
,		CASE WHEN (ActualBioMix >= TargetBioMix AND ActualRevCollected >= TargetRevenue AND ClosePct >= ClosePctTarget) THEN 1 ELSE 0 END AS 'OnTarget'
FROM
	(SELECT  C.CenterType
	,		C.MainGroupID
	,		C.MainGroup
	,		C.MainGroupImage
	,		C.CenterSSID
	,		C.CenterDescription
	,		C.CenterDescriptionNumber
		--Sales Mix Qualifier
	,		dbo.DIVIDE_DECIMAL((ISNULL(S.NB_TradCnt, 0) + ISNULL(S.NB_GradCnt, 0) + ISNULL(S.NB_XtrCnt,0)), ISNULL(S.NetNB1Count, 0)) AS 'ActualBioMix'
	,		.55 AS 'TargetBioMix'
		--NB1 Revenue
	,       ISNULL(S.NetNB1Sales, 0) AS 'ActualRevCollected'
	,		C.TargetRevenue AS 'TargetRevenue'
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Sales, 0),ISNULL(C.TargetRevenue,0)) AS 'PercentRevenue'
		--NB1 Sales Volume
	,       ISNULL(S.NetNB1Count, 0) AS 'ActualSales'  --Count
	,		C.TargetSales AS 'TargetSales'  --Count
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Count,0),ISNULL(C.TargetSales,0)) AS 'PercentSalesVolume'
		--NB Closing Percent
	,		dbo.DIVIDE(ISNULL(S.NetNB1Count, 0), ISNULL(CONS.Consultations, 0)) AS 'ClosePct'
	,		.45 AS 'ClosePctTarget'
	,		CASE WHEN ISNULL(CONS.Consultations, 0)=0 THEN 0 ELSE (dbo.DIVIDE(ISNULL(S.NetNB1Count, 0),ISNULL(CONS.Consultations, 0)))/.45 END AS 'ClosePctTargetPercent'
	,		C.CenterSortOrder
	FROM    #Centers C
			LEFT OUTER JOIN #Sales S
				ON C.CenterSSID = S.CenterSSID
			LEFT OUTER JOIN #Consultations CONS
				ON C.CenterSSID = CONS.CenterSSID
	)q
ORDER BY q.CenterSortOrder

END
GO
