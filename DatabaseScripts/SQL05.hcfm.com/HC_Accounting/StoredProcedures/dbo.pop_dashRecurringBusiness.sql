/* CreateDate: 08/07/2015 17:01:24.320 , ModifyDate: 08/07/2015 17:03:16.597 */
GO
/***********************************************************************
PROCEDURE:				[pop_dashRecurringBusiness]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
RELATED REPORT:
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
08/07/2015 - RH - Moved this stored procedure to SQL05 so that the CMS job could run it
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashRecurringBusiness]
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_dashRecurringBusiness]

AS
BEGIN

	SET ARITHABORT OFF
	SET ANSI_WARNINGS ON
	SET ANSI_NULLS ON

	CREATE TABLE #dashRB(
		FirstDateOfMonth DATETIME NOT NULL
	,	YearNumber INT NOT NULL
	,	YearMonthNumber INT NOT NULL
	,	CenterSSID INT NOT NULL
	,	NBApps INT NULL
	,	BIOPCPCount_Budget INT NULL
    ,	XtrandsPCPCount_Budget INT NULL
    ,	EXTPCPCount_Budget INT NULL
	,   BIOPCPCount INT NULL
	,	XtrandsPCPCount INT NULL
	,	EXTPCPCount  INT NULL
	,	BIOConvCnt_Budget INT NULL
	,	XtrandsConvCnt_Budget INT NULL
	,	EXTConvCnt_Budget INT NULL
	,	BIOConvCnt_Actual INT NULL
	,	XtrandsConvCnt_Actual INT NULL
	,	EXTConvCnt_Actual INT NULL
	,	BIOPCPAmt_Budget INT NULL
	,	XtrandsPCPAmt_Budget INT NULL
	,   EXTMEMPCPAmt_Budget  INT NULL
	,	TotalPCPAmt_Budget INT NULL
	,	RetailAmt_Budget INT NULL
	,	TotalRevenue_Budget INT NULL
	,	BIOPCPAmt_Actual INT NULL
	,	XtrandsPCPAmt_Actual INT NULL
	,	EXTMEMPCPAmt_Actual  INT NULL
	,	TotalPCPAmt_Actual INT NULL
	,	TotalCenterSales INT NULL
	,	RetailAmt INT NULL
	,	NB_XTRCnt INT NULL
	,	NB_ExtCnt INT NULL
	)


--Find dates for one month ago and today at the end of the day

DECLARE @StartDate DATETIME
DECLARE @FirstDayOfOneMonthAgo DATETIME
DECLARE @EndOfToday DATETIME


SET @StartDate = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)
SET @FirstDayOfOneMonthAgo = DATEADD(month,-1,@StartDate)
SET @EndOfToday = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETUTCDATE()+1),0) ))

PRINT @StartDate
PRINT @FirstDayOfOneMonthAgo
PRINT @EndOfToday


;WITH Rolling1Month AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN @FirstDayOfOneMonthAgo AND @EndOfToday
)


-- Get PCP counts
 , PCPActualBudget AS (
    SELECT  DC.CenterSSID
	,       FA.DateKey --Always first of the month

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) AS 'NBApps'

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) AS 'BIOPCPCount_Budget'
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) AS 'XtrandsPCPCount_Budget'
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) AS 'EXTPCPCount_Budget'

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'BIOPCPCount'
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'BIOConvCnt_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'XtrandsConvCnt_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'EXTConvCnt_Budget'

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN FA.Flash ELSE 0 END, 0)) AS 'BIOConvCnt_Actual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsConvCnt_Actual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTConvCnt_Actual'

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'BIOPCPAmt_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'XtrandsPCPAmt_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'EXTMEMPCPAmt_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10530,10540 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10530,10540  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'TotalPCPAmt_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (3090,3096) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (3090,3096) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END AS 'RetailAmt_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10525,10530,10540,3090,3096) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10525,10530,10540,3090,3096) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END AS 'TotalRevenue_Budget'

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) AS 'BIOPCPAmt_Actual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) AS 'XtrandsPCPAmt_Actual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) AS 'EXTMEMPCPAmt_Actual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (  10530,10540  ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) AS 'TotalPCPAmt_Actual'

	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling1Month DD
			ON FA.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterSSID
	WHERE  CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
		AND DC.Active = 'Y'
	GROUP BY DC.CenterSSID
	,       FA.DateKey
)
-- Get Sales Data
,	Sales AS (
        SELECT  DC.CenterSSID
		,       DD.YearMonthNumber
		,	 ROUND(SUM(ISNULL(FST.NB_XTRCnt, 0)),0) AS 'NB_XTRCnt'   --Opportunity
		,	 ROUND(SUM(ISNULL(FST.NB_ExtCnt, 0)),0) AS 'NB_ExtCnt'   --Opportunity
        ,      ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
			+	   ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0)
			AS 'SubTotalCenterSales'

        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN Rolling1Month DD
					ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                    ON FST.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON CM.CenterKey = DC.CenterKey       --KEEP HomeCenter Based

        GROUP BY DC.CenterSSID
        ,	DD.YearMonthNumber
)

-- Get Retail Sales data
,	RetailSales AS (
        SELECT  DC.CenterSSID AS 'CenterSSID'
        ,    DD.YearMonthNumber
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) AS 'RetailAmt'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling1Month DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey						--KEEP Transaction Based
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		WHERE (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))

		GROUP BY DC.CenterSSID
		,    DD.YearMonthNumber
		)


INSERT INTO #dashRB(
[FirstDateOfMonth]
      ,[YearNumber]
      ,[YearMonthNumber]
      ,[CenterSSID]
      ,[NBApps]
	  ,	[BIOPCPCount_Budget]
	  ,	[XtrandsPCPCount_Budget]
      ,	[EXTPCPCount_Budget]
      ,[BIOPCPCount]
      ,[XtrandsPCPCount]
      ,[EXTPCPCount]
      ,[BIOConvCnt_Budget]
      ,[XtrandsConvCnt_Budget]
      ,[EXTConvCnt_Budget]
      ,[BIOConvCnt_Actual]
      ,[XtrandsConvCnt_Actual]
      ,[EXTConvCnt_Actual]
      ,[BIOPCPAmt_Budget]
      ,[XtrandsPCPAmt_Budget]
      ,[EXTMEMPCPAmt_Budget]
      ,[TotalPCPAmt_Budget]
      ,[RetailAmt_Budget]
	  ,[TotalRevenue_Budget]
      ,[BIOPCPAmt_Actual]
      ,[XtrandsPCPAmt_Actual]
      ,[EXTMEMPCPAmt_Actual]
      ,[TotalPCPAmt_Actual]
      ,[TotalCenterSales]
      ,[RetailAmt]
	  ,[NB_XTRCnt]
	  ,[NB_ExtCnt]
	  )

SELECT ROLL.FirstDateOfMonth
	,	ROLL.YearNumber
	,	ROLL.YearMonthNumber
	,	PCP.CenterSSID
	,	PCP.NBApps
	,	PCP.BIOPCPCount_Budget
	,	PCP.XtrandsPCPCount_Budget
	,	PCP.EXTPCPCount_Budget
	,	PCP.BIOPCPCount
	,	PCP.XtrandsPCPCount
	,	PCP.EXTPCPCount
	,	PCP.BIOConvCnt_Budget
	,	PCP.XtrandsConvCnt_Budget
	,	PCP.EXTConvCnt_Budget
	,	PCP.BIOConvCnt_Actual
	,	PCP.XtrandsConvCnt_Actual
	,	PCP.EXTConvCnt_Actual
	,	PCP.BIOPCPAmt_Budget
	,	PCP.XtrandsPCPAmt_Budget
	,	PCP.EXTMEMPCPAmt_Budget
	,	PCP.TotalPCPAmt_Budget
	,	PCP.RetailAmt_Budget
	,	PCP.TotalRevenue_Budget
	,	PCP.BIOPCPAmt_Actual
	,	PCP.XtrandsPCPAmt_Actual
	,	PCP.EXTMEMPCPAmt_Actual
	,	PCP.TotalPCPAmt_Actual
	,	(S.SubTotalCenterSales + RS.RetailAmt) AS 'TotalCenterSales'
	,	S.NB_XTRCnt
	,	S.NB_ExtCnt
	,	RS.RetailAmt

FROM PCPActualBudget PCP
	INNER JOIN Rolling1Month ROLL
		ON PCP.DateKey = ROLL.DateKey
	INNER JOIN Sales S
		ON PCP.CenterSSID = S.CenterSSID
			AND ROLL.YearMonthNumber = S.YearMonthNumber
	INNER JOIN RetailSales RS
		ON PCP.CenterSSID = RS.CenterSSID
			AND ROLL.YearMonthNumber = RS.YearMonthNumber



--merge records with Target and Source
MERGE SQL06.HC_BI_Datazen.dbo.dashRecurringBusiness AS Target
USING (SELECT FirstDateOfMonth
      ,YearNumber
      ,YearMonthNumber
      ,CenterSSID
      ,NBApps
	  ,BIOPCPCount_Budget
	  ,XtrandsPCPCount_Budget
	  ,EXTPCPCount_Budget
      ,BIOPCPCount
      ,XtrandsPCPCount
      ,EXTPCPCount
      ,BIOConvCnt_Budget
      ,XtrandsConvCnt_Budget
      ,EXTConvCnt_Budget
      ,BIOConvCnt_Actual
      ,XtrandsConvCnt_Actual
      ,EXTConvCnt_Actual
      ,BIOPCPAmt_Budget
      ,XtrandsPCPAmt_Budget
      ,EXTMEMPCPAmt_Budget
      ,TotalPCPAmt_Budget
      ,RetailAmt_Budget
	  ,TotalRevenue_Budget
      ,BIOPCPAmt_Actual
      ,XtrandsPCPAmt_Actual
      ,EXTMEMPCPAmt_Actual
      ,TotalPCPAmt_Actual
      ,TotalCenterSales
      ,RetailAmt
	  ,NB_XTRCnt
	  ,NB_ExtCnt
FROM #dashRB
GROUP BY FirstDateOfMonth
      ,YearNumber
      ,YearMonthNumber
      ,CenterSSID

      ,NBApps

	  ,BIOPCPCount_Budget
	  ,XtrandsPCPCount_Budget
	  ,EXTPCPCount_Budget

      ,BIOPCPCount
      ,XtrandsPCPCount
      ,EXTPCPCount

      ,BIOConvCnt_Budget
      ,XtrandsConvCnt_Budget
      ,EXTConvCnt_Budget

      ,BIOConvCnt_Actual
      ,XtrandsConvCnt_Actual
      ,EXTConvCnt_Actual

      ,BIOPCPAmt_Budget
      ,XtrandsPCPAmt_Budget
      ,EXTMEMPCPAmt_Budget
      ,TotalPCPAmt_Budget
      ,RetailAmt_Budget
	  ,TotalRevenue_Budget

      ,BIOPCPAmt_Actual
      ,XtrandsPCPAmt_Actual
      ,EXTMEMPCPAmt_Actual
      ,TotalPCPAmt_Actual

      ,TotalCenterSales
      ,RetailAmt
	  ,NB_XTRCnt
	  ,NB_ExtCnt
	  ) AS Source
ON (Target.FirstDateOfMonth = Source.FirstDateOfMonth AND Target.YearNumber = Source.YearNumber
		AND Target.YearMonthNumber = Source.YearMonthNumber AND Target.CenterSSID = Source.CenterSSID)
WHEN MATCHED THEN
	UPDATE SET Target.NBApps = Source.NBApps

	,	Target.BIOPCPCount_Budget = Source.BIOPCPCount_Budget
	,	Target.XtrandsPCPCount_Budget = Source.XtrandsPCPCount_Budget
	,	Target.EXTPCPCount_Budget = Source.EXTPCPCount_Budget

	,	Target.BIOPCPCount = Source.BIOPCPCount
	,	Target.XtrandsPCPCount = Source.XtrandsPCPCount
	,	Target.EXTPCPCount = Source.EXTPCPCount

	,	Target.BIOConvCnt_Budget = Source.BIOConvCnt_Budget
	,	Target.XtrandsConvCnt_Budget = Source.XtrandsConvCnt_Budget
	,	Target.EXTConvCnt_Budget = Source.EXTConvCnt_Budget

	,	Target.BIOConvCnt_Actual = Source.BIOConvCnt_Actual
	,	Target.XtrandsConvCnt_Actual = Source.XtrandsConvCnt_Actual
	,	Target.EXTConvCnt_Actual = Source.EXTConvCnt_Actual

	,	Target.BIOPCPAmt_Budget = Source.BIOPCPAmt_Budget
	,	Target.XtrandsPCPAmt_Budget = Source.XtrandsPCPAmt_Budget
	,	Target.EXTMEMPCPAmt_Budget = Source.EXTMEMPCPAmt_Budget
	,	Target.TotalPCPAmt_Budget = Source.TotalPCPAmt_Budget
	,	Target.RetailAmt_Budget = Source.RetailAmt_Budget
	,	Target.TotalRevenue_Budget = Source.TotalRevenue_Budget

	,	Target.BIOPCPAmt_Actual = Source.BIOPCPAmt_Actual
	,	Target.XtrandsPCPAmt_Actual = Source.XtrandsPCPAmt_Actual
	,	Target.EXTMEMPCPAmt_Actual = Source.EXTMEMPCPAmt_Actual
	,	Target.TotalPCPAmt_Actual = Source.TotalPCPAmt_Actual

	,	Target.TotalCenterSales = Source.TotalCenterSales
	,	Target.RetailAmt = Source.RetailAmt

	,	Target.NB_XTRCnt = Source.NB_XTRCnt
	,	Target.NB_ExtCnt = Source.NB_ExtCnt



WHEN NOT MATCHED BY TARGET THEN
	INSERT(FirstDateOfMonth
      ,YearNumber
      ,YearMonthNumber
      ,CenterSSID
      ,NBApps
	  ,BIOPCPCount_Budget
	  ,XtrandsPCPCount_Budget
	  ,EXTPCPCount_Budget
      ,BIOPCPCount
      ,XtrandsPCPCount
      ,EXTPCPCount
      ,BIOConvCnt_Budget
      ,XtrandsConvCnt_Budget
      ,EXTConvCnt_Budget
      ,BIOConvCnt_Actual
      ,XtrandsConvCnt_Actual
      ,EXTConvCnt_Actual
      ,BIOPCPAmt_Budget
      ,XtrandsPCPAmt_Budget
      ,EXTMEMPCPAmt_Budget
      ,TotalPCPAmt_Budget
      ,RetailAmt_Budget
	  ,TotalRevenue_Budget
      ,BIOPCPAmt_Actual
      ,XtrandsPCPAmt_Actual
      ,EXTMEMPCPAmt_Actual
      ,TotalPCPAmt_Actual
      ,TotalCenterSales
      ,RetailAmt
	  ,NB_XTRCnt
	  ,NB_ExtCnt)
	VALUES(Source.FirstDateOfMonth
	  ,Source.YearNumber
      ,Source.YearMonthNumber
      ,Source.CenterSSID
      ,Source.NBApps
	  ,Source.BIOPCPCount_Budget
	  ,Source.XtrandsPCPCount_Budget
	  ,Source.EXTPCPCount_Budget
      ,Source.BIOPCPCount
      ,Source.XtrandsPCPCount
      ,Source.EXTPCPCount
      ,Source.BIOConvCnt_Budget
      ,Source.XtrandsConvCnt_Budget
      ,Source.EXTConvCnt_Budget
      ,Source.BIOConvCnt_Actual
      ,Source.XtrandsConvCnt_Actual
      ,Source.EXTConvCnt_Actual
      ,Source.BIOPCPAmt_Budget
      ,Source.XtrandsPCPAmt_Budget
      ,Source.EXTMEMPCPAmt_Budget
      ,Source.TotalPCPAmt_Budget
      ,Source.RetailAmt_Budget
	  ,Source.TotalRevenue_Budget
      ,Source.BIOPCPAmt_Actual
      ,Source.XtrandsPCPAmt_Actual
      ,Source.EXTMEMPCPAmt_Actual
      ,Source.TotalPCPAmt_Actual
      ,Source.TotalCenterSales
      ,Source.RetailAmt
	  ,Source.NB_XTRCnt
	  ,Source.NB_ExtCnt)
;

END
GO
