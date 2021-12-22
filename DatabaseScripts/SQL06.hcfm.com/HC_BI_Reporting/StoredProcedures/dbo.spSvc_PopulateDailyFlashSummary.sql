/* CreateDate: 03/18/2021 11:43:37.723 , ModifyDate: 03/23/2021 12:42:03.530 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_PopulateDailyFlashSummary
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		2/11/2021
DESCRIPTION:			2/11/2021
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_PopulateDailyFlashSummary 'C'
EXEC spSvc_PopulateDailyFlashSummary 'F'
***********************************************************************/
CREATE PROCEDURE [dbo].spSvc_PopulateDailyFlashSummary
(
	@CenterType CHAR(1)
)
AS
BEGIN

SET NOCOUNT ON;
SET FMTONLY OFF;


DECLARE	@CurrentDate DATETIME
,		@YesterdayStart DATETIME
,		@YesterdayEnd DATETIME
,		@CurrentMonthStart DATETIME
,		@CurrentMonthEnd DATETIME
,		@DaysInMonth INT
,		@MTDDays INT
,		@MTDWorkingDays INT
,		@WorkingDaysInMonth INT
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@CurrentFiscalYearStart DATETIME
,		@CurrentFiscalYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME
,		@BudgetNBDollarsPerSale DECIMAL(18,4)


SET @CurrentDate = GETDATE()
SET @YesterdayStart = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, @CurrentDate), 101))
SET @YesterdayEnd = @YesterdayStart
SET @CurrentMonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@YesterdayStart)) + '/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
SET @CurrentMonthEnd = CONVERT(DATE, DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart)))
SET @DaysInMonth = DAY(EOMONTH(@CurrentMonthStart))
SET @MTDDays = (SELECT COUNT(d.FullDate) FROM HC_BI_ENT_DDS.bief_dds.DimDate d WHERE d.FullDate BETWEEN @CurrentMonthStart AND @YesterdayEnd)
SET @MTDWorkingDays = (SELECT COUNT(d.FullDate) FROM HC_BI_ENT_DDS.bief_dds.DimDate d WHERE d.FullDate BETWEEN @CurrentMonthStart AND @YesterdayEnd AND d.DayOfWeekName NOT IN ( 'Sunday', 'Monday' ))
SET @WorkingDaysInMonth = (SELECT COUNT(d.FullDate) FROM HC_BI_ENT_DDS.bief_dds.DimDate d WHERE d.FullDate BETWEEN @CurrentMonthStart AND @CurrentMonthEnd AND d.DayOfWeekName NOT IN ( 'Sunday', 'Monday' ))
SET @CurrentYearStart = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
SET @CurrentYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentYearStart))
SET @CurrentFiscalYearStart = (SELECT CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(FullDate))) FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @YesterdayStart, 101)))
SET @CurrentFiscalYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentFiscalYearStart))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Date (
	DateID INT
,	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	SortOrder INT
)

CREATE TABLE #Center (
	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
)

CREATE TABLE #Budget (
	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	FullDate DATETIME
,	AccountID INT
,	AccountDescription VARCHAR(300)
,	Value REAL
)

CREATE TABLE #Sales (
	FullDate DATETIME
,	NB1Applications INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales DECIMAL(18, 4)
,	NetTradCount INT
,	NetTradSales DECIMAL(18, 4)
,	NetGradCount INT
,	NetGradSales DECIMAL(18, 4)
,	NetEXTCount INT
,	NetEXTSales DECIMAL(18, 4)
,	NetXtrCount INT
,	NetXtrSales DECIMAL(18, 4)
,	SurgeryCount INT
,	SurgerySales DECIMAL(18, 4)
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18, 4)
,	NetMDPCount INT
,	NetMDPSales DECIMAL(18, 4)
,	NetLaserCount INT
,	NetLaserSales DECIMAL(18, 4)
,	NetNBLaserCount INT
,	NetNBLaserSales DECIMAL(18, 4)
,	NetPCPLaserCount INT
,	NetPCPLaserSales DECIMAL(18, 4)
,	PCPSales DECIMAL(18, 4)
,	NetPCPSales DECIMAL(18, 4)
,	NetNB2Sales DECIMAL(18, 4)
,	ServiceSales DECIMAL(18, 4)
,	RetailSales DECIMAL(18, 4)
,	BIOConversions INT
,	EXTConversions INT
,	XTRConversions INT
,	TotalConversions INT
,	NBCancels INT
,	PCPCancels INT
,	TotalCancels INT
)

CREATE TABLE #Receivables (
	FullDate DATETIME
,	Receivables INT
,	ClientCount INT
)

CREATE TABLE #Lead (
	FullDate DATETIME
,	Leads INT
)

CREATE TABLE #Task (
	FullDate DATETIME
,	Id NVARCHAR(18)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	Accomodation NVARCHAR(50)
,	ExcludeFromConsults INT
,	ExcludeFromBeBacks INT
,	BeBacksToExclude INT
)

CREATE TABLE #Activity (
	FullDate DATETIME
,	Appointments INT
,	Consultations INT
,	InPersonConsultations INT
,	VirtualConsultations INT
,	BeBacks INT
,	BeBacksToExclude INT
,	Shows INT
,	Sales INT
)

CREATE TABLE #Final (
	ReportDate DATETIME
