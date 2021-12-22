/* CreateDate: 10/02/2013 14:50:46.860 , ModifyDate: 04/04/2017 09:47:40.457 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_PresidentsClubNewBusinessCorporate]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/02/2013
------------------------------------------------------------------------
CHANGE HISTORY:

01/27/2014 - DL - Removed EXT % column and replaced it with Hair % (#96819)
04/03/2014 - RH - Removed an additional SalesCodeKey = 468 for Center Transfer
11/21/2014 - RH - Added NB_XtrCnt and NB_XtrAmt for Xtrands to the fields and to the Net Sales counts.
11/24/2014 - RH - Removed Xtrands to be added Jan 2015.  Removed PostEXT from the formulas for Sales Mix.
					Added NetNB1Count_PostEXT for the Consultations ratio - it should include PostEXT per MO.
12/03/2014 - RH - (#109323) Added NetNB1Sales_PostEXT; Added Xtrands per Rev
01/28/2015 - RH - (#111093) Added Xtrands back in for 2015 for NetNB1Count and NetNB1Sales
12/16/2015 - RH - (#121325) Changed Sales to reflect home center in order to match the Flash report
12/29/2015 - RH - (#121868) BOSAppt was changed to a Consultation per MO
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_PresidentsClubNewBusinessCorporate] 2, '12/1/2015', '12/31/2015'

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_PresidentsClubNewBusinessCorporate]
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

CREATE TABLE #Consultations (
    CenterSSID INT
,	Performer NVARCHAR(255)
,	Consultations INT
)

CREATE TABLE #Sales (
    CenterSSID INT
,	Performer NVARCHAR(255)
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Count_PostEXT INT
,	NetNB1Sales INT
,	NetNB1Sales_PostEXT INT
,	NetTradCount INT
,	NetTradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	NetXTRCount INT
,	NetXTRSales MONEY
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
,	NB1Apps INT
,	HairSalesCount INT
,	TradGradExtCount INT
,	TradGradExtSales MONEY
)

CREATE TABLE #Results (
    CenterSSID INT
,	Performer NVARCHAR(255)
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Count_PostEXT INT
,	NetNB1Sales INT
,	NetNB1Sales_PostEXT INT
,	NetTradCount INT
,	NetTradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	NetXTRCount INT
,	NetXTRSales MONEY
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
,	NB1Apps INT
,	HairSalesCount INT
,	TradGradExtCount INT
,	TradGradExtSales MONEY
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
               WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
    END
ELSE
    IF @CenterType = 8  --Franchise has its own version of this report/ stored procedure
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



 /********************************** Get consultations  *************************************/
 --From Flash NB
INSERT  INTO #Consultations
        SELECT DC.CenterSSID
		,	ISNULL(DAD.Performer, 'Unknown, Unknown') AS 'Performer'
		,	SUM(CASE WHEN Consultation = 1 THEN 1 ELSE 0 END) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.

	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimActivity DA
				ON FAR.ActivityKey = DA.ActivityKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterSSID = CTR.CenterSSID
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
					ON DA.ActivitySSID = DAD.ActivitySSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.BeBack <> 1
		AND FAR.Show=1
	GROUP BY DC.CenterSSID
		,	ISNULL(DAD.Performer, 'Unknown, Unknown')


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  DC.ReportingCenterSSID
		,		EM.EmployeeFullName AS 'Performer'
		,		SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Count'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.NB_XTRCnt, 0))  --Removed RH 11/21/2014  --Put back for 2015 RH 01/28/2015
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                --+ SUM(ISNULL(FST.S_PostExtCnt, 0)) --Removed RH 11/24/2014
					AS 'NetNB1Count'  --This value is used in HairSalesMix %
		,       SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.NB_XTRCnt, 0))  --Added RH 12/03/2014
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0))
					AS 'NetNB1Count_PostEXT' --Added this for Close % - It should include PostEXT per MO and Xtrands per Rev
        ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0))   --Removed RH 11/21/2014  --Put back for 2015 RH 01/28/2015
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                --+ SUM(ISNULL(FST.S_PostExtAmt, 0)) --Removed RH 11/24/2014
					AS 'NetNB1Sales'
		  ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0))  --Added RH 12/03/2014
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0)) --Added RH 12/03/2014
					AS 'NetNB1Sales_PostEXT'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'NetTradCount'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NetTradSales'
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NetEXTCount'
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NetEXTSales'
        ,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NetGradCount'
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NetGradSales'
		,		SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetXTRCount'  --Added RH 12/03/2014
		,		SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NetXTRSales'
        ,       SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SurgeryCount'
        ,       SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgerySales'
        ,       SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostEXTCount'
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXTSales'
        ,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Apps'
		,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'HairSalesCount'
		,		SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'TradGradExtCount'
		,		SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) + SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'TradGradExtSales'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = SC.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EM
					ON FST.Employee1Key = EM.EmployeeKey
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
		,		EM.EmployeeFullName


