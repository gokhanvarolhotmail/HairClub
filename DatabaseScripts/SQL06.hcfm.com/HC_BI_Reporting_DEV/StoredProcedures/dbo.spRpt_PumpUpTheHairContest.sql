/* CreateDate: 09/17/2015 15:33:40.813 , ModifyDate: 10/01/2015 13:49:22.707 */
GO
/***********************************************************************
PROCEDURE:				spRpt_PumpUpTheHairContest
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			PumpUpTheHairContest.rdl  --September and October 2015
ORIGINAL AUTHOR:		Rachelen Hut
DATE IMPLEMENTED:		09/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PumpUpTheHairContest

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PumpUpTheHairContest]

AS
BEGIN

DECLARE @ContestSSID INT
,	@StartDate DATETIME
,	@EndDate DATETIME

SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'Pump Up The Hair')


SET @StartDate = '9/18/2015'
SET @EndDate = '10/31/2015'


SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create Temp Table Objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupImage VARCHAR(100)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
,	TargetRevenue MONEY
,	TargetSales INT
,	CenterSortOrder INT
)

CREATE TABLE #Sales (
	CenterSSID INT
,	SalesMixCount INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales MONEY
,	NetXtrCount INT
,	NetXtrSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
,	NB1Apps INT
)


/********************************** Get List of Centers *************************************/
INSERT  INTO #Centers
		SELECT  CRG.ContestReportGroupSSID
		,		CRG.GroupDescription
		,		CRG.GroupImage
		,		DC.CenterSSID
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


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  c.ReportingCenterSSID
        ,       SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                --+ SUM(ISNULL(FST.S_PostExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'SalesMixCount'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				--+ SUM(ISNULL(FST.S_SurCnt, 0))
    --            + SUM(ISNULL(FST.S_PostExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetNB1Count'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				--+ SUM(ISNULL(FST.S_SurAmt, 0))
    --            + SUM(ISNULL(FST.S_PostExtAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'NetNB1Sales'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'NetTradCount'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NetTradSales'
		,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetXtrCount'
        ,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NetXtrSales'
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NetEXTCount'
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NetEXTSales'
        ,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NetGradCount'
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NetGradSales'
        ,       SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SurgeryCount'
        ,       SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgerySales'
        ,       SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostEXTCount'
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXTSales'
        ,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Apps'
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
                    ON C.ReportingCenterSSID = #Centers.CenterSSID
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
        GROUP BY c.ReportingCenterSSID


/********************************** Display By Main Group/Center *************************************/

--Find the percent Revenue and percent Sales Volume; and then the Grand Total
SELECT q.CenterType
,		q.MainGroupID
,		q.MainGroup
,		q.MainGroupImage
,		q.CenterSSID
,		q.CenterDescription
,		q.ActualBIOXTRMix
,		q.TargetBIOXTRMix
,		ActualRevCollected
,		TargetRevenue
,		percentRevenue
,		ActualSales
,		TargetSales
,		percentSalesVolume
,		((percentRevenue*.5)+(percentSalesVolume*.5)) AS 'GrandTotal'
,		CenterSortOrder
FROM
	(SELECT  C.CenterType
	,		C.MainGroupID
	,		C.MainGroup
	,		C.MainGroupImage
	,		C.CenterSSID
	,		C.CenterDescription
	--Sales Mix BIO/XTR Qualifier
	,		dbo.DIVIDE_DECIMAL((ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0) + ISNULL(S.NetXtrCount, 0)), ISNULL(S.SalesMixCount, 0)) AS 'ActualBIOXTRMix'
	,		.57 AS 'TargetBIOXTRMix'

		--NB1 Revenue
	,       ISNULL(S.NetNB1Sales, 0) AS 'ActualRevCollected'
	,		C.TargetRevenue AS 'TargetRevenue'
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Sales, 0),ISNULL(C.TargetRevenue,0)) AS 'percentRevenue'
		--NB1 Sales Volume
	,       ISNULL(S.NetNB1Count, 0) AS 'ActualSales'  --Count
	,		C.TargetSales AS 'TargetSales'  --Count
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Count,0),ISNULL(C.TargetSales,0)) AS 'percentSalesVolume'
	,		C.CenterSortOrder
	FROM    #Centers C
			LEFT OUTER JOIN #Sales S
				ON C.CenterSSID = S.CenterSSID)q
ORDER BY q.CenterSortOrder

END
GO