,	DateID INT
,	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	SortOrder INT
,	BudgetLeads DECIMAL(18, 4)
,	BudgetAppointments DECIMAL(18, 4)
,	BudgetConsultations DECIMAL(18, 4)
,	BudgetGrossNB1Count DECIMAL(18, 4)
,	BudgetNetNB1Count DECIMAL(18, 4)
,	BudgetNetNB1Sales DECIMAL(18, 4)
,	BudgetNB1DollarPerSale DECIMAL(18, 4)
,	BudgetXtrandsPlusInitialCount DECIMAL(18, 4)
,	BudgetXtrandsPlusInitialSales DECIMAL(18, 4)
,	BudgetXtrandsPlusInitialConversionCount DECIMAL(18, 4)
,	BudgetXtrandsCount DECIMAL(18, 4)
,	BudgetXtrandsSales DECIMAL(18, 4)
,	BudgetXtrandsConversionCount DECIMAL(18, 4)
,	BudgetEXTCount DECIMAL(18, 4)
,	BudgetEXTSales DECIMAL(18, 4)
,	BudgetEXTConversionCount DECIMAL(18, 4)
,	BudgetSurgeryCount DECIMAL(18, 4)
,	BudgetSurgerySales DECIMAL(18, 4)
,	BudgetRestorInkCount DECIMAL(18, 4)
,	BudgetRestorInkSales DECIMAL(18, 4)
,	BudgetApplications DECIMAL(18, 4)
,	BudgetConversions DECIMAL(18, 4)
,	BudgetRecurringSales DECIMAL(18, 4)
,	BudgetLaserSales DECIMAL(18, 4)
,	BudgetNonProgramSales DECIMAL(18, 4)
,	BudgetServiceSales DECIMAL(18, 4)
,	BudgetRetailSales DECIMAL(18, 4)
,	NB1Applications INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales DECIMAL(18, 4)
,	NB1DollarPerSale DECIMAL(18, 4)
,	NetTradCount INT
,	NetTradSales DECIMAL(18, 4)
,	NetGradCount INT
,	NetGradSales DECIMAL(18, 4)
,	NetEXTCount INT
,	NetEXTSales DECIMAL(18, 4)
,	NetXtrCount INT
,	NetXtrSales DECIMAL(18, 4)
,	SurgeryCount INT
,	SurgerySales DECIMAL(18, 4)
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18, 4)
,	NetMDPCount INT
,	NetMDPSales DECIMAL(18, 4)
,	NetLaserCount INT
,	NetLaserSales DECIMAL(18, 4)
,	NetNBLaserCount INT
,	NetNBLaserSales DECIMAL(18, 4)
,	NetPCPLaserCount INT
,	NetPCPLaserSales DECIMAL(18, 4)
,	PCPSales DECIMAL(18, 4)
,	NetPCPSales DECIMAL(18, 4)
,	NetNB2Sales DECIMAL(18, 4)
,	ServiceSales DECIMAL(18, 4)
,	RetailSales DECIMAL(18, 4)
,	BIOConversions INT
,	EXTConversions INT
,	XTRConversions INT
,	TotalConversions INT
,	NBCancels INT
,	PCPCancels INT
,	TotalCancels INT
,	Receivables INT
,	ReceivablesClientCount INT
,	Leads INT
,	Appointments INT
,	Consultations INT
,	InPersonConsultations INT
,	VirtualConsultations INT
,	BeBacks INT
,	BeBacksToExclude INT
,	Shows INT
,	Sales INT
)


/********************************** Get Dates data *************************************/
INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (1, 'Day', 'Day', @YesterdayStart, @YesterdayEnd, 1)


INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (2, 'MTD', 'MTD', @CurrentMonthStart, @YesterdayEnd, 2)


INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (3, 'Full Month', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentMonthStart, @CurrentMonthEnd, 3)


INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (4, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentFiscalYearStart, @YesterdayEnd, 4)


CREATE NONCLUSTERED INDEX IDX_Date_Dates ON #Date ( StartDate, EndDate );


SELECT	@MinDate = CAST(MIN(d.StartDate) AS DATE)
,		@MaxDate = CAST(MAX(d.EndDate) AS DATE)
FROM	#Date d


UPDATE	d
SET		d.DateDescFiscalYear = CASE WHEN d.DateID = 3 THEN DATENAME(MONTH, d.StartDate) ELSE 'FY' END + ' ' + CONVERT(VARCHAR, dd.FiscalYear)
FROM	#Date d
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.FullDate = d.StartDate
WHERE	d.DateID IN ( 3, 4 )


UPDATE STATISTICS #Date;


/********************************** Get Center data *************************************/
IF @CenterType = 'C'
BEGIN
	INSERT INTO #Center
			SELECT	ctr.CenterKey
			,		ctr.CenterSSID
			,		ctr.CenterNumber
			,		ctr.CenterDescription
			FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
						ON ct.CenterTypeSSID = ctr.CenterTypeSSID
			WHERE	ct.CenterTypeDescriptionShort = 'C'
					AND ( ctr.CenterNumber IN ( 360, 199 ) OR ctr.Active = 'Y' )
END


IF @CenterType = 'F'
BEGIN
	INSERT INTO #Center
			SELECT	ctr.CenterKey
			,		ctr.CenterSSID
			,		ctr.CenterNumber
			,		ctr.CenterDescription
			FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON ctr.CenterTypeSSID = CT.CenterTypeSSID
			WHERE	CT.CenterTypeDescriptionShort IN ( 'F', 'JV' )
					AND ctr.Active = 'Y'
END


CREATE NONCLUSTERED INDEX IDX_Center_CenterKey ON #Center ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


UPDATE STATISTICS #Center;


