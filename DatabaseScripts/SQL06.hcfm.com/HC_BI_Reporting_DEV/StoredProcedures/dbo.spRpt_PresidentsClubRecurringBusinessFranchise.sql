/***********************************************************************
PROCEDURE:				spRpt_PresidentsClubRecurringBusinessFranchise
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/02/2013
------------------------------------------------------------------------
CHANGE HISTORY:
01/08/2015 - RH - Added PCP_PCPAmt2013 and PCP_PCPAmt2014 (WO#110249)
07/13/2015 - RH - Changed PCPDetail to SQL05.HC_Accounting.dbo.vwFactPCPDetail - PCP Count now includes Xtrands
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PresidentsClubRecurringBusinessFranchise 8, '12/1/2014', '12/8/2014'

EXEC spRpt_PresidentsClubRecurringBusinessFranchise 8, '12/1/2014', '1/9/2015'

EXEC spRpt_PresidentsClubRecurringBusinessFranchise 8, '1/1/2015', '1/31/2015'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubRecurringBusinessFranchise]
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

CREATE TABLE #EXTExpirations (
	CenterSSID INT
,	Expirations INT
)

CREATE TABLE #PCPCount (
	CenterSSID INT
,	PCPCount INT
)

CREATE TABLE #PCPTarget (
	CenterSSID INT
,	PCPTarget INT
)

CREATE TABLE #PCPGoldAndBelow (
	CenterSSID INT
,	PCPGoldAndBelow INT
)

CREATE TABLE #PCPGoldAndBelowSales (
	CenterSSID INT
,	PCPGoldAndBelowSales MONEY
)

CREATE TABLE #Sales (
	CenterSSID INT
,	NetNB1Conv INT
,	NetEXTConv INT
,	NetTradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetGradSales MONEY
,	NB2Sales MONEY
,	PCPSales MONEY
,	ServiceSales MONEY
,	RetailSales MONEY
,	ClientsServiced INT
,	SurgerySales MONEY
,	PostEXTSales MONEY
,	NB1Apps INT
,	Upgrades INT
,	Downgrades INT
,	Cancels INT
,	Removals INT
,	PCP_PCPAmt2013 MONEY
,	PCP_PCPAmt2014 MONEY
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


/********************************** Get EXT Expiration Data *************************************/
INSERT	INTO #EXTExpirations
		SELECT	DC.CenterSSID
		,		COUNT(DC.ClientSSID) AS 'Expirations'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
				INNER JOIN #Centers cntr
					ON DC.CenterSSID = cntr.CenterSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON DC.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON CM.MembershipSSID = DM.MembershipSSID
		WHERE	DM.MembershipSSID IN ( 6, 7, 8, 9 )
				AND CM.ClientMembershipEndDate BETWEEN @StartDate AND @EndDate
				AND CM.ClientMembershipStatusSSID IN ( 1 )
		GROUP BY DC.CenterSSID


/********************************** Get PCP Count Data *************************************/
INSERT	INTO #PCPCount
		SELECT  CE.CenterSSID
		,       ( SUM(FPCP.ActiveBIO) + SUM(FPCP.ActiveEXT) + SUM(FPCP.ActiveXTR) ) AS 'PCP_Count'
		FROM    SQL05.HC_Accounting.dbo.vwFactPCPDetail FPCP
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FPCP.DateKey = DD.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
					ON FPCP.CenterKey = CE.CenterKey
				INNER JOIN #Centers cntr
					ON CE.CenterSSID = cntr.CenterSSID
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		GROUP BY CE.CenterSSID


/********************************** Get PCP Target Data *************************************/
INSERT	INTO #PCPTarget
		SELECT  CE.CenterSSID AS 'Center'
		,       CEILING(AVG(FlashReporting) * .03) AS 'PCPTarget'
		FROM    HC_Accounting.dbo.FactAccounting FA
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FA.DateKey = DD.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
					ON FA.CenterID = CE.CenterSSID
				INNER JOIN #Centers cntr
					ON CE.CenterSSID = cntr.CenterSSID
		WHERE   DD.FullDate BETWEEN DATEADD(day, -DAY(@StartDate) + 1, CONVERT(VARCHAR, @StartDate, 101))
						 AND     DATEADD(day, -DAY(@EndDate) + 1, CONVERT(VARCHAR, @EndDate, 101))
				AND FA.AccountID = 10410
		GROUP BY CE.CenterSSID


/********************************** Get PCP Gold & Below Counts Data *************************************/
INSERT	INTO #PCPGoldAndBelow
		SELECT  CE.CenterSSID AS 'Center'
		,       AVG(FA.FlashReporting) AS 'PCPCountGoldAndBelow'
		FROM    HC_Accounting.dbo.FactAccounting FA
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FA.DateKey = DD.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
					ON FA.CenterID = CE.CenterSSID
				INNER JOIN #Centers cntr
					ON CE.CenterSSID = cntr.CenterSSID
		WHERE   DD.FullDate BETWEEN DATEADD(day, -DAY(@StartDate) + 1, @StartDate)
							AND     DATEADD(day, -DAY(@EndDate) + 1, @EndDate)
				AND FA.AccountID = 10557
		GROUP BY CE.CenterSSID


