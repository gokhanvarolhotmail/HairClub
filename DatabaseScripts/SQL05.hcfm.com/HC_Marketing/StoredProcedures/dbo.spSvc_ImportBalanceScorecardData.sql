/* CreateDate: 04/28/2020 15:22:59.000 , ModifyDate: 05/04/2021 10:10:50.643 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ImportBalanceScorecardData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/16/2019
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ImportBalanceScorecardData 2021
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_ImportBalanceScorecardData]
(
	@Year INT
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


DECLARE @CenterType INT
,		@ReportPeriod DATETIME
,		@ReportPeriodStartDate DATETIME
,		@CurrentPeriod DATETIME
,		@Yesterday DATETIME
,		@CurrentPeriodStartDate DATETIME
,		@CurrentPeriodEndDate DATETIME
,		@PreviousPeriodStartDate DATETIME
,		@PreviousPeriodEndDate DATETIME
,		@RefreshDate DATETIME
,		@StartDate DATETIME
,		@EndDate DATETIME


SET @CenterType = 2
SET @ReportPeriod = DATETIMEFROMPARTS(@Year, MONTH(CURRENT_TIMESTAMP), DAY(CURRENT_TIMESTAMP), 0, 0, 0, 0)
SET @ReportPeriodStartDate = DATETIMEFROMPARTS(YEAR(@ReportPeriod), MONTH(@ReportPeriod), 1, 0, 0, 0, 0)
SET @CurrentPeriod = CURRENT_TIMESTAMP
SET @Yesterday = CAST(DATEADD(DAY, -1, @CurrentPeriod) AS DATE)
SET @CurrentPeriodStartDate = DATETIMEFROMPARTS(YEAR(@CurrentPeriod), MONTH(@CurrentPeriod), 1, 0, 0, 0, 0)
SET @CurrentPeriodEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentPeriodStartDate) +1, 0))
SET @PreviousPeriodStartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentPeriodStartDate), 0))
SET @PreviousPeriodEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @CurrentPeriodStartDate)) +1, 0))
SET @RefreshDate = DATEADD(YEAR, -2, DATEADD(YEAR, DATEDIFF(YEAR, 0, @ReportPeriodStartDate), 0))
SET @StartDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, @ReportPeriodStartDate), 0)
SET @EndDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, @ReportPeriodStartDate) + 1, 0)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	RegionSSID INT
,	RegionDescription NVARCHAR(50)
,	AreaDescription NVARCHAR(100)
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

CREATE TABLE #Date (
	Period DATETIME
,	PeriodEndDate DATETIME
,	MonthNumber INT
,	DaysInMonth INT
)

CREATE TABLE #Account (
	AccountID INT
,	AccountDescription VARCHAR(300)
,	Level1 NVARCHAR(50)
,	Level2 NVARCHAR(50)
,	Level3 NVARCHAR(50)
,	Level4 NVARCHAR(255)
,	Level5 NVARCHAR(50)
,	Level6 NVARCHAR(50)
,	IsByAreaFlag BIT
)

CREATE TABLE #AccountData (
	AreaDescription NVARCHAR(103)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	MonthNumber INT
,	AccountID INT
,	AccountDescription VARCHAR(300)
,	Level1 NVARCHAR(50)
,	Level2 NVARCHAR(50)
,	Level3 NVARCHAR(50)
,	Level4 NVARCHAR(255)
,	Level5 NVARCHAR(50)
,	Level6 NVARCHAR(50)
,	KPIValue REAL
)

CREATE TABLE #CenterAreaAccount (
	AreaDescription NVARCHAR(103)
,	Period DATETIME
,	MonthNumber INT
,	DaysInMonth INT
,	AccountID INT
,	AccountDescription VARCHAR(300)
,	Level1 NVARCHAR(50)
,	Level2 NVARCHAR(50)
,	Level3 NVARCHAR(50)
,	Level4 NVARCHAR(255)
,	Level5 NVARCHAR(50)
,	Level6 NVARCHAR(50)
)

CREATE TABLE #CenterAccount (
	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	MonthNumber INT
,	DaysInMonth INT
,	AccountID INT
,	AccountDescription VARCHAR(300)
,	Level1 NVARCHAR(50)
,	Level2 NVARCHAR(50)
,	Level3 NVARCHAR(50)
,	Level4 NVARCHAR(255)
,	Level5 NVARCHAR(50)
,	Level6 NVARCHAR(50)
)

CREATE TABLE #KPI (
	Organization NVARCHAR(103)
,	Period DATETIME
,	MonthNumber INT
,	DaysInMonth INT
,	AccountID INT
,	AccountDescription VARCHAR(300)
,	Level1 NVARCHAR(50)
,	Level2 NVARCHAR(50)
,	Level3 NVARCHAR(50)
,	Level4 NVARCHAR(255)
,	Level5 NVARCHAR(50)
,	Level6 NVARCHAR(50)
,	KPIValue REAL
)

CREATE TABLE #Consultation (
	CenterSSID INT
,	ClientKey INT
,	ClientIdentifier INT
,	Period DATETIME
)

CREATE TABLE #Appointment (
	AreaDescription NVARCHAR(103)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	ClientIdentifier INT
,	AppointmentDate DATE
,	Period DATETIME
,	TotalAppointments INT
,	TotalCompleted INT
)

CREATE TABLE #QAData (
	AreaDescription NVARCHAR(103)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	[10919_TotalQADone] INT
,	[10919_TotalQANeeded] INT
,	[10920_YesTotal] INT
,	[10920_Total] INT
,	[10921_YesTotal] INT
,	[10921_Total] INT
,	[10922_YesTotal] INT
,	[10922_Total] INT
,	[10923_YesTotal] INT
,	[10923_Total] INT
)

CREATE TABLE #HairInventorySnapShot (
	RowID INT
,	HairSystemInventorySnapshotID INT
,	CenterID INT
,	Period DATETIME
,	HairSystemInventoryBatchStatusDescription NVARCHAR(100)
)

CREATE TABLE #HairInventory (
	AreaDescription NVARCHAR(103)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	QuantityExpected INT
,	QuantityScanned INT
)

CREATE TABLE #LaserInventorySnapShot (
	RowID INT
,	SerializedInventoryAuditSnapshotID INT
,	CenterID INT
,	Period DATETIME
,	InventoryAuditBatchStatusDescription NVARCHAR(100)
)

CREATE TABLE #LaserInventory (
	AreaDescription NVARCHAR(103)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	QuantityExpected INT
,	QuantityScanned INT
)

CREATE TABLE #Survey (
	RowID INT
,	Period DATETIME
,	MonthNumber INT
,	SurveyName NVARCHAR(255)
,	Lead__c NVARCHAR(18)
,	Trigger_Task_Id__c NVARCHAR(18)
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	AreaDescription NVARCHAR(100)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	First_Name__c NVARCHAR(255)
,	Last_Name__c NVARCHAR(255)
,	Status NVARCHAR(50)
,	SurveyDate DATETIME
,	SurveyCompletionDate DATETIME
,	IsCompleted BIT
,	GF1_100__c INT
,	GF2_90__c INT
,	GF3230__c INT
,	GF4320__c INT
,	GF350__c INT
,	GF460__c INT
,	GF4220__c INT
,	GF4250__c INT
,	GF1_40__c INT
,	GF3200__c INT
,	GF4260__c INT
,	GF4230__c INT
,	GF330__c INT
,	GF4290__c INT
,	GF1_80__c INT
)

CREATE TABLE #SurveyKPI (
	AreaDescription NVARCHAR(100)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	MonthNumber INT
,	[10938] INT
,	[10925] INT
,	[10926] INT
,	[10927] INT
,	[10928] INT
,	[10929] INT
,	[10930] INT
,	[10931] INT
,	[10932] INT
,	[10933_YesTotal] INT
,	[10933_Total] INT
,	[10934] INT
,	[10935] INT
,	[10936] INT
,	[10937] INT
)

CREATE TABLE #Receivables (
	AreaDescription NVARCHAR(100)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	PeriodEndDate DATETIME
,	ReceivablesBalance REAL
)


/********************************** Get list of centers *******************************************/
IF @CenterType = 0 OR @CenterType = 2
	BEGIN
		INSERT  INTO #Center
				SELECT  r.RegionSSID
				,		r.RegionDescription
				,		ISNULL(cma.CenterManagementAreaDescription, '') AS 'AreaDescription'
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescriptionNumber
				,		ct.CenterTypeDescriptionShort
				,		'' AS 'SortOrder'
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
							ON ct.CenterTypeKey = ctr.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
							ON r.RegionKey = ctr.RegionSSID
						LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
							ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
				WHERE   ct.CenterTypeDescriptionShort = 'C'
						AND ctr.CenterNumber NOT IN ( 100, 103, 901, 902, 903, 904 )
						AND ctr.Active = 'Y'
	END


IF @CenterType = 0 OR @CenterType = 8
	BEGIN
		INSERT  INTO #Center
				SELECT  r.RegionSSID
				,		r.RegionDescription
				,		ISNULL(cma.CenterManagementAreaDescription, '') AS 'AreaDescription'
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescriptionNumber
				,		ct.CenterTypeDescriptionShort
				,		'' AS 'SortOrder'
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
							ON ct.CenterTypeKey = ctr.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
							ON r.RegionKey = ctr.RegionKey
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
		,		CASE WHEN c.AreaDescription = 'Area Canada' THEN '02'
					WHEN c.AreaDescription = 'Area East' THEN '03'
					WHEN c.AreaDescription = 'Area Mid-Atlantic' THEN '04'
					WHEN c.AreaDescription = 'Area Midwest' THEN '05'
					WHEN c.AreaDescription = 'Area North' THEN '06'
					WHEN c.AreaDescription = 'Area South' THEN '07'
					WHEN c.AreaDescription = 'Area West' THEN '08'
					WHEN c.AreaDescription = 'Area Virtual' THEN '09'
				END AS "SortOrder"
		FROM	#Center c


CREATE NONCLUSTERED INDEX IDX_CenterArea_AreaDescription ON #CenterArea ( AreaDescription );


UPDATE STATISTICS #CenterArea;


