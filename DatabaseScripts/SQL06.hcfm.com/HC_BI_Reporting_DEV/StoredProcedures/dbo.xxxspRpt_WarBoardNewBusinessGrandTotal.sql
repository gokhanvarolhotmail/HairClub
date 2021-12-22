/* CreateDate: 04/16/2013 13:43:22.220 , ModifyDate: 04/17/2019 16:47:13.600 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardNewBusinessGrandTotal

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		04/16/2013

==============================================================================
DESCRIPTION:	New Business War Board
==============================================================================
NOTES:
12/17/2013 - MB - Modified all budget amounts to be 1 if they are currently budgeted at 0 (WO# 94762)
03/04/2014 - RH - Changed @HairSalesMix_Cap = 1.2 to 2.0
06/16/2014 - RH - Added 10306 (Xtrands) to the NetNb1Amount (CashA) and the NetNb1Budget (CashB); Changed @CorpShowsBuget to @CorpShowsBudget
10/28/2014 - RH - Added SUM(ISNULL(CASE WHEN FA.AccountID IN (10206) THEN Flash ELSE 0 END, 0)) AS 'NetXtrCount';
					Added NetXtrCount to dbo.DIVIDE_DECIMAL((NetTradCount + NetXtrCount + NetGradCount), (NetTradCount + NetXtrCount + NetGradCount + NetEXTCount + NetSurCount)) AS 'HairSalesMixA';
					Added NetXtrCount to dbo.DIVIDE_DECIMAL((NetTradCount + NetXtrCount + NetGradCount + NetEXTCount + NetSurCount + NetPostEXTCount), Consultations) AS 'CloseA';
					Added NetXtrCount to three more places in the stored procedure.
12/28/2015 - RH - Made several changes according to #120883 for the 2016 year
05/10/2017 - RH - (#138911) Combined XTR+ and Xtrands for the HairSalesMix, changed @HairSalesMix_Benchmark to 60%
11/16/2017 - RH - (#144227) Added CASE WHEN HairSalesMixA > 1.00 THEN 1.00 ELSE HairSalesMixA
06/11/2018 - RH - (#150799) Changed CenterSSID to CenterNumber in the #Centers temp table
07/13/2018 - JL - (#149913) Removed join to region table insert into #Accounting. It's not necessary for grand total.
01/25/2019 - RH - (Case #7101) Removed Surgery Revenue 10320
01/28/2019 - RH - (Case #7507) Added MDP Revenue to NetNb1Amount
04/17/2019 - RH - (Case #7100) Removed the Consultation section; removed revenue cap; increased Hair Sales Mix weight to 20%; increased NSD weight to 20%; replaced 'Xtr+ & Xtr Sales Mix' section with NB Counts
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardNewBusinessGrandTotal] 3, 2019
==============================================================================
*/
CREATE PROCEDURE [dbo].[xxxspRpt_WarBoardNewBusinessGrandTotal] (
	@Month			TINYINT
,	@Year			SMALLINT)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


DECLARE @CummWorkdays INT
,	@MonthWorkdays INT
,	@CurrentMonth TINYINT
,	@CummToMonth DECIMAL(7, 6)
,	@MonthTotalDays DECIMAL(7, 6)
,	@CurrentDay DECIMAL(7, 6)
,	@CurrentToTotal DECIMAL(7, 6)
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@NBCount_Weighting DECIMAL(18,4)
,	@NBCount_Cap DECIMAL(18,4)
,	@NewStyles_Weighting NUMERIC(15,5)
,	@NewStyles_Cap NUMERIC(15,5)
,	@CorpNewStylesBudget NUMERIC(15,5)
,	@NBRevenue_Weighting NUMERIC(15,5)
,	@Closing_Weighting NUMERIC(15,5)
,	@Closing_Cap NUMERIC(15,5)
,	@Closing_Benchmark NUMERIC(15,5)

