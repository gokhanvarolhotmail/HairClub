/* CreateDate: 04/26/2021 10:06:20.847 , ModifyDate: 05/14/2021 14:12:28.950 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_PopulateSpiderImpactData
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/26/2021
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_PopulateSpiderImpactData 2021
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_PopulateSpiderImpactData]
(
	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CenterType INT
,		@CurrentDate DATETIME
,		@Yesterday DATETIME
,		@CurrentMonthStartDate DATETIME
,		@CurrentMonthEndDate DATETIME
,		@PreviousMonthStartDate DATETIME
,		@PreviousMonthEndDate DATETIME
,		@CurrentYearStartDate DATETIME
,		@CurrentYearEndDate DATETIME
,		@NextYearStartDate DATETIME
,		@NextYearEndDate DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @CenterType = 2


SET @CurrentDate = DATETIMEFROMPARTS(@Year, MONTH(CURRENT_TIMESTAMP), DAY(CURRENT_TIMESTAMP), 0, 0, 0, 0)
SET @Yesterday = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, @CurrentDate), 101))
SET @CurrentMonthStartDate = DATEADD(DAY, 0, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Yesterday), 0))
SET @CurrentMonthEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Yesterday) +1, 0))
SET @PreviousMonthStartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Yesterday), 0))
SET @PreviousMonthEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @Yesterday)) +1, 0))
SET @CurrentYearStartDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, @Yesterday), 0)
SET @CurrentYearEndDate = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @Yesterday), 0)))
SET @NextYearStartDate = DATEADD(YEAR, 1, @CurrentYearStartDate)
SET @NextYearEndDate = DATEADD(YEAR, 1, @CurrentYearEndDate)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	AreaDescription NVARCHAR(100)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	CenterType NVARCHAR(50)
,	SortOrder VARCHAR(10)
)

CREATE TABLE #CenterArea (
	AreaDescription NVARCHAR(100)
,	SortOrder VARCHAR(10)
)

CREATE TABLE #DailyDate (
	FullDate DATETIME
,	PeriodStartDate DATETIME
,	PeriodEndDate DATETIME
,	MonthNumber INT
,	DayOfMonth INT
,	DayOfWeekName NVARCHAR(50)
,	IsWorkDay BIT
,	IsFirstDayOfMonth BIT
,	DaysInMonth INT
,	WorkDaysInMonth INT
)

CREATE TABLE #MonthlyDate (
	FullDate DATETIME
,	PeriodStartDate DATETIME
,	PeriodEndDate DATETIME
,	DaysInMonth INT
,	WorkDaysInMonth INT
)

CREATE TABLE #CenterDate (
	CenterKey INT
,	CenterNumber INT
,	FullDate DATETIME
,	PeriodStartDate DATETIME
,	PeriodEndDate DATETIME
,	MonthNumber INT
,	DayOfMonth INT
,	DayOfWeekName NVARCHAR(50)
,	IsWorkDay BIT
,	IsFirstDayOfMonth BIT
,	DaysInMonth INT
,	WorkDaysInMonth INT
)

CREATE TABLE #CenterMeasure (
	CenterKey INT
,	CenterDescription VARCHAR(80)
,	MeasureID INT
,	CenterMeasureID INT
,	ExcludeFromVirtualFlag BIT
,	Measure NVARCHAR(80)
,	AccountID INT
,	MeasureType NVARCHAR(50)
,	MeasureThresholdType NVARCHAR(50)
,	HasThreshold1Flag BIT
,	Threshold1Calculation DECIMAL(18, 2)
,	HasThreshold2Flag BIT
,	Threshold2Calculation DECIMAL(18, 2)
,	HasThreshold3Flag BIT
,	Threshold3Calculation DECIMAL(18, 2)
,	HasThreshold4Flag BIT
,	Threshold4Calculation DECIMAL(18, 2)
)

CREATE TABLE #Budget (
	FullDate DATETIME
,	CenterKey INT
,	AccountID INT
,	AccountDescription NVARCHAR(255)
,	MonthlyBudget REAL
,	DaysInMonthBudget REAL
,	WorkDaysInMonthBudget REAL
)

CREATE TABLE #Lead (
	FullDate DATETIME
,	CenterKey INT
,	Leads REAL
)

CREATE TABLE #Task (
	FullDate DATETIME
,	CenterKey INT
,	Id NVARCHAR(18)
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	Accomodation NVARCHAR(50)
,	ExcludeFromConsults INT
,	ExcludeFromBeBacks INT
,	BeBacksToExclude INT
)

CREATE TABLE #Appointment (
	FullDate DATETIME
,	CenterKey INT
,	Appointments INT
)

CREATE TABLE #Consultation (
	FullDate DATETIME
,	CenterKey INT
,	Consultations INT
,	InPersonConsultations INT
,	VirtualConsultations INT
,	BeBacksToExclude INT
)

CREATE TABLE #ClientCount (
	FullDate DATETIME
,	CenterKey INT
,	AccountID INT
,	ClientCount INT
)

CREATE TABLE #Receivables (
	FullDate DATETIME
,	CenterKey INT
,	ReceivablesBalance REAL
,	ClientCount INT
)

CREATE TABLE #Sales (
	FullDate DATETIME
,	CenterKey INT
,	NewStyleDays INT
,	GrossNBCount INT
,	NBCount INT
,	NBSales DECIMAL(18, 4)
,	ClosingPercentage DECIMAL(18, 4)
,	NBXtrandsPlusCount INT
,	NBXtrandsPlusSales DECIMAL(18, 4)
,	NBEXTCount INT
,	NBEXTSales DECIMAL(18, 4)
,	NBXtrandsCount INT
,	NBXtrandsSales DECIMAL(18, 4)
,	SurgeryCount INT
,	SurgerySales DECIMAL(18, 4)
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18, 4)
,	PRPCount INT
,	PRPSales DECIMAL(18, 4)
,	RestorInkCount INT
,	RestorInkSales DECIMAL(18, 4)
,	PCPXtrandsPlusSales DECIMAL(18, 4)
,	PCPEXTSales DECIMAL(18, 4)
,	PCPXtrandSales DECIMAL(18, 4)
,	NonProgamSales DECIMAL(18, 4)
,	ServiceSales DECIMAL(18, 4)
,	XtrandsPlusConversions INT
,	EXTConversions INT
,	XtrandsConversions INT
,	XTRPCancels INT
,	EXTCancels INT
,	XTRCancels INT
,	NBCancels INT
,	PCPCancels INT
,	Upgrades INT
,	Downgrades INT
,	ExtensionServicesSales DECIMAL(18, 4)
,	NBLaserSales DECIMAL(18, 4)
,	PCPLaserSales DECIMAL(18, 4)
)

CREATE TABLE #RetailSales (
	FullDate DATETIME
,	CenterKey INT
,	RetailSales DECIMAL(18, 4)
,	SPADeviceSales DECIMAL(18, 4)
,	HaloSales DECIMAL(18, 4)
,	ExtensionSales DECIMAL(18, 4)
)

CREATE TABLE #WigSales (
	FullDate DATETIME
,	CenterKey INT
,	WigSales DECIMAL(18, 4)
)

CREATE TABLE #ScorecardData (
	OrganizationKey INT
,	Organization NVARCHAR(80)
,	MeasureID INT
,	CenterMeasureID INT
,	ExcludeFromVirtualFlag BIT
,	Measure NVARCHAR(80)
,	AccountID INT
,	MeasureType NVARCHAR(50)
,	MeasureThresholdType NVARCHAR(50)
,	HasThreshold1Flag BIT
,	Threshold1Calculation DECIMAL(18, 4)
,	HasThreshold2Flag BIT
,	Threshold2Calculation DECIMAL(18, 4)
,	HasThreshold3Flag BIT
,	Threshold3Calculation DECIMAL(18, 4)
,	HasThreshold4Flag BIT
,	Threshold4Calculation DECIMAL(18, 4)
,	Date DATETIME
,	Period DATETIME
,	IsWorkDay BIT
,	Value DECIMAL(18, 4)
,	Threshold1 DECIMAL(18, 4)
,	Threshold2 DECIMAL(18, 4)
,	Threshold3 DECIMAL(18, 4)
,	Threshold4 DECIMAL(18, 4)
)


/********************************** Get list of centers *******************************************/
IF @CenterType = 0 OR @CenterType = 2
	BEGIN
		INSERT  INTO #Center
				SELECT  ISNULL(cma.CenterManagementAreaDescription, '') AS 'AreaDescription'
				,		ctr.CenterKey
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescriptionNumber
				,		ct.CenterTypeDescriptionShort
				,		'' AS 'SortOrder'
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
							ON ct.CenterTypeKey = ctr.CenterTypeKey
						LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
							ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
				WHERE   ct.CenterTypeDescriptionShort = 'C'
						AND ctr.CenterNumber NOT IN ( 100, 103, 396, 901, 902, 903, 904 )
						AND ctr.Active = 'Y'
	END