UPDATE	c
SET		c.SortOrder = ca.SortOrder
FROM	#Center c
		INNER JOIN #CenterArea ca
			ON ca.AreaDescription = c.AreaDescription


/********************************** Get Dates data *************************************/
INSERT	INTO #Date
		SELECT	d.FirstDateOfMonth AS 'Period'
		,		d.LastDateOfMonth AS 'PeriodEndDate'
		,		d.MonthNumber
		,		DATEDIFF(DAY, DATEADD(DAY, 1 - DAY(d.FirstDateOfMonth), d.FirstDateOfMonth), DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(d.FirstDateOfMonth), d.FirstDateOfMonth))) AS 'DaysInMonth'
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate d
		WHERE	d.FullDate BETWEEN @RefreshDate AND @EndDate
		GROUP BY d.FirstDateOfMonth
		,		d.LastDateOfMonth
		,		d.MonthNumber


CREATE NONCLUSTERED INDEX IDX_Date_Period ON #Date ( Period );
CREATE NONCLUSTERED INDEX IDX_Date_PeriodEndDate ON #Date ( PeriodEndDate );


UPDATE STATISTICS #Date;


/********************************** Get KPI Accounts *************************************/
INSERT	INTO #Account
		SELECT	a.AccountID
		,		a.Description AS 'AccountDescription'
		,		'Scorecard' AS 'Level1'
		,		a.Level2
		,		a.Level3
		,		a.Level4
		,		a.Level5
		,		a.Level6
		,		CASE WHEN a.AccountID IN ( 10902, 10903, 10904, 10905, 10906, 10907, 10908, 10909, 10910, 10911, 10912, 10913, 10914, 10915, 10190, 10924, 10918, 10919, 10920, 10921, 10922, 10923, 10925, 10926, 10927, 10928, 10929, 10930, 10931, 10932, 10933, 10934, 10935, 10936, 10937, 10852, 10938 ) THEN 1
					ELSE 0
				END AS 'IsByAreaFlag'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimAccount a
		WHERE	a.AccountID IN ( 10110, 10190, 10206, 10215, 10220, 10225, 10230, 10231, 10240, 10305, 10310, 10306, 10315, 10320, 10325, 10400, 10401, 10405, 10430
							, 10433, 10435, 10510, 10515, 10531, 10532, 10535, 10551, 10552, 10891, 10892, 10893, 10894, 10895, 10896, 10897, 10898, 10899, 10901
							, 10902, 10903, 10904, 10905, 10906, 10907, 10908, 10909, 10910, 10911, 10912, 10913, 10914, 10915, 10916, 10917, 10918, 10919, 10920
							, 10921, 10922, 10923, 10924, 10925, 10926, 10927, 10928, 10929, 10930, 10931, 10932, 10933, 10934, 10935, 10936, 10937, 10852, 10938
							)
		ORDER BY a.AccountID


CREATE NONCLUSTERED INDEX IDX_Account_AccountID ON #Account ( AccountID );


UPDATE STATISTICS #Account;


/********************************** Get KPI Account Data *************************************/
INSERT	INTO #AccountData
		SELECT	c.AreaDescription
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		CASE WHEN fa.AccountID IN ( 10400, 10401, 10405 ) THEN DATEADD(MONTH, -1, d.FirstDateOfMonth) ELSE d.FirstDateOfMonth END AS 'Period'
		,		CASE WHEN fa.AccountID IN ( 10400, 10401, 10405 ) THEN MONTH(DATEADD(MONTH, -1, d.FirstDateOfMonth)) ELSE d.MonthNumber END AS 'MonthNumber'
		,		a.AccountID
		,		a.AccountDescription
		,		a.Level1
		,		a.Level2
		,		a.Level3
		,		a.Level4
		,		a.Level5
		,		a.Level6
		,		fa.Flash AS 'KPIValue'
		FROM	HC_Accounting.dbo.FactAccounting fa
				INNER JOIN #Account a
					ON a.AccountID = fa.AccountID
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = fa.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterNumber = fa.CenterID
				INNER JOIN #Center c
					ON c.CenterSSID = ctr.CenterSSID
		WHERE	d.FirstDateOfMonth BETWEEN @RefreshDate AND @EndDate


CREATE NONCLUSTERED INDEX IDX_Account_AreaDescription ON #AccountData ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_Account_CenterSSID ON #AccountData ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Account_CenterNumber ON #AccountData ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Account_AccountID ON #AccountData ( AccountID );


UPDATE STATISTICS #AccountData;


/********************************** Combine Areas with KPI Accounts *************************************/
INSERT	INTO #CenterAreaAccount
		SELECT	ca.AreaDescription
		,		d.Period
		,		d.MonthNumber
		,		d.DaysInMonth
		,		a.AccountID
		,		a.AccountDescription
		,		a.Level1
		,		a.Level2
		,		a.Level3
		,		a.Level4
		,		a.Level5
		,		a.Level6
		FROM	#Account a
		,		#CenterArea ca
		,		#Date d


CREATE NONCLUSTERED INDEX IDX_CenterAreaAccount_AreaDescription ON #CenterAreaAccount ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_CenterAreaAccount_AccountID ON #CenterAreaAccount ( AccountID );
CREATE NONCLUSTERED INDEX IDX_CenterAreaAccount_Period ON #CenterAreaAccount ( Period );


UPDATE STATISTICS #CenterAreaAccount;


/********************************** Combine Centers with KPI Accounts *************************************/
INSERT	INTO #CenterAccount
		SELECT	c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		d.Period
		,		d.MonthNumber
		,		d.DaysInMonth
		,		a.AccountID
		,		a.AccountDescription
		,		a.Level1
		,		a.Level2
		,		a.Level3
		,		a.Level4
		,		a.Level5
		,		a.Level6
		FROM	#Account a
		,		#Center c
		,		#Date d


CREATE NONCLUSTERED INDEX IDX_CenterAccount_CenterSSID ON #CenterAccount ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_CenterAccount_CenterNumber ON #CenterAccount ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_CenterAccount_AccountID ON #CenterAccount ( AccountID );
CREATE NONCLUSTERED INDEX IDX_CenterAccount_Period ON #CenterAccount ( Period );


UPDATE STATISTICS #CenterAccount;


/********************************** Get KPI Account data By Area *************************************/
INSERT	INTO #KPI
		SELECT	caa.AreaDescription
		,		caa.Period
		,		caa.MonthNumber
		,		caa.DaysInMonth
		,		caa.AccountID
		,		caa.AccountDescription
		,		caa.Level1
		,		caa.Level2
		,		caa.Level3
		,		caa.Level4
		,		caa.Level5
		,		caa.Level6
		,		o_Fa.KPIValue AS 'KPIValue'
		FROM	#CenterAreaAccount caa
				OUTER APPLY (
					SELECT	ad.AreaDescription
					,		ad.Period
					,		ad.MonthNumber
					,		SUM(ad.KPIValue) AS 'KPIValue'
					FROM	#AccountData ad
					WHERE	ad.AreaDescription = caa.AreaDescription
							AND ad.AccountID = caa.AccountID
							AND ad.Period = caa.Period
					GROUP BY ad.AreaDescription
					,		ad.Period
					,		ad.MonthNumber
				) o_Fa


/********************************** Get KPI Account data By Center *************************************/
INSERT	INTO #KPI
		SELECT	ca.CenterDescription
		,		ca.Period
		,		ca.MonthNumber
		,		ca.DaysInMonth
		,		ca.AccountID
		,		ca.AccountDescription
		,		ca.Level1
		,		ca.Level2
		,		ca.Level3
		,		ca.Level4
		,		ca.Level5
		,		ca.Level6
		,		o_Fa.KPIValue AS 'KPIValue'
		FROM	#CenterAccount ca
				OUTER APPLY (
					SELECT	ad.CenterSSID
					,		ad.CenterNumber
					,		ad.CenterDescription
					,		ad.Period
					,		ad.MonthNumber
					,		SUM(ad.KPIValue) AS 'KPIValue'
					FROM	#AccountData ad
					WHERE	ad.CenterNumber = ca.CenterNumber
							AND ad.AccountID = ca.AccountID
							AND ad.Period = ca.Period
					GROUP BY ad.CenterSSID
					,		ad.CenterNumber
					,		ad.CenterDescription
					,		ad.Period
					,		ad.MonthNumber
				) o_Fa


CREATE NONCLUSTERED INDEX IDX_KPI_Organization ON #KPI ( Organization );
CREATE NONCLUSTERED INDEX IDX_KPI_AccountID ON #KPI ( AccountID );
CREATE NONCLUSTERED INDEX IDX_KPI_Period ON #KPI ( Period );


UPDATE STATISTICS #KPI;


/********************************** Get Mobile App Use Analysis - % Completed data By Center *************************************/
INSERT	INTO #Consultation
		SELECT	ctr.CenterSSID
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		d.FirstDateOfMonth AS 'Period'
		FROM	HairClubCMS.dbo.HC_BI_MKTG_DDS_vwFactActivityResults_VIEW far
				INNER JOIN HairClubCMS.dbo.HC_BI_ENT_DDS_DimCenter_TABLE c
					ON c.CenterKey = far.CenterKey
				INNER JOIN HairClubCMS.dbo.HC_BI_ENT_DDS_DimDate_TABLE d
					ON d.DateKey = far.ActivityDueDateKey
				INNER JOIN #Center ctr
					ON ctr.CenterSSID = c.CenterSSID
				INNER JOIN HairClubCMS.dbo.HC_BI_CMS_DDS_DimClient_TABLE clt
					ON clt.contactkey = far.ContactKey
		WHERE	d.FullDate BETWEEN @RefreshDate AND @EndDate
				AND far.BeBack <> 1
				AND far.Show = 1
		GROUP BY ctr.CenterSSID
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		d.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Consultation_CenterSSID ON #Consultation ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Consultation_ClientKey ON #Consultation ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_Consultation_ClientIdentifier ON #Consultation ( ClientIdentifier );
CREATE NONCLUSTERED INDEX IDX_Consultation_Period ON #Consultation ( Period );


UPDATE STATISTICS #Consultation;


