/* CreateDate: 03/21/2019 14:46:11.527 , ModifyDate: 03/21/2019 15:20:51.753 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusiness
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		New Version - Rachelen Hut 12/12/2018
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
		@TimeFilter = 1 for Monthly, 2 for Quarterly, 3 for YTD
		@Time is the detail of the timeframe, specific month or quarter selected

03/20/2019 - RH - (Case 9353) This is to be used in the Power BI report - YTD New Business, Monthly and Quarterly
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_pbiFlashNewBusiness 2019, 1, 1    --Monthly, January
EXEC spRpt_pbiFlashNewBusiness 2019, 2, 1    --Quarterly, FirstQuarter
EXEC spRpt_pbiFlashNewBusiness 2019, 3, 0    --YTD

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_pbiFlashNewBusiness]
(
	@Year	INT
,	@Timeframe INT
,	@Time	INT
) AS
BEGIN

SET FMTONLY OFF;

/******************** Create a start date and end date to use for the drill-downs in the report ***/
DECLARE @Month INT
DECLARE @Quarter INT

DECLARE @StartDate DATETIME
DECLARE	@EndDate DATETIME

IF @Timeframe = 1																	--Monthly
	BEGIN
	SET @Month = @Time
	SET @StartDate = CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
	SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(month,1,@StartDate) ))

	--PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	--PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))
END

ELSE IF @Timeframe = 2																--Quarterly
BEGIN
	SET @Quarter = @Time
	IF @Quarter = 1
		BEGIN
		SET @StartDate = CAST('1/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('3/31/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END
	ELSE IF @Quarter = 2
		BEGIN
		SET @StartDate = CAST('4/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('6/30/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END
	ELSE IF @Quarter = 3
		BEGIN
		SET @StartDate = CAST('7/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('9/30/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END
	ELSE IF @Quarter = 4
		BEGIN
		SET @StartDate = CAST('10/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		SET @EndDate = CAST('12/31/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
		END

	--PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	--PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))
END

ELSE IF @Timeframe = 3																--YTD
BEGIN
	SET @StartDate = CAST('1/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
	SET @EndDate = GETUTCDATE()
	SET @Time = 0

	--PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	--PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))
END


DECLARE @PartitionDate DATETIME
SET @PartitionDate = (SELECT CAST((CAST(MONTH(@StartDate) AS VARCHAR(2)) + CAST('/1/' AS VARCHAR(3)) + CAST(YEAR(@StartDate) AS VARCHAR(4))) AS DATETIME))

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
)

CREATE TABLE #Consultations(
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	Consultations INT
)


CREATE TABLE #BeBacks(
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	BeBacks INT
)


CREATE TABLE #NetReferrals (
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	Referrals INT
)

CREATE TABLE #NB_ARBalance (
	CenterNumber INT
,	NB_ARBalance MONEY
)

CREATE TABLE #Laser(
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	CenterDescription NVARCHAR(50)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
)

CREATE TABLE #Sales (
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	NB1Applications INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales DECIMAL(18,4)
,	NetEXTCount INT
,	NetEXTSales DECIMAL(18,4)
,	NetXtrCount INT  --Added 11/7/2014 RH
,	NetXtrSales DECIMAL(18,4)
,	NetGradCount INT
,	NetGradSales DECIMAL(18,4)
,	SurgeryCount INT
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18,4)
,	ClientARBalance DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
)

CREATE TABLE #Budget(
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	AccountID INT
,	NBNetCnt_InclPEXT_Budget INT
,	NBNetAMT_ExclSUR_Budget DECIMAL(18,4)
)

CREATE TABLE #SUM_Budget(
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	NBNetCnt_InclPEXT_Budget INT
,	NBNetAMT_ExclSUR_Budget DECIMAL(18,4)
)


/********************************** Get list of centers *************************************/


		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE	DC.Active = 'Y'
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ( 'C')


/********************************** Get consultations and bebacks *************************************/
INSERT  INTO #Consultations
        SELECT DC.CenterNumber
		,	DD.FirstDateOfMonth
		,	SUM(CASE WHEN Consultation = 1 THEN 1 ELSE 0 END) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterNumber = CTR.CenterNumber
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.BeBack <> 1
		AND FAR.Show=1
	GROUP BY DC.CenterNumber
	,	DD.FirstDateOfMonth


