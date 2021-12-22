/* CreateDate: 01/21/2015 11:43:45.940 , ModifyDate: 01/22/2015 09:07:06.783 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_HairyTalesContest
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HairebrationContest.rdl  --End of Summer
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		01/21/2015
------------------------------------------------------------------------
NOTES: The contest dates are
10/20/2014 - RH - Remove POST EXT Count, keep POST EXT Sales (Revenue) - this is from the Hairebration Contest
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_HairyTalesContest '1/27/2015', '3/13/2015'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_HairyTalesContest]
(
	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

DECLARE @ContestSSID INT


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'HairyTale')


SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create Temp Table Objects *************************************/
CREATE TABLE #Centers (
	ContestReportGroupSSID INT
,	GroupDescription VARCHAR(50)
,	GroupImage VARCHAR(100)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
,	TargetRevenue MONEY
,	TargetInitAppsCnt INT
,	TargetConversions INT
,	CenterSortOrder INT
)

CREATE TABLE #Sales (
	CenterSSID INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NB_AppsCnt INT
,	TotalConversions INT
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
		,		CCT.TargetInitAppsCnt
		,		CCT.TargetConversions
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
		ORDER BY CCRG.CenterSortOrder


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  c.ReportingCenterSSID AS 'CenterSSID'
        ,       SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Count'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetNB1Count'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'NetNB1Sales'
		,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB_AppsCnt'
		,       SUM(ISNULL(FST.NB_BIOConvCnt,0)) + SUM(ISNULL(FST.NB_EXTConvCnt,0)) + SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'TotalConversions'
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

--Find the percent Revenue, percent Apps and percent Conversions; and then the Grand Total
SELECT q.CenterType
,		q.ContestReportGroupSSID
,		q.GroupDescription
,		q.GroupImage
,		q.CenterSSID
,		q.CenterDescription
,		q.TargetRevenue
,		q.NetNB1Sales
,		q.percentRevenue
,		q.TargetInitAppsCnt
,		q.NB_AppsCnt
,		q.percentApps
,		q.TargetConversions
,		q.TotalConversions
,		q.percentConv
,		((q.percentRevenue*.3333)+(q.percentApps*.3333)+(q.percentConv*.3333)) AS 'GrandTotal'
,		CenterSortOrder
FROM
	(SELECT  C.CenterType
	,		C.ContestReportGroupSSID
	,		C.GroupDescription
	,		C.GroupImage
	,		C.CenterSSID
	,		C.CenterDescription
		--NB1 Revenue
	,		C.TargetRevenue AS 'TargetRevenue'
	,       ISNULL(S.NetNB1Sales, 0) AS 'NetNB1Sales' --Money
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Sales, 0),ISNULL(C.TargetRevenue,0)) AS 'percentRevenue'
		--Initial Applications
	,		C.TargetInitAppsCnt AS 'TargetInitAppsCnt'
	,       ISNULL(S.NB_AppsCnt, 0) AS 'NB_AppsCnt'  --Count
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NB_AppsCnt,0),ISNULL(C.TargetInitAppsCnt,0)) AS 'percentApps'
		--Conversions
	,		C.TargetConversions AS 'TargetConversions'  --Count
	,       ISNULL(S.TotalConversions, 0) AS 'TotalConversions'
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.TotalConversions,0),ISNULL(C.TargetConversions,0)) AS 'percentConv'
	,		C.CenterSortOrder
	FROM    #Centers C
			LEFT OUTER JOIN #Sales S
				ON C.CenterSSID = S.CenterSSID)q
ORDER BY q.CenterSortOrder

END
GO