INSERT	INTO #Appointment
		SELECT	r.AreaDescription
		,		r.CenterSSID
		,		r.CenterNumber
		,		r.CenterDescription
		,		r.ClientIdentifier
		,		r.AppointmentDate
		,		DATETIMEFROMPARTS(YEAR(r.AppointmentDate), MONTH(r.AppointmentDate), 1, 0, 0, 0, 0) AS 'Period'
		,		COUNT(r.ClientIdentifier) AS 'TotalAppointments'
		,		SUM(CASE WHEN ISNULL(r.CompletedVisitTypeID, 0) = 0 THEN 0 ELSE 1 END) AS 'TotalCompleted'
		FROM	(
					SELECT  ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier, a.AppointmentDate ORDER BY a.StartTime ) AS 'RowID'
					,		ctr.AreaDescription
					,		ctr.CenterSSID
					,		ctr.CenterNumber
					,		ctr.CenterDescription
					,       clt.ClientIdentifier
					,       a.AppointmentDate
					,		a.StartTime
					,		a.CheckinTime
					,		a.CheckoutTime
					,		a.CheckedInFlag
					,		a.AppointmentTypeID
					,		a.CompletedVisitTypeID
					FROM    HairClubCMS.dbo.datAppointment a
							INNER JOIN #Center ctr
								ON ctr.CenterSSID = a.CenterID
							INNER JOIN HairClubCMS.dbo.datClient clt
								ON clt.ClientGUID = a.ClientGUID
							LEFT OUTER JOIN HairClubCMS.dbo.lkpAppointmentType lat
								ON lat.AppointmentTypeID = a.AppointmentTypeID
							LEFT OUTER JOIN #Consultation c
								ON c.ClientIdentifier = clt.ClientIdentifier
					WHERE   a.AppointmentDate BETWEEN @RefreshDate AND @EndDate
							AND ISNULL(lat.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
							AND a.CheckinTime IS NOT NULL
							AND a.IsDeletedFlag = 0
							AND c.ClientIdentifier IS NULL -- Client is not in consultations for the same period of time
				) r
		WHERE	r.RowID = 1
				AND ISNULL(r.AppointmentTypeID, 0) IN ( 0, 2, 4 )
		GROUP BY r.AreaDescription
		,		r.CenterSSID
		,		r.CenterNumber
		,		r.CenterDescription
		,		r.ClientIdentifier
		,		r.AppointmentDate
		,		DATETIMEFROMPARTS(YEAR(r.AppointmentDate), MONTH(r.AppointmentDate), 1, 0, 0, 0, 0)


CREATE NONCLUSTERED INDEX IDX_Appointment_AreaDescription ON #Appointment ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_Appointment_CenterSSID ON #Appointment ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Appointment_CenterNumber ON #Appointment ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Appointment_CenterDescription ON #Appointment ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_Appointment_Period ON #Appointment ( Period );


UPDATE STATISTICS #Appointment;


/********************************** Get QA Data By Center *************************************/
INSERT	INTO #QAData
		SELECT	QA.AreaDescription
		,		QA.CenterSSID
		,		QA.CenterNumber
		,		QA.CenterDescription
		,		QA.Period
		,		SUM(QA.[10919_TotalQADone]) AS '10919_TotalQADone'
		,		SUM(QA.[10919_TotalQANeeded]) AS '10919_TotalQANeeded'
		,		SUM(QA.[10920_YesTotal]) AS '10920_YesTotal'
		,		SUM(QA.[10920_Total]) AS '10920_Total'
		,		SUM(QA.[10921_YesTotal]) AS '10921_YesTotal'
		,		SUM(QA.[10921_Total]) AS '10921_Total'
		,		SUM(QA.[10922_YesTotal]) AS '10922_YesTotal'
		,		SUM(QA.[10922_Total]) AS '10922_Total'
		,		SUM(QA.[10923_YesTotal]) AS '10923_YesTotal'
		,		SUM(QA.[10923_Total]) AS '10923_Total'
		FROM (
				SELECT  ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(hst.HairSystemOrderTransactionDate), MONTH(hst.HairSystemOrderTransactionDate), 1, 0, 0, 0, 0) AS 'Period'
				,		COUNT(hso.HairSystemOrderNumber) AS '10919_TotalQADone'
				,		0 AS '10919_TotalQANeeded'
				,		0 AS '10920_YesTotal'
				,		0 AS '10920_Total'
				,		0 AS '10921_YesTotal'
				,		0 AS '10921_Total'
				,		0 AS '10922_YesTotal'
				,		0 AS '10922_Total'
				,		0 AS '10923_YesTotal'
				,		0 AS '10923_Total'
				FROM    HairClubCMS.dbo.datHairSystemOrderTransaction hst
						INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
							ON hso.HairSystemOrderGUID = hst.HairSystemOrderGUID
						INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus hsos
							ON hsos.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
						INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus sf --Status From
							ON sf.HairSystemOrderStatusID = hst.PreviousHairSystemOrderStatusID
						INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus st --Status To
							ON st.HairSystemOrderStatusID = hst.NewHairSystemOrderStatusID
						INNER JOIN #Center ctr
							ON ctr.CenterSSID = hst.CenterID
				WHERE   hst.HairSystemOrderTransactionDate BETWEEN @RefreshDate AND @EndDate + ' 23:59:59'
						AND ( hsos.HairSystemOrderStatusDescriptionShort NOT IN ( 'QANEEDED' ) -- Current HSO Status is not QA Needed
								AND ( sf.HairSystemOrderStatusDescriptionShort IN ( 'QANEEDED' ) --Status From is QA Needed
										AND st.HairSystemOrderStatusDescriptionShort IN ( 'CENT' ) ) ) --Status To is CENT
				GROUP BY ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(hst.HairSystemOrderTransactionDate), MONTH(hst.HairSystemOrderTransactionDate), 1, 0, 0, 0, 0)

				UNION

				SELECT  ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(hst.HairSystemOrderTransactionDate), MONTH(hst.HairSystemOrderTransactionDate), 1, 0, 0, 0, 0) AS 'Period'
				,		0 AS '10919_TotalQADone'
				,		COUNT(hso.HairSystemOrderNumber) AS '10919_TotalQANeeded'
				,		0 AS '10920_YesTotal'
				,		0 AS '10920_Total'
				,		0 AS '10921_YesTotal'
				,		0 AS '10921_Total'
				,		0 AS '10922_YesTotal'
				,		0 AS '10922_Total'
				,		0 AS '10923_YesTotal'
				,		0 AS '10923_Total'
				FROM    HairClubCMS.dbo.datHairSystemOrderTransaction hst
						INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
							ON hso.HairSystemOrderGUID = hst.HairSystemOrderGUID
						INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus hsos
							ON hsos.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
						INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus sf --Status From
							ON sf.HairSystemOrderStatusID = hst.PreviousHairSystemOrderStatusID
						INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus st --Status To
							ON st.HairSystemOrderStatusID = hst.NewHairSystemOrderStatusID
						INNER JOIN #Center ctr
							ON ctr.CenterSSID = hst.CenterID
				WHERE   hst.HairSystemOrderTransactionDate BETWEEN @RefreshDate AND @EndDate + ' 23:59:59'
						AND ( hsos.HairSystemOrderStatusDescriptionShort NOT IN ( 'QANEEDED' ) -- Current HSO Status is not QA Needed
								AND st.HairSystemOrderStatusDescriptionShort IN ( 'QANEEDED' ) ) --Status To is not QA Needed
				GROUP BY ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(hst.HairSystemOrderTransactionDate), MONTH(hst.HairSystemOrderTransactionDate), 1, 0, 0, 0, 0)

				UNION

				SELECT	ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(ac.CompleteDate), MONTH(ac.CompleteDate), 1, 0, 0, 0, 0) AS 'Period'
				,		0 AS '10919_TotalQADone'
				,		0 AS '10919_TotalQANeeded'
				,		SUM(CASE WHEN sc.ScorecardCategoryDescription = 'Preparation' AND asm.ScorecardMetricAnswer = 1 THEN 1 ELSE 0 END) AS '10920_YesTotal'
				,		SUM(CASE WHEN sc.ScorecardCategoryDescription = 'Preparation' THEN 1 ELSE 0 END) AS '10920_Total'
				,		SUM(CASE WHEN sc.ScorecardCategoryDescription = 'New Style' AND sm.ScorecardMetricDescription = 'Product Instruction Given' AND asm.ScorecardMetricAnswer = 1 THEN 1 ELSE 0 END) AS '10921_YesTotal'
				,		SUM(CASE WHEN sc.ScorecardCategoryDescription = 'New Style' AND sm.ScorecardMetricDescription = 'Product Instruction Given' THEN 1 ELSE 0 END) AS '10921_Total'
				,		SUM(CASE WHEN sc.ScorecardCategoryDescription = 'New Style' AND sm.ScorecardMetricDescription = 'Proper Fit' AND asm.ScorecardMetricAnswer = 1 THEN 1 ELSE 0 END) AS '10922_YesTotal'
				,		SUM(CASE WHEN sc.ScorecardCategoryDescription = 'New Style' AND sm.ScorecardMetricDescription = 'Proper Fit' THEN 1 ELSE 0 END) AS '10922_Total'
				,		0 AS '10923_YesTotal'
				,		0 AS '10923_Total'
				FROM	HairClubCMS.dbo.datAppointmentScorecard ac
						INNER JOIN HairClubCMS.dbo.datAppointmentScorecardMetric asm
							ON asm.AppointmentScorecardID = ac.AppointmentScorecardID
						INNER JOIN HairClubCMS.dbo.lkpScorecardCategory sc
							ON sc.ScorecardCategoryID = ac.ScorecardCategoryID
						INNER JOIN HairClubCMS.dbo.lkpScorecardMetric sm
							ON sm.ScorecardMetricID = asm.ScorecardMetricID
						INNER JOIN HairClubCMS.dbo.datAppointment a
							ON a.AppointmentGUID = ac.AppointmentGUID
						INNER JOIN #Center ctr
							ON ctr.CenterSSID = a.CenterID
				GROUP BY ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(ac.CompleteDate), MONTH(ac.CompleteDate), 1, 0, 0, 0, 0)

				UNION

				SELECT	ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(a.AppointmentDate), MONTH(a.AppointmentDate), 1, 0, 0, 0, 0) AS 'Period'
				,		0 AS '10919_TotalQADone'
				,		0 AS '10919_TotalQANeeded'
				,		0 AS '10920_YesTotal'
				,		0 AS '10920_Total'
				,		0 AS '10921_YesTotal'
				,		0 AS '10921_Total'
				,		0 AS '10922_YesTotal'
				,		0 AS '10922_Total'
				,		SUM(CASE WHEN a.IsClientContactInformationConfirmed = 1 THEN 1 ELSE 0 END) AS '10923_YesTotal'
				,		COUNT(1) AS '10923_Total'
				FROM	HairClubCMS.dbo.datAppointment a
						INNER JOIN #Center ctr
							ON ctr.CenterSSID = a.CenterID
						LEFT OUTER JOIN HairClubCMS.dbo.lkpAppointmentType lat
							ON lat.AppointmentTypeID = a.AppointmentTypeID
				WHERE	a.AppointmentDate BETWEEN @RefreshDate AND @EndDate
						AND ISNULL(lat.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
						AND ISNULL(a.IsDeletedFlag, 0) = 0
				GROUP BY ctr.AreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		DATETIMEFROMPARTS(YEAR(a.AppointmentDate), MONTH(a.AppointmentDate), 1, 0, 0, 0, 0)
		) QA
		GROUP BY QA.AreaDescription
		,		QA.CenterSSID
		,		QA.CenterNumber
		,		QA.CenterDescription
		,		QA.Period