INSERT  INTO #BeBacks
        SELECT DC.CenterNumber
		,	DD.FirstDateOfMonth
		,	SUM(CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5)THEN 1 ELSE 0 END) AS 'BeBacks'
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterNumber = CTR.CenterNumber
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (FAR.BeBack = 1)
		AND FAR.Show=1
	GROUP BY DC.CenterNumber
	,	DD.FirstDateOfMonth

/********************************** Get referrals ****************************************************/

SELECT CTR.CenterNumber
,	CASE
		WHEN FAR.BOSRef = 1 THEN 1
		WHEN FAR.BOSOthRef = 1 THEN 1
		WHEN FAR.HCRef = 1 THEN 1
	END AS 'Referral'
,	DD.FirstDateOfMonth
INTO #Referrals
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FAR.ActivityDueDateKey = DD.DateKey
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

INSERT  INTO #NetReferrals
SELECT r.CenterNumber
,	FirstDateOfMonth
, SUM(r.Referral) AS Referrals
FROM #Referrals r
GROUP BY r.CenterNumber
,	FirstDateOfMonth

/******************************** Get New Business AR balances *************************************/
INSERT INTO #NB_ARBalance
SELECT s.CenterNumber, SUM(s.NB_ARBalance) AS 'NB_ARBalance'
FROM (SELECT C.CenterNumber
			,	C.CenterDescription
			,	CLT.ClientIdentifier
			,	CLT.ClientKey
			,	CLT.ClientLastName
			,	CLT.ClientFirstName
			,	M.MembershipDescription
			,	currentclient.ClientMembershipKey
			,	CLT.ClientARBalance AS 'NB_ARBalance'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CLT.CenterSSID = C.CenterSSID
				INNER JOIN #Centers CTR
					ON CTR.CenterNumber = C.CenterNumber
				OUTER APPLY (SELECT ClientIdentifier, CenterSSID, Membership, ClientMembershipKey, RevenueGroupSSID
							FROM dbo.fnGetCurrentMembershipDetailsByClientKey(CLT.ClientKey)
							) currentclient
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON currentclient.ClientMembershipKey = M.MembershipKey
		WHERE CLT.ClientARBalance > 0
				AND M.RevenueGroupDescription = 'New Business'
		) s
GROUP BY s.CenterNumber

/***************************** Find NB Laser Membership Counts and Revenue ************************************/
INSERT INTO #Laser
SELECT q.CenterNumber
,		q.FirstDateOfMonth
,       q.CenterDescription
,       SUM(ISNULL(q.LaserCnt,0)) AS LaserCnt
,       SUM(ISNULL(q.LaserAmt,0)) AS LaserAmt
FROM (SELECT DD.FullDate
		,	C.CenterNumber
		,	DD.FirstDateOfMonth
		,	#Centers.CenterDescription
		,	FST.Quantity AS LaserCnt
		,	FST.ExtendedPrice AS LaserAmt
		,	SC.SalesCodeDescriptionShort
		,	SC.SalesCodeDescription
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
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C				--Keep HomeCenter-based
							ON cm.CenterKey = c.CenterKey
						INNER JOIN #Centers
							ON C.CenterNumber = #Centers.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
							ON FST.ClientKey = CLT.ClientKey
				WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
						AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
						AND SO.IsVoidedFlag = 0
						AND (SC.SalesCodeDescription LIKE '%EXT%Laser%Payment'
							OR														--For Capillus
							SC.SalesCodeDescriptionShort LIKE 'EXTPMTCAP%')
							AND SC.SalesCodeDepartmentSSID = 2020)q					--Membership Revenue
GROUP BY q.CenterNumber,
         q.CenterDescription
		 ,	q.FirstDateOfMonth