IF @CenterType = 0 OR @CenterType = 8
	BEGIN
		INSERT  INTO #Center
				SELECT  ISNULL(cma.CenterManagementAreaDescription, '') AS 'AreaDescription'
				,		ctr.CenterKey
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescriptionNumber
				,		ct.CenterTypeDescriptionShort
				,		'' AS 'SortOrder'
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
							ON ct.CenterTypeKey = ctr.CenterTypeKey
						LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
							ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
				WHERE   ct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
						AND ctr.CenterNumber NOT IN ( 104 )
						AND ctr.Active = 'Y'
	END


CREATE NONCLUSTERED INDEX IDX_Center_CenterSSID ON #Center ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


UPDATE STATISTICS #Center;


-- Update Area Description
UPDATE	c
SET		c.AreaDescription = 'Area ' + c.AreaDescription
FROM	#Center c


/********************************** Get list of center areas *******************************************/
INSERT  INTO #CenterArea
		SELECT	'Field Operations' AS 'AreaDescription'
		,		'01' AS 'SortOrder'
		UNION
		SELECT	DISTINCT
				c.AreaDescription
		,		CASE WHEN c.AreaDescription = 'North Region' THEN '02'
					WHEN c.AreaDescription = 'East Region' THEN '03'
					WHEN c.AreaDescription = 'South Region' THEN '04'
					WHEN c.AreaDescription = 'West Region' THEN '05'
					WHEN c.AreaDescription = 'Virtual Region' THEN '06'
				END AS "SortOrder"
		FROM	#Center c


CREATE NONCLUSTERED INDEX IDX_CenterArea_AreaDescription ON #CenterArea ( AreaDescription );


UPDATE STATISTICS #CenterArea;


UPDATE	c
SET		c.SortOrder = ca.SortOrder
FROM	#Center c
		INNER JOIN #CenterArea ca
			ON ca.AreaDescription = c.AreaDescription


/********************************** Get Daily Dates data *************************************/
INSERT	INTO #DailyDate
		SELECT	d.FullDate
		,		d.FirstDateOfMonth AS 'PeriodStartDate'
		,		d.LastDateOfMonth AS 'PeriodEndDate'
		,		d.MonthNumber
		,		d.DayOfMonth
		,		d.DayOfWeekName
		,		CASE WHEN d.DayOfWeekName NOT IN ( 'Sunday', 'Monday' ) THEN 1 ELSE 0 END AS 'IsWorkDay'
		,		CASE WHEN d.FullDate = d.FirstDateOfMonth THEN 1 ELSE 0 END AS 'IsFirstDayOfMonth'
		,		DAY(EOMONTH(d.FirstDateOfMonth)) AS 'DaysInMonth'
		,		x_Wd.WorkDaysInMonth AS 'WorkDaysInMonth'
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate d
				CROSS APPLY (
					SELECT	COUNT(dd.FullDate) AS 'WorkDaysInMonth'
					FROM	HC_BI_ENT_DDS.bief_dds.DimDate dd
					WHERE	dd.FullDate BETWEEN d.FirstDateOfMonth AND d.LastDateOfMonth
							AND dd.DayOfWeekName NOT IN ( 'Sunday', 'Monday' )
				) x_Wd
		WHERE	d.FullDate BETWEEN @CurrentYearStartDate AND @Yesterday
		ORDER BY d.FullDate


SELECT	@MinDate = CAST(MIN(d.FullDate) AS DATE)
,		@MaxDate = CAST(MAX(d.FullDate) AS DATE)
FROM	#DailyDate d


CREATE NONCLUSTERED INDEX IDX_DailyDate_FullDate ON #DailyDate ( FullDate );
CREATE NONCLUSTERED INDEX IDX_DailyDate_PeriodStartDate ON #DailyDate ( PeriodStartDate );
CREATE NONCLUSTERED INDEX IDX_DailyDate_DayOfWeekName ON #DailyDate ( DayOfWeekName );
CREATE NONCLUSTERED INDEX IDX_DailyDate_IsWorkDay ON #DailyDate ( IsWorkDay );


UPDATE STATISTICS #DailyDate;