SELECT @NBCount_Weighting = .20
,	@NBCount_Cap = 2.00
,	@NewStyles_Weighting = .20
,	@NewStyles_Cap = 2
,	@NBRevenue_Weighting = .3
,	@Closing_Weighting = .30
,	@Closing_Cap = 1.50
,	@Closing_Benchmark = .45



CREATE TABLE #Centers (
		CenterNumber INT
	,	CenterKey INT
	,	CenterDescriptionNumber NVARCHAR(104)
)

/************** Find Centers ************************************************************************************************************************************************/

INSERT INTO #Centers
SELECT C.CenterNumber
,	C.CenterKey
,	C.CenterDescriptionNumber
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = C.CenterTypeKey
WHERE CT.CenterTypeDescriptionShort = 'C'
	AND C.Active = 'Y'
	AND C.CenterNumber <> 100

/************** Get # of Month and Cumulative workdays ***********************************************************************************************************************/

SET @MonthWorkdays = (SELECT [MonthWorkdaysTotal] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = (CONVERT(VARCHAR, @Month) + '/01/' + CONVERT(VARCHAR, @Year)))
SET @CummWorkdays = (SELECT [CummWorkdays] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(VARCHAR, GETDATE(), 101))


IF (@Month = MONTH(GETDATE()) AND @Year = YEAR(GETDATE()))
	BEGIN
		SET @MonthTotalDays = (SELECT MAX(DAY(FullDate)) FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE MONTH(FullDate) = @Month AND YEAR(FullDate) = @Year)
		SET @CurrentDay = (SELECT DAY(GETDATE()))

		IF @CurrentDay >= 2
		BEGIN
			SET @CurrentDay = @CurrentDay - 1
		END

		SET @CurrentToTotal = (@CurrentDay / @MonthTotalDays)
	END
ELSE
	BEGIN
		SET @CurrentToTotal = 1
	END

--Find @StartDate and @EndDate to use to find Sales

SELECT @StartDate = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
SELECT @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@StartDate)) + '23:59:000'									--End of the same month

/**************** Find Budgets ***************************************************************************************************************************************/


SELECT FA.CenterID
,	CTR.CenterDescriptionNumber
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10205,10206,10210,10215,10225) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10205,10206,10210,10215,10225) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) END AS 'NetNBCount_Budget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10110) THEN Flash ELSE 0 END, 0)) AS 'Consultations'  --KEEP for Closing%  --CloseA
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'NewStyles'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'BudgetNewStyles'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310,  10325) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310,  10325) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) END AS 'NetNb1Budget'
INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers CTR
		ON FA.CenterID = CTR.CenterNumber  --In FactAccounting Colorado Springs is 238 (CenterNumber) as CenterID
WHERE MONTH(FA.PartitionDate)=@Month
	AND YEAR(FA.PartitionDate)=@Year
GROUP BY FA.CenterID
,	CTR.CenterDescriptionNumber


/****************** Find NetNB1Counts and NetNB1Revenue like the NB Flash - from FactSalesTransaction ***********************************************/

SELECT CTR.CenterNumber

,	(SUM(ISNULL(FST.NB_TradCnt, 0))
					+ SUM(ISNULL(FST.NB_GradCnt, 0))
					+ SUM(ISNULL(FST.NB_ExtCnt, 0))
					+ SUM(ISNULL(FST.S_PostExtCnt, 0))
					+ SUM(ISNULL(FST.NB_XTRCnt, 0))
					+ SUM(ISNULL(FST.NB_MDPCnt, 0)))  AS NetNBCount
,	(SUM(ISNULL(FST.NB_TradAmt, 0))
					+ SUM(ISNULL(FST.NB_GradAmt, 0))
					+ SUM(ISNULL(FST.NB_ExtAmt, 0))
					+ SUM(ISNULL(FST.S_PostExtAmt, 0))
					+ SUM(ISNULL(FST.NB_XTRAmt, 0))
					+ SUM(ISNULL(FST.NB_MDPAmt, 0)))  AS NetNb1Revenue