/********************************** Get sales data *************************************************/
INSERT  INTO #Sales
        SELECT  c.CenterNumber
		,	DD.FirstDateOfMonth
		,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Applications'
        ,       SUM(ISNULL(FST.NB_GrossNB1Cnt, 0))+ SUM(ISNULL(FST.NB_MDPCnt, 0)) AS 'GrossNB1Count'
		,		(	SUM(ISNULL(FST.NB_TradCnt, 0))
					+ SUM(ISNULL(FST.NB_GradCnt, 0))
					+ SUM(ISNULL(FST.NB_ExtCnt, 0))
					+ SUM(ISNULL(FST.S_PostExtCnt, 0))
					+ SUM(ISNULL(FST.NB_XTRCnt, 0))
					+ SUM(ISNULL(FST.S_SurCnt, 0))
					+ SUM(ISNULL(FST.NB_MDPCnt, 0))
					) AS 'NetNB1Count'
        ,       (SUM(ISNULL(FST.NB_TradAmt, 0))
					+ SUM(ISNULL(FST.NB_GradAmt, 0))
					+ SUM(ISNULL(FST.NB_ExtAmt, 0))
					+ SUM(ISNULL(FST.S_PostExtAmt, 0))
					+ SUM(ISNULL(FST.NB_XTRAmt, 0))
					+ SUM(ISNULL(FST.NB_MDPAmt, 0)))  AS NetNB1Sales
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS NetTradCount
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS NetTradSales
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS NetEXTCount
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS NetEXTSales
		,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS NetXtrCount
        ,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS NetXtrSales
        ,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS NetGradCount
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS NetGradSales
        ,       SUM(ISNULL(FST.S_SurCnt, 0)) AS SurgeryCount
        ,       SUM(ISNULL(FST.S_PostExtCnt, 0)) AS PostEXTCount
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS PostEXTSales
		,		SUM(ISNULL(CLT.ClientARBalance,0)) AS ClientARBalance
		,		SUM(ISNULL(FST.NB_MDPCnt,0)) AS NB_MDPCnt
		,		SUM(ISNULL(FST.NB_MDPAmt,0)) AS NB_MDPAmt
		,		SUM(ISNULL(FST.LaserCnt,0)) AS LaserCnt
		,		SUM(ISNULL(FST.LaserAmt,0)) AS LaserAmt
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
                INNER JOIN #Centers
                    ON C.CenterNumber = #Centers.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
        WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
                AND SO.IsVoidedFlag = 0
        GROUP BY c.CenterNumber
		,	DD.FirstDateOfMonth

/********************************** Get budget data *************************************************/

--Description
--10231 - NB - Net Sales (Incl PEXT) #
--10233 - NB - Net Sales (Incl PEXT) $

INSERT INTO #Budget
SELECT CTR.CenterNumber
,	FA.PartitionDate AS FirstDateOfMonth
,	FA.AccountID
,	CASE WHEN FA.AccountID = 10231 THEN SUM(ISNULL(FA.Budget,0)) ELSE 0 END AS NBNetCnt_InclPEXT_Budget		--Counts include Surgery
,	CASE WHEN FA.AccountID = 10237 THEN SUM(ISNULL(FA.Budget,0)) ELSE 0 END AS NBNetAMT_ExclSUR_Budget		--Revenue has Surgery excluded
FROM HC_Accounting.dbo.FactAccounting FA
INNER JOIN #Centers CTR
	ON FA.CenterID = CTR.CenterNumber
WHERE FA.PartitionDate BETWEEN  @PartitionDate AND @EndDate
	AND FA.AccountID IN(10231,10237)
GROUP BY CTR.CenterNumber
,	FA.PartitionDate
,	FA.AccountID


INSERT INTO #SUM_Budget
SELECT B.CenterNumber
,	B.FirstDateOfMonth
,	SUM(B.NBNetCnt_InclPEXT_Budget) AS NBNetCnt_InclPEXT_Budget
,	SUM(B.NBNetAMT_ExclSUR_Budget) AS NBNetAMT_ExclSUR_Budget
FROM #Budget B
GROUP BY B.CenterNumber
 ,    B.FirstDateOfMonth

/********************************** Display By Main Group/Center *************************************/