CREATE NONCLUSTERED INDEX IDX_QAData_AreaDescription ON #QAData ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_QAData_CenterSSID ON #QAData ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_QAData_CenterNumber ON #QAData ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_QAData_CenterDescription ON #QAData ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_QAData_Period ON #QAData ( Period );


UPDATE STATISTICS #QAData;


/********************************** Get Hair Inventory Data By Center *************************************/
INSERT	INTO #HairInventorySnapShot
		SELECT	ROW_NUMBER() OVER ( PARTITION BY DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0), c.CenterID ORDER BY s.HairSystemInventorySnapshotID DESC ) AS 'RowID'
		,		s.HairSystemInventorySnapshotID
		,		c.CenterID
		,		DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0) AS 'Period'
		,		bs.HairSystemInventoryBatchStatusDescription
		FROM	HairClubCMS.dbo.datHairSystemInventorySnapshot s
				INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch b
					ON s.HairSystemInventorySnapshotID = b.HairSystemInventorySnapshotID
				INNER JOIN HairClubCMS.dbo.cfgCenter c
					ON b.CenterID = c.CenterID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemInventoryBatchStatus bs
					ON b.HairSystemInventoryBatchStatusID = bs.HairSystemInventoryBatchStatusID
		WHERE	s.SnapshotDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND bs.HairSystemInventoryBatchStatusDescription = 'Completed'


CREATE NONCLUSTERED INDEX IDX_HairInventorySnapShot_RowID ON #HairInventorySnapShot ( RowID );
CREATE NONCLUSTERED INDEX IDX_HairInventorySnapShot_HairSystemInventorySnapshotID ON #HairInventorySnapShot ( HairSystemInventorySnapshotID );


UPDATE STATISTICS #HairInventorySnapShot;


DELETE FROM #HairInventorySnapShot WHERE RowID <> 1


INSERT	INTO #HairInventory
		SELECT	ctr.AreaDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0) AS 'Period'
		,		COUNT(t.HairSystemOrderNumber) AS 'QuantityExpected'
		,		SUM(CASE WHEN t.ScannedCenterID IS NOT NULL THEN 1 ELSE 0 END) AS 'QuantityScanned'
		FROM	HairClubCMS.dbo.datHairSystemInventorySnapshot s
				INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch b
					ON b.HairSystemInventorySnapshotID = s.HairSystemInventorySnapshotID
				INNER JOIN #HairInventorySnapShot hiss
					ON hiss.HairSystemInventorySnapshotID = b.HairSystemInventorySnapshotID
						AND hiss.CenterID = b.CenterID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemInventoryBatchStatus bs
					ON bs.HairSystemInventoryBatchStatusID = b.HairSystemInventoryBatchStatusID
				INNER JOIN #Center ctr
					ON ctr.CenterSSID = b.CenterID
				LEFT JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction t
					ON t.HairSystemInventoryBatchID = b.HairSystemInventoryBatchID
		GROUP BY ctr.AreaDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0)


CREATE NONCLUSTERED INDEX IDX_HairInventory_AreaDescription ON #HairInventory ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_HairInventory_CenterSSID ON #HairInventory ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_HairInventory_CenterNumber ON #HairInventory ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_HairInventory_CenterDescription ON #HairInventory ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_HairInventory_Period ON #HairInventory ( Period );


UPDATE STATISTICS #HairInventory;


/********************************** Get Laser Inventory Data By Center *************************************/
INSERT	INTO #LaserInventorySnapShot
		SELECT	ROW_NUMBER() OVER ( PARTITION BY DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0), c.CenterID ORDER BY s.SerializedInventoryAuditSnapshotID DESC ) AS 'RowID'
		,		s.SerializedInventoryAuditSnapshotID
		,		c.CenterID
		,		DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0) AS 'Period'
		,		bs.InventoryAuditBatchStatusDescription
		FROM	HairClubCMS.dbo.datSerializedInventoryAuditSnapshot s
				LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditBatch b
					ON s.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
				LEFT JOIN HairClubCMS.dbo.lkpInventoryAuditBatchStatus bs
					ON bs.InventoryAuditBatchStatusID = b.InventoryAuditBatchStatusID
				LEFT JOIN HairClubCMS.dbo.cfgCenter c
					ON b.CenterID = c.CenterID
		WHERE	s.SnapshotDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND bs.InventoryAuditBatchStatusDescription = 'Completed'


CREATE NONCLUSTERED INDEX IDX_LaserInventorySnapShot_RowID ON #LaserInventorySnapShot ( RowID );
CREATE NONCLUSTERED INDEX IDX_LaserInventorySnapShot_SerializedInventoryAuditSnapshotID ON #LaserInventorySnapShot ( SerializedInventoryAuditSnapshotID );


UPDATE STATISTICS #LaserInventorySnapShot;


DELETE FROM #LaserInventorySnapShot WHERE RowID <> 1


INSERT	INTO #LaserInventory
		SELECT	ctr.AreaDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0) AS 'Period'
		,		SUM(t.QuantityExpected) AS 'QuantityExpected'
		,		SUM(ISNULL(tacount.TotalQuantityScanned, 0)) AS 'QuantityScanned'
		FROM	HairClubCMS.dbo.datSerializedInventoryAuditSnapshot s
				INNER JOIN HairClubCMS.dbo.datSerializedInventoryAuditBatch b
					ON b.SerializedInventoryAuditSnapshotID = s.SerializedInventoryAuditSnapshotID
				INNER JOIN #LaserInventorySnapShot iss
					ON iss.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
						AND iss.CenterID = b.CenterID
				INNER JOIN #Center ctr
					ON ctr.CenterSSID = b.CenterID
				LEFT JOIN HairClubCMS.dbo.lkpInventoryAuditBatchStatus bs
					ON b.InventoryAuditBatchStatusID = bs.InventoryAuditBatchStatusID
				LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditTransaction t
					ON b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
				LEFT JOIN HairClubCMS.dbo.cfgSalesCode sc
					ON t.SalesCodeID = sc.SalesCodeID
				LEFT JOIN HairClubCMS.dbo.cfgSalesCodeCenter scc
					ON (sc.SalesCodeID = scc.SalesCodeID AND scc.CenterID = b.CenterID)
				LEFT JOIN HairClubCMS.dbo.datSalesCodeCenterInventory scci
					ON scc.SalesCodeCenterID = scci.SalesCodeCenterID
				LEFT JOIN (
							SELECT	t.SerializedInventoryAuditTransactionID
							,		COUNT(ts.ScannedCenterID) AS TotalQuantityScanned
							FROM	HairClubCMS.dbo.datSerializedInventoryAuditSnapshot s
									LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditBatch b
										ON s.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
									LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditTransaction t
										ON b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
									LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditTransactionSerialized ts
										ON t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
							WHERE	s.SnapshotDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
									AND ts.ScannedCenterID IS NOT NULL
									AND ts.ScannedCenterID = b.CenterID
							GROUP BY t.SerializedInventoryAuditTransactionID
						) tacount
					ON t.SerializedInventoryAuditTransactionID = tacount.SerializedInventoryAuditTransactionID
		GROUP BY ctr.AreaDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		DATETIMEFROMPARTS(YEAR(s.SnapshotDate), MONTH(s.SnapshotDate), 1, 0, 0, 0, 0)


CREATE NONCLUSTERED INDEX IDX_LaserInventory_AreaDescription ON #LaserInventory ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_LaserInventory_CenterSSID ON #LaserInventory ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_LaserInventory_CenterNumber ON #LaserInventory ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_LaserInventory_CenterDescription ON #LaserInventory ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_LaserInventory_Period ON #LaserInventory ( Period );


UPDATE STATISTICS #LaserInventory;