INTO #NetNb1Amount
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipKey = m.MembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C  --Keep HomeCenter-based
                    ON cm.CenterKey = c.CenterKey
                INNER JOIN #Centers CTR
                    ON C.CenterNumber = CTR.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
                AND SO.IsVoidedFlag = 0
GROUP BY CTR.CenterNumber


/********* Get Corporate Totals.  Needed for calculations below ******************************************************************/

SELECT 	@CorpNewStylesBudget = SUM(BudgetNewStyles)
FROM #Accounting

--If current month is selected divide budget amount by total number of workdays in month then multiply by number of cumulative workdays to date for month
SET @CorpNewStylesBudget = (CASE WHEN @Month = MONTH(GETDATE()) THEN dbo.DIVIDE_DECIMAL(@CorpNewStylesBudget, @MonthWorkdays) * @CummWorkdays ELSE @CorpNewStylesBudget END)

/********** Find HairSalesMixA, HairSalesMixBenchmark, NBRevenueA, NBRevenueB *********************************************************/

SELECT 	1 AS [Group]
,	SUM(ISNULL(NB1.NetNBCount,0)) AS NetNBCount
,	SUM(ISNULL(ACCT.NetNBCount_Budget,0)) AS NetNBCount_Budget
,	SUM(ISNULL(ACCT.NewStyles,0)) AS NewStyles
,	SUM(ISNULL(ACCT.BudgetNewStyles,0)) AS BudgetNewStyles
,	CONVERT(NUMERIC(15, 0), SUM(NB1.NetNb1Revenue)) AS 'CashA'
,	CONVERT(NUMERIC(15, 0), SUM(ACCT.NetNb1Budget)) AS 'CashB'
,	dbo.DIVIDE_DECIMAL(SUM(NB1.NetNBCount), SUM(ACCT.Consultations)) AS 'CloseA'
,	@Closing_Benchmark AS 'CloseC'
INTO #Base
FROM #Accounting ACCT
	INNER JOIN #NetNb1Amount NB1
		ON ACCT.CenterID = NB1.CenterNumber

/********** Find HairSalesMixPercent, CashPercent and other percentages **************************************************************************************************************/

SELECT 	1 AS [Group]
,	NetNBCount
,	NetNBCount_Budget
,	CASE WHEN dbo.DIVIDE_DECIMAL(NetNBCount, NetNBCount_Budget) > @NBCount_Cap
		THEN @NBCount_Cap
		ELSE dbo.DIVIDE_DECIMAL(NetNBCount, NetNBCount_Budget)
	END AS 'NetNBCountPercent'
,	NewStyles
,	BudgetNewStyles
,	CASE WHEN dbo.DIVIDE_DECIMAL(NewStyles, BudgetNewStyles) > @NewStyles_Cap
		THEN @NewStyles_Cap
		ELSE dbo.DIVIDE_DECIMAL(NewStyles, BudgetNewStyles)
	END AS 'NewStylesPercent'
,	CashA
,	CashB
,	dbo.DIVIDE_DECIMAL(CashA, CashB) AS 'CashPercent'
,	CloseA
,	CloseC
,	CASE WHEN dbo.DIVIDE_DECIMAL(CloseA, CloseC) > @Closing_Cap
		THEN @Closing_Cap
		ELSE dbo.DIVIDE_DECIMAL(CloseA, CloseC)
	END AS 'ClosePercent'
INTO #Final
FROM #Base

/**************** Find weightings *******************************************************************************************************************************/

SELECT  f.NetNBCount
,	f.NetNBCount_Budget
,	f.NetNBCountPercent
,	f.NewStyles
,	f.BudgetNewStyles
,	f.NewStylesPercent
,	f.CashA
,	f.CashB
,	f.CashPercent
,	f.CloseA
,	f.CloseC
,	f.ClosePercent
,	f.NetNBCountPercent * @NBCount_Weighting
		+ f.NewStylesPercent * @NewStyles_Weighting
		+ f.CashPercent * @NBRevenue_Weighting
		+ f.ClosePercent * @Closing_Weighting
	AS 'Total'
FROM #Final f




END
GO