/********************************** Get Monthly Dates data *************************************/
INSERT	INTO #MonthlyDate
		SELECT	d.PeriodStartDate
		,		d.PeriodStartDate
		,		d.PeriodEndDate
		,		d.DaysInMonth
		,		d.WorkDaysInMonth
		FROM	#DailyDate d
		GROUP BY d.PeriodStartDate
		,		d.PeriodEndDate
		,		d.DaysInMonth
		,		d.WorkDaysInMonth
		ORDER BY d.PeriodStartDate


CREATE NONCLUSTERED INDEX IDX_MonthlyDate_FullDate ON #MonthlyDate ( FullDate );


UPDATE STATISTICS #MonthlyDate;


/********************************** Get Center Dates data *************************************/
INSERT	INTO #CenterDate
		SELECT	c.CenterKey
		,		c.CenterNumber
		,		dd.FullDate
		,		dd.PeriodStartDate
		,		dd.PeriodEndDate
		,		dd.MonthNumber
		,		dd.DayOfMonth
		,		dd.DayOfWeekName
		,		dd.IsWorkDay
		,		dd.IsFirstDayOfMonth
		,		dd.DaysInMonth
		,		dd.WorkDaysInMonth
		FROM	#DailyDate dd
		,		#Center c


CREATE NONCLUSTERED INDEX IDX_CenterDate_CenterKey ON #CenterDate ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_CenterDate_CenterNumber ON #CenterDate ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_CenterDate_FullDate ON #CenterDate ( FullDate );
CREATE NONCLUSTERED INDEX IDX_CenterDate_PeriodStartDate ON #CenterDate ( PeriodStartDate );
CREATE NONCLUSTERED INDEX IDX_CenterDate_DayOfWeekName ON #CenterDate ( DayOfWeekName );
CREATE NONCLUSTERED INDEX IDX_CenterDate_IsWorkDay ON #CenterDate ( IsWorkDay );
CREATE NONCLUSTERED INDEX IDX_CenterDate_IsFirstDayOfMonth ON #CenterDate ( IsFirstDayOfMonth );


UPDATE STATISTICS #CenterDate;


/********************************** Get Scorecard Center Measures *************************************/
INSERT	INTO #CenterMeasure
		SELECT	c.CenterKey
		,		scm.Organization AS 'CenterDescription'
		,		scm.MeasureID
		,		scm.CenterMeasureID
		,		sm.ExcludeFromVirtualFlag
		,		scm.Measure
		,		sm.AccountID
		,		sm.MeasureType
		,		sm.MeasureThresholdType
		,		sm.HasThreshold1Flag
		,		sm.Threshold1Calculation
		,		sm.HasThreshold2Flag
		,		sm.Threshold2Calculation
		,		sm.HasThreshold3Flag
		,		sm.Threshold3Calculation
		,		sm.HasThreshold4Flag
		,		sm.Threshold4Calculation
		FROM	HC_BI_Reporting.dbo.datScorecardCenterMeasures scm
				INNER JOIN HC_BI_Reporting.dbo.datScorecardMeasures sm
					ON sm.MeasureID = scm.MeasureID
				INNER JOIN #Center c
					ON c.CenterDescription = scm.Organization
		WHERE	scm.Organization NOT IN ( 'Dashboards', 'Support Center' )
				AND ISNULL(sm.IncludeInDailyImportFlag, 0) = 1
		ORDER BY scm.Organization


CREATE NONCLUSTERED INDEX IDX_CenterMeasure_CenterKey ON #CenterMeasure ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_CenterMeasure_MeasureID ON #CenterMeasure ( MeasureID );
CREATE NONCLUSTERED INDEX IDX_CenterMeasure_CenterMeasureID ON #CenterMeasure ( CenterMeasureID );


UPDATE STATISTICS #CenterMeasure;


/********************************** Get Budget Data *************************************/
INSERT	INTO #Budget
		SELECT	d.FullDate
		,		c.CenterKey
		,		a.AccountID
		,		a.AccountDescription
		,		fa.Budget AS 'MonthlyBudget'
		,		NULL AS 'DaysInMonthBudget'
		,		NULL AS 'WorkDaysInMonthBudget'
		FROM	HC_Accounting.dbo.FactAccounting fa
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount a
					ON a.AccountID = fa.AccountID
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = fa.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterNumber = fa.CenterID
				INNER JOIN #Center c
					ON c.CenterSSID = ctr.CenterSSID
		WHERE	d.FirstDateOfMonth BETWEEN @MinDate AND @MaxDate
				AND a.AccountID IN ( 3015, 10100, 10125, 10155, 10206, 10215, 10220, 10221, 10225, 10230, 10240, 10305, 10306, 10310, 10315, 10320, 10321, 10325, 10400, 10401, 10405, 10430, 10433
								, 10435, 10531, 10532, 10535, 10551, 10552, 10891, 10893, 10894, 10895, 10896, 10897, 10898, 10899, 10901 )


CREATE NONCLUSTERED INDEX IDX_Budget_CenterKey ON #Budget ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_Budget_AccountID ON #Budget ( AccountID );
CREATE NONCLUSTERED INDEX IDX_Budget_FullDate ON #Budget ( FullDate );


UPDATE STATISTICS #Budget;


UPDATE	b
SET		b.DaysInMonthBudget = HC_BI_Reporting.dbo.DIVIDE_DECIMAL(b.MonthlyBudget, d.DaysInMonth)
,		b.WorkDaysInMonthBudget = HC_BI_Reporting.dbo.DIVIDE_DECIMAL(b.MonthlyBudget, d.WorkDaysInMonth)
FROM	#Budget b
		INNER JOIN #DailyDate d
			ON d.FullDate = b.FullDate


/********************************** Get Lead data *************************************/
INSERT	INTO #Lead
		SELECT	CAST(l.ReportCreateDate__c AS DATE) AS 'FullDate'
		,		c.CenterKey
		,		COUNT(l.Id) AS 'Leads'
		FROM	HC_BI_SFDC.dbo.Lead l
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(ISNULL(l.CenterID__c, l.CenterNumber__c), 100)
				OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
		WHERE	l.Status IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
				AND CAST(l.ReportCreateDate__c AS DATE) BETWEEN @MinDate AND @MaxDate
				AND ISNULL(l.IsDeleted, 0) = 0
				AND ISNULL(fil.IsInvalidLead, 0) = 0
		GROUP BY CAST(l.ReportCreateDate__c AS DATE)
		,		c.CenterKey


INSERT	INTO #Lead
		SELECT	cd.FullDate
		,		cd.CenterKey
		,		0 AS 'Leads'
		FROM	#CenterDate cd
				LEFT OUTER JOIN #Lead l
					ON l.CenterKey = cd.CenterKey
					AND l.FullDate = cd.FullDate
		WHERE	l.CenterKey IS NULL