/********************************** Get Survey data *************************************/
INSERT	INTO #Survey
		SELECT	ROW_NUMBER() OVER ( PARTITION BY src.Lead__c, src.Trigger_Task_Id__c ORDER BY src.Completion_Time__c ASC ) AS 'RowID'
		,		d.FirstDateOfMonth AS 'Period'
		,		d.MonthNumber
		,		src.Survey_Name__c
		,		src.Lead__c
		,		src.Trigger_Task_Id__c
		,		t.Action__c
		,		t.Result__c
		,		ctr.AreaDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		src.First_Name__c
		,		src.Last_Name__c
		,		l.Status
		,		src.CreatedDate AS 'SurveyDate'
		,		CAST(src.Completion_Time__c AS DATE) AS 'SurveyCompletionDate'
		,		CASE WHEN src.Status__c = 'Completed' THEN 1 ELSE 0 END AS 'IsCompleted'
		,		src.GF1_100__c
		,		src.GF2_90__c
		,		src.GF3230__c
		,		src.GF4320__c
		,		src.GF350__c
		,		src.GF460__c
		,		src.GF4220__c
		,		src.GF4250__c
		,		src.GF1_40__c
		,		src.GF3200__c
		,		src.GF4260__c
		,		src.GF4230__c
		,		src.GF330__c
		,		src.GF4290__c
		,		src.GF1_80__c
		FROM	HC_BI_SFDC.dbo.Survey_Response__c src
				INNER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = src.Lead__c
				INNER JOIN HC_BI_SFDC.dbo.Task t
					ON t.Id = src.Trigger_Task_Id__c
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.FullDate = CAST(src.Completion_Time__c AS DATE)
				INNER JOIN #Center ctr
					ON ctr.CenterNumber = l.CenterNumber__c
		WHERE	l.CenterNumber__c LIKE '[2]%'


CREATE NONCLUSTERED INDEX IDX_Survey_RowID ON #Survey ( AreaDescription );


UPDATE STATISTICS #Survey;


-- De-dupe survey records
DELETE FROM #Survey WHERE RowID <> 1


-- Remove surveys that were not completed
DELETE FROM #Survey WHERE IsCompleted <> 1


INSERT	INTO #SurveyKPI
		SELECT	s.AreaDescription
		,		s.CenterSSID
		,		s.CenterNumber
		,		s.CenterDescription
		,		s.Period
		,		s.MonthNumber
		,		AVG(s.GF1_100__c) AS '10938'
		,		AVG(s.GF2_90__c) AS '10925'
		,		AVG(s.GF3230__c) AS '10926'
		,		AVG(s.GF4320__c) AS '10927'
		,		AVG(s.GF350__c) AS '10928'
		,		AVG(s.GF460__c) AS '10929'
		,		AVG(s.GF4220__c) AS '10930'
		,		AVG(s.GF4250__c) AS '10931'
		,		AVG(s.GF1_40__c) AS '10932'
		,		NULL AS '10933_YesTotal'
		,		NULL AS '10933_Total'
		,		AVG(s.GF4230__c) AS '10934'
		,		AVG(s.GF330__c) AS '10935'
		,		AVG(s.GF4290__c) AS '10936'
		,		AVG(s.GF1_80__c) AS '10937'
		FROM	#Survey s
		GROUP BY s.AreaDescription
		,		s.CenterSSID
		,		s.CenterNumber
		,		s.CenterDescription
		,		s.Period
		,		s.MonthNumber
		ORDER BY s.CenterNumber


CREATE NONCLUSTERED INDEX IDX_SurveyKPI_AreaDescription ON #SurveyKPI ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_CenterSSID ON #SurveyKPI ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_CenterNumber ON #SurveyKPI ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_CenterDescription ON #SurveyKPI ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_Period ON #SurveyKPI ( Period );


UPDATE STATISTICS #SurveyKPI;


UPDATE	sk
SET		sk.[10933_YesTotal] = ISNULL(o_K.[10933_YesTotal], 0)
,		sk.[10933_Total] = ISNULL(o_K.[10933_Total], 0)
FROM	#SurveyKPI sk
		OUTER APPLY (
			SELECT	SUM(CASE WHEN ( s.GF3200__c IS NOT NULL OR s.GF4260__c IS NOT NULL ) AND ( s.GF3200__c = 1 OR s.GF4260__c = 1 ) THEN 1 ELSE 0 END) AS '10933_YesTotal'
			,		SUM(1) AS '10933_Total'
			FROM	#Survey s
			WHERE	( s.GF3200__c IS NOT NULL OR s.GF4260__c IS NOT NULL )
					AND s.CenterNumber = sk.CenterNumber
					AND s.Period = sk.Period
		) o_K


/********************************** Get Receivables data *************************************/
INSERT	INTO #Receivables
		SELECT	c.AreaDescription
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		d.Period
		,		d.PeriodEndDate
		,		SUM(fr.Balance) AS 'ReceivablesBalance'
		FROM    HC_Accounting.dbo.FactReceivables fr
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fr.ClientKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fr.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fr.DateKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN #Date d
					ON CASE WHEN d.PeriodEndDate = @CurrentPeriodEndDate THEN @Yesterday ELSE d.PeriodEndDate END = dd.FullDate
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
		GROUP BY c.AreaDescription
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		d.Period
		,		d.PeriodEndDate


CREATE NONCLUSTERED INDEX IDX_Receivables_AreaDescription ON #Receivables ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_Receivables_CenterSSID ON #Receivables ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Receivables_CenterNumber ON #Receivables ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Receivables_CenterDescription ON #Receivables ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_Receivables_Period ON #Receivables ( Period );
CREATE NONCLUSTERED INDEX IDX_Receivables_PeriodEndDate ON #Receivables ( PeriodEndDate );


UPDATE STATISTICS #Receivables;


---------------------------------------------------------------------------------------------------------------------
-- UPDATE DATA FOR FIELD OPERATIONS AREA
---------------------------------------------------------------------------------------------------------------------


-- Update NB Retention
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10902 THEN ( 1 - dbo.DIVIDE(o_K.Cancels_XTRP, o_K.XTRP_Count) )
						WHEN kc.AccountID = 10903 THEN ( 1 - dbo.DIVIDE(o_K.Cancels_EXT, o_K.EXT_Count) )
						WHEN kc.AccountID = 10904 THEN ( 1 - dbo.DIVIDE(o_K.Cancels_XTR, o_K.XTR_Count) )
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10231 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'XTRP_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10215 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'EXT_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10206 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'XTR_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10915 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Cancels_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10916 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Cancels_EXT'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10917 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Cancels_XTR'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10231, 10215, 10206, 10915, 10916, 10917 )
					AND k.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID IN ( 10902, 10903, 10904 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Conversion Rate
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10905 THEN dbo.DIVIDE(o_K.Conversions_XTRP, o_K.Applications)
						WHEN kc.AccountID = 10906 THEN dbo.DIVIDE(o_K.Conversions_XTR, o_K.XTR_Count)
						WHEN kc.AccountID = 10907 THEN dbo.DIVIDE(o_K.Conversions_EXT, o_K.EXT_Count)
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10240 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Applications'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10430 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10206 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'XTR_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10433 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10215 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'EXT_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10435 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10240, 10430, 10206, 10433, 10215, 10435 )
					AND k.Period BETWEEN DATEADD(MONTH, -11, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', kc.Period), '19000101')) AND kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID IN ( 10905, 10906, 10907 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Positive Membership Changes
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE( ( o_K.Upgrades - o_K.Downgrades ), o_K.ActivePCP )
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10400 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ActivePCP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10510 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Downgrades'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10515 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Upgrades'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10400, 10510, 10515 )
					AND k.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID = 10908
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update PCP Retention
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10909 THEN ( 1 - dbo.DIVIDE(( o_Op.OpenPCP_XTRP + o_C.Conversions_XTRP - o_Cp.ClosePCP_XTRP ), dbo.DIVIDE(( o_Op.OpenPCP_XTRP + o_Cp.ClosePCP_XTRP ), 2)) )
						WHEN kc.AccountID = 10910 THEN ( 1 - dbo.DIVIDE(( o_Op.OpenPCP_XTR + o_C.Conversions_XTR - o_Cp.ClosePCP_XTR ), dbo.DIVIDE(( o_Op.OpenPCP_XTR + o_Cp.ClosePCP_XTR ), 2)) )
						WHEN kc.AccountID = 10911 THEN ( 1 - dbo.DIVIDE(( o_Op.OpenPCP_EXT + o_C.Conversions_EXT - o_Cp.ClosePCP_EXT ), dbo.DIVIDE(( o_Op.OpenPCP_EXT + o_Cp.ClosePCP_EXT ), 2)) )
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10400 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'OpenPCP_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10401 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'OpenPCP_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10405 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'OpenPCP_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10400, 10401, 10405 )
					AND k.Period = DATEADD(MONTH, -11, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', kc.Period), '19000101'))
		) o_Op
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10400 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ClosePCP_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10401 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ClosePCP_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10405 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ClosePCP_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10400, 10401, 10405 )
					AND k.Period = kc.Period
		) o_Cp
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10430 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10433 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10435 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10430, 10433, 10435 )
					AND k.Period BETWEEN DATEADD(MONTH, -11, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', kc.Period), '19000101')) AND kc.Period
		) o_C
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID IN ( 10909, 10910, 10911 )
		AND kc.Period BETWEEN @StartDate AND @PreviousPeriodEndDate


