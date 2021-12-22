/* CreateDate: 12/16/2016 11:51:36.493 , ModifyDate: 01/23/2017 16:41:54.037 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ContestNewHairResolution
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Cloned spRpt_HairebrationContest
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		12/16/2016
------------------------------------------------------------------------
NOTES:
01/18/2017 - RH - Removed PostEXT and Surgery from NetNB1Sales
01/23/2017 - RH - Extended the @EndDate to 2/18/2017
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_ContestNewHairResolution]

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestNewHairResolution]

AS
BEGIN

DECLARE @ContestSSID INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'NewHairResolution')
SET @StartDate = '1/3/2017'
SET @EndDate = '2/18/2017'

----For testing
--SET @StartDate = '12/01/2016'
--SET @EndDate = '12/15/2016'


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


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  c.CenterSSID
        ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				--+ SUM(ISNULL(FST.S_SurAmt, 0))
    --            + SUM(ISNULL(FST.S_PostExtAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'NetNB1Sales'

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
	FROM    #Centers C
			LEFT OUTER JOIN #Sales S
				ON C.CenterSSID = S.CenterSSID
	)q
ORDER BY q.CenterSortOrder

END
GO