CREATE NONCLUSTERED INDEX IDX_Lead_CenterKey ON #Lead ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_Lead_FullDate ON #Lead ( FullDate );


UPDATE STATISTICS #Lead;


/********************************** Get Task data *************************************/
INSERT	INTO #Task
		SELECT	CAST(t.ActivityDate AS DATE) AS 'FullDate'
		,		c.CenterKey
		,		t.Id
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
					ON c.CenterNumber = ISNULL(ISNULL(t.CenterID__c, t.CenterNumber__c), 100)
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = t.WhoId
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a
					ON a.PersonContactId = t.WhoId
		WHERE	LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
				AND CAST(t.ActivityDate AS DATE) BETWEEN @MinDate AND @MaxDate
				AND ISNULL(t.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Task_FullDate ON #Task ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Task_CenterKey ON #Task ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_Task_Action__c ON #Task ( Action__c );
CREATE NONCLUSTERED INDEX IDX_Task_Result__c ON #Task ( Result__c );


UPDATE STATISTICS #Task;


/********************************** Get Appointment data *************************************/
INSERT	INTO #Appointment
		SELECT	t.FullDate
		,		t.CenterKey
		,		SUM(CASE WHEN t.Action__c IN ( 'Appointment', 'In House', 'Recovery' ) AND ISNULL(t.Result__c, '') NOT IN ( 'Void', 'Cancel', 'Reschedule', 'Center Exception' ) THEN 1 ELSE 0 END) AS 'Appointments'
		FROM	#Task t
		GROUP BY t.FullDate
		,		t.CenterKey


CREATE NONCLUSTERED INDEX IDX_Appointment_FullDate ON #Appointment ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Appointment_CenterKey ON #Appointment ( CenterKey );


UPDATE STATISTICS #Appointment;


/********************************** Get Consultation data *************************************/
INSERT	INTO #Consultation
		SELECT	t.FullDate
		,		t.CenterKey
		,		SUM(CASE WHEN ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1 ELSE 0 END) AS 'Consultations'
		,		SUM(CASE WHEN ISNULL(t.Accomodation, 'In Person Consult') = 'In Person Consult' AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1 ELSE 0 END) AS 'InPersonConsultations'
		,		SUM(CASE WHEN ISNULL(t.Accomodation, 'In Person Consult') <> 'In Person Consult' AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1 ELSE 0 END) AS 'VirtualConsultations'
		,		SUM(CASE WHEN ISNULL(t.BeBacksToExclude, 0) = 1 THEN 1 ELSE 0 END) AS 'BeBacksToExclude'
		FROM	#Task t
		GROUP BY t.FullDate
		,		t.CenterKey


CREATE NONCLUSTERED INDEX IDX_Consultation_FullDate ON #Consultation ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Consultation_CenterKey ON #Consultation ( CenterKey );


UPDATE STATISTICS #Consultation;


/********************************** Get Client Count data *************************************/
INSERT	INTO #ClientCount
		SELECT	DATEADD(MONTH, -1, d.FirstDateOfMonth) AS 'FullDate'
		,		c.CenterKey
		,		fa.AccountID
		,		fa.Flash AS 'ClientCount'
		FROM	HC_Accounting.dbo.FactAccounting fa
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = fa.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterNumber = fa.CenterID
				INNER JOIN #Center c
					ON c.CenterSSID = ctr.CenterSSID
		WHERE	fa.AccountID IN ( 10400, 10401, 10405 )
				AND d.FirstDateOfMonth >= @MinDate
				AND fa.Flash IS NOT NULL
		ORDER BY c.CenterKey
		,		DATEADD(MONTH, -1, d.FirstDateOfMonth)


CREATE NONCLUSTERED INDEX IDX_ClientCount_FullDate ON #ClientCount ( FullDate );
CREATE NONCLUSTERED INDEX IDX_ClientCount_CenterKey ON #ClientCount ( CenterKey );


UPDATE STATISTICS #ClientCount;


/********************************** Get Receivables data *************************************/
INSERT	INTO #Receivables
		SELECT	md.FullDate
		,		c.CenterKey
		,		SUM(fr.Balance) AS 'ReceivablesBalance'
		,		COUNT(DISTINCT fr.ClientKey) AS 'ClientCount'
		FROM    HC_Accounting.dbo.FactReceivables fr
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fr.ClientKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fr.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fr.DateKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN #MonthlyDate md
					ON CASE WHEN md.PeriodEndDate = @CurrentMonthEndDate THEN @Yesterday ELSE md.PeriodEndDate END = dd.FullDate
				CROSS APPLY (
					SELECT	DISTINCT
							cm.ClientKey
					FROM	HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
								ON m.MembershipKey = cm.MembershipKey
					WHERE	( cm.ClientMembershipSSID = clt.CurrentBioMatrixClientMembershipSSID
								OR cm.ClientMembershipSSID = clt.CurrentExtremeTherapyClientMembershipSSID
								OR cm.ClientMembershipSSID = clt.CurrentXtrandsClientMembershipSSID )
							AND m.RevenueGroupSSID = 2
				) x_Cm
		WHERE	fr.Balance > 0
		GROUP BY md.FullDate
		,		c.CenterKey


CREATE NONCLUSTERED INDEX IDX_Receivables_FullDate ON #Receivables ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Receivables_CenterKey ON #Receivables ( CenterKey );


UPDATE STATISTICS #Receivables;


/********************************** Get Sales data *************************************/
INSERT  INTO #Sales
		SELECT	d.FullDate
		,		c.CenterKey
		,		SUM(fst.NB_AppsCnt) AS 'NewStyleDays'
		,		SUM(fst.NB_GrossNB1Cnt) + SUM(fst.NB_MDPCnt) AS 'GrossNBCount'
		,		( SUM(fst.NB_TradCnt) + SUM(fst.NB_GradCnt) + SUM(fst.NB_ExtCnt) + SUM(fst.S_PostExtCnt) + SUM(fst.NB_XTRCnt) + SUM(fst.S_SurCnt) + SUM(fst.NB_MDPCnt) + SUM(fst.S_PRPCnt) ) AS 'NBCount'
		,		( SUM(fst.NB_TradAmt) + SUM(fst.NB_GradAmt) + SUM(fst.NB_ExtAmt) + SUM(fst.S_PostExtAmt) + SUM(fst.NB_XTRAmt) + SUM(fst.NB_MDPAmt) + SUM(fst.NB_LaserAmt) + SUM(fst.S_SurAmt) + SUM(fst.S_PRPAmt) ) AS 'NBSales'
		,		NULL AS 'ClosingPercentage'
		,		( SUM(fst.NB_TradCnt) + SUM(fst.NB_GradCnt) ) AS 'NBXtrandsPlusCount'
		,		( SUM(fst.NB_TradAmt) + SUM(fst.NB_GradAmt) ) AS 'NBXtrandsPlusSales'
		,		SUM(fst.NB_ExtCnt) AS 'NBEXTCount'
		,		SUM(fst.NB_ExtAmt) AS 'NBEXTSales'
		,		SUM(fst.NB_XTRCnt) AS 'NBXtrandsCount'
		,		SUM(fst.NB_XTRAmt) AS 'NBXtrandsSales'
		,		SUM(fst.S_SurCnt) AS 'SurgeryCount'
		,		SUM(fst.S_SurAmt) AS 'SurgerySales'
		,		SUM(fst.S_PostExtCnt) AS 'PostEXTCount'
		,		SUM(fst.S_PostExtAmt) AS 'PostEXTSales'
		,		SUM(fst.S_PRPCnt) AS 'PRPCount'
		,		SUM(fst.S_PRPAmt) AS 'PRPSales'
		,		SUM(fst.NB_MDPCnt) AS 'RestorInkCount'
		,		SUM(fst.NB_MDPAmt) AS 'RestorInkSales'
		,		SUM(fst.PCP_BioAmt) AS 'PCPXtrandsPlusSales'
		,		SUM(fst.PCP_ExtMemAmt) AS 'PCPEXTSales'
		,		SUM(fst.PCP_XtrAmt) AS 'PCPXtrandSales'
		,		( SUM(fst.PCP_NB2Amt) - SUM(fst.PCP_PCPAmt) ) AS 'NonProgramSales'
		,		( SUM(fst.ServiceAmt) - SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ( 'TAPESVC', 'TAPEINSTSVC', 'TAPEREINSTSVC' ) THEN fst.ServiceAmt ELSE NULL END) ) AS 'ServiceSales'
		,		SUM(fst.NB_BIOConvCnt) AS 'XtrandsPlusConversions'
		,		SUM(fst.NB_ExtConvCnt) AS 'EXTConversions'
		,		SUM(fst.NB_XTRConvCnt) AS 'XtrandsConversions'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'NB' AND m.BusinessSegmentDescriptionShort IN ( 'BIO', 'XTRPLUS' ) THEN 1 ELSE 0 END) AS 'XTRPCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'NB' AND m.BusinessSegmentDescriptionShort = 'EXT' THEN 1 ELSE 0 END) AS 'EXTCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'NB' AND m.BusinessSegmentDescriptionShort = 'XTR' THEN 1 ELSE 0 END) AS 'XTRCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'NB' THEN 1 ELSE 0 END) AS 'NBCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'PCP' THEN 1 ELSE 0 END) AS 'PCPCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1070 THEN 1 ELSE 0 END) AS 'Upgrades'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1080 THEN 1 ELSE 0 END) AS 'Downgrades'
		,		SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ( 'TAPESVC', 'TAPEINSTSVC', 'TAPEREINSTSVC' ) THEN fst.ServiceAmt ELSE 0 END) AS 'ExtensionServicesSales'
		,		SUM(fst.nb_LaserAmt) AS 'NBLaserSales'
		,		SUM(fst.pcp_LaserAmt) AS 'PCPLaserSales'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = fst.OrderDateKey
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
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND so.IsVoidedFlag = 0
		GROUP BY d.FullDate
		,		d.FirstDateOfMonth
		,		c.CenterKey


