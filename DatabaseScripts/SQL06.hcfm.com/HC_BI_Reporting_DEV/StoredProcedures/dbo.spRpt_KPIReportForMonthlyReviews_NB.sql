/* CreateDate: 11/01/2018 15:16:36.700 , ModifyDate: 04/01/2020 11:15:53.770 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		4/17/2019
DESCRIPTION:
------------------------------------------------------------------------
NOTES:
04/17/2019 - DL - Rewrote stored procedure
06/24/2019 - JL - (TFS 12573) Laser Report adjustment
03/13/2020 - RH - TrackIT 7697 Added S_PRPCnt to GrossCount, SurgeryCount, SurgerySales, NetNB1Count and NetNB1Sales
04/01/2020 - RH - (TrackIT 7257) Added Budget for 10320 - NB - Surgery Sales $ AND 10891 - NB - RestorInk $
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_KPIReportForMonthlyReviews_NB 230, 2, 2020
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_KPIReportForMonthlyReviews_NB]
(
	@CenterNumber INT
,	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE	@StartDate DATETIME
DECLARE	@EndDate DATETIME


SET @StartDate = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, @StartDate)) + '23:59:59'


DECLARE @LastMonthPCP DATETIME
SET @LastMonthPCP = DATEADD(Month,-1,@StartDate)


IF @CenterNumber = 1002
BEGIN
	SET @CenterNumber = 238
END


/*************************** Create temp tables ****************************************/
CREATE TABLE #Center (
	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(100)
,	CenterTypeDescription NVARCHAR(25)
)

CREATE TABLE #Sales (
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(100)
,	CenterTypeDescription NVARCHAR(25)
,	FullDate DATETIME
,	NB1Applications INT
,	GrossNB1Count INT
,	NetNB1CountNoSurgery INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales DECIMAL(18,4)
,	NetGradCount INT
,	NetGradSales DECIMAL(18,4)
,	NetGrad6Count INT
,	NetGrad6Sales DECIMAL(18,4)
,	NetGrad12Count INT
,	NetGrad12Sales DECIMAL(18,4)
,	NetEXTCount INT
,	NetEXTSales DECIMAL(18,4)
,	NetXtrCount INT
,	NetXtrSales DECIMAL(18,4)
,	SurgeryCount INT
,	SurgerySales DECIMAL(18,4)
,	AdditionalSurgerySales DECIMAL(18,4)
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18,4)
,	NetMDPCount INT
,	NetMDPSales DECIMAL(18,4)
,	NetLaserCount INT
,	NetLaserSales DECIMAL(18,4)
,	NetXtrPlusCount INT
,	NetXtrPlusSales DECIMAL(18,4)
,	XtrandsPlusSalesMix DECIMAL(18,4)
)

CREATE TABLE #Budget (
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(100)
,	CenterTypeDescription NVARCHAR(25)
,	FullDate DATETIME
,	Budget_TraditionalSales INT
,	Budget_TraditionalRevenue DECIMAL(18,4)
,	Budget_GradualSales INT
,	Budget_GradualRevenue DECIMAL(18,4)
,	Budget_EXTSales INT
,	Budget_EXTRevenue DECIMAL(18,4)
,	Budget_XtrandsSales INT
,	Budget_XtrandsRevenue DECIMAL(18,4)
,	Budget_SurgerySales INT
,	Budget_SurgeryRevenue DECIMAL(18,4)
,	Budget_PostEXTSales INT
,	Budget_PostEXTRevenue DECIMAL(18,4)
,	Budget_MDPSales INT
,	Budget_Applications INT
,	Budget_GrossNB1Sales INT
,	Budget_NetNB1Sales INT
,	Budget_NetNB1Revenue DECIMAL(18,4)
,	Budget_Closing DECIMAL(18,4)
)

CREATE TABLE #Consultation (
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(100)
,	CenterTypeDescription NVARCHAR(25)
,	FullDate DATETIME
,	Consultations INT
)


/********************************** Get Center data *************************************/
INSERT	INTO #Center
		SELECT  ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		ctr.CenterDescriptionNumber
		,		dct.CenterTypeDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
		WHERE   ctr.CenterNumber = @CenterNumber
				AND ctr.Active = 'Y'


CREATE NONCLUSTERED INDEX IDX_Center_CenterKey ON #Center ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