SELECT  CASE WHEN CT.CenterTypeDescriptionShort = 'C' THEN 'Corporate' WHEN CT.CenterTypeDescriptionShort = 'HW' THEN 'Total Hair Solutions' ELSE 'Franchise' END AS [TYPE]
,		CASE WHEN CT.CenterTypeDescriptionShort = 'C' THEN 1 WHEN CT.CenterTypeDescriptionShort = 'HW' THEN 3 ELSE 2 END AS TypeID
,		C.MainGroupID
,		C.MainGroup
,		c.MainGroupSortOrder
,		C.CenterNumber AS CenterID
,		S.FirstDateOfMonth
,		C.CenterDescription
,		C.CenterDescriptionNumber AS CenterDescriptionNumber
,		ISNULL(Cons.Consultations, 0) AS consultations
,		ISNULL(BB.BeBacks, 0) AS BeBacks
,		ISNULL(Ref.Referrals, 0) AS Referrals
,		ISNULL(S.GrossNB1Count, 0) AS GrossNB1Count
,       ISNULL(S.NetNB1Count, 0) AS NetNB1Count
,       ISNULL(S.NetNB1Sales, 0) AS NetNB1Sales
,       ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0) AS NetXPCount
,       ISNULL(S.NetTradSales, 0) + ISNULL(S.NetGradSales, 0) AS NetXPSales
,       ISNULL(S.NetEXTCount, 0) + ISNULL(S.PostEXTCount, 0) AS NetEXTCount
,       ISNULL(S.NetEXTSales, 0) + ISNULL(S.PostEXTSales, 0) AS NetEXTSales
,		ISNULL(S.NetXtrCount, 0) AS NetXtrCount
,       ISNULL(S.NetXtrSales, 0) AS NetXtrSales
,       ISNULL(S.SurgeryCount, 0) AS SurgeryCount
,       ISNULL(S.PostEXTCount, 0) AS PostEXTCount
,       ISNULL(S.PostEXTSales, 0) AS PostEXTSales
,		ISNULL(S.NB1Applications, 0) AS NB1Applications
,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Sales, 0), ISNULL(S.NetNB1Count, 0)) AS [per_nb1_revenue]
,		dbo.DIVIDE(ISNULL(S.NetNB1Count, 0), ISNULL(Cons.Consultations, 0)) AS close_pct
,		dbo.DIVIDE((ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0)), (ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0) + ISNULL(S.NetEXTCount, 0) + ISNULL(S.PostEXTCount, 0) + ISNULL(S.NetXtrCount, 0)  + ISNULL(S.NB_MDPCnt, 0))) AS per_Bio
,		dbo.DIVIDE((ISNULL(S.NetEXTCount, 0) + ISNULL(S.PostEXTCount, 0)), (ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0) + ISNULL(S.NetEXTCount, 0) + ISNULL(S.PostEXTCount, 0) + ISNULL(S.NetXtrCount, 0) + ISNULL(S.NB_MDPCnt, 0))) AS per_EXT
,		dbo.DIVIDE((ISNULL(S.SurgeryCount, 0)) , (ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0) + ISNULL(S.NetEXTCount, 0) + ISNULL(S.PostEXTCount, 0) + ISNULL(S.NetXtrCount, 0) + ISNULL(S.SurgeryCount, 0) + ISNULL(S.NB_MDPCnt, 0))) AS per_Sur
,		dbo.DIVIDE(ISNULL(S.NetXtrCount, 0), (ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0) + ISNULL(S.NetEXTCount, 0) + ISNULL(S.PostEXTCount, 0)+ ISNULL(S.SurgeryCount, 0) + ISNULL(S.NetXtrCount, 0) + ISNULL(S.NB_MDPCnt, 0))) AS per_Xtr
,		dbo.DIVIDE(ISNULL(S.NB_MDPCnt, 0), (ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0) + ISNULL(S.NetEXTCount, 0) + ISNULL(S.PostEXTCount, 0) + ISNULL(S.SurgeryCount, 0) + ISNULL(S.NetXtrCount, 0) + ISNULL(S.NB_MDPCnt, 0))) AS per_MDP
,		ISNULL(NB.NB_ARBalance,0) AS NB_ARBalance
,		ISNULL(S.NB_MDPCnt,0) AS NB_MDPCnt
,		ISNULL(S.NB_MDPAmt,0) AS NB_MDPAmt
,		ISNULL(LA.LaserCnt,0) AS LaserCnt
,		ISNULL(LA.LaserAmt,0) AS LaserAmt
,	    ISNULL(BUD.NBNetCnt_InclPEXT_Budget,0) AS NBNetCnt_InclPEXT_Budget
,	    ISNULL(BUD.NBNetAMT_ExclSUR_Budget,'0.00') AS NBNetAMT_ExclSUR_Budget
,		@StartDate AS StartDate
,		@EndDate AS EndDate
FROM    #Centers C
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON C.CenterSSID = CTR.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CTR.CenterTypeKey = CT.CenterTypeKey
		LEFT OUTER JOIN #Sales S
			ON S.CenterNumber = C.CenterNumber
		LEFT OUTER JOIN #Consultations Cons
			ON Cons.CenterNumber = C.CenterNumber
		LEFT OUTER JOIN #Bebacks BB
			ON BB.CenterNumber = C.CenterNumber
		LEFT OUTER JOIN #NetReferrals Ref
			ON Ref.CenterNumber = C.CenterNumber
		LEFT OUTER JOIN #NB_ARBalance NB
			ON NB.CenterNumber = C.CenterNumber
		LEFT OUTER JOIN #Laser LA
			ON LA.CenterNumber = C.CenterNumber
		LEFT OUTER JOIN #SUM_Budget BUD
			ON C.CenterNumber = BUD.CenterNumber




END
GO