CREATE NONCLUSTERED INDEX IDX_Sales_FullDate ON #Sales ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Sales_CenterKey ON #Sales ( CenterKey );


UPDATE STATISTICS #Sales;


/* Update Daily Closing Percentage */
UPDATE	s
SET		s.ClosingPercentage = HC_BI_Reporting.dbo.DIVIDE_DECIMAL(ISNULL(s.NBCount, 0), ( ISNULL(c.Consultations, 0) - ISNULL(c.BeBacksToExclude, 0) ) )
FROM	#Sales s
		LEFT OUTER JOIN #Consultation c
			ON c.CenterKey = s.CenterKey
				AND c.FullDate = s.FullDate


/********************************** Get Retail Sales data *************************************/
INSERT  INTO #RetailSales
		SELECT	d.FullDate
		,		c.CenterKey
		,		SUM(CASE WHEN ( sc.SalesCodeDepartmentSSID IN ( 3065, 7052 ) OR sc.SalesCodeDescriptionShort IN ( 'TAPEPACK', 'HALO2LINES', 'HALO5LINES', 'HALO20', '480-116' ) ) THEN 0 ELSE fst.RetailAmt END) AS 'RetailSales'
		,		SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ( '480-116' ) THEN fst.RetailAmt ELSE NULL END) AS 'SPADeviceSales'
		,		SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) THEN fst.RetailAmt ELSE 0 END) AS 'HaloSales'
		,		SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ( 'TAPEPACK' ) THEN fst.RetailAmt ELSE NULL END) AS 'ExtensionSales'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fst.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
					ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = fst.MembershipKey
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND scd.SalesCodeDivisionSSID = 30
				AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYRET' )
				AND so.IsVoidedFlag = 0
		GROUP BY d.FullDate
		,		c.CenterKey


CREATE NONCLUSTERED INDEX IDX_RetailSales_FullDate ON #RetailSales ( FullDate );
CREATE NONCLUSTERED INDEX IDX_RetailSales_CenterKey ON #RetailSales ( CenterKey );


UPDATE STATISTICS #RetailSales;


/********************************** Get Wig Sales data *************************************/
INSERT  INTO #WigSales
		SELECT	d.FullDate
		,		c.CenterKey
		,		SUM(fst.RetailAmt) AS 'WigSales'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fst.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
					ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = fst.MembershipKey
				CROSS APPLY (
					SELECT	DISTINCT
							sot.SalesOrderKey
					FROM	HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender sot
					WHERE	sot.SalesOrderKey = fst.SalesOrderKey
							AND sot.TenderTypeDescriptionShort <> 'InterCo'
				) x_T
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND scd.SalesCodeDivisionSSID = 30
				AND scd.SalesCodeDepartmentSSID = 7052
				AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYRET' )
				AND so.IsVoidedFlag = 0
		GROUP BY d.FullDate
		,		c.CenterKey


CREATE NONCLUSTERED INDEX IDX_WigSales_FullDate ON #WigSales ( FullDate );
CREATE NONCLUSTERED INDEX IDX_WigSales_CenterKey ON #WigSales ( CenterKey );


UPDATE STATISTICS #WigSales;


