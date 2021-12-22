/* CreateDate: 03/18/2021 14:32:22.940 , ModifyDate: 03/23/2021 12:42:51.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_PopulateDailyFlashDetail
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

EXEC spSvc_PopulateDailyFlashDetail 'C'
EXEC spSvc_PopulateDailyFlashDetail 'F'
***********************************************************************/
CREATE PROCEDURE [dbo].spSvc_PopulateDailyFlashDetail
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


/********************************** Create temp table objects *************************************/
CREATE TABLE #Date (
	DateKey INT
,	FullDate DATETIME
,	YearNumber INT
,	MonthNumber INT
,	MonthName CHAR(10)
,	DayOfMonth INT
,	DayOfWeekName NVARCHAR(50)
,	FirstDateOfMonth DATETIME
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
,	NetNB1Sales INT
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
	FullDate DATETIME
,	DayOfWeekName NVARCHAR(50)
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

CREATE TABLE #DailyBudget (
	FullDate DATETIME
,	DayOfWeekName NVARCHAR(50)
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
)


/********************************** Get Date data *************************************/
INSERT	INTO #Date
		SELECT	dd.DateKey
		,		dd.FullDate
		,		dd.YearNumber
		,		dd.MonthNumber
		,		dd.MonthName
		,		dd.DayOfMonth
		,		dd.DayOfWeekName
		,		dd.FirstDateOfMonth
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate dd
		WHERE	dd.FullDate BETWEEN @CurrentMonthStart AND @YesterdayEnd


CREATE NONCLUSTERED INDEX IDX_Date_DateKey ON #Date ( DateKey );
CREATE NONCLUSTERED INDEX IDX_Date_FullDate ON #Date ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Date_FirstDateOfMonth ON #Date ( FirstDateOfMonth );


UPDATE STATISTICS #Date;


