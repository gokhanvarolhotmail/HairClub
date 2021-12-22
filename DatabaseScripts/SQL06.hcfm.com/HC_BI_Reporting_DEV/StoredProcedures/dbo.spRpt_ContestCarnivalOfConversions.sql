/* CreateDate: 04/26/2018 12:17:40.737 , ModifyDate: 04/26/2018 12:17:40.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_ContestCarnivalOfConversions]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Cloned spRpt_ContestNewHairResolution
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		04/26/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbo].[spRpt_ContestCarnivalOfConversions]

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestCarnivalOfConversions]

AS
BEGIN

DECLARE @ContestSSID INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'CarnivalOfConversions')
--SET @StartDate = '5/01/2018'
--SET @EndDate = '6/30/2018'

----For testing
SET @StartDate = '3/01/2018'
SET @EndDate = '3/30/2018'


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
,	TargetConversions INT
)

CREATE TABLE #Conv(
	CenterNumber INT
,	ActualConversions INT
)



/********************************** Get List of Centers and their TargetConversions *************************************/
INSERT  INTO #Centers
		SELECT  CRG.ContestReportGroupSSID
		,		CRG.GroupDescription
		,		CRG.GroupImage
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		CCT.TargetConversions
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



/********************************** Get All Conversions *************************************/
INSERT  INTO #Conv
SELECT  C.CenterNumber
,		SUM(ISNULL(FST.NB_BIOConvCnt,0)) + SUM(ISNULL(FST.NB_EXTConvCnt,0)) + SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'ActualConversions'

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
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
					/*	'Removal - New Member'
						,	'NEW MEMBER TRANSFER'
						,	'Transfer Member Out'
						,	'Update Membership'	*/
		AND SOD.IsVoidedFlag = 0
GROUP BY C.CenterNumber

/********************************** Display By Main Group/Center *************************************/

SELECT  C.CenterType
,		C.MainGroupID
,		C.MainGroup
,		C.MainGroupImage
,		C.CenterNumber
,		C.CenterDescription
,		C.CenterDescriptionNumber
,		C.TargetConversions
,		#Conv.ActualConversions
FROM    #Centers C
		LEFT OUTER JOIN #Conv
			ON #Conv.CenterNumber = C.CenterNumber




END
GO