/********************************** Combine Scorecard Data *************************************/
INSERT	INTO #ScorecardData
		SELECT	cm.CenterKey AS 'OrganizationKey'
		,		cm.CenterDescription AS 'Organization'
		,		cm.MeasureID
		,		cm.CenterMeasureID
		,		cm.ExcludeFromVirtualFlag
		,		cm.Measure
		,		cm.AccountID
		,		cm.MeasureType
		,		cm.MeasureThresholdType
		,		cm.HasThreshold1Flag
		,		cm.Threshold1Calculation
		,		cm.HasThreshold2Flag
		,		cm.Threshold2Calculation
		,		cm.HasThreshold3Flag
		,		cm.Threshold3Calculation
		,		cm.HasThreshold4Flag
		,		cm.Threshold4Calculation
		,		d.FullDate AS 'Date'
		,		d.PeriodStartDate
		,		d.IsWorkDay
		,		NULL AS 'Value'
		,		NULL AS 'Threshold1'
		,		NULL AS 'Threshold2'
		,		NULL AS 'Threshold3'
		,		NULL AS 'Threshold4'
		FROM	#CenterMeasure cm
		,		#DailyDate d


CREATE NONCLUSTERED INDEX IDX_ScorecardData_OrganizationKey ON #ScorecardData ( OrganizationKey );
CREATE NONCLUSTERED INDEX IDX_ScorecardData_MeasureID ON #ScorecardData ( MeasureID );
CREATE NONCLUSTERED INDEX IDX_ScorecardData_AccountID ON #ScorecardData ( AccountID );
CREATE NONCLUSTERED INDEX IDX_ScorecardData_Date ON #ScorecardData ( Date );
CREATE NONCLUSTERED INDEX IDX_ScorecardData_IsWorkDay ON #ScorecardData ( IsWorkDay );


UPDATE STATISTICS #ScorecardData;


-- Remove specific measures for the Virtual Center
DELETE	sd
FROM	#ScorecardData sd
WHERE	sd.OrganizationKey = 396
		AND sd.ExcludeFromVirtualFlag = 1


-- Remove daily records for the Monthly based metrics
DELETE	sd
FROM	#ScorecardData sd
		LEFT OUTER JOIN #MonthlyDate md
			ON md.FullDate = sd.Date
WHERE	sd.MeasureType = 'Percentage'
		AND sd.MeasureID NOT IN ( 9, 19, 56, 87, 93 )
		AND md.FullDate IS NULL


/********************************** Update Scorecard Actuals Data *************************************/


-- Update LASS Actuals
UPDATE	sd
SET		sd.Value = CASE WHEN sd.MeasureID = 40 THEN ISNULL(l.Leads, 0)
					WHEN sd.MeasureID = 4 THEN ISNULL(a.Appointments, 0)
					WHEN sd.MeasureID = 31 THEN ISNULL(c.InPersonConsultations, 0)
					WHEN sd.MeasureID = 78 THEN ISNULL(c.VirtualConsultations, 0)
				END
FROM	#ScorecardData sd
		LEFT OUTER JOIN #Lead l
			ON l.CenterKey = sd.OrganizationKey
			AND l.FullDate = sd.Date
		LEFT OUTER JOIN #Appointment a
			ON a.CenterKey = sd.OrganizationKey
			AND a.FullDate = sd.Date
		LEFT OUTER JOIN #Consultation c
			ON c.CenterKey = sd.OrganizationKey
			AND c.FullDate = sd.Date
WHERE	sd.MeasureID IN ( 40, 4, 31, 78 )


-- Update Retail Sales Actuals
UPDATE	sd
SET		sd.Value = CASE WHEN sd.MeasureID = 69 THEN rs.SPADeviceSales
					WHEN sd.MeasureID = 30 THEN rs.HaloSales
					WHEN sd.MeasureID = 59 THEN rs.RetailSales
					WHEN sd.MeasureID = 24 THEN rs.ExtensionSales
				END
FROM	#ScorecardData sd
		LEFT OUTER JOIN #RetailSales rs
			ON rs.CenterKey = sd.OrganizationKey
			AND rs.FullDate = sd.Date
WHERE	sd.MeasureID IN ( 69, 30, 59, 24 )


-- Update Wig Sales Actuals
UPDATE	sd
SET		sd.Value = ws.WigSales
FROM	#ScorecardData sd
		LEFT OUTER JOIN #WigSales ws
			ON ws.CenterKey = sd.OrganizationKey
			AND ws.FullDate = sd.Date
WHERE	sd.MeasureID = 79


-- Update PCP AR Actuals
UPDATE	sd
SET		sd.Value = CASE WHEN sd.MeasureID = 51 THEN r.ReceivablesBalance
					WHEN sd.MeasureID = 50 THEN r.ClientCount
				END
FROM	#ScorecardData sd
		LEFT OUTER JOIN #Receivables r
			ON r.CenterKey = sd.OrganizationKey
			AND r.FullDate = sd.Date
WHERE	sd.MeasureID IN ( 50, 51 )


-- Update Client Count Actuals
UPDATE	sd
SET		sd.Value = cc.ClientCount
FROM	#ScorecardData sd
		LEFT OUTER JOIN #ClientCount cc
			ON cc.CenterKey = sd.OrganizationKey
			AND cc.FullDate = sd.Date
			AND cc.AccountID = sd.AccountID
WHERE	sd.MeasureID IN ( 21, 89, 96 )


