/* CreateDate: 02/24/2014 17:07:31.633 , ModifyDate: 03/19/2020 10:20:25.683 */
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardNewBusiness_Groups

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		02/25/2014

==============================================================================
DESCRIPTION:	New Business War Board
==============================================================================
NOTES:
This version of the WarBoard New Business divides by Groups that were setup by M.Oakes.
0 = All
1 = Group1 (Small)
2 = Group2 (Medium)
3 = Group3 (Large)

CHANGE HISTORY:
03/04/2014	RH	Changed @HairSalesMix_Cap = 1.2 to 2.0; Added 243 - Edmonton to Group 1. Replaced @CorpShowsBuget with @CorpShowsBudget.
04/14/2014	RH	(WO#99944) Re-arranged groups according to the request.
06/16/2014  RH  Added 10306 (Xtrands) to the NetNb1Amount (CashA) and the NetNb1Budget (CashB).
07/07/2014	RH	(#106841) Moved 241-Burlington from Large to Medium group and moved 239-Winnipeg from Medium to Small group.
10/28/2014 - RH - Added SUM(ISNULL(CASE WHEN FA.AccountID IN (10206) THEN Flash ELSE 0 END, 0)) AS 'NetXtrCount';
					Added NetXtrCount to dbo.DIVIDE_DECIMAL((NetTradCount + NetXtrCount + NetGradCount), (NetTradCount + NetXtrCount + NetGradCount + NetEXTCount + NetSurCount)) AS 'HairSalesMixA';
					Added NetXtrCount to dbo.DIVIDE_DECIMAL((NetTradCount + NetXtrCount + NetGradCount + NetEXTCount + NetSurCount + NetPostEXTCount), Consultations) AS 'CloseA';
					Added NetXtrCount to three more places in the stored procedure.
11/14/2014 - RH - Added 251 - Memphis and 252 - Nashville to Group 2; Added 253 - Tulsa and 254 - Little Rock to Group 1
12/09/2014 - RH - Moved 226 - Marlton from Group 1 to Group 2 (#109525)
03/09/2015 - RH - Moved centers according to (#111646)
11/12/2015 - RH - Moved centers according to (#120356)and added 277 - Oxnard to the Small group.
11/13/2015 - RH - Moved 220 - Columbia from Large to Medium (#120490)
12/28/2015 - RH - Made several changes according to #120883 for the 2016 year
01/26/2016 - RH - Added 262 - Baton Rouge and 299 - Broadway to the small group (#122447)
01/25/2017 - RH - (#134998) Added 245 - Pickering to the small group
03/08/2017 - RH - (#136756) Changed to use new fields NewBusinessSize and RecurringBusinessSize in the DimCenter table
05/10/2017 - RH - (#138911) Combined XTR+ and Xtrands for the HairSalesMix, changed @HairSalesMix_Benchmark to 60%
11/16/2017 - RH - (#144227) Added CASE WHEN HairSalesMixA > 1.00 THEN 1.00 ELSE HairSalesMixA
06/11/2018 - RH - (#150799) Changed CenterSSID to CenterNumber in the #Centers temp table, and changed the JOINs
07/13/2018 - JL - (#149913) Replaced Corporate Regions with Areas
01/25/2019 - RH - (Case #7101) Removed Surgery Revenue 10320
01/28/2019 - RH - (Case #7507) Added MDP Revenue to NetNb1Amount
04/17/2019 - RH - (Case #7100) Removed the Consultation section; removed revenue cap; increased Hair Sales Mix weight to 20%; increased NSD weight to 20%; replaced 'Xtr+ & Xtr Sales Mix' section with NB Counts
05/15/2019 - DL - (Case #11047) Removed WPB from report.
06/19/2019 - JL - (TFS 12573) Laser Report adjustment
01/07/2020 - RH - (TFS 13674) Added Surgery Counts and Dollars to NetNb1Budget; Added FST.S_SurAmt to NetNb1Revenue
01/28/2020 - RH - (TrackIT 5467) Added SelfGen weighting, cap, quotas - sales count made from referral consultations as defined in the NB Flash; changed @Closing_Weighting to .20; removed Corpus Christi (396)
03/16/2020 - RH - (TrackIT 7697) Added S_PRPCnt and S_PRPAmt to NetNBCount, NetNb1Revenue; Changed to C.CenterSSID NOT IN(100,212,1088); added consultations to the final select
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardNewBusiness_Groups] 2, 2020, 0, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardNewBusiness_Groups] (
	@Month TINYINT
,	@Year SMALLINT
,	@RegionSSID INT		-- This is Area
,	@GroupSize INT		-- 1 Small, 2 Medium, 3 Large
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

DECLARE @CummWorkdays INT
,	@MonthWorkdays INT
,	@CurrentMonth INT
,	@CummToMonth DECIMAL(18,4)
,	@MonthTotalDays DECIMAL(18,4)
,	@CurrentDay DECIMAL(18,4)
,	@CurrentToTotal DECIMAL(18,4)
,	@NBCount_Weighting DECIMAL(18,4)
,	@NBCount_Cap DECIMAL(18,4)
,	@NewStyles_Weighting DECIMAL(18,4)
,	@NewStyles_Cap DECIMAL(18,4)
,	@CorpNewStylesBudget DECIMAL(18,4)
,	@NBRevenue_Weighting DECIMAL(18,4)
,	@Closing_Weighting DECIMAL(18,4)
,	@Closing_Cap DECIMAL(18,4)
,	@Closing_Benchmark DECIMAL(18,4)
,	@SelfGen_Weighting DECIMAL(18,4)
,	@SelfGen_Cap DECIMAL(18,4)
,	@SelfGen_Small_Quota INT
,	@SelfGen_Med_Quota INT
,	@SelfGen_Large_Quota INT
,	@StartDate DATETIME
,	@EndDate DATETIME


SELECT @NBCount_Weighting = .20
,	@NBCount_Cap = 2.00
,	@NewStyles_Weighting = .20
,	@NewStyles_Cap = 2
,	@NBRevenue_Weighting = .3
,	@Closing_Weighting = .20
,	@Closing_Cap = 1.50
,	@Closing_Benchmark = .45

,	@SelfGen_Weighting = .10
,	@SelfGen_Cap = 1.50
,	@SelfGen_Small_Quota = 2
,	@SelfGen_Med_Quota = 3
,	@SelfGen_Large_Quota = 4

CREATE TABLE #Centers (
	CenterNumber INT
	,	CenterKey INT
	,	CenterDescriptionNumber NVARCHAR(104)
	,	NewBusinessSize NVARCHAR(10)
	,	SelfGenQuota INT
)

IF @RegionSSID=0
BEGIN
	INSERT INTO #Centers
	SELECT C.CenterNumber
	,	C.CenterKey
	,	C.CenterDescriptionNumber
	,	C.NewBusinessSize
	,	CASE WHEN C.NewBusinessSize = 'Small' THEN @SelfGen_Small_Quota
				WHEN C.NewBusinessSize = 'Medium' THEN @SelfGen_Med_Quota
				WHEN C.NewBusinessSize = 'Large' THEN @SelfGen_Large_Quota
		END AS SelfGenQuota
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	WHERE CT.CenterTypeDescriptionShort = 'C'
		AND C.Active = 'Y'
		AND C.CenterSSID NOT IN(100,212,1088) --Corporate, West Palm Beach, Corpus Christi
END
ELSE
BEGIN
	INSERT INTO #Centers
	SELECT C.CenterNumber
	,	C.CenterKey
	,	C.CenterDescriptionNumber
	,	C.NewBusinessSize
	,	CASE WHEN C.NewBusinessSize = 'Small' THEN @SelfGen_Small_Quota
				WHEN C.NewBusinessSize = 'Medium' THEN @SelfGen_Med_Quota
				WHEN C.NewBusinessSize = 'Large' THEN @SelfGen_Large_Quota
		END AS SelfGenQuota
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		ON CMA.CenterManagementAreaSSID = C.CenterManagementAreaSSID
	WHERE CT.CenterTypeDescriptionShort = 'C'
		AND C.Active = 'Y'
		AND CMA.CenterManagementAreaSSID=@RegionSSID
		AND C.CenterSSID NOT IN(100,212,1088) --Corporate, West Palm Beach, Corpus Christi

END


--Get # of Month and Cumulative workdays
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
/*
10205 - NB - Traditional Sales #
10206 - NB - Xtrands Sales #
10210 - NB - Gradual Sales #
10215 - NB - Extreme Sales #
10220 - NB - Surgery Sales #
10225 - NB - PostEXT Sales #
10901 - NB - RestorInk #
*/

/*
10305 - NB - Traditional Sales $
10306 - NB - Xtrands Sales $
10310 - NB - Gradual Sales $
10315 - NB - Extreme Sales $
10320 - NB - Surgery Sales $
10325 - NB - PostEXT Sales $
10552 - NB Laser Sales $
10891 - NB - RestorInk $
*/

SELECT FA.CenterID
,	CTR.CenterDescriptionNumber
,	CTR.SelfGenQuota
,	CASE WHEN CTR.NewBusinessSize = 'Small' THEN 1
		WHEN CTR.NewBusinessSize = 'Medium' THEN 2
		WHEN CTR.NewBusinessSize = 'Large' THEN 3
		ELSE 0
	END AS  'GroupSize'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10205,10206,10210,10215,10220,10225,10901) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10205,10206,10210,10215,10220,10225,10901) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) END AS 'NetNBCount_Budget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10110) THEN Flash ELSE 0 END, 0)) AS 'Consultations'  --KEEP for Closing%  --CloseA
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'NewStyles'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'BudgetNewStyles'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) END AS 'NetNb1Budget'
INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers CTR
		ON FA.CenterID = CTR.CenterNumber  --In FactAccounting Colorado Springs is 238 (CenterNumber) as CenterID
WHERE MONTH(FA.PartitionDate)=@Month
	AND YEAR(FA.PartitionDate)=@Year
GROUP BY FA.CenterID
,	CTR.CenterDescriptionNumber
,	CTR.SelfGenQuota
,	CASE WHEN CTR.NewBusinessSize = 'Small' THEN 1
		WHEN CTR.NewBusinessSize = 'Medium' THEN 2
		WHEN CTR.NewBusinessSize = 'Large' THEN 3
		ELSE 0
	END



/****************** Find NetNB1Counts and NetNB1Revenue like the NB Flash - from FactSalesTransaction ***********************************************/

SELECT CTR.CenterNumber
,	CTR.SelfGenQuota
,	CASE WHEN CTR.NewBusinessSize = 'Small' THEN 1
		WHEN CTR.NewBusinessSize = 'Medium' THEN 2
		WHEN CTR.NewBusinessSize = 'Large' THEN 3
		ELSE 0
	END AS  'GroupSize'
,	(SUM(ISNULL(FST.NB_TradCnt, 0))
					+ SUM(ISNULL(FST.NB_GradCnt, 0))
					+ SUM(ISNULL(FST.NB_ExtCnt, 0))
					+ SUM(ISNULL(FST.S_PostExtCnt, 0))
					+ SUM(ISNULL(FST.NB_XTRCnt, 0))
					+ SUM(ISNULL(FST.NB_MDPCnt, 0))
					+ SUM(ISNULL(FST.S_SurCnt,0))
					+ SUM(ISNULL(FST.S_PRPCnt,0)) )  AS NetNBCount
,	(SUM(ISNULL(FST.NB_TradAmt, 0))
					+ SUM(ISNULL(FST.NB_GradAmt, 0))
					+ SUM(ISNULL(FST.NB_ExtAmt, 0))
					+ SUM(ISNULL(FST.S_PostExtAmt, 0))
					+ SUM(ISNULL(FST.NB_XTRAmt, 0))
					+ SUM(ISNULL(FST.NB_MDPAmt, 0))
					+ SUM(ISNULL(FST.NB_LASERAmt, 0))
					+ SUM(ISNULL(FST.S_SurAmt, 0))
					+ SUM(ISNULL(FST.S_PRPAmt,0)) ) AS NetNb1Revenue
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
,	CTR.SelfGenQuota
,	CASE WHEN CTR.NewBusinessSize = 'Small' THEN 1 WHEN CTR.NewBusinessSize = 'Medium' THEN 2 WHEN CTR.NewBusinessSize = 'Large' THEN 3 ELSE 0 END


/********* Get Corporate Totals.  Needed for calculations below ******************************************************************/

SELECT 	@CorpNewStylesBudget = SUM(BudgetNewStyles)
FROM #Accounting

--If current month is selected divide budget amount by total number of workdays in month then multiply by number of cumulative workdays to date for month
SET @CorpNewStylesBudget = (CASE WHEN @Month = MONTH(GETDATE()) THEN dbo.DIVIDE_DECIMAL(@CorpNewStylesBudget, @MonthWorkdays) * @CummWorkdays ELSE @CorpNewStylesBudget END)

/********** Find HairSalesMixA, HairSalesMixBenchmark, NBRevenueA, NBRevenueB *********************************************************/

SELECT ISNULL(ACCT.GroupSize,NB1.GroupSize) AS GroupSize
,	ACCT.CenterID
,	ACCT.CenterDescriptionNumber
,	ISNULL(ACCT.SelfGenQuota,NB1.SelfGenQuota) AS SelfGenQuota
,	NB1.NetNBCount
,	ACCT.Consultations
,	ACCT.NetNBCount_Budget
,	ACCT.NewStyles
,	ACCT.BudgetNewStyles
,	CONVERT(NUMERIC(15, 0), NB1.NetNb1Revenue) AS 'CashA'
,	CONVERT(NUMERIC(15, 0), ACCT.NetNb1Budget) AS 'CashB'
,	dbo.DIVIDE_DECIMAL(NB1.NetNBCount, ACCT.Consultations) AS 'CloseA'
,	@Closing_Benchmark AS 'CloseC'
INTO #Base
FROM #Accounting ACCT
	INNER JOIN #NetNb1Amount NB1
		ON ACCT.CenterID = NB1.CenterNumber

/********************************** Get referrals and SelfGenCnt ****************************************************/

SELECT CTR.CenterNumber
,	SUM(CASE
		WHEN FAR.BOSRef = 1 THEN 1
		WHEN FAR.BOSOthRef = 1 THEN 1
		WHEN FAR.HCRef = 1 THEN 1
	END) AS 'Referral'
,	SUM(CASE
		WHEN (FAR.BOSRef = 1 AND A.ResultCodeSSID = 'SHOWSALE') THEN 1
		WHEN (FAR.BOSOthRef = 1 AND A.ResultCodeSSID = 'SHOWSALE') THEN 1
		WHEN (FAR.HCRef = 1 AND A.ResultCodeSSID = 'SHOWSALE') THEN 1
	END) AS 'SelfGenCnt'
INTO #Referrals
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
		ON FAR.ActivityKey = A.ActivityKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON A.CenterSSID = CTR.CenterSSID
	INNER JOIN #Centers
		ON CTR.CenterNumber = #Centers.CenterNumber
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
		ON A.SourceSSID = DS.SourceSSID
WHERE A.ActivityDueDate BETWEEN @StartDate AND @EndDate
	AND DS.Media IN ('Referrals', 'Referral')
	AND A.ResultCodeSSID NOT IN ('NOSHOW')
	AND FAR.BOSAppt <> 1
	AND DS.OwnerType <> 'Bosley Consult'
GROUP BY CTR.CenterNumber

/********** Find HairSalesMixPercent, CashPercent and other percentages **************************************************************************************************************/

SELECT GroupSize
,	CenterID
,	CenterDescriptionNumber
,	NetNBCount
,	Consultations
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
,	ISNULL(REF.SelfGenCnt,0) AS SelfGenCnt
,	ISNULL(#Base.SelfGenQuota,0) AS SelfGenQuota
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(REF.SelfGenCnt,0), ISNULL(#Base.SelfGenQuota,0)) > @SelfGen_Cap
		THEN @SelfGen_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(REF.SelfGenCnt,0), ISNULL(#Base.SelfGenQuota,0))
	END AS 'SelfGenPercent'
INTO #Final
FROM #Base
LEFT JOIN #Referrals REF
	ON #Base.CenterID = REF.CenterNumber

/**************** Find weightings *******************************************************************************************************************************/

SELECT  CASE WHEN f.GroupSize=0 THEN 1 ELSE f.GroupSize END AS GroupSize
,	f.CenterID
,	C.CenterDescriptionNumber
,	CMA.CenterManagementAreaDescription AS 'RegionDescription'
,	f.NetNBCount
,	f.Consultations
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

,	f.SelfGenCnt
,	f.SelfGenQuota
,	f.SelfGenPercent

,	f.NetNBCountPercent * @NBCount_Weighting
		+ f.NewStylesPercent * @NewStyles_Weighting
		+ f.CashPercent * @NBRevenue_Weighting
		+ f.ClosePercent * @Closing_Weighting
		+ f.SelfGenPercent * @SelfGen_Weighting
	AS 'Total'
FROM #Final f
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	ON C.CenterNumber = f.CenterID
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
WHERE f.GroupSize = @GroupSize
	OR @GroupSize = 0


END
GO