/********************************** Get PCP Gold & Below Sales Data *************************************/
INSERT	INTO #PCPGoldAndBelowSales
		SELECT  CE.CenterSSID
		,       AVG(FA.FlashReporting) AS 'PCPSalesGoldAndBelow'
		FROM    HC_Accounting.dbo.FactAccounting FA
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FA.DateKey = DD.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
					ON FA.CenterID = CE.CenterSSID
				INNER JOIN #Centers cntr
					ON CE.CenterSSID = cntr.CenterSSID
		WHERE   DD.FullDate BETWEEN DATEADD(day, -DAY(@StartDate) + 1, @StartDate)
							AND     DATEADD(day, -DAY(@EndDate) + 1, @EndDate)
				AND FA.AccountID = 10558
		GROUP BY CE.CenterSSID


/********************************** Get Sales Data *************************************/
INSERT INTO #Sales
		SELECT	DC.ReportingCenterSSID AS 'CenterSSID'
		,		SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'Bio_Conv'
		,		SUM(ISNULL(FST.NB_ExtConvCnt, 0)) AS 'Ext_Conv'
		,		SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NetTradSales'
		,		SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NetEXTCount'
		,		SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,		SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NetGradSales'
		,		SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'NB2Sales'
		,		SUM(ISNULL(FST.PCP_PCPAmt, 0)) AS 'PCPSales'
		,		SUM(ISNULL(FST.ServiceAmt, 0)) AS 'ServiceSales'
		,		SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailSales'
		,		SUM(ISNULL(FST.ClientServicedCnt, 0)) AS 'ClientsServiced'
		,		SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgerySales'
		,		SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXTSales'
		,		SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Apps'
		,		SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) AS 'Upgrades'
		,		SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END) AS 'Downgrades'
		,		SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1099) AND DM.RevenueGroupDescriptionShort = 'PCP' THEN 1 ELSE 0 END) AS 'Cancels'
		,		SUM(CASE WHEN SC.SalesCodeSSID IN (399) THEN 1 ELSE 0 END) AS 'Removals'
		,		NULL AS 'PCP_PCPAmt2013'
		,		NULL AS 'PCP_PCPAmt2014'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = SC.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON FST.ClientMembershipKey = cm.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON CM.MembershipSSID = DM.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON FST.CenterKey = DC.CenterKey
                INNER JOIN #Centers
                    ON DC.ReportingCenterSSID = #Centers.CenterSSID
		WHERE	DD.FullDate BETWEEN @StartDate AND @EndDate
		GROUP BY DC.ReportingCenterSSID


/********************************** Find Start Date for 2013 and 2014 *************************************/
		DECLARE @MonthStart NVARCHAR(2)
		DECLARE @DayStart NVARCHAR(2)
		DECLARE @Start2013 DATETIME
		DECLARE @Start2014 DATETIME

		DECLARE @MonthEnd NVARCHAR(2)
		DECLARE @DayEnd NVARCHAR(2)
		DECLARE @End2013 DATETIME
		DECLARE @End2014 DATETIME

		SET @MonthStart = CAST(MONTH(@StartDate) AS VARCHAR(2))
		SET @DayStart = CAST(DAY(@StartDate) AS VARCHAR(2))

		IF YEAR(@StartDate) = 2014 AND YEAR(@EndDate) = 2014
		BEGIN
			SET @Start2013 = (SELECT DATEADD(YEAR,-1,CAST(@StartDate AS NVARCHAR(12))))
			SET @Start2014 = @StartDate
			SET @End2013 = (SELECT DATEADD(YEAR,-1,CAST(@EndDate AS NVARCHAR(12))))
			SET @End2014 = @EndDate
		END
		ELSE
		IF YEAR(@StartDate) = 2014 AND YEAR(@EndDate) = 2015
		BEGIN
			SET @Start2013 = (SELECT @MonthStart + '/' + @DayStart +  '/2012')
			SET @Start2014 = (SELECT DATEADD(YEAR,-1,CAST(@StartDate AS NVARCHAR(12))))
			SET @End2013 = (SELECT DATEADD(YEAR,-2,CAST(@EndDate AS NVARCHAR(12))) + ' 23:59:00:000')
			SET @End2014 = (SELECT DATEADD(YEAR,-1,CAST(@EndDate AS NVARCHAR(12))) + ' 23:59:00:000')
		END
		ELSE
		BEGIN
			SET @Start2013 = (SELECT DATEADD(YEAR,-2,CAST(@StartDate AS NVARCHAR(12))))
			SET @Start2014 = (SELECT DATEADD(YEAR,-1,CAST(@StartDate AS NVARCHAR(12))))
			SET @End2013 = (SELECT DATEADD(YEAR,-2,CAST(@EndDate AS NVARCHAR(12))) + ' 23:59:00:000')
			SET @End2014 = (SELECT DATEADD(YEAR,-1,CAST(@EndDate AS NVARCHAR(12))) + ' 23:59:00:000')
		END


			PRINT @Start2013
			PRINT @End2013
			PRINT @Start2014
			PRINT @End2014