-- Update Sales Actuals
UPDATE	sd
SET		sd.Value = CASE WHEN sd.MeasureID = 26 THEN s.GrossNBCount
					WHEN sd.MeasureID = 92 THEN s.NBXtrandsPlusSales
					WHEN sd.MeasureID = 18 THEN s.NBEXTSales
					WHEN sd.MeasureID = 85 THEN s.NBXtrandsSales
					WHEN sd.MeasureID = 65 THEN s.RestorInkSales
					WHEN sd.MeasureID = 74 THEN s.SurgerySales
					WHEN sd.MeasureID = 58 THEN s.PostEXTSales
					WHEN sd.MeasureID = 95 THEN s.PCPXtrandsPlusSales
					WHEN sd.MeasureID = 20 THEN s.PCPEXTSales
					WHEN sd.MeasureID = 88 THEN s.PCPXtrandSales
					WHEN sd.MeasureID = 90 THEN s.NBXtrandsPlusCount
					WHEN sd.MeasureID = 17 THEN s.NBEXTCount
					WHEN sd.MeasureID = 84 THEN s.NBXtrandsCount
					WHEN sd.MeasureID = 64 THEN s.RestorInkCount
					WHEN sd.MeasureID = 73 THEN s.SurgeryCount
					WHEN sd.MeasureID = 57 THEN s.PostEXTCount
					WHEN sd.MeasureID = 94 THEN s.NewStyleDays
					WHEN sd.MeasureID = 91 THEN s.XtrandsPlusConversions
					WHEN sd.MeasureID = 16 THEN s.EXTConversions
					WHEN sd.MeasureID = 86 THEN s.XtrandsConversions
					WHEN sd.MeasureID = 60 THEN s.PRPCount
					WHEN sd.MeasureID = 61 THEN s.PRPSales
					WHEN sd.MeasureID = 23 THEN s.ExtensionServicesSales
					WHEN sd.MeasureID = 67 THEN s.ServiceSales
					WHEN sd.MeasureID = 54 THEN s.NonProgamSales
					WHEN sd.MeasureID = 35 THEN s.NBLaserSales
					WHEN sd.MeasureID = 36 THEN s.PCPLaserSales
					WHEN sd.MeasureID = 47 THEN s.NBCancels
					WHEN sd.MeasureID = 55 THEN s.PCPCancels
					WHEN sd.MeasureID = 9 THEN s.ClosingPercentage
				END
FROM	#ScorecardData sd
		LEFT OUTER JOIN #Sales s
			ON s.CenterKey = sd.OrganizationKey
			AND s.FullDate = sd.Date
WHERE	sd.MeasureID IN ( 26, 92, 18, 85, 65, 74, 58, 95, 20, 88, 90, 17, 84, 64, 73, 57, 94, 91, 16, 86, 60, 61, 23, 67, 54, 35, 36, 47, 55, 9 )


-- Update NB Retention
UPDATE	sd
SET		sd.Value = CASE
						WHEN sd.MeasureID = 19 THEN ( 1 - dbo.DIVIDE(o_S.Cancels_EXT, o_S.EXT_Count) )
						WHEN sd.MeasureID = 87 THEN ( 1 - dbo.DIVIDE(o_S.Cancels_XTR, o_S.XTR_Count) )
						WHEN sd.MeasureID = 93 THEN ( 1 - dbo.DIVIDE(o_S.Cancels_XTRP, o_S.XTRP_Count) )
					  END
FROM	#ScorecardData sd
		INNER JOIN #MonthlyDate md
			ON md.FullDate = sd.Date
		OUTER APPLY (
			SELECT	SUM(ISNULL(s.NBXtrandsPlusCount, 0)) AS 'XTRP_Count'
			,		SUM(ISNULL(s.NBEXTCount, 0)) AS 'EXT_Count'
			,		SUM(ISNULL(s.NBXtrandsCount, 0)) AS 'XTR_Count'
			,		SUM(ISNULL(s.XTRPCancels, 0)) AS 'Cancels_XTRP'
			,		SUM(ISNULL(s.EXTCancels, 0)) AS 'Cancels_EXT'
			,		SUM(ISNULL(s.XTRCancels, 0)) AS 'Cancels_XTR'
			FROM	#Sales s
			WHERE	s.CenterKey = sd.OrganizationKey
					AND s.FullDate BETWEEN md.PeriodStartDate AND md.PeriodEndDate
		) o_S
WHERE	sd.MeasureID IN ( 19, 87, 93 )


-- Update Positive Membership Changes
UPDATE	sd
SET		sd.Value = dbo.DIVIDE( ( o_S.Upgrades - o_S.Downgrades ), o_C.ActivePCP )
FROM	#ScorecardData sd
		INNER JOIN #MonthlyDate md
			ON md.FullDate = sd.Date
		OUTER APPLY (
			SELECT	SUM(ISNULL(s.Downgrades, 0)) AS 'Downgrades'
			,		SUM(ISNULL(s.Upgrades, 0)) AS 'Upgrades'
			FROM	#Sales s
			WHERE	s.CenterKey = sd.OrganizationKey
					AND s.FullDate BETWEEN md.PeriodStartDate AND md.PeriodEndDate
		) o_S
		OUTER APPLY (
			SELECT	cc.ClientCount AS 'ActivePCP'
			FROM	#ClientCount cc
			WHERE	cc.CenterKey = sd.OrganizationKey
					AND cc.FullDate = md.FullDate
					AND cc.AccountID = 10400
		) o_C
WHERE	sd.MeasureID = 56


/********************************** Update Scorecard Thresholds Data *************************************/


-- Update Lead Thresholds
UPDATE	sd
SET		sd.Threshold1 = ( o_B.DaysInMonthBudget * sd.Threshold1Calculation )
,		sd.Threshold2 = ( o_B.DaysInMonthBudget * sd.Threshold2Calculation )
,		sd.Threshold3 = ( o_B.DaysInMonthBudget * sd.Threshold3Calculation )
,		sd.Threshold4 = ( o_B.DaysInMonthBudget * sd.Threshold4Calculation )
FROM	#ScorecardData sd
		OUTER APPLY (
			SELECT	SUM(b.MonthlyBudget) AS 'MonthlyBudget'
			,		SUM(b.DaysInMonthBudget) AS 'DaysInMonthBudget'
			,		SUM(b.WorkDaysInMonthBudget) AS 'WorkDaysInMonthBudget'
			FROM	#Budget b
			WHERE	b.CenterKey = sd.OrganizationKey
					AND b.FullDate = sd.Period
					AND b.AccountID = sd.AccountID
		) o_B
WHERE	sd.MeasureID = 40


-- Update Gross New Business Thresholds
UPDATE	sd
SET		sd.Threshold1 = ( ( o_B.WorkDaysInMonthBudget * 1.10 ) * sd.Threshold1Calculation )
,		sd.Threshold2 = ( ( o_B.WorkDaysInMonthBudget * 1.10 ) * sd.Threshold2Calculation )
,		sd.Threshold3 = ( ( o_B.WorkDaysInMonthBudget * 1.10 ) * sd.Threshold3Calculation )
,		sd.Threshold4 = ( ( o_B.WorkDaysInMonthBudget * 1.10 ) * sd.Threshold4Calculation )
FROM	#ScorecardData sd
		OUTER APPLY (
			SELECT	SUM(b.MonthlyBudget) AS 'MonthlyBudget'
			,		SUM(b.DaysInMonthBudget) AS 'DaysInMonthBudget'
			,		SUM(b.WorkDaysInMonthBudget) AS 'WorkDaysInMonthBudget'
			FROM	#Budget b
			WHERE	b.CenterKey = sd.OrganizationKey
					AND b.FullDate = sd.Period
					AND b.AccountID = 10125
		) o_B