/********************************** Get Budget Data *************************************/
INSERT	INTO #Budget
		SELECT	c.CenterKey
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		d.FullDate
		,		a.AccountID
		,		a.AccountDescription
		,		fa.Budget AS 'Value'
		FROM	HC_Accounting.dbo.FactAccounting fa
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount a
					ON a.AccountID = fa.AccountID
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = fa.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterNumber = fa.CenterID
				INNER JOIN #Center c
					ON c.CenterSSID = ctr.CenterSSID
		WHERE	d.FirstDateOfMonth BETWEEN @CurrentFiscalYearStart AND @YesterdayEnd
				AND a.AccountID IN ( 10125, 10230, 10305, 10310, 10430, 10206, 10306, 10433, 10215, 10225, 10315, 10325, 10435, 10220, 10221, 10320, 10321, 10901, 10891
								, 10240, 10536, 10551, 10552, 10540, 10575, 10555, 10155, 10100, 10110, 10440
								)


/********************************** Get Sales data *************************************/
INSERT  INTO #Sales
		SELECT	dd.FullDate
		,		SUM(ISNULL(fst.NB_AppsCnt, 0)) AS 'NB1Applications'
		,		SUM(ISNULL(fst.NB_GrossNB1Cnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0)) AS 'GrossNB1Count'
		,		( SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) + SUM(ISNULL(fst.NB_ExtCnt, 0)) + SUM(ISNULL(fst.S_PostExtCnt, 0)) + SUM(ISNULL(fst.NB_XTRCnt, 0)) + SUM(ISNULL(fst.S_SurCnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt, 0)) ) AS 'NetNB1Count'
		,		( SUM(ISNULL(fst.NB_TradAmt, 0)) + SUM(ISNULL(fst.NB_GradAmt, 0)) + SUM(ISNULL(fst.NB_ExtAmt, 0)) + SUM(ISNULL(fst.S_PostExtAmt, 0)) + SUM(ISNULL(fst.NB_XTRAmt, 0)) + SUM(ISNULL(fst.NB_MDPAmt, 0)) + SUM(ISNULL(fst.NB_LaserAmt, 0)) + SUM(ISNULL(fst.S_SurAmt, 0)) + SUM(ISNULL(fst.S_PRPAmt, 0))) AS 'NetNB1Sales'
		,		SUM(ISNULL(fst.NB_TradCnt, 0)) AS 'NetTradCount'
		,		SUM(ISNULL(fst.NB_TradAmt, 0)) AS 'NetTradSales'
		,		SUM(ISNULL(fst.NB_GradCnt, 0)) AS 'NetGradCount'
		,		SUM(ISNULL(fst.NB_GradAmt, 0)) AS 'NetGradSales'
		,		SUM(ISNULL(fst.NB_ExtCnt, 0)) AS 'NetEXTCount'
		,		SUM(ISNULL(fst.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,		SUM(ISNULL(fst.NB_XTRCnt, 0)) AS 'NetXtrCount'
		,		SUM(ISNULL(fst.NB_XTRAmt, 0)) AS 'NetXtrSales'
		,		SUM(ISNULL(fst.S_SurCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt, 0)) AS 'SurgeryCount'
		,		SUM(ISNULL(fst.S_SurAmt, 0)) + SUM(ISNULL(fst.S_PRPAmt, 0))AS 'SurgerySales'
		,		SUM(ISNULL(fst.S_PostExtCnt, 0)) AS 'PostEXTCount'
		,		SUM(ISNULL(fst.S_PostExtAmt, 0)) AS 'PostEXTSales'
		,		SUM(ISNULL(fst.NB_MDPCnt, 0)) AS 'NetMDPCount'
		,		SUM(ISNULL(fst.NB_MDPAmt, 0)) AS 'NetMDPSales'
		,		SUM(ISNULL(fst.LaserCnt, 0)) AS 'NetLaserCount'
		,		SUM(ISNULL(fst.LaserAmt, 0)) AS 'NetLaserSales'
		,		SUM(ISNULL(fst.nb_LaserCnt, 0)) AS 'NetNBLaserCount'
		,		SUM(ISNULL(fst.nb_LaserAmt, 0)) AS 'NetNBLaserSales'
		,		SUM(ISNULL(fst.pcp_LaserCnt, 0)) AS 'NetPCPLaserCount'
		,		SUM(ISNULL(fst.pcp_LaserAmt, 0)) AS 'NetPCPLaserSales'
		,		SUM(ISNULL(fst.PCP_PCPAmt, 0)) AS 'PCPSales'
		,		SUM(ISNULL(fst.PCP_NB2Amt, 0)) AS 'NetPCPSales'
		,		SUM(ISNULL(fst.PCP_NB2Amt, 0)) - SUM(ISNULL(fst.PCP_PCPAmt, 0)) AS 'NetNB2Sales'
		,		SUM(ISNULL(fst.ServiceAmt, 0)) AS 'ServiceSales'
		,       SUM(CASE WHEN scd.SalesCodeDivisionSSID IN ( 30, 50 )AND sc.SalesCodeDepartmentSSID <> 3065 THEN ISNULL(fst.RetailAmt, 0) ELSE 0 END) AS 'RetailSales'
		,		SUM(ISNULL(fst.NB_BIOConvCnt, 0)) AS 'BIOConversions'
		,		SUM(ISNULL(fst.NB_ExtConvCnt, 0)) AS 'EXTConversions'
		,		SUM(ISNULL(fst.NB_XTRConvCnt, 0)) AS 'XTRConversions'
		,		SUM(ISNULL(fst.NB_BIOConvCnt, 0)) + SUM(ISNULL(fst.NB_ExtConvCnt, 0)) + SUM(ISNULL(fst.NB_XTRConvCnt, 0)) AS 'TotalConversions'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'NB' THEN 1 ELSE 0 END) AS 'NBCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'PCP' THEN 1 ELSE 0 END) AS 'PCPCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort IN ( 'NB', 'PCP' ) THEN 1 ELSE 0 END) AS 'TotalCancels'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
					ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
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
		WHERE	dd.FullDate BETWEEN @MinDate AND @YesterdayEnd
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND so.IsVoidedFlag = 0
		GROUP BY dd.FullDate


