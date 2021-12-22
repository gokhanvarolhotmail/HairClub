/***********************************************************************
PROCEDURE:				spDB_PopulateLASSDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		6/5/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

09/08/2020	KMurdoch	Added new Lead Statuses 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'
10/01/2020	DLeiba		Added function for Lead Validation
02/16/2021  KMurdoch    Added to Center join to account for Null CenterNumber & CenterID
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateLASSDashboard
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateLASSDashboard]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Today DATETIME
,		@Yesterday DATETIME
,		@CurrentMonthStart DATETIME
,		@CurrentMonthEnd DATETIME
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @Today = CAST(DATEADD(DAY, 0, CURRENT_TIMESTAMP) AS DATE)
--SET @Today = CASE WHEN ( DATENAME(WEEKDAY, @Today) IN ( 'Monday', 'Tuesday', 'Wednesday' ) AND DAY(@Today) = 1 ) OR ( DATENAME(WEEKDAY, @Today) = 'Tuesday' AND DAY(@Today) = 2 ) THEN DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, GETDATE())) +1, 0)) ELSE @Today END
SET @Yesterday = DATEADD(DAY, -1, @Today)
SET @CurrentMonthStart = DATEADD(DAY, 0, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today), 0))
SET @CurrentMonthEnd = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today) +1, 0))
SET @CurrentYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)
SET @CurrentYearEnd = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)))


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

CREATE TABLE #Campaign (
	SourceCodeID NVARCHAR(18)
,	SourceCode NVARCHAR(50)
,	Creative NVARCHAR(50)
)

CREATE TABLE #SourceCode (
	RowID INT IDENTITY(1, 1)
,	SourceCodeID NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	DPNCode NVARCHAR(50)
,	DWFCode NVARCHAR(50)
,	DWCCode NVARCHAR(50)
,	MPNCode NVARCHAR(50)
,	MWFCode NVARCHAR(50)
,	MWCCode NVARCHAR(50)
,	Channel NVARCHAR(50)
,	OwnerType NVARCHAR(50)
,	Gender NVARCHAR(50)
,	Goal NVARCHAR(50)
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	Location NVARCHAR(50)
,	Language NVARCHAR(50)
,	Format NVARCHAR(50)
,	Creative NVARCHAR(50)
,	Number NVARCHAR(50)
,	DNIS NVARCHAR(50)
,	PromoCode NVARCHAR(50)
,	PromoCodeDescription NVARCHAR(500)
,	StartDate DATETIME
,	EndDate DATETIME
,	Status NVARCHAR(50)
,	IsActive BIT
,	CreatedDate DATETIME
,	LastModifiedDate DATETIME
)

CREATE TABLE #DuplicateSource (
	SourceCode NVARCHAR(50)
)

CREATE TABLE #CleanupSource (
	RowID INT
,	SourceCodeRowID INT
,	SourceCodeID NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	DPNCode NVARCHAR(50)
,	DWFCode NVARCHAR(50)
,	DWCCode NVARCHAR(50)
,	MPNCode NVARCHAR(50)
,	MWFCode NVARCHAR(50)
,	MWCCode NVARCHAR(50)
,	Channel NVARCHAR(50)
,	OwnerType NVARCHAR(50)
,	Gender NVARCHAR(50)
,	Goal NVARCHAR(50)
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	Location NVARCHAR(50)
,	Language NVARCHAR(50)
,	Format NVARCHAR(50)
,	Creative NVARCHAR(50)
,	Number NVARCHAR(50)
,	DNIS NVARCHAR(50)
,	PromoCode NVARCHAR(50)
,	PromoCodeDescription NVARCHAR(500)
,	StartDate DATETIME
,	EndDate DATETIME
,	Status NVARCHAR(50)
,	IsActive BIT
,	CreatedDate DATETIME
,	LastModifiedDate DATETIME
)

CREATE TABLE #Lead (
	FirstDateOfMonth DATETIME
,	FullDate DATETIME
,	Id NVARCHAR(18)
,	CenterNumber INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(80)
,	LeadStatus NVARCHAR(50)
,	SourceCode NVARCHAR(50)
)

CREATE TABLE #Task (
	FirstDateOfMonth DATETIME
,	FullDate DATETIME
,	Id NVARCHAR(18)
,	CenterNumber INT
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	ExcludeFromConsults INT
,	ExcludeFromBeBacks INT
)

CREATE TABLE #LASS (
	Area NVARCHAR(100)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	FirstDateOfMonth DATETIME
,	FullDate DATETIME
,	SourceCode NVARCHAR(50)
,	CampaignName NVARCHAR(80)
,	OwnerType NVARCHAR(50)
,	Channel NVARCHAR(50)
,	Gender NVARCHAR(50)
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	[Location] NVARCHAR(50)
,	[Language] NVARCHAR(50)
,	[Format] NVARCHAR(50)
,	DeviceType NVARCHAR(50)
,	TollfreeNumber NVARCHAR(50)
,	Leads INT
,	Appointments INT
,	Consultations INT
,	BeBacks INT
,	Inhouses INT
,	Shows INT
,	Sales INT
,	NoShows INT
,	NoSales INT
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
		WHERE	dd.FullDate BETWEEN @CurrentYearStart AND @Yesterday


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
		,		ct.CenterTypeDescription AS 'CenterType'
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


/********************************** Get Campaign data *************************************/
INSERT  INTO #Campaign
		SELECT  c.Id
		,		c.SourceCode_L__c
		,		NULL AS 'Creative'
		FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.IsDeleted = 0
		UNION
		SELECT  c.Id
		,		c.DPNCode__c
		,		'Desktop Phone' AS 'Creative'
		FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	( c.DPNCode__c IS NOT NULL
					AND c.DPNCode__c <> c.SourceCode_L__c )
				AND c.IsDeleted = 0
		UNION
		SELECT  c.Id
		,		c.DWFCode__c
		,		'Desktop Form' AS 'Creative'
		FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.DWFCode__c IS NOT NULL
				AND c.IsDeleted = 0
		UNION
		SELECT  c.Id
		,		c.DWCCode__c
		,		'Desktop Chat' AS 'Creative'
		FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.DWCCode__c IS NOT NULL
				AND c.IsDeleted = 0
		UNION
		SELECT  c.Id
		,		c.MPNCode__c
		,		'Mobile Phone' AS 'Creative'
		FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.MPNCode__c IS NOT NULL
				AND c.IsDeleted = 0
		UNION
		SELECT  c.Id
		,		c.MWFCode__c
		,		'Mobile Form' AS 'Creative'
		FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.MWFCode__c IS NOT NULL
				AND c.IsDeleted = 0
		UNION
		SELECT  c.Id
		,		c.MWCCode__c
		,		'Mobile Chat' AS 'Creative'
		FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.MWCCode__c IS NOT NULL
				AND c.IsDeleted = 0