/********************************** Combine Completion & Sales Data *************************************/
INSERT  INTO #Results
		SELECT  CenterSSID
		,       Performer
		,       SUM(Consultations) AS 'Consultations'
		,       SUM(NetNB1Count) AS 'NetNB1Count'
		,		SUM(NetNB1Count_PostEXT) AS 'NetNB1Count_PostEXT'
		,       SUM(NetNB1Sales) AS 'NetNB1Sales'
		,		SUM(NetNB1Sales_PostEXT) AS 'NetNB1Sales_PostEXT'
		,       SUM(NetTradCount) AS 'NetTradCount'
		,       SUM(NetTradSales) AS 'NetTradSales'
		,       SUM(NetEXTCount) AS 'NetEXTCount'
		,       SUM(NetEXTSales) AS 'NetEXTSales'
		,       SUM(NetGradCount) AS 'NetGradCount'
		,       SUM(NetGradSales) AS 'NetGradSales'
		,       SUM(NetXTRCount) AS 'NetXTRCount'  --Added RH 12/03/2014
		,       SUM(NetXTRSales) AS 'NetXTRSales'
		,       SUM(SurgeryCount) AS 'SurgeryCount'
		,       SUM(SurgerySales) AS 'SurgerySales'
		,       SUM(PostEXTCount) AS 'PostEXTCount'
		,       SUM(PostEXTSales) AS 'PostEXTSales'
		,       SUM(NB1Apps) AS 'NB1Apps'
		,       SUM(HairSalesCount) AS 'HairSalesCount'
		,       SUM(TradGradExtCount) AS 'TradGradExtCount'
		,       SUM(TradGradExtSales) AS 'TradGradExtSales'
		FROM    ( SELECT    CenterSSID
				  ,         ISNULL(Performer, 'Unknown, Unknown') AS 'Performer'
				  ,         0 AS 'Consultations'
				  ,         ISNULL(NetNB1Count, 0) AS 'NetNB1Count'
				  ,			ISNULL(NetNB1Count_PostEXT, 0) AS 'NetNB1Count_PostEXT'
				  ,         ISNULL(NetNB1Sales, 0) AS 'NetNB1Sales'
				  ,         ISNULL(NetNB1Sales_PostEXT, 0) AS 'NetNB1Sales_PostEXT'
				  ,         ISNULL(NetTradCount, 0) AS 'NetTradCount'
				  ,         ISNULL(NetTradSales, 0) AS 'NetTradSales'
				  ,         ISNULL(NetEXTCount, 0) AS 'NetEXTCount'
				  ,         ISNULL(NetEXTSales, 0) AS 'NetEXTSales'
				  ,         ISNULL(NetGradCount, 0) AS 'NetGradCount'
				  ,         ISNULL(NetGradSales, 0) AS 'NetGradSales'
				  ,         ISNULL(NetXTRCount, 0) AS 'NetXTRCount'  --Added RH 12/03/2014
				  ,         ISNULL(NetXTRSales, 0) AS 'NetXTRSales'
				  ,         ISNULL(SurgeryCount, 0) AS 'SurgeryCount'
				  ,         ISNULL(SurgerySales, 0) AS 'SurgerySales'
				  ,         ISNULL(PostEXTCount, 0) AS 'PostEXTCount'
				  ,         ISNULL(PostEXTSales, 0) AS 'PostEXTSales'
				  ,         ISNULL(NB1Apps, 0) AS 'NB1Apps'
				  ,         ISNULL(HairSalesCount, 0) AS 'HairSalesCount'
				  ,         ISNULL(TradGradExtCount, 0) AS 'TradGradExtCount'
				  ,         ISNULL(TradGradExtSales, 0) AS 'TradGradExtSales'
				  FROM      #Sales
				  UNION
				  SELECT    CenterSSID
				  ,         ISNULL(Performer, 'Unknown, Unknown') AS 'Performer'
				  ,         ISNULL(Consultations, 0) AS 'Consultations'
				  ,         0 AS 'NetNB1Count'
				  ,         0 AS 'NetNB1Count_PostEXT'
				  ,         0 AS 'NetNB1Sales'
				  ,			0 AS 'NetNB1Sales_PostEXT'
				  ,         0 AS 'NetTradCount'
				  ,         0 AS 'NetTradSales'
				  ,         0 AS 'NetEXTCount'
				  ,         0 AS 'NetEXTSales'
				  ,         0 AS 'NetGradCount'
				  ,         0 AS 'NetGradSales'
				  ,         0 AS 'NetXTRCount'  --Added RH 12/03/2014
				  ,         0 AS 'NetXTRSales'
				  ,         0 AS 'SurgeryCount'
				  ,         0 AS 'SurgerySales'
				  ,         0 AS 'PostEXTCount'
				  ,         0 AS 'PostEXTSales'
				  ,         0 AS 'NB1Apps'
				  ,         0 AS 'HairSalesCount'
				  ,         0 AS 'TradGradExtCount'
				  ,         0 AS 'TradGradExtSales'
				  FROM      #Consultations
				) Results
		GROUP BY CenterSSID
		,       Performer