CREATE NONCLUSTERED INDEX IDX_Sales_FullDate ON #Sales ( FullDate );


UPDATE STATISTICS #Sales;


/********************************** Get Receivables data *************************************/
INSERT	INTO #Receivables
		SELECT	dd.FullDate
		,		SUM(ISNULL(fr.Balance, 0)) AS 'Receivables'
		,		COUNT(DISTINCT fr.ClientKey) AS 'ClientCount'
		FROM	HC_Accounting.dbo.FactReceivables fr
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fr.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fr.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
						AND ctr.Active = 'Y'
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fr.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON ( cm.ClientMembershipSSID = clt.CurrentBioMatrixClientMembershipSSID
							OR cm.ClientMembershipSSID = clt.CurrentExtremeTherapyClientMembershipSSID
							OR cm.ClientMembershipSSID = clt.CurrentXtrandsClientMembershipSSID )
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipSSID = cm.MembershipSSID
		WHERE	dd.FullDate = @YesterdayEnd
				AND m.RevenueGroupSSID = 2 --PCP Receivables Only
				AND fr.Balance >= 0
		GROUP BY dd.FullDate


CREATE NONCLUSTERED INDEX IDX_Receivables_FullDate ON #Receivables ( FullDate );


UPDATE STATISTICS #Receivables;


/********************************** Get Lead data *************************************/
INSERT	INTO #Lead
		SELECT	CAST(l.ReportCreateDate__c AS DATE) AS 'FullDate'
		,		COUNT(l.Id) AS 'Leads'
		FROM	HC_BI_SFDC.dbo.Lead l
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(ISNULL(l.CenterNumber__c, l.CenterID__c), 100)
				OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
		WHERE	l.Status IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
				AND CAST(l.ReportCreateDate__c AS DATE) BETWEEN @MinDate AND @YesterdayEnd
				AND ISNULL(l.IsDeleted, 0) = 0
				AND ISNULL(fil.IsInvalidLead, 0) = 0
		GROUP BY CAST(l.ReportCreateDate__c AS DATE)


CREATE NONCLUSTERED INDEX IDX_Lead_FullDate ON #Lead ( FullDate );


UPDATE STATISTICS #Lead;


/********************************** Get Task data *************************************/
INSERT	INTO #Task
		SELECT	CAST(t.ActivityDate AS DATE) AS 'FullDate'
		,		t.Id
		,		ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c), 100)
		,		c.CenterDescription
		,		t.Action__c
		,		t.Result__c
		,		t.SourceCode__c
		,		t.Accommodation__c
		,		CASE WHEN (
							(
								t.Action__c = 'Be Back'
								OR	t.SourceCode__c IN ( 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSNCREF'
														, '4Q2016LWEXLD', 'REFEROTHER', 'IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF'
														, 'IPREFCLRERECA12476DP', 'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
														)
							)
							AND t.ActivityDate < '12/1/2020'
						) THEN 1
					ELSE 0
				END AS 'ExcludeFromConsults'
		,		CASE WHEN t.SourceCode__c IN ( 'CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSBIODMREF'
											, '4Q2016LWEXLD', 'REFEROTHER'
											) AND t.ActivityDate < '12/1/2020' THEN 1
					ELSE 0
				END AS 'ExcludeFromBeBacks'
		,		CASE WHEN ( t.Action__c = 'Be Back' AND t.ActivityDate < '12/1/2020' ) THEN 1
					ELSE 0
				END AS 'BeBacksToExclude'
		FROM	HC_BI_SFDC.dbo.Task t
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c), 100)
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = t.WhoId
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a
					ON a.PersonContactId = t.WhoId
		WHERE	LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
				AND CAST(t.ActivityDate AS DATE) BETWEEN @MinDate AND @YesterdayEnd
				AND ISNULL(t.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Task_FullDate ON #Task ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Task_Id ON #Task ( Id );
CREATE NONCLUSTERED INDEX IDX_Task_CenterNumber ON #Task ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Task_Action__c ON #Task ( Action__c );
CREATE NONCLUSTERED INDEX IDX_Task_Result__c ON #Task ( Result__c );
CREATE NONCLUSTERED INDEX IDX_Task_SourceCode ON #Task ( SourceCode );


UPDATE STATISTICS #Task;


/********************************** Get Activity data *************************************/
INSERT	INTO #Activity
		SELECT	t.FullDate
		,		SUM(CASE WHEN t.Action__c IN ( 'Appointment', 'In House', 'Recovery' ) AND ISNULL(t.Result__c, '') NOT IN ( 'Void', 'Cancel', 'Reschedule', 'Center Exception' ) THEN 1 ELSE 0 END) AS 'Appointments'
		,		SUM(CASE WHEN ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1 ELSE 0 END) AS 'Consultations'
		,		SUM(CASE WHEN ISNULL(t.Accomodation, 'In Person Consult') = 'In Person Consult' AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1 ELSE 0 END) AS 'InPersonConsultations'
		,		SUM(CASE WHEN ISNULL(t.Accomodation, 'In Person Consult') <> 'In Person Consult' AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1 ELSE 0 END) AS 'VirtualConsultations'
		,		SUM(CASE WHEN t.Action__c IN ( 'Be Back' ) AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromBeBacks, 0) = 0 THEN 1 ELSE 0 END) AS 'BeBacks'
		,		SUM(CASE WHEN ISNULL(t.BeBacksToExclude, 0) = 1 THEN 1 ELSE 0 END) AS 'BeBacksToExclude'
		,		SUM(CASE WHEN ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) THEN 1 ELSE 0 END) AS 'Shows'
		,		SUM(CASE WHEN ISNULL(t.Result__c, '') = 'Show Sale' THEN 1 ELSE 0 END) AS 'Sales'
		FROM	#Task t
		GROUP BY t.FullDate