SELECT	@MinDate = MIN(d.FullDate)
,		@MaxDate = MAX(d.FullDate)
FROM	#Date d


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
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
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
		SELECT  d.FullDate
		,		d.DayOfWeekName
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10155) AS 'BudgetLeads'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10100) AS 'BudgetAppointments'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10110) AS 'BudgetConsultations'
		,		(SELECT ( ISNULL(SUM(b.Value), 0) * 1.10 ) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10125) AS 'BudgetGrossNB1Count'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10125) AS 'BudgetNB1Count'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10305, 10310, 10315, 10325, 10306, 10891, 10320, 10321, 10552 )) AS 'BudgetNB1Sales'
		,		NULL AS 'BudgetNB1DollarPerSale'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10230) AS 'BudgetXtrandsPlusInitialCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10305, 10310 )) AS 'BudgetXtrandsPlusInitialSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10430) AS 'BudgetXtrandsPlusInitialConversionCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10206) AS 'BudgetXtrandsCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10306) AS 'BudgetXtrandsSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10433) AS 'BudgetXtrandsConversionCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10215, 10225 )) AS 'BudgetEXTCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10315, 10325 )) AS 'BudgetEXTSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10435) AS 'BudgetEXTConversionCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10220, 10221 )) AS 'BudgetSurgeryCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10320, 10321 )) AS 'BudgetSurgerySales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10901) AS 'BudgetRestorInkCount'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10891) AS 'BudgetRestorInkSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10240) AS 'BudgetApplications'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10430, 10433, 10435 )) AS 'BudgetConversions'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10536) AS 'BudgetRecurringSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID IN ( 10551, 10552 )) AS 'BudgetLaserSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10540) AS 'BudgetNonProgramSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10575) AS 'BudgetServiceSales'
		,		(SELECT ISNULL(SUM(b.Value), 0) FROM #Budget b WHERE b.FullDate = d.FullDate AND b.AccountID = 10555) AS 'BudgetRetailSales'
		,		(SELECT ISNULL(SUM(NB1Applications), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NB1Applications'
		,		(SELECT ISNULL(SUM(GrossNB1Count), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'GrossNB1Count'
		,		(SELECT ISNULL(SUM(NetNB1Count), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetNB1Count'
		,		(SELECT ISNULL(SUM(NetNB1Sales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetNB1Sales'
		,		(SELECT dbo.DIVIDE_DECIMAL(ISNULL(SUM(NetNB1Sales), 0), ISNULL(SUM(NetNB1Count), 0)) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetNB1Sales'
		,		(SELECT ISNULL(SUM(NetTradCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetTradCount'
		,		(SELECT ISNULL(SUM(NetTradSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetTradSales'
		,		(SELECT ISNULL(SUM(NetGradCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetGradCount'
		,		(SELECT ISNULL(SUM(NetGradSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetGradSales'
		,		(SELECT ISNULL(SUM(NetEXTCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetEXTCount'
		,		(SELECT ISNULL(SUM(NetEXTSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetEXTSales'
		,		(SELECT ISNULL(SUM(NetXtrCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetXtrCount'
		,		(SELECT ISNULL(SUM(NetXtrSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetXtrSales'
		,		(SELECT ISNULL(SUM(SurgeryCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'SurgeryCount'
		,		(SELECT ISNULL(SUM(SurgerySales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'SurgerySales'
		,		(SELECT ISNULL(SUM(PostEXTCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'PostEXTCount'
		,		(SELECT ISNULL(SUM(PostEXTSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'PostEXTSales'
		,		(SELECT ISNULL(SUM(NetMDPCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetMDPCount'
		,		(SELECT ISNULL(SUM(NetMDPSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetMDPSales'
		,		(SELECT ISNULL(SUM(NetLaserCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetLaserCount'
		,		(SELECT ISNULL(SUM(NetLaserSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetLaserSales'
		,		(SELECT ISNULL(SUM(NetNBLaserCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetNBLaserCount'
		,		(SELECT ISNULL(SUM(NetNBLaserSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetNBLaserSales'
		,		(SELECT ISNULL(SUM(NetPCPLaserCount), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetPCPLaserCount'
		,		(SELECT ISNULL(SUM(NetPCPLaserSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetPCPLaserSales'
		,		(SELECT ISNULL(SUM(PCPSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'PCPSales'
		,		(SELECT ISNULL(SUM(NetPCPSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetPCPSales'
		,		(SELECT ISNULL(SUM(NetNB2Sales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NetNB2Sales'
		,		(SELECT ISNULL(SUM(ServiceSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'ServiceSales'
		,		(SELECT ISNULL(SUM(RetailSales), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'RetailSales'
		,		(SELECT ISNULL(SUM(BIOConversions), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'BIOConversions'
		,		(SELECT ISNULL(SUM(EXTConversions), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'EXTConversions'
		,		(SELECT ISNULL(SUM(XTRConversions), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'XTRConversions'
		,		(SELECT ISNULL(SUM(TotalConversions), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'TotalConversions'
		,		(SELECT ISNULL(SUM(NBCancels), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'NBCancels'
		,		(SELECT ISNULL(SUM(PCPCancels), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'PCPCancels'
		,		(SELECT ISNULL(SUM(TotalCancels), 0) FROM #Sales s WHERE s.FullDate = d.FullDate) AS 'TotalCancels'
		,		(SELECT ISNULL(SUM(Leads), 0) FROM #Lead l WHERE l.FullDate = d.FullDate) AS 'Leads'
		,		(SELECT ISNULL(SUM(Appointments), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'Appointments'
		,		(SELECT ISNULL(SUM(Consultations), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'Consultations'
		,		(SELECT ISNULL(SUM(a.InPersonConsultations), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'InPersonConsultations'
		,		(SELECT ISNULL(SUM(a.VirtualConsultations), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'VirtualConsultations'
		,		(SELECT ISNULL(SUM(BeBacks), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'BeBacks'
		,		(SELECT ISNULL(SUM(a.BeBacksToExclude), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'BeBacksToExclude'
		,		(SELECT ISNULL(SUM(Shows), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'Shows'
		,		(SELECT ISNULL(SUM(Sales), 0) FROM #Activity a WHERE a.FullDate = d.FullDate) AS 'Sales'
		FROM    #Date d


CREATE NONCLUSTERED INDEX IDX_Final_FullDate ON #Final ( FullDate );


UPDATE STATISTICS #Final;


/********************************** Get NB1 $/Sale Budget Value *************************************/
SET @BudgetNBDollarsPerSale = (SELECT dbo.DIVIDE_DECIMAL(SUM(f.BudgetNetNB1Sales), SUM(f.BudgetNetNB1Count)) FROM #Final f)


/********************************** Calculate Daily Budgets *************************************/
INSERT	INTO #DailyBudget
		SELECT	d.FullDate
		,		d.DayOfWeekName
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetLeads, @DaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetLeads'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetAppointments, @DaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetAppointments'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetConsultations, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetConsultations'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetGrossNB1Count, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetGrossNB1Count'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetNetNB1Count, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetNetNB1Count'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetNetNB1Sales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetNetNB1Sales'
		,		@BudgetNBDollarsPerSale AS 'BudgetNBDollarsPerSale'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetXtrandsPlusInitialCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetXtrandsPlusInitialCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetXtrandsPlusInitialSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetXtrandsPlusInitialSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetXtrandsPlusInitialConversionCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetXtrandsPlusInitialConversionCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetXtrandsCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetXtrandsCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetXtrandsSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetXtrandsSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetXtrandsConversionCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetXtrandsConversionCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetEXTCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetEXTCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetEXTSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetEXTSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetEXTConversionCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetEXTConversionCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetSurgeryCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetSurgeryCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetSurgerySales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetSurgerySales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetRestorInkCount, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetRestorInkCount'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetRestorInkSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetRestorInkSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetApplications, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetApplications'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetConversions, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetConversions'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetRecurringSales, @DaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetRecurringSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetLaserSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetLaserSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetNonProgramSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetNonProgramSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetServiceSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetServiceSales'
		,		(SELECT dbo.DIVIDE_DECIMAL(f.BudgetRetailSales, @WorkingDaysInMonth) FROM #Final f WHERE f.FullDate = @CurrentMonthStart) AS 'BudgetRetailSales'
		FROM	#Date d


CREATE NONCLUSTERED INDEX IDX_DailyBudget_FullDate ON #DailyBudget ( FullDate );
CREATE NONCLUSTERED INDEX IDX_DailyBudget_DayOfWeekName ON #DailyBudget ( DayOfWeekName );


UPDATE STATISTICS #DailyBudget;


/********************************** Update Daily Budgets associated with Working Days to Zero for NON-WORKING Days *************************************/
UPDATE	db
SET		db.BudgetConsultations = 0
,		db.BudgetGrossNB1Count = 0
,		db.BudgetNetNB1Count = 0
,		db.BudgetNetNB1Sales = 0
,		db.BudgetNB1DollarPerSale = 0
,		db.BudgetXtrandsPlusInitialCount = 0
,		db.BudgetXtrandsPlusInitialSales = 0
,		db.BudgetXtrandsPlusInitialConversionCount = 0
,		db.BudgetXtrandsCount = 0
,		db.BudgetXtrandsSales = 0
,		db.BudgetXtrandsConversionCount = 0
,		db.BudgetEXTCount = 0
,		db.BudgetEXTSales = 0
,		db.BudgetEXTConversionCount = 0
,		db.BudgetSurgeryCount = 0
,		db.BudgetSurgerySales = 0
,		db.BudgetRestorInkCount = 0
,		db.BudgetRestorInkSales = 0
,		db.BudgetApplications = 0
,		db.BudgetConversions = 0
,		db.BudgetRecurringSales = 0
,		db.BudgetLaserSales = 0
,		db.BudgetNonProgramSales = 0
,		db.BudgetServiceSales = 0
,		db.BudgetRetailSales = 0
FROM	#DailyBudget db
WHERE	db.DayOfWeekName IN ( 'Sunday', 'Monday' )


/********************************** Now that we have the Daily Budgets calculated, update the final dataset *************************************/
UPDATE	f
SET		f.BudgetLeads = db.BudgetLeads
,		f.BudgetAppointments = db.BudgetAppointments
,		f.BudgetConsultations = db.BudgetConsultations
,		f.BudgetGrossNB1Count = db.BudgetGrossNB1Count
,		f.BudgetNetNB1Count = db.BudgetNetNB1Count
,		f.BudgetNetNB1Sales = db.BudgetNetNB1Sales
,		f.BudgetNB1DollarPerSale = db.BudgetNB1DollarPerSale
,		f.BudgetXtrandsPlusInitialCount = db.BudgetXtrandsPlusInitialCount
,		f.BudgetXtrandsPlusInitialSales = db.BudgetXtrandsPlusInitialSales
,		f.BudgetXtrandsPlusInitialConversionCount = db.BudgetXtrandsPlusInitialConversionCount
,		f.BudgetXtrandsCount = db.BudgetXtrandsCount
,		f.BudgetXtrandsSales = db.BudgetXtrandsSales
,		f.BudgetXtrandsConversionCount = db.BudgetXtrandsConversionCount
,		f.BudgetEXTCount = db.BudgetEXTCount
,		f.BudgetEXTSales = db.BudgetEXTSales
,		f.BudgetEXTConversionCount = db.BudgetEXTConversionCount
,		f.BudgetSurgeryCount = db.BudgetSurgeryCount
,		f.BudgetSurgerySales = db.BudgetSurgerySales
,		f.BudgetRestorInkCount = db.BudgetRestorInkCount
,		f.BudgetRestorInkSales = db.BudgetRestorInkSales
,		f.BudgetApplications = db.BudgetApplications
,		f.BudgetConversions = db.BudgetConversions
,		f.BudgetRecurringSales = db.BudgetRecurringSales
,		f.BudgetLaserSales = db.BudgetLaserSales
,		f.BudgetNonProgramSales = db.BudgetNonProgramSales
,		f.BudgetServiceSales = db.BudgetServiceSales
,		f.BudgetRetailSales = db.BudgetRetailSales
FROM	#Final f
		INNER JOIN #DailyBudget db
			ON db.FullDate = f.FullDate


/********************************** Save Final Data *************************************/
TRUNCATE TABLE datDailyFlashDetail


INSERT	INTO datDailyFlashDetail
		SELECT	f.FullDate
		,		f.DayOfWeekName
		,		ROUND(f.BudgetLeads, 0) AS 'BudgetLeads'
		,		f.Leads
		,		ROUND(f.BudgetAppointments, 0) AS 'BudgetAppointments'
		,		f.Appointments
		,		ROUND(f.BudgetConsultations, 0) AS 'BudgetConsultations'
		,		f.Consultations
		,		f.InPersonConsultations
		,		f.VirtualConsultations
		,		ROUND(f.BudgetGrossNB1Count, 0) AS 'BudgetGrossNB1Count'
		,		f.GrossNB1Count
		,		ROUND(f.BudgetNetNB1Count, 0) AS 'BudgetNetNB1Count'
		,		f.NetNB1Count
		,		ROUND(f.BudgetNetNB1Sales, 0) AS 'BudgetNetNB1Sales'
		,		f.NetNB1Sales
		,		ROUND(f.BudgetNB1DollarPerSale, 0) AS 'BudgetNB1DollarPerSale'
		,		f.NB1DollarPerSale
		,		ROUND(( f.NB1DollarPerSale - f.BudgetNB1DollarPerSale ), 0) AS 'NB1DollarPerSaleVariance'
		,		ROUND(f.BudgetXtrandsPlusInitialCount, 0) AS 'BudgetXtrandsPlusCount'
		,		( f.NetTradCount + f.NetGradCount ) AS 'XtrandsPlusCount'
		,		ROUND(f.BudgetXtrandsPlusInitialSales, 0) AS 'BudgetXtrandsPlusSales'
		,		( f.NetTradSales + f.NetGradSales ) AS 'XtrandsPlusSales'
		,		ROUND(f.BudgetXtrandsPlusInitialConversionCount, 0) AS 'BudgetXtrandsPlusConversionsCount'
		,		f.BIOConversions AS 'XtrandsPlusConversionsCount'
		,		ROUND(f.BudgetXtrandsCount, 0) AS 'BudgetXtrandsCount'
		,		f.NetXtrCount AS 'XtrandsCount'
		,		ROUND(f.BudgetXtrandsSales, 0) AS 'BudgetXtrandsSales'
		,		f.NetXtrSales AS 'XtrandsSales'
		,		ROUND(f.BudgetXtrandsConversionCount, 0) AS 'BudgetXtrandsConversionCount'
		,		f.XTRConversions AS 'XtrandsConversionsCount'
		,		ROUND(f.BudgetEXTCount, 0) AS 'BudgetEXTCount'
		,		( f.NetEXTCount + f.PostEXTCount ) AS 'EXTCount'
		,		ROUND(f.BudgetEXTSales, 0) AS 'BudgetEXTSales'
		,		( f.NetEXTSales + f.PostEXTSales ) AS 'EXTSales'
		,		ROUND(f.BudgetEXTConversionCount, 0) AS 'BudgetEXTConversionCount'
		,		f.EXTConversions AS 'EXTConversionsCount'
		,		ROUND(f.BudgetSurgeryCount, 0) AS 'BudgetSurgeryCount'
		,		f.SurgeryCount
		,		ROUND(f.BudgetSurgerySales, 0) AS 'BudgetSurgerySales'
		,		f.SurgerySales
		,		ROUND(f.BudgetRestorInkCount, 0) AS 'BudgetRestorInkCount'
		,		f.NetMDPCount AS 'RestorInkCount'
		,		ROUND(f.BudgetRestorInkSales, 0) AS 'BudgetRestorInkSales'
		,		f.NetMDPSales AS 'RestorInkSales'
		,		ROUND(f.BudgetApplications, 0) AS 'BudgetApplicationsCount'
		,		f.NB1Applications AS 'ApplicationsCount'
		,		ROUND(f.BudgetConversions, 0) AS 'BudgetConversionsCount'
		,		f.TotalConversions AS 'ConversionsCount'
		,		ROUND(f.BudgetRecurringSales, 0) AS 'BudgetNetPCPSales'
		,		f.NetPCPSales
		,		ROUND(f.BudgetLaserSales, 0) AS 'BudgetLaserSales'
		,		f.NetLaserSales AS 'LaserSales'
		,		ROUND(f.BudgetNonProgramSales, 0) AS 'BudgetNonProgramSales'
		,		f.NetNB2Sales AS 'NonProgramSales'
		,		ROUND(f.BudgetServiceSales, 0) AS 'BudgetServiceSales'
		,		f.ServiceSales
		,		ROUND(f.BudgetRetailSales, 0) AS 'BudgetRetailSales'
		,		f.RetailSales
		,		f.NBCancels
		,		f.PCPCancels
		,		f.TotalCancels
		FROM	#Final f

END
GO