/********************************** Display By Region/Center/Performer *************************************/
SELECT  R.CenterSSID AS 'CenterID'
,       DR.RegionSSID AS 'RegionID'
,       DR.RegionDescription AS 'region'
,       DC.CenterDescriptionNumber AS 'center'
,		R.Performer AS 'Performer'
,		R.Performer AS 'PerformerName'
,		R.Consultations AS 'consultations'
,       R.NetNB1Count AS 'NetNB1Count' --netSale --minus PostEXT and minus Xtrands  --Put back Xtrands for 2015 RH 01/28/2015
,       R.NetNB1Count_PostEXT AS 'NetNB1Count_PostEXT' --Added RH 11/24/2014
,		R.NetNB1Sales AS 'NetNB1Sales' --net_  --net$ --minus PostEXT and minus Xtrands --Put back Xtrands for 2015 RH 01/28/2015
,		R.NetNB1Sales_PostEXT AS 'NetNB1Sales_PostEXT' --net_  --net$  --Added RH 12/03/2014
,       dbo.DIVIDE_DECIMAL(ISNULL(R.NetNB1Count_PostEXT, 0), ISNULL(R.Consultations, 0)) AS 'ClosePercent' --Close% --Close_
,		dbo.DIVIDE_DECIMAL(R.NetNB1Sales_PostEXT, R.NetNB1Count_PostEXT) AS 'NetDollarsOverCount'  --Net$/# --Net___
,       R.HairSalesCount AS 'netHairSales'
,		R.NetEXTCount AS 'EXTSales'
,		dbo.DIVIDE_DECIMAL(R.HairSalesCount, R.NetNB1Count) AS 'HairSalesPercent' --HairSales%  --HairSales_
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