/********************************** Get Sales data *************************************/
INSERT  INTO #Sales
		SELECT	c.CenterNumber
		,		c.CenterDescriptionNumber
		,		c.CenterTypeDescription
		,		dd.FirstDateOfMonth
		,		SUM(ISNULL(fst.NB_AppsCnt, 0)) AS 'NB1Applications'
		,		SUM(ISNULL(fst.NB_GrossNB1Cnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt, 0)) AS 'GrossNB1Count'
		,		( SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) + SUM(ISNULL(fst.NB_ExtCnt, 0)) + SUM(ISNULL(fst.S_PostExtCnt, 0)) + SUM(ISNULL(fst.NB_XTRCnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0))) AS 'NetNB1CountNoSurgery'
		,		( SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) + SUM(ISNULL(fst.NB_ExtCnt, 0)) + SUM(ISNULL(fst.S_PostExtCnt, 0)) + SUM(ISNULL(fst.NB_XTRCnt, 0)) + SUM(ISNULL(fst.S_SurCnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt, 0))) AS 'NetNB1Count'
		,		( SUM(ISNULL(fst.NB_TradAmt, 0)) + SUM(ISNULL(fst.NB_GradAmt, 0)) + SUM(ISNULL(fst.NB_ExtAmt, 0)) + SUM(ISNULL(fst.S_PostExtAmt, 0)) + SUM(ISNULL(fst.NB_XTRAmt, 0)) + SUM(ISNULL(fst.NB_MDPAmt, 0)) + + SUM(ISNULL(fst.NB_LaserAmt, 0))+ SUM(ISNULL(fst.S_SurAmt, 0)) + SUM(ISNULL(fst.S_PRPAmt, 0))) AS 'NetNB1Sales'
		,		SUM(ISNULL(fst.NB_TradCnt, 0)) AS 'NetTradCount'
		,		SUM(ISNULL(fst.NB_TradAmt, 0)) AS 'NetTradSales'
		,		SUM(ISNULL(fst.NB_GradCnt, 0)) AS 'NetGradCount'
		,		SUM(ISNULL(fst.NB_GradAmt, 0)) AS 'NetGradSales'
		,		SUM(CASE WHEN m.MembershipDescriptionShort NOT IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12' ) THEN ISNULL(FST.NB_GradCnt, 0) ELSE 0 END) AS 'NetGrad6Count'
		,		SUM(CASE WHEN m.MembershipDescriptionShort NOT IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12' ) THEN ISNULL(FST.NB_GradAmt, 0) ELSE 0 END) AS 'NetGrad6Sales'
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12' ) THEN ISNULL(FST.NB_GradCnt, 0) ELSE 0 END) AS 'NetGrad12Count'
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12' ) THEN ISNULL(FST.NB_GradAmt, 0) ELSE 0 END) AS 'NetGrad12Sales'
		,		SUM(ISNULL(fst.NB_ExtCnt, 0)) AS 'NetEXTCount'
		,		SUM(ISNULL(fst.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,		SUM(ISNULL(fst.NB_XTRCnt, 0)) AS 'NetXtrCount'
		,		SUM(ISNULL(fst.NB_XTRAmt, 0)) AS 'NetXtrSales'
		,		SUM(ISNULL(fst.S_SurCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt, 0)) AS 'SurgeryCount'
		,		SUM(ISNULL(fst.S_SurAmt, 0)) + SUM(ISNULL(fst.S_PRPAmt, 0)) AS 'SurgerySales'
		,		SUM(ISNULL(fst.SA_NetSalesCnt, 0)) AS 'AdditionalSurgerySales'
		,		SUM(ISNULL(fst.S_PostExtCnt, 0)) AS 'PostEXTCount'
		,		SUM(ISNULL(fst.S_PostExtAmt, 0)) AS 'PostEXTSales'
		,		SUM(ISNULL(fst.NB_MDPCnt, 0)) AS 'NetMDPCount'
		,		SUM(ISNULL(fst.NB_MDPAmt, 0)) AS 'NetMDPSales'
		,		SUM(ISNULL(fst.LaserCnt, 0)) AS 'NetLaserCount'
		,		SUM(ISNULL(fst.LaserAmt, 0)) AS 'NetLaserSales'
		,		( SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) ) AS 'NetXtrPlusCount'
		,		( SUM(ISNULL(fst.NB_TradAmt, 0)) + SUM(ISNULL(fst.NB_GradAmt, 0)) ) AS 'NetXtrPlusSales'
		,		NULL AS 'XtrandsPlusSalesMix'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = cm.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = cm.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fst.ClientKey
		WHERE	dd.FullDate BETWEEN @StartDate AND @EndDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND so.IsVoidedFlag = 0
		GROUP BY c.CenterNumber
		,		c.CenterDescriptionNumber
		,		c.CenterTypeDescription
		,		dd.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Sales_FullDate ON #Sales ( FullDate );


UPDATE	s
SET		s.XtrandsPlusSalesMix = dbo.DIVIDE_NOROUND(NetXtrPlusCount, NetNB1CountNoSurgery)
FROM	#Sales s


/********************************** Get Budget data *************************************/
INSERT	INTO #Budget
		SELECT	c.CenterNumber
		,		c.CenterDescriptionNumber
		,		c.CenterTypeDescription
		,		fa.PartitionDate AS 'FullDate'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10205 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_TraditionalSales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10305 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_TraditionalRevenue'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10210 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_GradualSales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10310 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_GradualRevenue'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10215 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_EXTSales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10315 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_EXTRevenue'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10206 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_XtrandsSales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10306 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_XtrandsRevenue'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10220 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_SurgerySales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10320 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_SurgeryRevenue'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10225 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_PostEXTSales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10325 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_PostEXTRevenue'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 1500 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_MDPSales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10240 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_Applications'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10235 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_GrossNB1Sales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10205, 10206, 10210, 10215, 10220, 10225 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_NetNB1Sales'
		,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10305, 10306, 10310, 10315, 10320, 10325, 10552, 10891 ) THEN fa.Budget ELSE 0 END, 0)) AS 'Budget_NetNB1Revenue'
		,		0.45 AS 'Budget_Closing'
		FROM	HC_Accounting.dbo.FactAccounting fa
				INNER JOIN #Center c
					ON c.CenterSSID = fa.CenterID
		WHERE	fa.PartitionDate BETWEEN @StartDate AND @EndDate
				AND fa.AccountID IN ( 10205, 10305, 10210, 10310, 10215, 10315, 10206, 10306, 10220, 10320, 10225, 10325, 1500, 10240, 10235, 10552, 10891 )
		GROUP BY c.CenterNumber
		,		c.CenterDescriptionNumber
		,		c.CenterTypeDescription
		,		fa.PartitionDate


