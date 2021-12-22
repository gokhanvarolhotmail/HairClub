/***********************************************************************
PROCEDURE:				spDB_PopulateARDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/31/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateARDashboard
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateARDashboard]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Today DATETIME
,		@Yesterday DATETIME
,		@StartDate DATETIME
,		@EndDate DATETIME
,		@CurrentMonthEndDate DATETIME
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@PreviousYearStart DATETIME
,		@PreviousYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @Today = CAST(DATEADD(DAY, 0, CURRENT_TIMESTAMP) AS DATE)
SET @Yesterday = CAST(DATEADD(DAY, -1, @Today) AS DATE)
SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today), 0))
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @Today)) +1, 0))
SET @CurrentMonthEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today) +1, 0))
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
,	LastDateOfMonth DATETIME
)

CREATE TABLE #Center (
	Area VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
)

CREATE TABLE #Receivables (
	AreaDescription NVARCHAR(100)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	Period DATETIME
,	PeriodEndDate DATETIME
,	ReceivablesBalance REAL
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
		,		dd.LastDateOfMonth
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


/********************************** Get Receivables data *************************************/
INSERT	INTO #Receivables
		SELECT	c.Area
		,		c.CenterKey
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth
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
					ON CASE WHEN d.LastDateOfMonth = @CurrentMonthEndDate THEN @Yesterday ELSE d.LastDateOfMonth END = dd.FullDate
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
		GROUP BY c.Area
		,		c.CenterKey
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		d.FirstDateOfMonth
		,		d.LastDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Receivables_AreaDescription ON #Receivables ( AreaDescription );
CREATE NONCLUSTERED INDEX IDX_Receivables_CenterSSID ON #Receivables ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Receivables_CenterNumber ON #Receivables ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Receivables_CenterDescription ON #Receivables ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_Receivables_Period ON #Receivables ( Period );
CREATE NONCLUSTERED INDEX IDX_Receivables_PeriodEndDate ON #Receivables ( PeriodEndDate );


UPDATE STATISTICS #Receivables;


/********************************** Get Receivables data *************************************/
TRUNCATE TABLE dbAccountsReceivable


INSERT	INTO dbAccountsReceivable
		SELECT	r.CenterKey
		,		r.PeriodEndDate AS 'FullDate'
		,		r.ReceivablesBalance
		FROM	#Receivables r
		ORDER BY r.PeriodEndDate
		,		r.CenterKey

END