CREATE NONCLUSTERED INDEX IDX_Activity_FullDate ON #Activity ( FullDate );


UPDATE STATISTICS #Activity;


/********************************** Get Totals *************************************/
INSERT	INTO #Final
		SELECT  CONVERT(DATE, @CurrentDate) AS 'ReportDate'
		,		d.DateID
		,       d.DateDesc
		,       d.DateDescFiscalYear
		,       d.StartDate
		,       d.EndDate
		,       d.SortOrder
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10155) AS 'BudgetLeads'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10100) AS 'BudgetAppointments'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10110) AS 'BudgetConsultations'
		,		(SELECT ( ISNULL(SUM(b.Value), 0) * 1.10 ) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10125) AS 'BudgetGrossNB1Count'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10125) AS 'BudgetNB1Count'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10305, 10310, 10315, 10325, 10306, 10891, 10320, 10321, 10552 )) AS 'BudgetNB1Sales'
		,		NULL AS 'BudgetNB1DollarPerSale'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10230) AS 'BudgetXtrandsPlusInitialCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10305, 10310 )) AS 'BudgetXtrandsPlusInitialSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10430) AS 'BudgetXtrandsPlusInitialConversionCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10206) AS 'BudgetXtrandsCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10306) AS 'BudgetXtrandsSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10433) AS 'BudgetXtrandsConversionCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10215, 10225 )) AS 'BudgetEXTCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10315, 10325 )) AS 'BudgetEXTSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10435) AS 'BudgetEXTConversionCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10220, 10221 )) AS 'BudgetSurgeryCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10320, 10321 )) AS 'BudgetSurgerySales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10901) AS 'BudgetRestorInkCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10891) AS 'BudgetRestorInkSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10240) AS 'BudgetApplications'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10430, 10433, 10435 )) AS 'BudgetConversions'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10536) AS 'BudgetRecurringSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID IN ( 10551, 10552 )) AS 'BudgetLaserSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10540) AS 'BudgetNonProgramSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10575) AS 'BudgetServiceSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate BETWEEN d.StartDate AND d.EndDate AND b.AccountID = 10555) AS 'BudgetRetailSales'
		,		(SELECT ISNULL(SUM(NB1Applications), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NB1Applications'
		,		(SELECT ISNULL(SUM(GrossNB1Count), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'GrossNB1Count'
		,		(SELECT ISNULL(SUM(NetNB1Count), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNB1Count'
		,		(SELECT ISNULL(SUM(NetNB1Sales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNB1Sales'
		,		(SELECT dbo.DIVIDE_DECIMAL(ISNULL(SUM(NetNB1Sales), 0), ISNULL(SUM(NetNB1Count), 0)) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNB1Sales'
		,		(SELECT ISNULL(SUM(NetTradCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetTradCount'
		,		(SELECT ISNULL(SUM(NetTradSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetTradSales'
		,		(SELECT ISNULL(SUM(NetGradCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetGradCount'
		,		(SELECT ISNULL(SUM(NetGradSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetGradSales'
		,		(SELECT ISNULL(SUM(NetEXTCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetEXTCount'
		,		(SELECT ISNULL(SUM(NetEXTSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetEXTSales'
		,		(SELECT ISNULL(SUM(NetXtrCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetXtrCount'
		,		(SELECT ISNULL(SUM(NetXtrSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetXtrSales'
		,		(SELECT ISNULL(SUM(SurgeryCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryCount'
		,		(SELECT ISNULL(SUM(SurgerySales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgerySales'
		,		(SELECT ISNULL(SUM(PostEXTCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PostEXTCount'
		,		(SELECT ISNULL(SUM(PostEXTSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PostEXTSales'
		,		(SELECT ISNULL(SUM(NetMDPCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetMDPCount'
		,		(SELECT ISNULL(SUM(NetMDPSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetMDPSales'
		,		(SELECT ISNULL(SUM(NetLaserCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetLaserCount'
		,		(SELECT ISNULL(SUM(NetLaserSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetLaserSales'
		,		(SELECT ISNULL(SUM(NetNBLaserCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNBLaserCount'
		,		(SELECT ISNULL(SUM(NetNBLaserSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNBLaserSales'
		,		(SELECT ISNULL(SUM(NetPCPLaserCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetPCPLaserCount'
		,		(SELECT ISNULL(SUM(NetPCPLaserSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetPCPLaserSales'
		,		(SELECT ISNULL(SUM(PCPSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PCPSales'
		,		(SELECT ISNULL(SUM(NetPCPSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetPCPSales'
		,		(SELECT ISNULL(SUM(NetNB2Sales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNB2Sales'
		,		(SELECT ISNULL(SUM(ServiceSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'ServiceSales'
		,		(SELECT ISNULL(SUM(RetailSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'RetailSales'
		,		(SELECT ISNULL(SUM(BIOConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BIOConversions'
		,		(SELECT ISNULL(SUM(EXTConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'EXTConversions'
		,		(SELECT ISNULL(SUM(XTRConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'XTRConversions'
		,		(SELECT ISNULL(SUM(TotalConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'TotalConversions'
		,		(SELECT ISNULL(SUM(NBCancels), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NBCancels'
		,		(SELECT ISNULL(SUM(PCPCancels), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PCPCancels'
		,		(SELECT ISNULL(SUM(TotalCancels), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'TotalCancels'
		,		(SELECT ISNULL(SUM(Receivables), 0) FROM #Receivables r WHERE r.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Receivables'
		,		(SELECT ISNULL(SUM(ClientCount), 0) FROM #Receivables r WHERE r.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'ReceivablesClientCount'
		,		(SELECT ISNULL(SUM(Leads), 0) FROM #Lead l WHERE l.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Leads'
		,		(SELECT ISNULL(SUM(Appointments), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Appointments'
		,		(SELECT ISNULL(SUM(Consultations), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Consultations'
		,		(SELECT ISNULL(SUM(a.InPersonConsultations), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'InPersonConsultations'
		,		(SELECT ISNULL(SUM(a.VirtualConsultations), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'VirtualConsultations'
		,		(SELECT ISNULL(SUM(BeBacks), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BeBacks'
		,		(SELECT ISNULL(SUM(a.BeBacksToExclude), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BeBacksToExclude'
		,		(SELECT ISNULL(SUM(Shows), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Shows'
		,		(SELECT ISNULL(SUM(Sales), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Sales'
		FROM    #Date d


UPDATE STATISTICS #Final;


/********************************** Get NB1 $/Sale Budget Value *************************************/
SET @BudgetNBDollarsPerSale = (SELECT dbo.DIVIDE_DECIMAL(f.BudgetNetNB1Sales, f.BudgetNetNB1Count) FROM #Final f WHERE f.DateDesc = 'Full Month')


/********************************** Update Dataset with Daily Budgets *************************************/
UPDATE	f_d
SET		f_d.BudgetLeads = dbo.DIVIDE_DECIMAL(x_M.BudgetLeads, @DaysInMonth)
,		f_d.BudgetAppointments = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetAppointments, @WorkingDaysInMonth) END
,		f_d.BudgetConsultations = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetConsultations, @WorkingDaysInMonth) END
,		f_d.BudgetGrossNB1Count = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(( x_M.BudgetNetNB1Count * 1.10 ), @WorkingDaysInMonth) END
,		f_d.BudgetNetNB1Count = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetNetNB1Count, @WorkingDaysInMonth) END
,		f_d.BudgetNetNB1Sales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetNetNB1Sales, @WorkingDaysInMonth) END
,		f_d.BudgetXtrandsPlusInitialCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetXtrandsPlusInitialCount, @WorkingDaysInMonth) END
,		f_d.BudgetXtrandsPlusInitialSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetXtrandsPlusInitialSales, @WorkingDaysInMonth) END
,		f_d.BudgetXtrandsPlusInitialConversionCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetXtrandsPlusInitialConversionCount, @WorkingDaysInMonth) END
,		f_d.BudgetXtrandsCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetXtrandsCount, @WorkingDaysInMonth) END
,		f_d.BudgetXtrandsSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetXtrandsSales, @WorkingDaysInMonth) END
,		f_d.BudgetXtrandsConversionCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetXtrandsConversionCount, @WorkingDaysInMonth) END
,		f_d.BudgetEXTCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetEXTCount, @WorkingDaysInMonth) END
,		f_d.BudgetEXTSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetEXTSales, @WorkingDaysInMonth) END
,		f_d.BudgetEXTConversionCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetEXTConversionCount, @WorkingDaysInMonth) END
,		f_d.BudgetSurgeryCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetSurgeryCount, @WorkingDaysInMonth) END
,		f_d.BudgetSurgerySales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetSurgerySales, @WorkingDaysInMonth) END
,		f_d.BudgetRestorInkCount = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetRestorInkCount, @WorkingDaysInMonth) END
,		f_d.BudgetRestorInkSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetRestorInkSales, @WorkingDaysInMonth) END
,		f_d.BudgetApplications = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetApplications, @WorkingDaysInMonth) END
,		f_d.BudgetConversions = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetConversions, @WorkingDaysInMonth) END
,		f_d.BudgetRecurringSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetRecurringSales, @DaysInMonth) END
,		f_d.BudgetLaserSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetLaserSales, @WorkingDaysInMonth) END
,		f_d.BudgetNonProgramSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetNonProgramSales, @WorkingDaysInMonth) END
,		f_d.BudgetServiceSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetServiceSales, @WorkingDaysInMonth) END
,		f_d.BudgetRetailSales = CASE WHEN DATENAME(WEEKDAY, @YesterdayEnd) IN ( 'Sunday', 'Monday' ) THEN 0 ELSE dbo.DIVIDE_DECIMAL(x_M.BudgetRetailSales, @WorkingDaysInMonth) END
FROM	#Final f_d
		CROSS APPLY (
			SELECT	f_m.StartDate
			,		f_m.EndDate
			,		f_m.BudgetLeads
			,		f_m.BudgetAppointments
			,		f_m.BudgetConsultations
			,		f_m.BudgetNetNB1Count
			,		f_m.BudgetNetNB1Sales
			,		f_m.BudgetNB1DollarPerSale
			,		f_m.BudgetXtrandsPlusInitialCount
			,		f_m.BudgetXtrandsPlusInitialSales
			,		f_m.BudgetXtrandsPlusInitialConversionCount
			,		f_m.BudgetXtrandsCount
			,		f_m.BudgetXtrandsSales
			,		f_m.BudgetXtrandsConversionCount
			,		f_m.BudgetEXTCount
			,		f_m.BudgetEXTSales
			,		f_m.BudgetEXTConversionCount
			,		f_m.BudgetSurgeryCount
			,		f_m.BudgetSurgerySales
			,		f_m.BudgetRestorInkCount
			,		f_m.BudgetRestorInkSales
			,		f_m.BudgetApplications
			,		f_m.BudgetConversions
			,		f_m.BudgetRecurringSales
			,		f_m.BudgetLaserSales
			,		f_m.BudgetNonProgramSales
			,		f_m.BudgetServiceSales
			,		f_m.BudgetRetailSales
			FROM	#Final f_m
			WHERE	f_m.DateDesc = 'Full Month'
					AND f_d.StartDate BETWEEN f_m.StartDate AND f_m.EndDate
		) x_M
WHERE	f_d.DateDesc = 'Day'


/********************************** Update Dataset with MTD Budgets *************************************/
UPDATE	f_m
SET		f_m.BudgetLeads = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetLeads, @DaysInMonth) ) * @MTDDays )
,		f_m.BudgetAppointments = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetAppointments, @DaysInMonth) ) * @MTDDays )
,		f_m.BudgetConsultations = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetConsultations, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetGrossNB1Count = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetGrossNB1Count, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetNetNB1Count = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetNetNB1Count, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetNetNB1Sales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetNetNB1Sales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetXtrandsPlusInitialCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetXtrandsPlusInitialCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetXtrandsPlusInitialSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetXtrandsPlusInitialSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetXtrandsPlusInitialConversionCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetXtrandsPlusInitialConversionCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetXtrandsCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetXtrandsCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetXtrandsSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetXtrandsSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetXtrandsConversionCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetXtrandsConversionCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetEXTCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetEXTCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetEXTSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetEXTSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetEXTConversionCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetEXTConversionCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetSurgeryCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetSurgeryCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetSurgerySales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetSurgerySales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetRestorInkCount = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetRestorInkCount, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetRestorInkSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetRestorInkSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetApplications = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetApplications, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetConversions = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetConversions, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetRecurringSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetRecurringSales, @DaysInMonth) ) * @MTDDays )
,		f_m.BudgetLaserSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetLaserSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetNonProgramSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetNonProgramSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetServiceSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetServiceSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
,		f_m.BudgetRetailSales = ( ( dbo.DIVIDE_DECIMAL(f_m.BudgetRetailSales, @WorkingDaysInMonth) ) * @MTDWorkingDays )
FROM	#Final f_m
WHERE	f_m.DateDesc = 'MTD'


/********************************** Save Final Data *************************************/
TRUNCATE TABLE datDailyFlashSummary


INSERT	INTO datDailyFlashSummary
		SELECT	f.ReportDate
		,		f.DateID
		,		f.DateDesc
		,		f.DateDescFiscalYear
		,		f.StartDate
		,		f.EndDate
		,		f.SortOrder
		,		ROUND(f.BudgetLeads, 0) AS 'BudgetLeads'
		,		f.Leads
		,		ROUND(( f.Leads - f.BudgetLeads ), 0) AS 'LeadsVariance'
		,		ROUND(f.BudgetAppointments, 0) AS 'BudgetAppointments'
		,		f.Appointments
		,		ROUND(( f.Appointments - f.BudgetAppointments ), 0) AS 'AppointmentsVariance'
		,		ROUND(f.BudgetConsultations, 0) AS 'BudgetConsultations'
		,		f.Consultations
		,		ROUND(( f.Consultations - f.BudgetConsultations ), 0) AS 'ConsultationsVariance'
		,		f.InPersonConsultations
		,		f.VirtualConsultations
		,		ROUND(f.BudgetGrossNB1Count, 0) AS 'BudgetGrossNB1Count'
		,		f.GrossNB1Count
		,		ROUND(( f.GrossNB1Count - f.BudgetGrossNB1Count ), 0) AS 'GrossNB1CountVariance'
		,		ROUND(f.BudgetNetNB1Count, 0) AS 'BudgetNetNB1Count'
		,		f.NetNB1Count
		,		ROUND(( f.NetNB1Count - f.BudgetNetNB1Count ), 0) AS 'NetNB1CountVariance'
		,		ROUND(f.BudgetNetNB1Sales, 0) AS 'BudgetNetNB1Sales'
		,		f.NetNB1Sales
		,		ROUND(( f.NetNB1Sales - f.BudgetNetNB1Sales ), 0) AS 'NetNB1SalesVariance'
		,		ROUND(@BudgetNBDollarsPerSale, 0) AS 'BudgetNB1DollarPerSale'
		,		f.NB1DollarPerSale
		,		ROUND(( f.NB1DollarPerSale - @BudgetNBDollarsPerSale ), 0) AS 'NB1DollarPerSaleVariance'
		,		ROUND(f.BudgetXtrandsPlusInitialCount, 0) AS 'BudgetXtrandsPlusCount'
		,		( f.NetTradCount + f.NetGradCount ) AS 'XtrandsPlusCount'
		,		ROUND(( ( f.NetTradCount + f.NetGradCount ) - f.BudgetXtrandsPlusInitialCount ), 0) AS 'XtrandsPlusCountVariance'
		,		ROUND(f.BudgetXtrandsPlusInitialSales, 0) AS 'BudgetXtrandsPlusSales'
		,		( f.NetTradSales + f.NetGradSales ) AS 'XtrandsPlusSales'
		,		ROUND(( ( f.NetTradSales + f.NetGradSales ) - f.BudgetXtrandsPlusInitialSales ), 0) AS 'XtrandsPlusSalesVariance'
		,		ROUND(f.BudgetXtrandsPlusInitialConversionCount, 0) AS 'BudgetXtrandsPlusConversionsCount'
		,		f.BIOConversions AS 'XtrandsPlusConversionsCount'
		,		ROUND(( f.BIOConversions - f.BudgetXtrandsPlusInitialConversionCount ), 0) AS 'XtrandsPlusConversionsCountVariance'
		,		ROUND(f.BudgetXtrandsCount, 0) AS 'BudgetXtrandsCount'
		,		f.NetXtrCount AS 'XtrandsCount'
		,		ROUND(( f.NetXtrCount - f.BudgetXtrandsCount ), 0) AS 'XtrandsCountVariance'
		,		ROUND(f.BudgetXtrandsSales, 0) AS 'BudgetXtrandsSales'
		,		f.NetXtrSales AS 'XtrandsSales'
		,		ROUND(( f.NetXtrSales - f.BudgetXtrandsSales ), 0) AS 'XtrandsSalesVariance'
		,		ROUND(f.BudgetXtrandsConversionCount, 0) AS 'BudgetXtrandsConversionCount'
		,		f.XTRConversions AS 'XtrandsConversionsCount'
		,		ROUND(( f.XTRConversions - f.BudgetXtrandsConversionCount ), 0) AS 'XtrandsConversionsCountVariance'
		,		ROUND(f.BudgetEXTCount, 0) AS 'BudgetEXTCount'
		,		( f.NetEXTCount + f.PostEXTCount ) AS 'EXTCount'
		,		ROUND(( ( f.NetEXTCount + f.PostEXTCount ) - f.BudgetEXTCount ), 0) AS 'EXTCountVariance'
		,		ROUND(f.BudgetEXTSales, 0) AS 'BudgetEXTSales'
		,		( f.NetEXTSales + f.PostEXTSales ) AS 'EXTSales'
		,		ROUND(( ( f.NetEXTSales + f.PostEXTSales ) - f.BudgetEXTSales ), 0) AS 'EXTSalesVariance'
		,		ROUND(f.BudgetEXTConversionCount, 0) AS 'BudgetEXTConversionCount'
		,		f.EXTConversions AS 'EXTConversionsCount'
		,		ROUND(( f.EXTConversions - f.BudgetEXTConversionCount ), 0) AS 'EXTConversionsCountVariance'
		,		ROUND(f.BudgetSurgeryCount, 0) AS 'BudgetSurgeryCount'
		,		f.SurgeryCount
		,		ROUND(( f.SurgeryCount - f.BudgetSurgeryCount ), 0) AS 'SurgeryCountVariance'
		,		ROUND(f.BudgetSurgerySales, 0) AS 'BudgetSurgerySales'
		,		f.SurgerySales
		,		ROUND(( f.SurgerySales - f.BudgetSurgerySales ), 0) AS 'SurgerySalesVariance'
		,		ROUND(f.BudgetRestorInkCount, 0) AS 'BudgetRestorInkCount'
		,		f.NetMDPCount AS 'RestorInkCount'
		,		ROUND(( f.NetMDPCount - f.BudgetRestorInkCount ), 0) AS 'RestorInkCountVariance'
		,		ROUND(f.BudgetRestorInkSales, 0) AS 'BudgetRestorInkSales'
		,		f.NetMDPSales AS 'RestorInkSales'
		,		ROUND(( f.NetMDPSales - f.BudgetRestorInkSales ), 0) AS 'RestorInkSalesVariance'
		,		ROUND(f.BudgetApplications, 0) AS 'BudgetApplicationsCount'
		,		f.NB1Applications AS 'ApplicationsCount'
		,		ROUND(( f.NB1Applications - f.BudgetApplications ), 0) AS 'ApplicationsCountVariance'
		,		ROUND(f.BudgetConversions, 0) AS 'BudgetConversionsCount'
		,		f.TotalConversions AS 'ConversionsCount'
		,		ROUND(( f.TotalConversions - f.BudgetConversions ), 0) AS 'ConversionsCountVariance'
		,		ROUND(f.BudgetRecurringSales, 0) AS 'BudgetNetPCPSales'
		,		f.NetPCPSales
		,		ROUND(( f.NetPCPSales - f.BudgetRecurringSales ), 0) AS 'NetPCPSalesVariance'
		,		ROUND(f.BudgetLaserSales, 0) AS 'BudgetLaserSales'
		,		f.NetLaserSales AS 'LaserSales'
		,		ROUND(( f.NetLaserSales - f.BudgetLaserSales ), 0) AS 'LaserSalesVariance'
		,		ROUND(f.BudgetNonProgramSales, 0) AS 'BudgetNonProgramSales'
		,		f.NetNB2Sales AS 'NonProgramSales'
		,		ROUND(( f.NetNB2Sales - f.BudgetNonProgramSales ), 0) AS 'NonProgramSalesVariance'
		,		ROUND(f.BudgetServiceSales, 0) AS 'BudgetServiceSales'
		,		f.ServiceSales
		,		ROUND(( f.ServiceSales - f.BudgetServiceSales ), 0) AS 'ServiceSalesVariance'
		,		ROUND(f.BudgetRetailSales, 0) AS 'BudgetRetailSales'
		,		f.RetailSales
		,		ROUND(( f.RetailSales - f.BudgetRetailSales ), 0) AS 'RetailSalesVariance'
		,		f.Receivables
		,		f.ReceivablesClientCount
		,		f.NBCancels
		,		f.PCPCancels
		,		f.TotalCancels
		FROM	#Final f

END
GO