CREATE NONCLUSTERED INDEX IDX_Campaign_SourceCodeID ON #Campaign ( SourceCodeID );
CREATE NONCLUSTERED INDEX IDX_Campaign_SourceCode ON #Campaign ( SourceCode );


UPDATE STATISTICS #Campaign;


DELETE FROM #Campaign WHERE SourceCodeID IN ( '701f4000000U71nAAC', '701f4000000U71mAAC' )


INSERT	INTO #SourceCode
		SELECT  c.SourceCodeID
		,		(SELECT Name FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignName'
		,		(SELECT CampaignType__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignType'
		,		c.SourceCode
		,		(SELECT DPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DPNCode'
		,		(SELECT DWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWFCode'
		,		(SELECT DWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWCCode'
		,		(SELECT MPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MPNCode'
		,		(SELECT MWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWFCode'
		,		(SELECT MWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWCCode'
		,		(SELECT Channel__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Channel'
		,		(SELECT Type FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'OwnerType'
		,		(SELECT Gender__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Gender'
		,		(SELECT Goal__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Goal'
		,		(SELECT Media__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Media'
		,		(SELECT Source__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Origin'
		,		(SELECT Location__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Location'
		,		(SELECT Language__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Language'
		,		(SELECT Format__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Format'
		,		c.Creative
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN '(' + LEFT(TollFreeMobileName__c, 3) + ') ' + SUBSTRING(TollFreeMobileName__c, 4, 3) + '-' + SUBSTRING(TollFreeMobileName__c, 7, 4) ELSE CASE WHEN c.SourceCode = DPNCode__c THEN '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) ELSE '' END END ELSE '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'Number'
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN DNISMobile__c ELSE CASE WHEN c.SourceCode = DPNCode__c THEN DNIS__c ELSE '' END END ELSE DNIS__c END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'DNIS'
		,		(SELECT PromoCodeName__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCode'
		,		(SELECT PromoCodeDisplay__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCodeDescription'
		,		(SELECT StartDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'StartDate'
		,		(SELECT EndDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'EndDate'
		,		(SELECT Status FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Status'
		,		(SELECT IsActive FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'IsActive'
		,		(SELECT CreatedDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CreatedDate'
		,		(SELECT LastModifiedDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'LastModifiedDate'
		FROM    #Campaign c
		ORDER BY c.SourceCodeID
		,		c.SourceCode


CREATE NONCLUSTERED INDEX IDX_SourceCode_SourceCodeID ON #SourceCode ( SourceCodeID );
CREATE NONCLUSTERED INDEX IDX_SourceCode_SourceCode ON #SourceCode ( SourceCode );


UPDATE STATISTICS #SourceCode;


-- Get Duplicate Source Codes
INSERT	INTO #DuplicateSource
		SELECT  sc.SourceCode
		FROM    #SourceCode sc
		GROUP BY sc.SourceCode
		HAVING  COUNT(*) > 1


CREATE NONCLUSTERED INDEX IDX_DuplicateSource_SourceCode ON #DuplicateSource ( SourceCode );


UPDATE STATISTICS #DuplicateSource;


-- Remove Inactive Duplicate Source Codes
INSERT	INTO #CleanupSource
		SELECT  ROW_NUMBER() OVER ( PARTITION BY sc.SourceCode ORDER BY sc.IsActive DESC, sc.DPNCode DESC, sc.DWFCode DESC, sc.DWCCode DESC, sc.MPNCode DESC, sc.MWFCode DESC, sc.MWCCode DESC, sc.Number DESC, sc.StartDate DESC, sc.EndDate DESC, sc.CreatedDate ASC ) AS 'RowID'
		,		sc.RowID
		,		sc.SourceCodeID
		,		sc.CampaignName
		,		sc.CampaignType
		,		sc.SourceCode
		,		sc.DPNCode
		,		sc.DWFCode
		,		sc.DWCCode
		,		sc.MPNCode
		,		sc.MWFCode
		,		sc.MWCCode
		,		sc.Channel
		,		sc.OwnerType
		,		sc.Gender
		,		sc.Goal
		,		sc.Media
		,		sc.Origin
		,		sc.Location
		,		sc.Language
		,		sc.Format
		,		sc.Creative
		,		sc.Number
		,		sc.DNIS
		,		sc.PromoCode
		,		sc.PromoCodeDescription
		,		sc.StartDate
		,		sc.EndDate
		,		sc.Status
		,		sc.IsActive
		,		sc.CreatedDate
		,		sc.LastModifiedDate
		FROM    #SourceCode sc
				INNER JOIN #DuplicateSource ds
					ON ds.SourceCode = sc.SourceCode
		ORDER BY sc.SourceCode


CREATE NONCLUSTERED INDEX IDX_CleanupSource_SourceCodeID ON #CleanupSource ( SourceCodeID );
CREATE NONCLUSTERED INDEX IDX_CleanupSource_SourceCode ON #CleanupSource ( SourceCode );


UPDATE STATISTICS #CleanupSource;


-- Cleanup Duplicates
DELETE	sc
FROM	#SourceCode sc
		CROSS APPLY (
						SELECT	*
						FROM	#CleanupSource cs
						WHERE	cs.SourceCodeID = sc.SourceCodeID
								AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
								AND cs.Status = 'Merged'
					) x_Cs


DELETE	sc
FROM	#SourceCode sc
		CROSS APPLY (
						SELECT	*
						FROM	#CleanupSource cs
						WHERE	cs.SourceCodeID = sc.SourceCodeID
								AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
								AND cs.Status = 'Completed'
					) x_Cs



DELETE	sc
FROM	#SourceCode sc
		CROSS APPLY (
						SELECT	*
						FROM	#CleanupSource cs
						WHERE	cs.SourceCodeID = sc.SourceCodeID
								AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
								AND cs.Status NOT IN ( 'Completed', 'Merged' )
					) x_Cs


/********************************** Get Lead data *************************************/
INSERT	INTO #Lead
		SELECT  d.FirstDateOfMonth
		,		d.FullDate
		,		l.Id
		,		ISNULL(ISNULL(l.CenterNumber__c, l.CenterID__c),100)
		,		l.FirstName
		,		l.LastName
		,		CASE WHEN l.Source_Code_Legacy__c = 'DGEMAEXDREM11680' THEN 'Prospect' ELSE l.Status END AS 'LeadStatus'
		,		l.Source_Code_Legacy__c
		FROM    HC_BI_SFDC.dbo.Lead l
				INNER JOIN #Date d
					ON d.FullDate = CAST(l.ReportCreateDate__c AS DATE)
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(ISNULL(l.CenterNumber__c, l.CenterID__c),100)
				OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
		WHERE   l.Status IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
				AND ISNULL(fil.IsInvalidLead, 0) = 0
				AND ISNULL(l.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Lead_FirstDateOfMonth ON #Lead ( FirstDateOfMonth );
CREATE NONCLUSTERED INDEX IDX_Lead_FullDate ON #Lead ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Lead_Id ON #Lead ( Id );
CREATE NONCLUSTERED INDEX IDX_Lead_CenterNumber ON #Lead ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Lead_SourceCode ON #Lead ( SourceCode );


UPDATE STATISTICS #Lead;


/********************************** Get Task data *************************************/
INSERT	INTO #Task
		SELECT  d.FirstDateOfMonth
		,		d.FullDate
		,		t.Id
		,		ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c),100)
		,		t.Action__c
		,		t.Result__c
		,		t.SourceCode__c
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
		FROM    HC_BI_SFDC.dbo.Task t
				INNER JOIN #Date d
					ON d.FullDate = CAST(t.ActivityDate AS DATE)
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c),100)
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = t.WhoId
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a
					ON a.PersonContactId = t.WhoId
		WHERE   LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
				AND ISNULL(t.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Task_FirstDateOfMonth ON #Task ( FirstDateOfMonth );
CREATE NONCLUSTERED INDEX IDX_Task_FullDate ON #Task ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Task_Id ON #Task ( Id );
CREATE NONCLUSTERED INDEX IDX_Task_CenterNumber ON #Task ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Task_Action__c ON #Task ( Action__c );
CREATE NONCLUSTERED INDEX IDX_Task_Result__c ON #Task ( Result__c );
CREATE NONCLUSTERED INDEX IDX_Task_SourceCode ON #Task ( SourceCode );


UPDATE STATISTICS #Task;


/********************************** Combine Data *************************************/

-- Salesforce Leads
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		l.FirstDateOfMonth
		,		l.FullDate
		,		l.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = l.SourceCode) AS 'TollfreeNumber'
		,		1 AS 'Leads'
		,		0 AS 'Appointments'
		,		0 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		0 AS 'Shows'
		,		0 AS 'Sales'
		,		0 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Lead l
				INNER JOIN #Center c
					ON c.CenterNumber = l.CenterNumber


-- Salesforce Appointments
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		1 AS 'Appointments'
		,		0 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		0 AS 'Shows'
		,		0 AS 'Sales'
		,		0 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	t.Action__c IN ( 'Appointment', 'In House', 'Recovery' )
				AND ISNULL(t.Result__c, '') NOT IN ( 'Void', 'Cancel', 'Reschedule', 'Center Exception' )


-- Salesforce Consultations
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		0 AS 'Appointments'
		,		1 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		0 AS 'Shows'
		,		0 AS 'Sales'
		,		0 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' )
				AND ISNULL(t.ExcludeFromConsults, 0) = 0


-- Salesforce BeBacks
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		0 AS 'Appointments'
		,		0 AS 'Consultations'
		,		1 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		0 AS 'Shows'
		,		0 AS 'Sales'
		,		0 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	t.Action__c IN ( 'Be Back' )
				AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' )
				AND ISNULL(t.ExcludeFromBeBacks, 0) = 0


-- Salesforce InHouses
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		0 AS 'Appointments'
		,		0 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		1 AS 'Inhouses'
		,		0 AS 'Shows'
		,		0 AS 'Sales'
		,		0 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	t.Action__c IN ( 'In House' )


-- Salesforce Shows
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		0 AS 'Appointments'
		,		0 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		1 AS 'Shows'
		,		0 AS 'Sales'
		,		0 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' )


-- Salesforce Sales
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		0 AS 'Appointments'
		,		0 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		0 AS 'Shows'
		,		1 AS 'Sales'
		,		0 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	ISNULL(t.Result__c, '') = 'Show Sale'


-- Salesforce No Shows
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		0 AS 'Appointments'
		,		0 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		0 AS 'Shows'
		,		0 AS 'Sales'
		,		1 AS 'NoShows'
		,		0 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	ISNULL(t.Result__c, '') = 'No Show'


-- Salesforce No Sales
INSERT	INTO #LASS
		SELECT	c.Area
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.CenterType
		,		t.FirstDateOfMonth
		,		t.FullDate
		,		t.SourceCode
		,		(SELECT sc.CampaignName FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.OwnerType FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Channel FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Gender FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Media FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Origin FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Location FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Language FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT sc.Format FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode)
		,		(SELECT ISNULL(sc.Creative, '') FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'DeviceType'
		,		(SELECT sc.Number FROM #SourceCode sc WHERE sc.SourceCode = t.SourceCode) AS 'TollfreeNumber'
		,		0 AS 'Leads'
		,		0 AS 'Appointments'
		,		0 AS 'Consultations'
		,		0 AS 'BeBacks'
		,		0 AS 'Inhouses'
		,		0 AS 'Shows'
		,		0 AS 'Sales'
		,		0 AS 'NoShows'
		,		1 AS 'NoSales'
		FROM	#Task t
				INNER JOIN #Center c
					ON c.CenterNumber = t.CenterNumber
		WHERE	ISNULL(t.Result__c, '') = 'Show No Sale'


/********************************** Insert Data *************************************/
TRUNCATE TABLE dbLASSDashboard


INSERT	INTO dbLASSDashboard
		SELECT	l.Area
		,		l.CenterNumber
		,		l.CenterDescription
		,		l.CenterType
		,		l.FirstDateOfMonth
		,		l.FullDate
		,		l.SourceCode
		,		l.CampaignName
		,		l.OwnerType
		,		l.Channel
		,		l.Gender
		,		l.Media
		,		l.Origin
		,		l.Location
		,		l.Language
		,		l.Format
		,		l.DeviceType
		,		l.TollfreeNumber
		,		SUM(l.Leads) AS 'Leads'
		,		SUM(l.Appointments) AS 'Appointments'
		,		SUM(l.Consultations) AS 'Consultations'
		,		SUM(l.BeBacks) AS 'BeBacks'
		,		SUM(l.Inhouses) AS 'Inhouses'
		,		SUM(l.Shows) AS 'Shows'
		,		SUM(l.Sales) AS 'Sales'
		,		SUM(l.NoShows) AS 'NoShows'
		,		SUM(l.NoSales) AS 'NoSales'
		FROM	#LASS l
		GROUP BY l.Area
		,		l.CenterNumber
		,		l.CenterDescription
		,		l.CenterType
		,		l.FirstDateOfMonth
		,		l.FullDate
		,		l.SourceCode
		,		l.CampaignName
		,		l.OwnerType
		,		l.Channel
		,		l.Gender
		,		l.Media
		,		l.Origin
		,		l.Location
		,		l.Language
		,		l.Format
		,		l.DeviceType
		,		l.TollfreeNumber

END
