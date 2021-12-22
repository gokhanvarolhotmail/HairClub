/* CreateDate: 03/10/2014 13:59:32.393 , ModifyDate: 03/10/2014 16:58:34.580 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_GradualAnalysis
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Gradual Analysis
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		03/10/2014
------------------------------------------------------------------------
NOTES:

03/10/2014 - DL - Created procedure.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_GradualAnalysis 2, '2/1/2014', '2/28/2014'
***********************************************************************/
CREATE PROCEDURE spRpt_GradualAnalysis
(
	@CenterType INT,
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Final (
	RowID INT
,	Period INT
,	Flash VARCHAR(255)
,	value DECIMAL(20,2)
)

/********************************** Get list of centers *************************************/
IF @CenterType = 0 OR @CenterType = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


IF @CenterType = 0 OR @CenterType = 8
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


/********************************** Get sales data *************************************/
SELECT	DD.YearNumber
,		DD.MonthNumber
,		DD.YearMonthNumber
,		CASE CLT.GenderSSID WHEN 1 THEN 'Male' WHEN 2 THEN 'Female' END AS 'Gender'
,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'NetTradCount'
,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NetTradSales'
,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NetGradCount'
,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NetGradSales'
,       SUM((ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_GradCnt, 0))) AS 'NetNB1Count'
,       SUM((ISNULL(FST.NB_TradAmt, 0) + ISNULL(FST.NB_GradAmt, 0))) AS 'NetNB1Sales'
,		SUM(CASE WHEN DM.MembershipKey NOT IN ( 56, 57, 58, 98, 99, 100, 101, 108, 109 ) THEN FST.NB_AppsCnt ELSE 0 END) AS 'TradApps'
,		SUM(CASE WHEN DM.MembershipKey IN ( 56, 57, 58, 98, 99, 100, 101, 108, 109 ) THEN FST.NB_AppsCnt ELSE 0 END) AS 'GradApps'
,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Apps'
,		SUM(CASE WHEN Dept.SalesCodeDepartmentSSID IN ( 1075 ) AND PrevDM.MembershipKey NOT IN ( 59, 60, 61, 62, 66, 106, 107 ) AND PrevDM.MembershipKey NOT IN ( 56, 57, 58, 98, 99, 100, 101 ) THEN FST.NB_BIOConvCnt ELSE 0 END) AS 'TradConversions'
,		SUM(CASE WHEN Dept.SalesCodeDepartmentSSID IN ( 1075 ) AND PrevDM.MembershipKey NOT IN ( 59, 60, 61, 62, 66, 106, 107 ) AND PrevDM.MembershipKey IN ( 56, 57, 58, 98, 99, 100, 101 ) THEN FST.NB_BIOConvCnt ELSE 0 END) AS 'GradConversions'
,       SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'NB1Conversions'
INTO	#Sales
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment Dept
			ON DSC.SalesCodeDepartmentKey = Dept.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
            ON DC.CenterSSID = C.CenterSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PrevCM
			ON DSOD.PreviousClientMembershipSSID = PrevCM.ClientMembershipSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PrevDM
			ON PrevCM.MembershipSSID = PrevDM.MembershipSSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND CLT.GenderSSID <> -2
GROUP BY DD.YearNumber
,		DD.MonthNumber
,		DD.YearMonthNumber
,		CLT.GenderSSID


/********************************** Display Data *************************************/
SELECT  S.YearMonthNumber AS 'Period'
,       SUM(CASE WHEN S.Gender = 'Male' THEN S.NetTradCount ELSE 0 END) AS 'NetTradCountMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.NetTradCount ELSE 0 END) AS 'NetTradCountFemale'
,		SUM(S.NetTradCount) AS 'NetTradCount'

,       SUM(CASE WHEN S.Gender = 'Male' THEN S.NetTradSales ELSE 0 END) AS 'NetTradSalesMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.NetTradSales ELSE 0 END) AS 'NetTradSalesFemale'
,		SUM(S.NetTradSales) AS 'NetTradSales'

,       SUM(CASE WHEN S.Gender = 'Male' THEN S.NetGradCount ELSE 0 END) AS 'NetGradCountMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.NetGradCount ELSE 0 END) AS 'NetGradCountFemale'
,		SUM(S.NetGradCount) AS 'NetGradCount'

,       SUM(CASE WHEN S.Gender = 'Male' THEN S.NetGradSales ELSE 0 END) AS 'NetGradSalesMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.NetGradSales ELSE 0 END) AS 'NetGradSalesFemale'
,		SUM(S.NetGradSales) AS 'NetGradSales'

,       SUM(S.NetNB1Count) AS 'NetNB1Count'
,       SUM(CASE WHEN S.Gender = 'Male' THEN S.NetNB1Sales ELSE 0 END) AS 'NetNB1SalesMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.NetNB1Sales ELSE 0 END) AS 'NetNB1SalesFemale'
,       SUM(S.NetNB1Sales) AS 'NetNB1Sales'

,       SUM(CASE WHEN S.Gender = 'Male' THEN S.TradApps ELSE 0 END) AS 'TradAppsMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.TradApps ELSE 0 END) AS 'TradAppsFemale'
,		SUM(S.TradApps) AS 'TradApps'

,       SUM(CASE WHEN S.Gender = 'Male' THEN S.GradApps ELSE 0 END) AS 'GradAppsMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.GradApps ELSE 0 END) AS 'GradAppsFemale'
,		SUM(S.GradApps) AS 'GradApps'

,       SUM(S.NB1Apps) AS 'NB1Apps'

,       SUM(CASE WHEN S.Gender = 'Male' THEN S.TradConversions ELSE 0 END) AS 'TradConversionsMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.TradConversions ELSE 0 END) AS 'TradConversionsFemale'
,       SUM(S.TradConversions) AS 'TradConversions'

,       SUM(CASE WHEN S.Gender = 'Male' THEN S.GradConversions ELSE 0 END) AS 'GradConversionsMale'
,       SUM(CASE WHEN S.Gender = 'Female' THEN S.GradConversions ELSE 0 END) AS 'GradConversionsFemale'
,       SUM(S.GradConversions) AS 'GradConversions'

,       SUM(S.NB1Conversions) AS 'NB1Conversions'
FROM	#Sales S
GROUP BY S.YearMonthNumber
ORDER BY S.YearMonthNumber

END
GO
