/* CreateDate: 04/19/2019 14:13:35.957 , ModifyDate: 04/23/2019 11:49:47.793 */
GO
/***********************************************************************
PROCEDURE:				spDB_GetLASSByCampaignDashboardData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/19/2019
DESCRIPTION:			Used to get data for the LASS By Campaign dashboard
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_GetLASSByCampaignDashboardData
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_GetLASSByCampaignDashboardData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
,		@EndDate DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @StartDate = DATEADD(YEAR, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0))
SET @EndDate = CAST(DATEADD(DAY, -1, CURRENT_TIMESTAMP) AS DATE)


/* Create temp table objects */
CREATE TABLE #Center (
	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
)

CREATE TABLE #CenterOwnership (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
)

CREATE TABLE #Date (
	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	MonthNumber INT
,	MonthName NVARCHAR(10)
,	YearNumber INT
,	QuarterShortName NVARCHAR(50)
)

CREATE TABLE #Campaign (
	CampaignID NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	Channel NVARCHAR(50)
,	Language NVARCHAR(50)
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	Format NVARCHAR(50)
,	Gender NVARCHAR(50)
,	CommunicationType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
)

CREATE TABLE #CombinedData (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	MonthNumber INT
,	MonthName NVARCHAR(10)
,	YearNumber INT
,	QuarterShortName NVARCHAR(50)
,	CampaignID NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	Channel NVARCHAR(50)
,	Language NVARCHAR(50)
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	Format NVARCHAR(50)
,	Gender NVARCHAR(50)
,	CommunicationType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
)

CREATE TABLE #LeadOriginal (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	OriginalCampaignID NVARCHAR(18)
,	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	OriginalCampaignLeadTotal INT
)

CREATE TABLE #LeadRecent (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	RecentCampaignID NVARCHAR(18)
,	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	RecentCampaignLeadTotal INT
)

CREATE TABLE #Appointments (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	AppointmentTotal INT
)

CREATE TABLE #Shows (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	ShowTotal INT
)

CREATE TABLE #Sales (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	SaleTotal INT
)

CREATE TABLE #Final (
	CenterOwnership NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	FirstDateOfMonth DATETIME
,	LastDateOfMonth DATETIME
,	MonthNumber INT
,	MonthName NVARCHAR(10)
,	YearNumber INT
,	QuarterShortName NVARCHAR(50)
,	CampaignID NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	Channel NVARCHAR(50)
,	Language NVARCHAR(50)
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	Format NVARCHAR(50)
,	Gender NVARCHAR(50)
,	CommunicationType NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	OriginalCampaignLeadTotal INT
,	RecentCampaignLeadTotal INT
,	AppointmentTotal INT
,	ShowTotal INT
,	SaleTotal INT
)


/* Get Center data */
INSERT	INTO #Center
		SELECT  ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		dco.CenterOwnershipDescription AS 'CenterOwnership'
		,		REPLACE(dct.CenterTypeDescription, 'Joint', 'Franchise') AS 'CenterType'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterOwnership dco
					ON dco.CenterOwnershipKey = ctr.CenterOwnershipKey
		WHERE   dct.CenterTypeDescriptionShort IN ( 'C', 'F', 'JV', 'HW' )
				AND ctr.CenterNumber <> 340
				AND ctr.Active = 'Y'


CREATE NONCLUSTERED INDEX IDX_Center_CenterSSID ON #Center ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Center_CenterOwnership ON #Center ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_Center_CenterType ON #Center ( CenterType );


/* Get Center Ownership data */
INSERT	INTO #CenterOwnership
		SELECT  c.CenterOwnership
		,		c.CenterType
		FROM    #Center c
		GROUP BY c.CenterOwnership
		,		c.CenterType


CREATE NONCLUSTERED INDEX IDX_CenterOwnership_CenterOwnership ON #CenterOwnership ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_CenterOwnership_CenterType ON #CenterOwnership ( CenterType );


/* Get Dates data */
INSERT	INTO #Date
		SELECT	dd.FirstDateOfMonth
		,		dd.LastDateOfMonth
		,		dd.MonthNumber
		,		dd.MonthName
		,		dd.YearNumber
		,		dd.QuarterShortName
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate dd
		WHERE	dd.FullDate BETWEEN @StartDate AND @EndDate
		GROUP BY dd.FirstDateOfMonth
		,		dd.LastDateOfMonth
		,		dd.MonthNumber
		,		dd.MonthName
		,		dd.YearNumber
		,		dd.QuarterShortName