WHERE	sd.MeasureThresholdType = 'Budget'
		AND sd.MeasureID = 26
		AND sd.IsWorkDay = 1


-- Update Non-Program $ Thresholds
UPDATE	sd
SET		sd.Threshold1 = ( o_B.WorkDaysInMonthBudget * sd.Threshold1Calculation )
,		sd.Threshold2 = ( o_B.WorkDaysInMonthBudget * sd.Threshold2Calculation )
,		sd.Threshold3 = ( o_B.WorkDaysInMonthBudget * sd.Threshold3Calculation )
,		sd.Threshold4 = ( o_B.WorkDaysInMonthBudget * sd.Threshold4Calculation )
FROM	#ScorecardData sd
		OUTER APPLY (
			SELECT	SUM(b.MonthlyBudget) AS 'MonthlyBudget'
			,		SUM(b.DaysInMonthBudget) AS 'DaysInMonthBudget'
			,		SUM(b.WorkDaysInMonthBudget) AS 'WorkDaysInMonthBudget'
			FROM	#Budget b
			WHERE	b.CenterKey = sd.OrganizationKey
					AND b.FullDate = sd.Period
					AND b.AccountID = 3015
		) o_B
WHERE	sd.MeasureThresholdType = 'Budget'
		AND sd.MeasureID = 54
		AND sd.IsWorkDay = 1


-- Update Xtrands+ NB $ Thresholds
UPDATE	sd
SET		sd.Threshold1 = ( o_B.WorkDaysInMonthBudget * sd.Threshold1Calculation )
,		sd.Threshold2 = ( o_B.WorkDaysInMonthBudget * sd.Threshold2Calculation )
,		sd.Threshold3 = ( o_B.WorkDaysInMonthBudget * sd.Threshold3Calculation )
,		sd.Threshold4 = ( o_B.WorkDaysInMonthBudget * sd.Threshold4Calculation )
FROM	#ScorecardData sd
		OUTER APPLY (
			SELECT	SUM(b.MonthlyBudget) AS 'MonthlyBudget'
			,		SUM(b.DaysInMonthBudget) AS 'DaysInMonthBudget'
			,		SUM(b.WorkDaysInMonthBudget) AS 'WorkDaysInMonthBudget'
			FROM	#Budget b
			WHERE	b.CenterKey = sd.OrganizationKey
					AND b.FullDate = sd.Period
					AND b.AccountID IN ( 10305, 10310 )
		) o_B
WHERE	sd.MeasureThresholdType = 'Budget'
		AND sd.MeasureID = 92
		AND sd.IsWorkDay = 1


-- Update Client Count Thresholds
UPDATE	sd
SET		sd.Threshold1 = ( o_B.MonthlyBudget * sd.Threshold1Calculation )
,		sd.Threshold2 = ( o_B.MonthlyBudget * sd.Threshold2Calculation )
,		sd.Threshold3 = ( o_B.MonthlyBudget * sd.Threshold3Calculation )
,		sd.Threshold4 = ( o_B.MonthlyBudget * sd.Threshold4Calculation )
FROM	#ScorecardData sd
		OUTER APPLY (
			SELECT	SUM(b.MonthlyBudget) AS 'MonthlyBudget'
			,		SUM(b.DaysInMonthBudget) AS 'DaysInMonthBudget'
			,		SUM(b.WorkDaysInMonthBudget) AS 'WorkDaysInMonthBudget'
			FROM	#Budget b
			WHERE	b.CenterKey = sd.OrganizationKey
					AND b.FullDate = sd.Date
					AND b.AccountID = sd.AccountID
		) o_B
WHERE	sd.MeasureThresholdType = 'Budget'
		AND sd.MeasureID IN ( 21, 89, 96 )


-- Update Sales Thresholds
UPDATE	sd
SET		sd.Threshold1 = ( o_B.WorkDaysInMonthBudget * sd.Threshold1Calculation )
,		sd.Threshold2 = ( o_B.WorkDaysInMonthBudget * sd.Threshold2Calculation )
,		sd.Threshold3 = ( o_B.WorkDaysInMonthBudget * sd.Threshold3Calculation )
,		sd.Threshold4 = ( o_B.WorkDaysInMonthBudget * sd.Threshold4Calculation )
FROM	#ScorecardData sd
		OUTER APPLY (
			SELECT	SUM(b.MonthlyBudget) AS 'MonthlyBudget'
			,		SUM(b.DaysInMonthBudget) AS 'DaysInMonthBudget'
			,		SUM(b.WorkDaysInMonthBudget) AS 'WorkDaysInMonthBudget'
			FROM	#Budget b
			WHERE	b.CenterKey = sd.OrganizationKey
					AND b.FullDate = sd.Period
					AND b.AccountID = sd.AccountID
		) o_B
WHERE	sd.MeasureThresholdType = 'Budget'
		AND sd.MeasureID NOT IN ( 40, 26, 92, 21, 89, 96 )
		AND sd.IsWorkDay = 1


/********************************** Cleanup Scorecard Data *************************************/


UPDATE	sd
SET		sd.Value = 0
FROM	#ScorecardData sd
WHERE	sd.Measure <> 'Leads #'
		AND sd.Value IS NULL
		AND sd.IsWorkDay = 1


UPDATE	sd
SET		sd.Threshold1 = NULL
,		sd.Threshold2 = NULL
,		sd.Threshold3 = NULL
,		sd.Threshold4 = NULL
FROM	#ScorecardData sd
WHERE	sd.Threshold1 = 0
		AND sd.Threshold2 = 0
		AND sd.Threshold3 = 0
		AND sd.Threshold4 = 0


DELETE	sd
FROM	#ScorecardData sd
WHERE	ISNULL(sd.Value, 0) = 0
		AND sd.Threshold1 IS NULL
		AND sd.Threshold1 IS NULL
		AND sd.Threshold2 IS NULL
		AND sd.Threshold3 IS NULL
		AND sd.Threshold4 IS NULL
		AND sd.IsWorkDay = 0


/********************************** Map Measure IDs & Insert Data *************************************/
TRUNCATE TABLE HC_BI_Reporting.dbo.datScorecard


INSERT	INTO HC_BI_Reporting.dbo.datScorecard
		SELECT	sd.OrganizationKey
		,		sd.Organization
		,		sd.CenterMeasureID
		,		sd.MeasureID
		,		sd.Measure
		,		sd.MeasureType
		,		CAST(sd.Date AS DATE) AS 'Date'
		,		sd.Value
		,		sd.Threshold1
		,		sd.Threshold2
		,		sd.Threshold3
		,		sd.Threshold4
		FROM	#ScorecardData sd

END
GO
