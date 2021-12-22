/* CreateDate: 10/02/2013 14:58:55.573 , ModifyDate: 04/05/2016 15:59:31.707 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_PresidentsClubNewBusinessFranchise
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/02/2013
------------------------------------------------------------------------
PARAMETERS:
@CenterType = 2 = Corporate, @CenterType = 8 = Franchise
------------------------------------------------------------------------
CHANGE HISTORY:
04/03/2014	RH	Removed an additional SalesCodeKey = 468 for Center Transfer
01/08/2015	RH	Added formula for ExtSalesMix to the final select (WO#110249)
12/10/2015  RH  Added Xtrands to the amounts (WO#121325)
12/16/2015	RH	(WO#121325) Changed Sales to reflect home center in order to match the Flash report
12/17/2015	RH	(WO#121325) Changed to pull Consultations/ Bebacks from vwFactActivityResults
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PresidentsClubNewBusinessFranchise 8, '3/1/2016', '4/1/2016'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubNewBusinessFranchise]
(
	@CenterType INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
)

CREATE TABLE #ConsultationsBebacks (
    CenterSSID INT
,	Consultations INT
,	BeBacks INT
)

CREATE TABLE #Sales (
    CenterSSID INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetXTRCount INT
,	NetXTRSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
,	NB1Apps INT
,	HairSalesCount INT
,	TradGradExtXtrCount INT
,	TradGradExtXtrSales MONEY
)

CREATE TABLE #Results (
    CenterSSID INT
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetXTRCount INT
,	NetXTRSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
,	NB1Apps INT
,	HairSalesCount INT
,	TradGradExtXtrCount INT
,	TradGradExtXtrSales MONEY
)


/********************************** Get list of centers *************************************/
IF @CenterType = 2
    BEGIN
        INSERT  INTO #Centers
                SELECT  DC.CenterSSID
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                            ON DC.RegionSSID = DR.RegionKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                            ON DC.CenterTypeKey = DCT.CenterTypeKey
                WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
                        AND DC.Active = 'Y'
    END
ELSE
    IF @CenterType = 8
        BEGIN
            INSERT  INTO #Centers
                    SELECT  DC.CenterSSID
                    FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                            INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                                ON DC.RegionSSID = DR.RegionKey
                            INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                                ON DC.CenterTypeKey = DCT.CenterTypeKey
                    WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
                            AND DC.Active = 'Y'
        END


/********************************** Get consultations and bebacks *************************************/
--#Consultations
    SELECT DC.CenterSSID
		,	SUM(CASE WHEN Consultation = 1 THEN 1 ELSE 0 END) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
	INTO #Consultations
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


--#BeBacks
    SELECT DC.CenterSSID
		,	SUM(CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5)THEN 1 ELSE 0 END) AS 'BeBacks'
	INTO #BeBacks
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterSSID = CTR.CenterSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (FAR.BeBack = 1)
		AND FAR.Show=1
	GROUP BY DC.CenterSSID


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  DC.ReportingCenterSSID
		,		SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Count'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0)) + SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0)) + SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetNB1Count'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0)) + SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0))  + SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NetNB1Sales'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'NetTradCount'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NetTradSales'
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NetEXTCount'
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetXTRCount'
        ,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NetXTRSales'
        ,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NetGradCount'
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NetGradSales'
        ,       SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SurgeryCount'
        ,       SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgerySales'
        ,       SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostEXTCount'
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXTSales'
        ,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Apps'
		,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'HairSalesCount'
		,		SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0)) + SUM(ISNULL(FST.NB_XTRCnt, 0)) AS 'TradGradExtXtrCount'
		,		SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) + SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'TradGradExtXtrSales'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = SC.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC   --Keep as Home Center
                    ON cm.CenterKey = DC.CenterKey
                INNER JOIN #Centers
                    ON DC.ReportingCenterSSID = #Centers.CenterSSID
        WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668, 468 )
                AND SOD.IsVoidedFlag = 0
        GROUP BY DC.ReportingCenterSSID


