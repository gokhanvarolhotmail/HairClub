/***********************************************************************
PROCEDURE:				spDB_PopulateNPSDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/27/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateNPSDashboard
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateNPSDashboard]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Today DATETIME
,		@StartDate DATETIME
,		@EndDate DATETIME
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@PreviousYearStart DATETIME
,		@PreviousYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @Today = CAST(DATEADD(DAY, 0, CURRENT_TIMESTAMP) AS DATE)
SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today), 0))
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @Today)) +1, 0))
SET @CurrentYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)
SET @CurrentYearEnd = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)))
SET @PreviousYearEnd = DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0))
SET @PreviousYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @PreviousYearEnd), 0)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Date (
	DateKey INT
,	FullDate DATETIME
,	YearNumber INT
,	MonthNumber INT
,	MonthName CHAR(10)
,	DayOfMonth INT
,	FirstDateOfMonth DATETIME
)

CREATE TABLE #Center (
	Area VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
)

CREATE TABLE #Survey (
	RowID INT
,	DateKey INT
,	Period DATETIME
,	MonthNumber INT
,	SurveyName NVARCHAR(255)
,	Lead__c NVARCHAR(18)
,	Trigger_Task_Id__c NVARCHAR(18)
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	AreaDescription NVARCHAR(100)
,	CenterKey INT
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
)

CREATE TABLE #SurveyKPI (
	AreaDescription NVARCHAR(100)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	DateKey INT
,	Period DATETIME
,	MonthNumber INT
,	FirstContactNPS INT
,	ConsultNPS INT
,	NewClientNPS INT
,	RecurringClientNPS INT
)


/********************************** Get Date data *************************************/
INSERT	INTO #Date
		SELECT	dd.DateKey
		,		dd.FullDate
		,		dd.YearNumber
		,		dd.MonthNumber
		,		dd.MonthName
		,		dd.DayOfMonth
		,		dd.FirstDateOfMonth
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate dd
		WHERE	dd.FullDate BETWEEN @PreviousYearStart AND @Today


CREATE NONCLUSTERED INDEX IDX_Date_DateKey ON #Date ( DateKey );
CREATE NONCLUSTERED INDEX IDX_Date_FullDate ON #Date ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Date_FirstDateOfMonth ON #Date ( FirstDateOfMonth );


UPDATE STATISTICS #Date;


SELECT	@MinDate = MIN(d.FullDate)
,		@MaxDate = MAX(d.FullDate)
FROM	#Date d


/********************************** Get Center data *************************************/
INSERT	INTO #Center
		SELECT	CASE WHEN ct.CenterTypeDescriptionShort IN ( 'JV', 'F' ) THEN r.RegionDescription ELSE ISNULL(cma.CenterManagementAreaDescription, 'Corporate') END AS 'Area'
		,		ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		CASE WHEN ct.CenterTypeDescription = 'Joint' THEN 'Joint Venture' ELSE ct.CenterTypeDescription END AS 'CenterType'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON r.RegionKey = ctr.RegionKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	ct.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
				AND ( ctr.CenterNumber IN ( 360, 199 ) OR ctr.Active = 'Y' )


CREATE NONCLUSTERED INDEX IDX_Center_CenterSSID ON #Center ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


UPDATE STATISTICS #Center;


/********************************** Get Survey data *************************************/
INSERT	INTO #Survey
		SELECT	ROW_NUMBER() OVER ( PARTITION BY src.Lead__c, src.Trigger_Task_Id__c ORDER BY src.Completion_Time__c ASC ) AS 'RowID'
		,		d.DateKey
		,		d.FirstDateOfMonth AS 'Period'
		,		d.MonthNumber
		,		src.Survey_Name__c
		,		src.Lead__c
		,		src.Trigger_Task_Id__c
		,		t.Action__c
		,		t.Result__c
		,		ctr.Area
		,		ctr.CenterKey
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
		FROM	HC_BI_SFDC.dbo.Survey_Response__c src
				INNER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = src.Lead__c
				INNER JOIN HC_BI_SFDC.dbo.Task t
					ON t.Id = src.Trigger_Task_Id__c
				INNER JOIN #Date d
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
		,		s.CenterKey
		,		s.CenterSSID
		,		s.CenterNumber
		,		s.CenterDescription
		,		s.DateKey
		,		s.Period
		,		s.MonthNumber
		,		AVG(s.GF1_100__c) AS 'FirstContactNPS'
		,		AVG(s.GF2_90__c) AS 'ConsultNPS'
		,		AVG(s.GF3230__c) AS 'NewClientNPS'
		,		AVG(s.GF4320__c) AS 'RecurringClientNPS'
		FROM	#Survey s
		GROUP BY s.AreaDescription
		,		s.CenterKey
		,		s.CenterSSID
		,		s.CenterNumber
		,		s.CenterDescription
		,		s.DateKey
		,		s.Period
		,		s.MonthNumber
		ORDER BY s.CenterNumber


CREATE NONCLUSTERED INDEX IDX_SurveyKPI_AreaDescription ON #SurveyKPI ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_CenterSSID ON #SurveyKPI ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_CenterNumber ON #SurveyKPI ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_CenterDescription ON #SurveyKPI ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_SurveyKPI_Period ON #SurveyKPI ( Period );


UPDATE STATISTICS #SurveyKPI;


/********************************** Insert Data into Dashboard tables *************************************/
TRUNCATE TABLE dbNPS


INSERT	INTO dbNPS
		SELECT	sk.CenterKey
		,		sk.Period AS 'FullDate'
		,		sk.FirstContactNPS
		,		sk.ConsultNPS
		,		sk.NewClientNPS
		,		sk.RecurringClientNPS
		FROM	#SurveyKPI sk

END
