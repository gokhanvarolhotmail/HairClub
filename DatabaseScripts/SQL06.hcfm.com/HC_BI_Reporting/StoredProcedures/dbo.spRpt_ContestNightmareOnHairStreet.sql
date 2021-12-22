/* CreateDate: 10/22/2018 15:39:12.583 , ModifyDate: 10/29/2018 09:31:06.960 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_ContestNightmareOnHairStreet]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Cloned spRpt_ContestNewHairResolution
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		10/22/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbo].[spRpt_ContestNightmareOnHairStreet]

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestNightmareOnHairStreet]

AS
BEGIN

DECLARE @ContestSSID INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'NightmareOnHairStreet')
--SET @StartDate = '4/03/2018'
--SET @EndDate = '4/20/2018'


SET @StartDate = '10/20/2018'
SET @EndDate = '11/20/2018'


SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create Temp Table Objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupImage VARCHAR(100)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterType VARCHAR(50)
,	TargetRevenue MONEY
,	TargetInitAppsCnt INT
,	CenterSortOrder INT
)

CREATE TABLE #Sales (
	CenterNumber INT
,	NetNB1Sales INT
,	NetNB1Count INT
,	NB_AppsCnt INT
)


/********************************** Get List of Centers *************************************/
INSERT  INTO #Centers
		SELECT  CRG.ContestReportGroupSSID
		,		CRG.GroupDescription
		,		CRG.GroupImage
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		CCT.TargetRevenue
		,		CCT.TargetInitAppsCnt   --Target of NSD's
		,		CCRG.CenterSortOrder
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN ContestCenterReportGroup CCRG
					ON DC.CenterNumber = CCRG.CenterSSID  ---Join on CenterNumber to CenterSSID
						AND CCRG.ContestSSID = @ContestSSID
				INNER JOIN ContestReportGroup CRG
					ON CCRG.ContestReportGroupSSID = CRG.ContestReportGroupSSID
						AND CRG.ContestSSID = @ContestSSID
				INNER JOIN ContestCenterTarget CCT
					ON DC.CenterNumber = CCT.CenterSSID  ---Join on CenterNumber to CenterSSID
						AND CCT.ContestSSID = @ContestSSID
		WHERE   DCT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT q.CenterNumber
		,	SUM(q.NetNB1Sales) AS 'NetNB1Sales'
		,	SUM(q.NetNB1Count) AS 'NetNB1Count'
		,	SUM(q.NB_AppsCnt) AS 'NB_AppsCnt'
		FROM (SELECT  C.CenterNumber
				,      SUM(ISNULL(FST.NB_TradAmt, 0))
								+ SUM(ISNULL(FST.NB_ExtAmt, 0))
								+ SUM(ISNULL(FST.NB_GradAmt, 0))
								+ SUM(ISNULL(FST.NB_XTRAmt, 0))
								--+ SUM(ISNULL(FST.S_SurAmt, 0))
								+ SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'NetNB1Sales'
				,		SUM(ISNULL(FST.NB_TradCnt, 0))
						+ SUM(ISNULL(FST.NB_ExtCnt, 0))
						+ SUM(ISNULL(FST.NB_XtrCnt, 0))
						+ SUM(ISNULL(FST.NB_GradCnt, 0))
						--+ SUM(ISNULL(FST.S_SurCnt, 0))
						+ SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Count'
				,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB_AppsCnt'  --New Business Applications - New Style Days
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
				GROUP BY c.CenterNumber
				,	DD.FullDate)q
			GROUP BY q.CenterNumber


/********************************** Display By Main Group/Center *************************************/

--Find the percent Revenue and percent NSD; and then the Grand Total
SELECT q.CenterType
,		q.MainGroupID
,		q.MainGroup
,		q.MainGroupImage
,		q.CenterNumber
,		q.CenterDescription
,		q.CenterDescriptionNumber

,		ActualRevCollected
,		TargetRevenue
,		PercentRevenue

,		NSD
,		NSDTarget
,		NSDTargetPercent
,		((PercentRevenue*.5)+(NSDTargetPercent*.5)) AS 'GrandTotal'
,		CenterSortOrder
,		CASE WHEN ((PercentRevenue*.5)+(NSDTargetPercent*.5)) >= 1 THEN 1 ELSE 0 END AS 'OnTarget'

FROM
	(SELECT  C.CenterType
	,		C.MainGroupID
	,		C.MainGroup
	,		C.MainGroupImage
	,		C.CenterNumber
	,		C.CenterDescription
	,		C.CenterDescriptionNumber
		--Sales Mix Qualifier

		--NB1 Revenue
	,       ISNULL(S.NetNB1Sales, 0) AS 'ActualRevCollected'
	,		C.TargetRevenue AS 'TargetRevenue'
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Sales, 0),ISNULL(C.TargetRevenue,0)) AS 'PercentRevenue'

		--NB NSD Percent
	,		ISNULL(S.NB_AppsCnt, 0) 'NSD'
	,		TargetInitAppsCnt AS 'NSDTarget'
	,		CASE WHEN ISNULL(TargetInitAppsCnt, 0)=0 THEN 0 ELSE dbo.DIVIDE(ISNULL(S.NB_AppsCnt, 0),ISNULL(TargetInitAppsCnt, 0)) END AS 'NSDTargetPercent'
	,		C.CenterSortOrder

	FROM    #Centers C
			LEFT OUTER JOIN #Sales S
				ON C.CenterNumber = S.CenterNumber

	)q


END
GO