CREATE NONCLUSTERED INDEX IDX_Budget_FullDate ON #Budget ( FullDate );


/********************************** Get Consultation data *************************************/
INSERT	INTO #Consultation
		SELECT	c.CenterNumber
		,		c.CenterDescriptionNumber
		,		c.CenterTypeDescription
		,		dd.FirstDateOfMonth
		,		SUM(ISNULL(far.Consultation, 0)) AS 'Consultations'
		FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults far
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = far.ActivityDueDateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = far.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
		WHERE	dd.FullDate BETWEEN @StartDate AND @EndDate
		GROUP BY c.CenterNumber
		,		c.CenterDescriptionNumber
		,		c.CenterTypeDescription
		,		dd.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Consultation_FullDate ON #Consultation ( FullDate );


/********************************** Return data *************************************/
SELECT	c.CenterNumber
,		c.CenterDescriptionNumber
,		c.CenterTypeDescription
,		(SELECT dd.DateKey FROM HC_BI_ENT_DDS.bief_dds.DimDate dd WHERE dd.FullDate = @StartDate) AS 'DateKey'
,		@StartDate AS 'PartitionDate'
,		b.Budget_Closing AS 'Bud_ClosingRate_inclPEXT'
,		dbo.DIVIDE_NOROUND(s.NetNB1Count, csl.Consultations) AS 'ClosingRate_inclPEXT'
,		b.Budget_NetNB1Sales AS 'Bud_NBCount'
,		s.NetNB1Count AS 'NBCount'
,		b.Budget_NetNB1Revenue AS 'Bud_NBRevenue'
,		s.NetNB1Sales AS 'NBRevenue'
,		s.NetXtrPlusCount AS 'XTRPlusHairCount'
,		s.PostEXTCount
,		s.SurgeryCount
,		.50 AS 'Bud_XTRPlusHairSalesMix'
,		s.XtrandsPlusSalesMix AS 'XTRPlusHairSalesMix'
,		b.Budget_Applications AS 'Bud_NBApps'
,		s.NB1Applications AS 'NBApps'
,		@StartDate AS StartDate
,		@EndDate AS EndDate
FROM	#Center c
		LEFT OUTER JOIN #Sales s
			ON s.CenterNumber = c.CenterNumber
		LEFT OUTER JOIN #Budget b
			ON b.CenterNumber = c.CenterNumber
		LEFT OUTER JOIN #Consultation csl
			ON csl.CenterNumber = c.CenterNumber

END
GO