/********************************** Find Total PCP Sales Data for 2013 *************************************/

		SELECT	DC.ReportingCenterSSID
		,		SUM(ISNULL(FST.PCP_PCPAmt, 0)) AS 'PCP_PCPAmt2013'
		INTO #2013
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = SC.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON FST.ClientMembershipKey = cm.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON CM.MembershipSSID = DM.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON FST.CenterKey = DC.CenterKey
                INNER JOIN #Centers
                    ON DC.ReportingCenterSSID = #Centers.CenterSSID

		WHERE	DD.FullDate BETWEEN @Start2013 AND @End2013
		GROUP BY DC.ReportingCenterSSID


/********************************** Find Total PCP Sales Data for 2013 *************************************/
		SELECT	DC.ReportingCenterSSID
		,		SUM(ISNULL(FST.PCP_PCPAmt, 0)) AS 'PCP_PCPAmt2014'
		INTO #2014
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = SC.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON FST.ClientMembershipKey = cm.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON CM.MembershipSSID = DM.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON FST.CenterKey = DC.CenterKey
                INNER JOIN #Centers
                    ON DC.ReportingCenterSSID = #Centers.CenterSSID

		WHERE	DD.FullDate BETWEEN @Start2014 AND @End2014
		GROUP BY DC.ReportingCenterSSID


/********************************** Update #Sales with PCP_PCPAmt2013 and PCP_PCPAmt2013  *********/

UPDATE #Sales
SET #Sales.PCP_PCPAmt2013 = #2013.PCP_PCPAmt2013
FROM #Sales
INNER JOIN #2013 ON #Sales.CenterSSID = #2013.ReportingCenterSSID
WHERE #Sales.PCP_PCPAmt2013 IS NULL

UPDATE #Sales
SET #Sales.PCP_PCPAmt2014 = #2014.PCP_PCPAmt2014
FROM #Sales
INNER JOIN #2014 ON #Sales.CenterSSID = #2014.ReportingCenterSSID
WHERE #Sales.PCP_PCPAmt2014 IS NULL


/********************************** Display By Region/Center *************************************/
SELECT	CT.CenterTypeDescriptionShort AS 'Type'
,		RGN.RegionDescription AS 'Region'
,		RGN.RegionSSID AS 'RegionID'
,		CTR.CenterSSID AS 'CenterID'
,		CTR.CenterDescriptionNumber AS 'Center'
,		ISNULL(S.NetNB1Conv, 0) AS 'BIO_Conv'
,		ISNULL(S.NB1Apps, 0) AS 'Apps_Bio'
,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Conv, 0), ISNULL(S.NB1Apps, 0)) AS 'Bio_Percent'
,		ISNULL(S.NetEXTConv, 0) AS 'Ext_Conv'
,		ISNULL(S.NetEXTCount, 0) AS 'Net_Ext'
,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetEXTConv, 0), ISNULL(S.NetEXTCount, 0)) AS 'Ext_Percent'
,		ISNULL(PCPCnt.PCPCount, 0) AS 'PCP_Count'
,		ISNULL(PCPTgt.PCPTarget, 0) AS 'Upg_Goal'
,		ISNULL(S.Upgrades, 0) AS 'Upg_Actual'
,		ISNULL(PCPGld.PCPGoldAndBelow, 0) AS 'PCP_Gold_Lower'
,		ISNULL(PCPGldSales.PCPGoldAndBelowSales, 0) AS 'Retail_Goal'
,		dbo.DIVIDE_DECIMAL(ISNULL(S.RetailSales, 0), ISNULL(S.ClientsServiced, 0)) AS 'Retail_Actual'
,		ISNULL(PCP_PCPAmt2013,0) AS 'PCP_PCPAmt2013'
,		ISNULL(PCP_PCPAmt2014,0) AS 'PCP_PCPAmt2014'
FROM	#Sales S
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON S.CenterSSID = CTR.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CTR.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion RGN
			ON CTR.RegionKey = RGN.RegionKey
		LEFT OUTER JOIN #EXTExpirations EXT
			ON CTR.CenterSSID = EXT.CenterSSID
		LEFT OUTER JOIN #PCPCount PCPCnt
			ON CTR.CenterSSID = PCPCnt.CenterSSID
		LEFT OUTER JOIN #PCPTarget PCPTgt
			ON CTR.CenterSSID = PCPTgt.CenterSSID
		LEFT OUTER JOIN #PCPGoldAndBelow PCPGld
			ON CTR.CenterSSID = PCPGld.CenterSSID
		LEFT OUTER JOIN #PCPGoldAndBelowSales PCPGldSales
			ON CTR.CenterSSID = PCPGldSales.CenterSSID
ORDER BY RGN.RegionDescription
,		CTR.CenterDescriptionNumber

END