-- Update Closing Percentage
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(ISNULL(o_K.NetNB1Count, 0), ISNULL(o_K.Consultations, 0))
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10231 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'NetNB1Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10110 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Consultations'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10110, 10231 )
					AND k.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID = 10190
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update 100% Room Visits: Hair Maintenance Instructions
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(ISNULL(o_K.TotalCompleted, 0), ISNULL(o_K.TotalAppointments, 0))
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(a.TotalAppointments) AS 'TotalAppointments'
			,		SUM(a.TotalCompleted) AS 'TotalCompleted'
			FROM	#Appointment a
			WHERE	a.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID IN ( 10913, 10918 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update QA KPIs
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10919 THEN dbo.DIVIDE(o_K.[10919_TotalQADone], o_K.[10919_TotalQANeeded])
						WHEN kc.AccountID = 10920 THEN dbo.DIVIDE(o_K.[10920_YesTotal], o_K.[10920_Total])
						WHEN kc.AccountID = 10921 THEN dbo.DIVIDE(o_K.[10921_YesTotal], o_K.[10921_Total])
						WHEN kc.AccountID = 10922 THEN dbo.DIVIDE(o_K.[10922_YesTotal], o_K.[10922_Total])
						WHEN kc.AccountID = 10923 THEN dbo.DIVIDE(o_K.[10923_YesTotal], o_K.[10923_Total])
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(qd.[10919_TotalQADone]) AS '10919_TotalQADone'
			,		SUM(qd.[10919_TotalQANeeded]) AS '10919_TotalQANeeded'
			,		SUM(qd.[10920_YesTotal]) AS '10920_YesTotal'
			,		SUM(qd.[10920_Total]) AS '10920_Total'
			,		SUM(qd.[10921_YesTotal]) AS '10921_YesTotal'
			,		SUM(qd.[10921_Total]) AS '10921_Total'
			,		SUM(qd.[10922_YesTotal]) AS '10922_YesTotal'
			,		SUM(qd.[10922_Total]) AS '10922_Total'
			,		SUM(qd.[10923_YesTotal]) AS '10923_YesTotal'
			,		SUM(qd.[10923_Total]) AS '10923_Total'
			FROM	#QAData qd
			WHERE	qd.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID IN ( 10919, 10920, 10921, 10922, 10923 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Hair Inventory KPI
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(o_K.QuantityScanned, o_K.QuantityExpected)
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(hi.QuantityScanned) AS 'QuantityScanned'
			,		SUM(hi.QuantityExpected) AS 'QuantityExpected'
			FROM	#HairInventory hi
			WHERE	hi.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID = 10924
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Laser Inventory KPI
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(o_K.QuantityScanned, o_K.QuantityExpected)
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(li.QuantityScanned) AS 'QuantityScanned'
			,		SUM(li.QuantityExpected) AS 'QuantityExpected'
			FROM	#LaserInventory li
			WHERE	li.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID = 10914
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Survey KPIs
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10925 THEN o_K.[10925]
						WHEN kc.AccountID = 10926 THEN o_K.[10926]
						WHEN kc.AccountID = 10927 THEN o_K.[10927]
						WHEN kc.AccountID = 10928 THEN o_K.[10928]
						WHEN kc.AccountID = 10929 THEN o_K.[10929]
						WHEN kc.AccountID = 10930 THEN o_K.[10930]
						WHEN kc.AccountID = 10931 THEN o_K.[10931]
						WHEN kc.AccountID = 10932 THEN o_K.[10932]
						WHEN kc.AccountID = 10933 THEN dbo.DIVIDE(o_K.[10933_YesTotal], o_K.[10933_Total])
						WHEN kc.AccountID = 10934 THEN o_K.[10934]
						WHEN kc.AccountID = 10935 THEN o_K.[10935]
						WHEN kc.AccountID = 10936 THEN o_K.[10936]
						WHEN kc.AccountID = 10937 THEN o_K.[10937]
						WHEN kc.AccountID = 10938 THEN o_K.[10938]
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	AVG(sk.[10925]) AS '10925'
			,		AVG(sk.[10926]) AS '10926'
			,		AVG(sk.[10927]) AS '10927'
			,		AVG(sk.[10928]) AS '10928'
			,		AVG(sk.[10929]) AS '10929'
			,		AVG(sk.[10930]) AS '10930'
			,		AVG(sk.[10931]) AS '10931'
			,		AVG(sk.[10932]) AS '10932'
			,		SUM(sk.[10933_YesTotal]) AS '10933_YesTotal'
			,		SUM(sk.[10933_Total]) AS '10933_Total'
			,		AVG(sk.[10934]) AS '10934'
			,		AVG(sk.[10935]) AS '10935'
			,		AVG(sk.[10936]) AS '10936'
			,		AVG(sk.[10937]) AS '10937'
			,		AVG(sk.[10938]) AS '10938'
			FROM	#SurveyKPI sk
			WHERE	sk.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID IN ( 10925, 10926, 10927, 10928, 10929, 10930, 10931, 10932, 10933, 10934, 10935, 10936, 10937, 10938 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update PCP AR
UPDATE	kc
SET		kc.KPIValue = o_K.ReceivablesBalance
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(r.ReceivablesBalance) AS 'ReceivablesBalance'
			FROM	#Receivables r
			WHERE	r.Period = kc.Period
		) o_K
WHERE	kc.Organization = 'Field Operations'
		AND kc.AccountID = 10852
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


---------------------------------------------------------------------------------------------------------------------
-- UPDATE DATA FOR ALL OTHER AREAs
---------------------------------------------------------------------------------------------------------------------


-- Update NB Retention
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10902 THEN ( 1 - dbo.DIVIDE(o_K.Cancels_XTRP, o_K.XTRP_Count) )
						WHEN kc.AccountID = 10903 THEN ( 1 - dbo.DIVIDE(o_K.Cancels_EXT, o_K.EXT_Count) )
						WHEN kc.AccountID = 10904 THEN ( 1 - dbo.DIVIDE(o_K.Cancels_XTR, o_K.XTR_Count) )
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10231 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'XTRP_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10215 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'EXT_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10206 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'XTR_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10915 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Cancels_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10916 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Cancels_EXT'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10917 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Cancels_XTR'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10231, 10215, 10206, 10915, 10916, 10917)
					AND k.Organization = kc.Organization
					AND k.Period = kc.Period
		) o_K
WHERE	kc.Organization <> 'Field Operations'
		AND kc.AccountID IN ( 10902, 10903, 10904 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Conversion Rate
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10905 THEN dbo.DIVIDE(o_K.Conversions_XTRP, o_K.Applications)
						WHEN kc.AccountID = 10906 THEN dbo.DIVIDE(o_K.Conversions_XTR, o_K.XTR_Count)
						WHEN kc.AccountID = 10907 THEN dbo.DIVIDE(o_K.Conversions_EXT, o_K.EXT_Count)
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10240 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Applications'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10430 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10206 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'XTR_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10433 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10215 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'EXT_Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10435 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10240, 10430, 10206, 10433, 10215, 10435 )
					AND k.Organization = kc.Organization
					AND k.Period BETWEEN DATEADD(MONTH, -11, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', kc.Period), '19000101')) AND kc.Period
		) o_K
WHERE	kc.Organization <> 'Field Operations'
		AND kc.AccountID IN ( 10905, 10906, 10907 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Positive Membership Changes
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE( ( o_K.Upgrades - o_K.Downgrades ), o_K.ActivePCP )
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10400 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ActivePCP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10510 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Downgrades'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10515 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Upgrades'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10400, 10510, 10515)
					AND k.Organization = kc.Organization
					AND k.Period = kc.Period
		) o_K
WHERE	kc.Organization <> 'Field Operations'
		AND kc.AccountID = 10908
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update PCP Retention
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10909 THEN ( 1 - dbo.DIVIDE(( o_Op.OpenPCP_XTRP + o_C.Conversions_XTRP - o_Cp.ClosePCP_XTRP ), dbo.DIVIDE(( o_Op.OpenPCP_XTRP + o_Cp.ClosePCP_XTRP ), 2)) )
						WHEN kc.AccountID = 10910 THEN ( 1 - dbo.DIVIDE(( o_Op.OpenPCP_XTR + o_C.Conversions_XTR - o_Cp.ClosePCP_XTR ), dbo.DIVIDE(( o_Op.OpenPCP_XTR + o_Cp.ClosePCP_XTR ), 2)) )
						WHEN kc.AccountID = 10911 THEN ( 1 - dbo.DIVIDE(( o_Op.OpenPCP_EXT + o_C.Conversions_EXT - o_Cp.ClosePCP_EXT ), dbo.DIVIDE(( o_Op.OpenPCP_EXT + o_Cp.ClosePCP_EXT ), 2)) )
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10400 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'OpenPCP_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10401 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'OpenPCP_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10405 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'OpenPCP_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10400, 10401, 10405 )
					AND k.Organization = kc.Organization
					AND k.Period = DATEADD(MONTH, -11, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', kc.Period), '19000101'))
		) o_Op
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10400 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ClosePCP_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10401 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ClosePCP_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10405 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'ClosePCP_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10400, 10401, 10405 )
					AND k.Organization = kc.Organization
					AND k.Period = kc.Period
		) o_Cp
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10430 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTRP'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10433 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_XTR'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10435 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Conversions_EXT'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10430, 10433, 10435 )
					AND k.Organization = kc.Organization
					AND k.Period BETWEEN DATEADD(MONTH, -11, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', kc.Period), '19000101')) AND kc.Period
		) o_C
WHERE	kc.Organization <> 'Field Operations'
		AND kc.AccountID IN ( 10909, 10910, 10911 )
		AND kc.Period BETWEEN @StartDate AND @PreviousPeriodEndDate


