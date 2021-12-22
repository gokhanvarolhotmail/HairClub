/***********************************************************************
PROCEDURE:				[spRpt_ContestBebackAttackStyleAndGo]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Cloned spRpt_ContestNewHairResolution
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		10/05/2017
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbo].[spRpt_ContestBebackAttackStyleAndGo]

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestBebackAttackStyleAndGo]

AS
BEGIN


DECLARE @ContestSSID INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'BeBackAttackStyleAndGo')
SET @StartDate = '10/03/2017'
SET @EndDate = '10/31/2017'

----For testing
--SET @StartDate = '7/5/2017'
--SET @EndDate = '8/9/2017'



/********************************** Create Temp Table Objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupImage VARCHAR(100)
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	[3MoAvg] INT
,	BeBackRefTarget INT
,	NSDTarget INT
,	TargetConversions INT
,	CenterSortOrder INT
)


CREATE TABLE #BeBacks(
	CenterSSID INT
,	BeBacks INT
)

CREATE TABLE #Referrals(
	CenterSSID INT
,	Referrals INT
)


CREATE TABLE #Apps (
	CenterSSID INT
,	NB_AppsCnt INT
,	Conversions INT
)

/****************** Get List of Centers with their Targets*************************************/
/*
TargetRevenue AS '3MoAvg'
, TargetSales AS 'Contest Target'
,	TargetInitAppsCnt as 'NSDTarget'
,	TargetConversions as 'TargetConversions'
*/
INSERT  INTO #Centers
		SELECT  CRG.ContestReportGroupSSID AS 'MainGroupID'
		,		CRG.GroupDescription AS 'MainGroup'
		,		CRG.GroupImage AS 'MainGroupImage'
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		CAST(CCT.TargetRevenue AS INT) AS '3MoAvg'
		,		CAST(CCT.TargetSales AS INT)  AS 'BeBackRefTarget'
		,		CCT.TargetInitAppsCnt AS'NSDTarget'
		,		CCT.TargetConversions AS 'TargetConversions'
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

/********************************** Find BeBacks ************************************/
INSERT  INTO #BeBacks
        SELECT DC.CenterSSID
		,	SUM(CASE WHEN Beback = 1 THEN 1 ELSE 0 END) AS 'Bebacks'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterSSID = CTR.CenterSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.BeBack = 1
		AND FAR.Show = 1
		--AND FAR.Sale = 1
	GROUP BY DC.CenterSSID

/********************************** Get referrals ****************************************************/
INSERT  INTO #Referrals
SELECT CenterSSID
, SUM(r.Referral) AS Referrals
FROM
	(
	SELECT CTR.ReportingCenterSSID AS 'CenterSSID'
	,	CASE
			WHEN FAR.BOSRef = 1 THEN 1
			WHEN FAR.BOSOthRef = 1 THEN 1
			WHEN FAR.HCRef = 1 THEN 1
		END AS 'Referral'
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
			ON FAR.ActivityKey = A.ActivityKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON A.CenterSSID = CTR.CenterSSID
		INNER JOIN #Centers
			ON CTR.ReportingCenterSSID = #Centers.CenterSSID
		 INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
			ON A.SourceSSID = DS.SourceSSID
	WHERE A.ActivityDueDate BETWEEN @StartDate AND @EndDate
		AND DS.Media = 'Referrals'
		AND FAR.Show = 1
		--AND FAR.Sale = 1
		AND FAR.BOSAppt <> 1

	)r
GROUP BY CenterSSID


/********************************** Get All Applications *************************************/
INSERT  INTO #Apps
SELECT  c.CenterSSID
,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB_AppsCnt'  --New Business Applications - New Style Days
,		SUM(ISNULL(FST.NB_BIOConvCnt,0)) + SUM(ISNULL(FST.NB_EXTConvCnt,0)) + SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'Conversions'

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

--Find the percent Revenue and percent NSD; and then the Grand Total
SELECT  C.CenterTypeDescriptionShort
,		C.MainGroupID
,		C.MainGroup
,		C.MainGroupImage
,		C.CenterSSID
,		C.CenterDescriptionNumber
,		C.CenterSortOrder

	--Beback and Referrals
,       SUM(ISNULL(BB.BeBacks, 0)) + SUM(ISNULL(REF.Referrals,0)) AS 'BeBackRef'
,		SUM(ISNULL(C.BeBackRefTarget,0)) AS 'BeBackRefTarget'
,		dbo.DIVIDE(SUM(ISNULL(BB.BeBacks, 0)) + SUM(ISNULL(REF.Referrals,0)),SUM(ISNULL(C.BeBackRefTarget,0))) AS 'PercentRevenue'

	--NSD Percent
,		SUM(ISNULL(APPS.NB_AppsCnt, 0)) AS 'NSD'
,		SUM(ISNULL(C.NSDTarget,0)) AS 'NSDTarget'
,		dbo.DIVIDE(SUM(ISNULL(APPS.NB_AppsCnt, 0)) ,SUM(ISNULL(C.NSDTarget,0)) ) AS 'NSDTargetPercent'

	--Consultations
,		SUM(ISNULL(APPS.Conversions,0)) AS 'Conversions'
,		SUM(ISNULL(C.TargetConversions,0)) AS 'TargetConversions'
,		dbo.DIVIDE(SUM(ISNULL(APPS.Conversions,0)), SUM(ISNULL(C.TargetConversions,0))) AS 'ConversionPct'

,		CASE WHEN ((SUM(ISNULL(BB.BeBacks, 0)) + SUM(ISNULL(REF.Referrals,0)))  >= SUM(ISNULL(C.BeBackRefTarget,0))
			AND SUM(ISNULL(APPS.NB_AppsCnt, 0)) >= SUM(ISNULL(C.NSDTarget,0))
			AND  SUM(ISNULL(APPS.Conversions,0)) >= SUM(ISNULL(C.TargetConversions,0)) )
			THEN 1 ELSE 0 END AS 'OnTarget'
FROM    #Centers C
		LEFT OUTER JOIN #BeBacks BB
			ON C.CenterSSID = BB.CenterSSID
		LEFT OUTER JOIN #Referrals REF
			ON C.CenterSSID = REF.CenterSSID
		LEFT OUTER JOIN #Apps APPS
			ON C.CenterSSID = APPS.CenterSSID
GROUP BY C.CenterTypeDescriptionShort
,		C.MainGroupID
,		C.MainGroup
,		C.MainGroupImage
,		C.CenterSSID
,		C.CenterDescriptionNumber
,		C.CenterSortOrder
ORDER BY C.CenterSortOrder



END
