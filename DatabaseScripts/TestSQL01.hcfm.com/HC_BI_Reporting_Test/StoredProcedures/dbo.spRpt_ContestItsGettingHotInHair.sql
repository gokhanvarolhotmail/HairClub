/* CreateDate: 06/16/2017 11:22:34.753 , ModifyDate: 07/13/2017 16:53:52.417 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_ContestItsGettingHotInHair]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Cloned spRpt_ContestNewHairResolution
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/22/2017
------------------------------------------------------------------------
NOTES:
07/13/2017 - RH - Added Surgery and PostEXT to NB Sales for the dates 7/13/2017 and forward.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbo].[spRpt_ContestItsGettingHotInHair]

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestItsGettingHotInHair]

AS
BEGIN

DECLARE @ContestSSID INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'It''s Getting Hot In Hair')
SET @StartDate = '7/5/2017'
SET @EndDate = '8/9/2017'

----For testing
--SET @StartDate = '4/01/2017'
--SET @EndDate = '4/30/2017'


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
,	NetNB1Sales INT
,	NetNB1Count INT
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
		,		CCT.TargetSales   --Target of NSD's
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

/********************************** Get consultations ************************************/
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
        SELECT CenterSSID
		,	SUM(q.NetNB1Sales) AS 'NetNB1Sales'
		,	SUM(q.NetNB1Count) AS 'NetNB1Count'
		,	SUM(q.NB_AppsCnt) AS 'NB_AppsCnt'
		FROM (SELECT  c.CenterSSID
				,      CASE WHEN DD.FullDate >= '7/13/2017' THEN  (SUM(ISNULL(FST.NB_TradAmt, 0))
								+ SUM(ISNULL(FST.NB_ExtAmt, 0))
								+ SUM(ISNULL(FST.NB_GradAmt, 0))
								+ SUM(ISNULL(FST.S_SurAmt, 0))
								+ SUM(ISNULL(FST.S_PostExtAmt, 0))
								+ SUM(ISNULL(FST.NB_XTRAmt, 0)))
						ELSE  (SUM(ISNULL(FST.NB_TradAmt, 0))
								+ SUM(ISNULL(FST.NB_ExtAmt, 0))
								+ SUM(ISNULL(FST.NB_GradAmt, 0))
								+ SUM(ISNULL(FST.NB_XTRAmt, 0)))
								--+ SUM(ISNULL(FST.S_SurAmt, 0)) --remove Surgery and PostEXT
								--+ SUM(ISNULL(FST.S_PostExtAmt, 0))
						END AS 'NetNB1Sales'--Remind Rev that without Surgery and Post EXT it will not match the Flash

				,		SUM(ISNULL(FST.NB_TradCnt, 0))
						+ SUM(ISNULL(FST.NB_ExtCnt, 0))
						+ SUM(ISNULL(FST.NB_XtrCnt, 0))
						+ SUM(ISNULL(FST.NB_GradCnt, 0))
						+ SUM(ISNULL(FST.S_SurCnt, 0))
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
				GROUP BY c.CenterSSID
				,	DD.FullDate)q
			GROUP BY q.CenterSSID


/********************************** Display By Main Group/Center *************************************/

--Find the percent Revenue and percent NSD; and then the Grand Total
SELECT q.CenterType
,		q.MainGroupID
,		q.MainGroup
,		q.MainGroupImage
,		q.CenterSSID
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
,		CASE WHEN (ActualRevCollected >= TargetRevenue AND NSD >= NSDTarget) THEN 1 ELSE 0 END AS 'OnTarget'
,		q.Close_Pct
FROM
	(SELECT  C.CenterType
	,		C.MainGroupID
	,		C.MainGroup
	,		C.MainGroupImage
	,		C.CenterSSID
	,		C.CenterDescription
	,		C.CenterDescriptionNumber
		--Sales Mix Qualifier

		--NB1 Revenue
	,       ISNULL(S.NetNB1Sales, 0) AS 'ActualRevCollected'
	,		C.TargetRevenue AS 'TargetRevenue'
	,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Sales, 0),ISNULL(C.TargetRevenue,0)) AS 'PercentRevenue'

		--NB NSD Percent
	,		ISNULL(S.NB_AppsCnt, 0) 'NSD'
	,		TargetSales AS 'NSDTarget'
	,		CASE WHEN ISNULL(TargetSales, 0)=0 THEN 0 ELSE dbo.DIVIDE(ISNULL(S.NB_AppsCnt, 0),ISNULL(TargetSales, 0)) END AS 'NSDTargetPercent'
	,		C.CenterSortOrder

		--Closing Percent
	,		dbo.DIVIDE(ISNULL(S.NetNB1Count, 0), ISNULL(Cons.Consultations, 0)) AS 'Close_Pct'
	FROM    #Centers C
			LEFT OUTER JOIN #Sales S
				ON C.CenterSSID = S.CenterSSID
			LEFT OUTER JOIN #Consultations Cons
				ON C.CenterSSID = Cons.CenterSSID
	)q
ORDER BY q.CenterSortOrder

END
GO