-- Update Closing Percentage
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(ISNULL(o_K.NetNB1Count, 0), ISNULL(o_K.Consultations, 0))
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(ISNULL(CASE WHEN k.AccountID IN ( 10231 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'NetNB1Count'
			,		SUM(ISNULL(CASE WHEN k.AccountID IN ( 10110 ) THEN k.KPIValue ELSE 0 END, 0)) AS 'Consultations'
			FROM	#KPI k
			WHERE	k.AccountID IN ( 10110, 10231 )
					AND k.Organization = kc.Organization
					AND k.Period = kc.Period
		) o_K
WHERE	kc.Organization <> 'Field Operations'
		AND kc.AccountID = 10190
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update 100% Room Visits: Hair Maintenance Instructions By Area
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(ISNULL(o_K.TotalCompleted, 0), ISNULL(o_K.TotalAppointments, 0))
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(a.TotalAppointments) AS 'TotalAppointments'
			,		SUM(a.TotalCompleted) AS 'TotalCompleted'
			FROM	#Appointment a
			WHERE	a.AreaDescription = kc.Organization
					AND a.Period = kc.Period
		) o_K
WHERE	kc.Organization IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic' )
		AND kc.AccountID IN ( 10913, 10918 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update 100% Room Visits: Hair Maintenance Instructions By Center
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(ISNULL(o_K.TotalCompleted, 0), ISNULL(o_K.TotalAppointments, 0))
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(a.TotalAppointments) AS 'TotalAppointments'
			,		SUM(a.TotalCompleted) AS 'TotalCompleted'
			FROM	#Appointment a
			WHERE	a.CenterDescription = kc.Organization
					AND a.Period = kc.Period
		) o_K
WHERE	kc.Organization NOT IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic', 'Field Operations' )
		AND kc.AccountID IN ( 10913, 10918 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update QA Data
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10919 THEN dbo.DIVIDE(o_K.[10919_TotalQADone], o_K.[10919_TotalQANeeded])
						WHEN kc.AccountID = 10920 THEN dbo.DIVIDE(o_K.[10920_YesTotal], o_K.[10920_Total])
						WHEN kc.AccountID = 10921 THEN dbo.DIVIDE(o_K.[10921_YesTotal], o_K.[10921_Total])
						WHEN kc.AccountID = 10922 THEN dbo.DIVIDE(o_K.[10922_YesTotal], o_K.[10922_Total])
						WHEN kc.AccountID = 10923 THEN dbo.DIVIDE(o_K.[10923_YesTotal], o_K.[10923_Total])
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(qd.[10919_TotalQADone]) AS '10919_TotalQADone'
			,		SUM(qd.[10919_TotalQANeeded]) AS '10919_TotalQANeeded'
			,		SUM(qd.[10920_YesTotal]) AS '10920_YesTotal'
			,		SUM(qd.[10920_Total]) AS '10920_Total'
			,		SUM(qd.[10921_YesTotal]) AS '10921_YesTotal'
			,		SUM(qd.[10921_Total]) AS '10921_Total'
			,		SUM(qd.[10922_YesTotal]) AS '10922_YesTotal'
			,		SUM(qd.[10922_Total]) AS '10922_Total'
			,		SUM(qd.[10923_YesTotal]) AS '10923_YesTotal'
			,		SUM(qd.[10923_Total]) AS '10923_Total'
			FROM	#QAData qd
			WHERE	qd.AreaDescription = kc.Organization
					AND qd.Period = kc.Period
		) o_K
WHERE	kc.Organization IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic' )
		AND kc.AccountID IN ( 10919, 10920, 10921, 10922, 10923 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10919 THEN dbo.DIVIDE(o_K.[10919_TotalQADone], o_K.[10919_TotalQANeeded])
						WHEN kc.AccountID = 10920 THEN dbo.DIVIDE(o_K.[10920_YesTotal], o_K.[10920_Total])
						WHEN kc.AccountID = 10921 THEN dbo.DIVIDE(o_K.[10921_YesTotal], o_K.[10921_Total])
						WHEN kc.AccountID = 10922 THEN dbo.DIVIDE(o_K.[10922_YesTotal], o_K.[10922_Total])
						WHEN kc.AccountID = 10923 THEN dbo.DIVIDE(o_K.[10923_YesTotal], o_K.[10923_Total])
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(qd.[10919_TotalQADone]) AS '10919_TotalQADone'
			,		SUM(qd.[10919_TotalQANeeded]) AS '10919_TotalQANeeded'
			,		SUM(qd.[10920_YesTotal]) AS '10920_YesTotal'
			,		SUM(qd.[10920_Total]) AS '10920_Total'
			,		SUM(qd.[10921_YesTotal]) AS '10921_YesTotal'
			,		SUM(qd.[10921_Total]) AS '10921_Total'
			,		SUM(qd.[10922_YesTotal]) AS '10922_YesTotal'
			,		SUM(qd.[10922_Total]) AS '10922_Total'
			,		SUM(qd.[10923_YesTotal]) AS '10923_YesTotal'
			,		SUM(qd.[10923_Total]) AS '10923_Total'
			FROM	#QAData qd
			WHERE	qd.CenterDescription = kc.Organization
					AND qd.Period = kc.Period
		) o_K
WHERE	kc.Organization NOT IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic', 'Field Operations' )
		AND kc.AccountID IN ( 10919, 10920, 10921, 10922, 10923 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Hair Inventory KPI
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(o_K.QuantityScanned, o_K.QuantityExpected)
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(hi.QuantityScanned) AS 'QuantityScanned'
			,		SUM(hi.QuantityExpected) AS 'QuantityExpected'
			FROM	#HairInventory hi
			WHERE	hi.AreaDescription = kc.Organization
					AND hi.Period = kc.Period
		) o_K
WHERE	kc.Organization IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic' )
		AND kc.AccountID = 10924
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(o_K.QuantityScanned, o_K.QuantityExpected)
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(hi.QuantityScanned) AS 'QuantityScanned'
			,		SUM(hi.QuantityExpected) AS 'QuantityExpected'
			FROM	#HairInventory hi
			WHERE	hi.CenterDescription = kc.Organization
					AND hi.Period = kc.Period
		) o_K
WHERE	kc.Organization NOT IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic', 'Field Operations' )
		AND kc.AccountID = 10924
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Laser Inventory KPI
UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(o_K.QuantityScanned, o_K.QuantityExpected)
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(li.QuantityScanned) AS 'QuantityScanned'
			,		SUM(li.QuantityExpected) AS 'QuantityExpected'
			FROM	#LaserInventory li
			WHERE	li.AreaDescription = kc.Organization
					AND li.Period = kc.Period
		) o_K
WHERE	kc.Organization IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic' )
		AND kc.AccountID = 10914
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


UPDATE	kc
SET		kc.KPIValue = dbo.DIVIDE(o_K.QuantityScanned, o_K.QuantityExpected)
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(li.QuantityScanned) AS 'QuantityScanned'
			,		SUM(li.QuantityExpected) AS 'QuantityExpected'
			FROM	#LaserInventory li
			WHERE	li.CenterDescription = kc.Organization
					AND li.Period = kc.Period
		) o_K
WHERE	kc.Organization NOT IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic', 'Field Operations' )
		AND kc.AccountID = 10914
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Survey KPIs
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10925 THEN o_K.[10925]
						WHEN kc.AccountID = 10926 THEN o_K.[10926]
						WHEN kc.AccountID = 10927 THEN o_K.[10927]
						WHEN kc.AccountID = 10928 THEN o_K.[10928]
						WHEN kc.AccountID = 10929 THEN o_K.[10929]
						WHEN kc.AccountID = 10930 THEN o_K.[10930]
						WHEN kc.AccountID = 10931 THEN o_K.[10931]
						WHEN kc.AccountID = 10932 THEN o_K.[10932]
						WHEN kc.AccountID = 10933 THEN dbo.DIVIDE(o_K.[10933_YesTotal], o_K.[10933_Total])
						WHEN kc.AccountID = 10934 THEN o_K.[10934]
						WHEN kc.AccountID = 10935 THEN o_K.[10935]
						WHEN kc.AccountID = 10936 THEN o_K.[10936]
						WHEN kc.AccountID = 10937 THEN o_K.[10937]
						WHEN kc.AccountID = 10938 THEN o_K.[10938]
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	AVG(sk.[10925]) AS '10925'
			,		AVG(sk.[10926]) AS '10926'
			,		AVG(sk.[10927]) AS '10927'
			,		AVG(sk.[10928]) AS '10928'
			,		AVG(sk.[10929]) AS '10929'
			,		AVG(sk.[10930]) AS '10930'
			,		AVG(sk.[10931]) AS '10931'
			,		AVG(sk.[10932]) AS '10932'
			,		SUM(sk.[10933_YesTotal]) AS '10933_YesTotal'
			,		SUM(sk.[10933_Total]) AS '10933_Total'
			,		AVG(sk.[10934]) AS '10934'
			,		AVG(sk.[10935]) AS '10935'
			,		AVG(sk.[10936]) AS '10936'
			,		AVG(sk.[10937]) AS '10937'
			,		AVG(sk.[10938]) AS '10938'
			FROM	#SurveyKPI sk
			WHERE	sk.AreaDescription = kc.Organization
					AND sk.Period = kc.Period
		) o_K
WHERE	kc.Organization IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic' )
		AND kc.AccountID IN ( 10925, 10926, 10927, 10928, 10929, 10930, 10931, 10932, 10933, 10934, 10935, 10936, 10937, 10938 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Survey KPIs
UPDATE	kc
SET		kc.KPIValue = CASE
						WHEN kc.AccountID = 10925 THEN o_K.[10925]
						WHEN kc.AccountID = 10926 THEN o_K.[10926]
						WHEN kc.AccountID = 10927 THEN o_K.[10927]
						WHEN kc.AccountID = 10928 THEN o_K.[10928]
						WHEN kc.AccountID = 10929 THEN o_K.[10929]
						WHEN kc.AccountID = 10930 THEN o_K.[10930]
						WHEN kc.AccountID = 10931 THEN o_K.[10931]
						WHEN kc.AccountID = 10932 THEN o_K.[10932]
						WHEN kc.AccountID = 10933 THEN dbo.DIVIDE(o_K.[10933_YesTotal], o_K.[10933_Total])
						WHEN kc.AccountID = 10934 THEN o_K.[10934]
						WHEN kc.AccountID = 10935 THEN o_K.[10935]
						WHEN kc.AccountID = 10936 THEN o_K.[10936]
						WHEN kc.AccountID = 10937 THEN o_K.[10937]
						WHEN kc.AccountID = 10938 THEN o_K.[10938]
					  END
FROM	#KPI kc
		OUTER APPLY (
			SELECT	AVG(sk.[10925]) AS '10925'
			,		AVG(sk.[10926]) AS '10926'
			,		AVG(sk.[10927]) AS '10927'
			,		AVG(sk.[10928]) AS '10928'
			,		AVG(sk.[10929]) AS '10929'
			,		AVG(sk.[10930]) AS '10930'
			,		AVG(sk.[10931]) AS '10931'
			,		AVG(sk.[10932]) AS '10932'
			,		SUM(sk.[10933_YesTotal]) AS '10933_YesTotal'
			,		SUM(sk.[10933_Total]) AS '10933_Total'
			,		AVG(sk.[10934]) AS '10934'
			,		AVG(sk.[10935]) AS '10935'
			,		AVG(sk.[10936]) AS '10936'
			,		AVG(sk.[10937]) AS '10937'
			,		AVG(sk.[10938]) AS '10938'
			FROM	#SurveyKPI sk
			WHERE	sk.CenterDescription = kc.Organization
					AND sk.Period = kc.Period
		) o_K
WHERE	kc.Organization NOT IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic', 'Field Operations' )
		AND kc.AccountID IN ( 10925, 10926, 10927, 10928, 10929, 10930, 10931, 10932, 10933, 10934, 10935, 10936, 10937, 10938 )
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update Percentage values to the actual percentage
UPDATE	k
SET		k.KPIValue = ( k.KPIValue * 100 )
FROM	#KPI k
WHERE	k.AccountID IN ( 10902, 10903, 10904, 10905, 10906, 10907, 10908, 10909, 10910, 10911, 10912, 10913, 10914, 10915, 10190, 10918, 10919, 10920, 10921, 10922, 10923, 10924, 10933 )
		AND k.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update PCP AR
UPDATE	kc
SET		kc.KPIValue = o_K.ReceivablesBalance
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(r.ReceivablesBalance) AS 'ReceivablesBalance'
			FROM	#Receivables r
			WHERE	r.AreaDescription = kc.Organization
					AND r.Period = kc.Period
		) o_K