CREATE NONCLUSTERED INDEX IDX_Date_Dates ON #Date ( FirstDateOfMonth, LastDateOfMonth );


SELECT	@MinDate = MIN(d.FirstDateOfMonth)
,		@MaxDate = MAX(d.LastDateOfMonth)
FROM	#Date d


/* Get Campaign data */
INSERT	INTO #Campaign
		SELECT	c.Id
		,		c.Name
		,		c.CampaignType__c
		,		c.Channel__c
		,		c.Language__c
		,		c.Media__c
		,		c.Source__c
		,		c.Format__c
		,		c.Gender__c
		,		c.CommunicationType__c
		,		c.SourceCode_L__c
		FROM	Campaign c
		WHERE	( c.StartDate BETWEEN @StartDate AND @EndDate
					OR c.EndDate BETWEEN @StartDate AND @EndDate )
				AND ISNULL(c.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Campaign_CampaignID ON #Campaign ( CampaignID );
CREATE NONCLUSTERED INDEX IDX_Campaign_SourceCode ON #Campaign ( SourceCode );


/* Combine Center Ownership, Date & Campaign data */
INSERT	INTO #CombinedData
		SELECT	co.CenterOwnership
		,		co.CenterType
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth
		,		d.MonthNumber
		,		d.MonthName
		,		d.YearNumber
		,		d.QuarterShortName
		,		c.CampaignID
		,		c.CampaignName
		,		c.CampaignType
		,		c.Channel
		,		c.Language
		,		c.Media
		,		c.Origin
		,		c.Format
		,		c.Gender
		,		c.CommunicationType
		,		c.SourceCode
		FROM	#CenterOwnership co
		,		#Date d
		,		#Campaign c


CREATE NONCLUSTERED INDEX IDX_CombinedData_CenterOwnership ON #CombinedData ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_CombinedData_FirstDateOfMonth ON #CombinedData ( FirstDateOfMonth );
CREATE NONCLUSTERED INDEX IDX_CombinedData_LastDateOfMonth ON #CombinedData ( LastDateOfMonth );
CREATE NONCLUSTERED INDEX IDX_CombinedData_CampaignID ON #CombinedData ( CampaignID );
CREATE NONCLUSTERED INDEX IDX_CombinedData_SourceCode ON #CombinedData ( SourceCode );


/* Get Leads where the Original Campaign Id equals to one of the campaigns */
INSERT	INTO #LeadOriginal
		SELECT	c.CenterOwnership
		,		c.CenterType
		,		l.OriginalCampaignID__c AS 'OriginalCampaignID'
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth
		,		COUNT(*) AS 'OriginalCampaignLeadTotal'
		FROM	Lead l
				INNER JOIN #Date d
					ON CAST(l.ReportCreateDate__c AS DATE) BETWEEN d.FirstDateOfMonth AND d.LastDateOfMonth
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(l.CenterID__c, l.CenterNumber__c)
		WHERE	l.Status IN ( 'Lead', 'Client' )
				AND ISNULL(l.IsDeleted, 0) = 0
		GROUP BY c.CenterOwnership
		,		c.CenterType
		,		l.OriginalCampaignID__c
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth


CREATE NONCLUSTERED INDEX IDX_LeadOriginal_CenterOwnership ON #LeadOriginal ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_LeadOriginal_OriginalCampaignID ON #LeadOriginal ( OriginalCampaignID );
CREATE NONCLUSTERED INDEX IDX_LeadOriginal_Dates ON #LeadOriginal ( FirstDateOfMonth, LastDateOfMonth );


/* Get Leads where the Recent Campaign Id equals to one of the campaigns */
INSERT	INTO #LeadRecent
		SELECT	c.CenterOwnership
		,		c.CenterType
		,		l.RecentCampaignID__c AS 'RecentCampaignID'
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth
		,		COUNT(*) AS 'RecentCampaignLeadTotal'
		FROM	Lead l
				INNER JOIN #Date d
					ON CAST(l.ReportCreateDate__c AS DATE) BETWEEN d.FirstDateOfMonth AND d.LastDateOfMonth
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(l.CenterID__c, l.CenterNumber__c)
		WHERE	l.Status IN ( 'Lead', 'Client' )
				AND ISNULL(l.IsDeleted, 0) = 0
		GROUP BY c.CenterOwnership
		,		c.CenterType
		,		l.RecentCampaignID__c
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth


CREATE NONCLUSTERED INDEX IDX_LeadRecent_CenterOwnership ON #LeadRecent ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_LeadRecent_RecentCampaignID ON #LeadRecent ( RecentCampaignID );
CREATE NONCLUSTERED INDEX IDX_LeadRecent_Dates ON #LeadRecent ( FirstDateOfMonth, LastDateOfMonth );


/* Get Appointments where the Task Source Code equals to one of the campaigns */
INSERT	INTO #Appointments
		SELECT	c.CenterOwnership
		,		c.CenterType
		,		ISNULL(t.SourceCode__c, cm.SourceCode) AS 'SourceCode'
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth
		,		COUNT(*) AS 'AppointmentTotal'
		FROM	Task t
				INNER JOIN Lead l
					ON l.Id = t.WhoId
				INNER JOIN #Campaign cm
					ON cm.CampaignID = l.RecentCampaignID__c
				INNER JOIN #Date d
					ON CAST(t.ActivityDate AS DATE) BETWEEN d.FirstDateOfMonth AND d.LastDateOfMonth
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(t.CenterID__c, t.CenterNumber__c)
		WHERE	t.Action__c IN ( 'Appointment', 'In House' )
				AND ( t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Void', 'Center Exception' )
					OR ISNULL(t.Result__c, '') = '' )
				AND ISNULL(t.IsDeleted, 0) = 0
		GROUP BY c.CenterOwnership
		,		c.CenterType
		,		ISNULL(t.SourceCode__c, cm.SourceCode)
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Appointments_CenterOwnership ON #Appointments ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_Appointments_SourceCode ON #Appointments ( SourceCode );
CREATE NONCLUSTERED INDEX IDX_Appointments_Dates ON #Appointments ( FirstDateOfMonth, LastDateOfMonth );


/* Get Shows where the Task Source Code equals to one of the campaigns */
INSERT	INTO #Shows
		SELECT	c.CenterOwnership
		,		c.CenterType
		,		ISNULL(t.SourceCode__c, cm.SourceCode) AS 'SourceCode'
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth
		,		COUNT(*) AS 'ShowTotal'
		FROM	Task t
				INNER JOIN Lead l
					ON l.Id = t.WhoId
				INNER JOIN #Campaign cm
					ON cm.CampaignID = l.RecentCampaignID__c
				INNER JOIN #Date d
					ON CAST(t.ActivityDate AS DATE) BETWEEN d.FirstDateOfMonth AND d.LastDateOfMonth
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(t.CenterID__c, t.CenterNumber__c)
		WHERE	t.Result__c IN ( 'Show Sale', 'Show No Sale' )
				AND ISNULL(t.IsDeleted, 0) = 0
		GROUP BY c.CenterOwnership
		,		c.CenterType
		,		ISNULL(t.SourceCode__c, cm.SourceCode)
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Shows_CenterOwnership ON #Shows ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_Shows_SourceCode ON #Shows ( SourceCode );
CREATE NONCLUSTERED INDEX IDX_Shows_Dates ON #Shows ( FirstDateOfMonth, LastDateOfMonth );


/* Get Sales where the Task Source Code equals to one of the campaigns */
INSERT	INTO #Sales
		SELECT	c.CenterOwnership
		,		c.CenterType
		,		ISNULL(t.SourceCode__c, cm.SourceCode) AS 'SourceCode'
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth
		,		COUNT(*) AS 'SaleTotal'
		FROM	Task t
				INNER JOIN Lead l
					ON l.Id = t.WhoId
				INNER JOIN #Campaign cm
					ON cm.CampaignID = l.RecentCampaignID__c
				INNER JOIN #Date d
					ON CAST(t.ActivityDate AS DATE) BETWEEN d.FirstDateOfMonth AND d.LastDateOfMonth
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(t.CenterID__c, t.CenterNumber__c)
		WHERE	t.Result__c IN ( 'Show Sale' )
				AND ISNULL(t.IsDeleted, 0) = 0
		GROUP BY c.CenterOwnership
		,		c.CenterType
		,		ISNULL(t.SourceCode__c, cm.SourceCode)
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Sales_CenterOwnership ON #Sales ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_Sales_SourceCode ON #Sales ( SourceCode );
CREATE NONCLUSTERED INDEX IDX_Sales_Dates ON #Sales ( FirstDateOfMonth, LastDateOfMonth );


/* Get Final Data with Totals */
INSERT	INTO #Final
		SELECT	cd.CenterOwnership
		,		cd.CenterType
		,		cd.FirstDateOfMonth
		,		cd.LastDateOfMonth
		,		cd.MonthNumber
		,		cd.MonthName
		,		cd.YearNumber
		,		cd.QuarterShortName
		,		cd.CampaignID
		,		cd.CampaignName
		,		cd.CampaignType
		,		cd.Channel
		,		cd.Language
		,		cd.Media
		,		cd.Origin
		,		cd.Format
		,		cd.Gender
		,		cd.CommunicationType
		,		cd.SourceCode
		,		(SELECT ISNULL(SUM(lo.OriginalCampaignLeadTotal), 0) FROM #LeadOriginal lo WHERE lo.CenterOwnership = cd.CenterOwnership AND lo.FirstDateOfMonth = cd.FirstDateOfMonth AND lo.LastDateOfMonth = cd.LastDateOfMonth AND lo.OriginalCampaignID = cd.CampaignID) AS 'OriginalCampaignLeadTotal'
		,		(SELECT ISNULL(SUM(lr.RecentCampaignLeadTotal), 0) FROM #LeadRecent lr WHERE lr.CenterOwnership = cd.CenterOwnership AND lr.FirstDateOfMonth = cd.FirstDateOfMonth AND lr.LastDateOfMonth = cd.LastDateOfMonth AND lr.RecentCampaignID = cd.CampaignID) AS 'RecentCampaignLeadTotal'
		,		(SELECT ISNULL(SUM(a.AppointmentTotal), 0) FROM #Appointments a WHERE a.CenterOwnership = cd.CenterOwnership AND a.FirstDateOfMonth = cd.FirstDateOfMonth AND a.LastDateOfMonth = cd.LastDateOfMonth AND a.SourceCode = cd.SourceCode) AS 'AppointmentTotal'
		,		(SELECT ISNULL(SUM(s.ShowTotal), 0) FROM #Shows s WHERE s.CenterOwnership = cd.CenterOwnership AND s.FirstDateOfMonth = cd.FirstDateOfMonth AND s.LastDateOfMonth = cd.LastDateOfMonth AND s.SourceCode = cd.SourceCode) AS 'ShowTotal'
		,		(SELECT ISNULL(SUM(sl.SaleTotal), 0) FROM #Sales sl WHERE sl.CenterOwnership = cd.CenterOwnership AND sl.FirstDateOfMonth = cd.FirstDateOfMonth AND sl.LastDateOfMonth = cd.LastDateOfMonth AND sl.SourceCode = cd.SourceCode) AS 'SaleTotal'
		FROM	#CombinedData cd


CREATE NONCLUSTERED INDEX IDX_Final_CenterOwnership ON #Final ( CenterOwnership );
CREATE NONCLUSTERED INDEX IDX_Final_FirstDateOfMonth ON #Final ( FirstDateOfMonth );
CREATE NONCLUSTERED INDEX IDX_Final_LastDateOfMonth ON #Final ( LastDateOfMonth );
CREATE NONCLUSTERED INDEX IDX_Final_CampaignID ON #Final ( CampaignID );
CREATE NONCLUSTERED INDEX IDX_Final_CampaignName ON #Final ( CampaignName );
CREATE NONCLUSTERED INDEX IDX_Final_SourceCode ON #Final ( SourceCode );


/* Return Final Data with Totals */
SELECT	f.CenterOwnership
,		f.CenterType
,		f.FirstDateOfMonth
,		f.LastDateOfMonth
,		f.MonthNumber
,		f.MonthName
,		f.YearNumber
,		f.QuarterShortName
,		f.CampaignID
,		f.CampaignName
,		f.CampaignType
,		f.Channel
,		f.Language
,		f.Media
,		f.Origin
,		f.Format
,		f.Gender
,		f.CommunicationType
,		f.SourceCode
,		f.OriginalCampaignLeadTotal
,		f.RecentCampaignLeadTotal
,		f.AppointmentTotal
,		f.ShowTotal
,		f.SaleTotal
FROM	#Final f

END
GO