/********************************** Combine Completion & Sales Data *************************************/
INSERT  INTO #Results
		SELECT  CenterSSID
		,       SUM(Consultations) AS 'Consultations'
		,       SUM(NetNB1Count) AS 'NetNB1Count'
		,       SUM(NetNB1Sales) AS 'NetNB1Sales'
		,       SUM(NetTradCount) AS 'NetTradCount'
		,       SUM(NetTradSales) AS 'NetTradSales'
		,       SUM(NetEXTCount) AS 'NetEXTCount'
		,       SUM(NetEXTSales) AS 'NetEXTSales'
		,       SUM(NetXTRCount) AS 'NetXTRCount'
		,       SUM(NetXTRSales) AS 'NetXTRSales'
		,       SUM(NetGradCount) AS 'NetGradCount'
		,       SUM(NetGradSales) AS 'NetGradSales'
		,       SUM(SurgeryCount) AS 'SurgeryCount'
		,       SUM(SurgerySales) AS 'SurgerySales'
		,       SUM(PostEXTCount) AS 'PostEXTCount'
		,       SUM(PostEXTSales) AS 'PostEXTSales'
		,       SUM(NB1Apps) AS 'NB1Apps'
		,       SUM(HairSalesCount) AS 'HairSalesCount'
		,       SUM(TradGradExtXtrCount) AS 'TradGradExtXtrCount'
		,       SUM(TradGradExtXtrSales) AS 'TradGradExtXtrSales'
		FROM    ( SELECT    CenterSSID
				  ,         0 AS 'Consultations'
				  ,         ISNULL(NetNB1Count, 0) AS 'NetNB1Count'
				  ,         ISNULL(NetNB1Sales, 0) AS 'NetNB1Sales'
				  ,         ISNULL(NetTradCount, 0) AS 'NetTradCount'
				  ,         ISNULL(NetTradSales, 0) AS 'NetTradSales'
				  ,         ISNULL(NetEXTCount, 0) AS 'NetEXTCount'
				  ,         ISNULL(NetEXTSales, 0) AS 'NetEXTSales'
				  ,         ISNULL(NetXTRCount, 0) AS 'NetXTRCount'
				  ,         ISNULL(NetXTRSales, 0) AS 'NetXTRSales'
				  ,         ISNULL(NetGradCount, 0) AS 'NetGradCount'
				  ,         ISNULL(NetGradSales, 0) AS 'NetGradSales'
				  ,         ISNULL(SurgeryCount, 0) AS 'SurgeryCount'
				  ,         ISNULL(SurgerySales, 0) AS 'SurgerySales'
				  ,         ISNULL(PostEXTCount, 0) AS 'PostEXTCount'
				  ,         ISNULL(PostEXTSales, 0) AS 'PostEXTSales'
				  ,         ISNULL(NB1Apps, 0) AS 'NB1Apps'
				  ,         ISNULL(HairSalesCount, 0) AS 'HairSalesCount'
				  ,         ISNULL(TradGradExtXtrCount, 0) AS 'TradGradExtXtrCount'
				  ,         ISNULL(TradGradExtXtrSales, 0) AS 'TradGradExtXtrSales'
				  FROM      #Sales
				  UNION
				  SELECT    CenterSSID
				  ,         ISNULL(Consultations, 0) AS 'Consultations'
				  ,         0 AS 'NetNB1Count'
				  ,         0 AS 'NetNB1Sales'
				  ,         0 AS 'NetTradCount'
				  ,         0 AS 'NetTradSales'
				  ,         0 AS 'NetEXTCount'
				  ,         0 AS 'NetEXTSales'
				  ,         0 AS 'NetXTRCount'
				  ,         0 AS 'NetXTRSales'
				  ,         0 AS 'NetGradCount'
				  ,         0 AS 'NetGradSales'
				  ,         0 AS 'SurgeryCount'
				  ,         0 AS 'SurgerySales'
				  ,         0 AS 'PostEXTCount'
				  ,         0 AS 'PostEXTSales'
				  ,         0 AS 'NB1Apps'
				  ,         0 AS 'HairSalesCount'
				  ,         0 AS 'TradGradExtXtrCount'
				  ,         0 AS 'TradGradExtXtrSales'
				  FROM      #Consultations
				) Results
		GROUP BY CenterSSID


/********************************** Display By Region/Center *************************************/
SELECT  DCT.CenterTypeDescriptionShort AS 'Type'
,       DR.RegionDescription AS 'region'
,       DR.RegionSSID AS 'RegionID'
,		DC.CenterSSID AS 'CenterID'
,       DC.CenterDescriptionNumber AS 'center'
,		R.Consultations AS 'consultations'
,       R.NetNB1Count AS 'netSale'
,       dbo.DIVIDE_DECIMAL(R.NetNB1Count, R.Consultations) AS 'Close%'
,       R.HairSalesCount AS 'netHairSales'
,		R.NB1Apps AS 'NSD'
,		dbo.DIVIDE_DECIMAL(R.NB1Apps, R.HairSalesCount) AS 'NSDSales%'
,		R.TradGradExtXtrCount AS 'TradGradExtXtrCount'
,		R.TradGradExtXtrSales AS 'TradGradExtXtrSales'
,		dbo.DIVIDE_DECIMAL(R.TradGradExtXtrSales, R.TradGradExtXtrCount) AS 'TradGradEXTXtrPerSale'
,		(R.NetTradCount + R. NetGradCount) AS 'NetXtrPlusCount'
,		R.NetEXTCount
,		CASE WHEN R.TradGradExtXtrCount = 0 THEN 0 ELSE ((CAST(R.NetTradCount AS DECIMAL(18,4)) + CAST(R. NetGradCount AS DECIMAL(18,4)))/CAST(R.TradGradExtXtrCount AS DECIMAL(18,4)))
			END AS 'XtrPlusSalesMix'
,		CASE WHEN R.TradGradExtXtrCount = 0 THEN 0 ELSE (CAST(R.NetEXTCount AS DECIMAL(18,4))/CAST(R.TradGradExtXtrCount AS DECIMAL(18,4)))
			END AS 'EXTSalesMix'
FROM    #Results R
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON R.CenterSSID = DC.CenterSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
            ON DC.CenterTypeKey = DCT.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DC.RegionKey = DR.RegionKey
ORDER BY DR.RegionDescription
,       DC.CenterDescriptionNumber

END
GO