WHERE	kc.Organization IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic' )
		AND kc.AccountID = 10852
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


-- Update PCP AR
UPDATE	kc
SET		kc.KPIValue = o_K.ReceivablesBalance
FROM	#KPI kc
		OUTER APPLY (
			SELECT	SUM(r.ReceivablesBalance) AS 'ReceivablesBalance'
			FROM	#Receivables r
			WHERE	r.CenterDescription = kc.Organization
					AND r.Period = kc.Period
		) o_K
WHERE	kc.Organization NOT IN ( 'Area Canada', 'Area Central', 'Area East', 'Area South', 'Area West', 'Area Midwest', 'Area Mid-Atlantic', 'Field Operations' )
		AND kc.AccountID = 10852
		AND kc.Period BETWEEN @StartDate AND @CurrentPeriodEndDate


/********************************** PIVOT KPI Account data *************************************/
DECLARE @Column01 NVARCHAR(50) = '1/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column02 NVARCHAR(50) = '2/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column03 NVARCHAR(50) = '3/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column04 NVARCHAR(50) = '4/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column05 NVARCHAR(50) = '5/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column06 NVARCHAR(50) = '6/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column07 NVARCHAR(50) = '7/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column08 NVARCHAR(50) = '8/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column09 NVARCHAR(50) = '9/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column10 NVARCHAR(50) = '10/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column11 NVARCHAR(50) = '11/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))
DECLARE @Column12 NVARCHAR(50) = '12/1/' + CONVERT(NVARCHAR, YEAR(@StartDate))


DECLARE @SQL NVARCHAR(MAX)


/********************************** Create temp table for KPI Account data *************************************/
CREATE TABLE #ScorecardData (
	RowID INT IDENTITY(1, 1)
,	Organization NVARCHAR(103)
,	OrganizationType NVARCHAR(10)
,	SortOrder VARCHAR(10)
,	Level1 NVARCHAR(50)
,	Level2 NVARCHAR(50)
,	Level3 NVARCHAR(50)
,	Level4 NVARCHAR(255)
,	Level5 NVARCHAR(50)
,	Level6 NVARCHAR(50)
)


SET @SQL = 'ALTER TABLE #ScorecardData ADD ';
SET @SQL += '[' + @Column01 + '] MONEY NULL, ';
SET @SQL += '[' + @Column02 + '] MONEY NULL, ';
SET @SQL += '[' + @Column03 + '] MONEY NULL, ';
SET @SQL += '[' + @Column04 + '] MONEY NULL, ';
SET @SQL += '[' + @Column05 + '] MONEY NULL, ';
SET @SQL += '[' + @Column06 + '] MONEY NULL, ';
SET @SQL += '[' + @Column07 + '] MONEY NULL, ';
SET @SQL += '[' + @Column08 + '] MONEY NULL, ';
SET @SQL += '[' + @Column09 + '] MONEY NULL, ';
SET @SQL += '[' + @Column10 + '] MONEY NULL, ';
SET @SQL += '[' + @Column11 + '] MONEY NULL, ';
SET @SQL += '[' + @Column12 + '] MONEY NULL ';


EXECUTE(@SQL)


ALTER TABLE #ScorecardData DROP COLUMN RowID;


/********************************** Return KPI Account data By Area *************************************/
SET @SQL = '
			INSERT	INTO #ScorecardData
			SELECT	ca.AreaDescription AS ''Organization''
			,		''A'' AS ''OrganizationType''
			,		ca.SortOrder
			,		a.Level1
			,		a.Level2
			,		a.Level3
			,		a.Level4
			,		a.Level5
			,		a.Level6
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column01 + '''), 0) AS ''' + @Column01 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column02 + '''), 0) AS ''' + @Column02 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column03 + '''), 0) AS ''' + @Column03 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column04 + '''), 0) AS ''' + @Column04 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column05 + '''), 0) AS ''' + @Column05 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column06 + '''), 0) AS ''' + @Column06 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column07 + '''), 0) AS ''' + @Column07 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column08 + '''), 0) AS ''' + @Column08 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column09 + '''), 0) AS ''' + @Column09 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column10 + '''), 0) AS ''' + @Column10 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column11 + '''), 0) AS ''' + @Column11 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column12 + '''), 0) AS ''' + @Column12 + '''
			FROM	#Account a
			,		#CenterArea ca
			WHERE	a.AccountID NOT IN ( 10110, 10231, 10510, 10515, 10912, 10915, 10916, 10917, 10925, 10926, 10927, 10938 )
					AND a.IsByAreaFlag = 1
			ORDER BY ca.SortOrder
			'


EXECUTE(@SQL)


-- Insert NPS Metrics Separately
SET @SQL = '
			INSERT	INTO #ScorecardData
			SELECT	ca.AreaDescription AS ''Organization''
			,		''A'' AS ''OrganizationType''
			,		ca.SortOrder
			,		a.Level1
			,		a.Level2
			,		a.Level3
			,		a.Level4
			,		a.Level5
			,		a.Level6
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column01 + ''') AS ''' + @Column01 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column02 + ''') AS ''' + @Column02 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column03 + ''') AS ''' + @Column03 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column04 + ''') AS ''' + @Column04 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column05 + ''') AS ''' + @Column05 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column06 + ''') AS ''' + @Column06 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column07 + ''') AS ''' + @Column07 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column08 + ''') AS ''' + @Column08 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column09 + ''') AS ''' + @Column09 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column10 + ''') AS ''' + @Column10 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column11 + ''') AS ''' + @Column11 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = ca.AreaDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column12 + ''') AS ''' + @Column12 + '''
			FROM	#Account a
			,		#CenterArea ca
			WHERE	a.AccountID IN ( 10925, 10926, 10927, 10938 )
					AND a.IsByAreaFlag = 1
			ORDER BY ca.SortOrder
			'


EXECUTE(@SQL)


/********************************** Return KPI Account data By Center *************************************/
SET @SQL = '
			INSERT	INTO #ScorecardData
			SELECT	c.CenterDescription AS ''Organization''
			,		''C'' AS ''OrganizationType''
			,		c.SortOrder
			,		a.Level1
			,		a.Level2
			,		a.Level3
			,		a.Level4
			,		a.Level5
			,		a.Level6
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column01 + '''), 0) AS ''' + @Column01 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column02 + '''), 0) AS ''' + @Column02 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column03 + '''), 0) AS ''' + @Column03 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column04 + '''), 0) AS ''' + @Column04 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column05 + '''), 0) AS ''' + @Column05 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column06 + '''), 0) AS ''' + @Column06 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column07 + '''), 0) AS ''' + @Column07 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column08 + '''), 0) AS ''' + @Column08 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column09 + '''), 0) AS ''' + @Column09 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column10 + '''), 0) AS ''' + @Column10 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column11 + '''), 0) AS ''' + @Column11 + '''
			,		ISNULL((SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column12 + '''), 0) AS ''' + @Column12 + '''
			FROM	#Account a
			,		#Center c
			WHERE	a.AccountID NOT IN ( 10110, 10231, 10510, 10515, 10912, 10915, 10916, 10917, 10925, 10926, 10927, 10938 )
			GROUP BY c.CenterDescription
			,		c.SortOrder
			,		a.Level1
			,		a.Level2
			,		a.Level3
			,		a.Level4
			,		a.Level5
			,		a.Level6
			ORDER BY c.CenterDescription
			'


EXECUTE(@SQL)


-- Insert NPS Metrics Separately
SET @SQL = '
			INSERT	INTO #ScorecardData
			SELECT	c.CenterDescription AS ''Organization''
			,		''C'' AS ''OrganizationType''
			,		c.SortOrder
			,		a.Level1
			,		a.Level2
			,		a.Level3
			,		a.Level4
			,		a.Level5
			,		a.Level6
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column01 + ''') AS ''' + @Column01 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column02 + ''') AS ''' + @Column02 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column03 + ''') AS ''' + @Column03 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column04 + ''') AS ''' + @Column04 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column05 + ''') AS ''' + @Column05 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column06 + ''') AS ''' + @Column06 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column07 + ''') AS ''' + @Column07 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column08 + ''') AS ''' + @Column08 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column09 + ''') AS ''' + @Column09 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column10 + ''') AS ''' + @Column10 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column11 + ''') AS ''' + @Column11 + '''
			,		(SELECT SUM(k.KPIValue) FROM #KPI k WHERE k.Organization = c.CenterDescription AND k.Level1 = a.Level1 AND k.Level2 = a.Level2 AND k.Level3 = a.Level3 AND k.Level4 = a.Level4 AND k.Level5 = a.Level5 AND k.Level6 = a.Level6 AND k.Period = ''' + @Column12 + ''') AS ''' + @Column12 + '''
			FROM	#Account a
			,		#Center c
			WHERE	a.AccountID IN ( 10925, 10926, 10927, 10938 )
			GROUP BY c.CenterDescription
			,		c.SortOrder
			,		a.Level1
			,		a.Level2
			,		a.Level3
			,		a.Level4
			,		a.Level5
			,		a.Level6
			ORDER BY c.CenterDescription
			'


EXECUTE(@SQL)


/********************************** Return KPI Account data *************************************/
TRUNCATE TABLE datScorecard


INSERT	INTO datScorecard
SELECT	*
FROM	#ScorecardData sd
ORDER BY sd.OrganizationType
,		sd.SortOrder
,		sd.Organization

END
GO
