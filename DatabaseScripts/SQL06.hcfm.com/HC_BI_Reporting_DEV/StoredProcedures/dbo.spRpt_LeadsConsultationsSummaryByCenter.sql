/***********************************************************************
PROCEDURE:				spRpt_LeadsConsultationsSummaryByCenter
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Leads & Consultations By Center Report
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		02/24/2014
------------------------------------------------------------------------
NOTES:

06/19/2020 - DL - Rewrote Stored Procedure.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_LeadsConsultationsSummaryByCenter
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_LeadsConsultationsSummaryByCenter]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @YesterdayStart DATETIME
,       @YesterdayEnd DATETIME
,       @CurrentMonthStart DATETIME
,       @CurrentMonthEnd DATETIME
,       @CurrentYearStart DATETIME
,       @CurrentYearEnd DATETIME
,       @CurrentQuarter INT
,       @CurrentQuarterStart DATETIME
,       @CurrentQuarterEnd DATETIME
,       @CurrentFiscalYearStart DATETIME
,       @CurrentFiscalYearEnd DATETIME
,       @MinDate DATETIME
,       @MaxDate DATETIME


CREATE TABLE #Dates (
	DateID INT
,	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	SortOrder INT
)

CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
,	Country VARCHAR(50)
,	Date DATETIME
,	Period DATETIME
)

CREATE TABLE #Final (
	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	GroupID INT
,	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterType VARCHAR(50)
,	DateID INT
,	StartDate DATETIME
,	SortOrder INT
,	EndDate DATETIME
,   Leads FLOAT
,	Consultations FLOAT
)


/********************************** Get Dates *************************************/
SET @YesterdayStart = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, GETDATE()), 101))
SET @YesterdayEnd = @YesterdayStart

SET @CurrentMonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@YesterdayStart)) + '/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
SET @CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))

SET @CurrentYearStart = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
SET @CurrentYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentYearStart))

SET @CurrentQuarter = (SELECT QuarterNumber FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @YesterdayStart, 101)))
SET @CurrentQuarterStart = (SELECT MIN(FullDate) FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE QuarterNumber = @CurrentQuarter AND YearNumber = YEAR(@YesterdayStart))
SET @CurrentQuarterEnd = (SELECT MAX(FullDate) FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE QuarterNumber = @CurrentQuarter AND YearNumber = YEAR(@YesterdayStart))

SET @CurrentFiscalYearStart = (SELECT CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(FullDate))) FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @YesterdayStart, 101)))
SET @CurrentFiscalYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentFiscalYearStart))


INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (1, 'Day', 'Day', @YesterdayStart, @YesterdayEnd, 1)


-- MTD
INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (5, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))), DATEADD(YEAR, -1, @CurrentMonthStart), DATEADD(YEAR, -1, @YesterdayEnd), 2)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (2, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentMonthStart, @YesterdayEnd, 3)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (7, 'MTD', 'Difference', @CurrentMonthStart, @YesterdayEnd, 4)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (12, 'MTD', 'Percent', @CurrentMonthStart, @YesterdayEnd, 5)


-- YTD
INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (6, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))), DATEADD(YEAR, -1, @CurrentFiscalYearStart), DATEADD(YEAR, -1, @YesterdayEnd), 6)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (4, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentFiscalYearStart, @YesterdayEnd, 7)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (8, 'YTD', 'Difference', @CurrentFiscalYearStart, @YesterdayEnd, 8)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (13, 'YTD', 'Percent', @CurrentMonthStart, @YesterdayEnd, 9)


-- QTR
INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (10, 'QTR', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))), DATEADD(YEAR, -1, @CurrentQuarterStart), DATEADD(YEAR, -1, @YesterdayEnd), 10)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (9, 'QTR', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentQuarterStart, @YesterdayEnd, 11)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (11, 'QTR', 'Difference', @CurrentQuarterStart, @YesterdayEnd, 12)

INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (14, 'QTR', 'Percent', @CurrentMonthStart, @YesterdayEnd, 13)


SELECT  @MinDate = MIN(StartDate)
,       @MaxDate = MAX(EndDate)
FROM    #Dates


UPDATE  D
SET     D.DateDescFiscalYear = CASE WHEN D.DateID IN ( 2, 5 ) THEN DATENAME(MONTH, D.StartDate)
                                    ELSE 'FY'
                               END + ' ' + CONVERT(VARCHAR, DD.FiscalYear)
FROM    #Dates D
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON D.StartDate = DD.FullDate
WHERE   D.DateID IN ( 2, 4, 5, 6 )


UPDATE  D
SET     D.DateDescFiscalYear = DD.QuarterShortNameWithYear
FROM    #Dates D
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON D.StartDate = DD.FullDate
WHERE   D.DateID IN ( 9, 10 )


UPDATE  D
SET     D.DateDescFiscalYear = 'var +(-)'
FROM    #Dates D
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON D.StartDate = DD.FullDate
WHERE   D.DateID IN ( 7, 8, 11 )


UPDATE  D
SET     D.DateDescFiscalYear = '% Change'
FROM    #Dates D
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON D.StartDate = DD.FullDate
WHERE   D.DateID IN ( 12, 13, 14 )


/********************************** Get list of centers *************************************/
SELECT  DC.CenterSSID AS 'Center'
,		DC.CenterNumber
,		DC.CenterDescription
,		DCT.CenterTypeDescription AS 'CenterType'
INTO    #CentersByType
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DCT.CenterTypeKey = DC.CenterTypeKey
WHERE	DCT.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
		AND ( ( DC.CenterNumber = 199 OR DC.Active = 'Y' )
				AND DC.CenterNumber NOT IN ( 104, 901, 902, 903, 904 ) )


-- Get Centers
INSERT  INTO #Centers
		SELECT	CASE WHEN ct.CenterTypeDescriptionShort IN ( 'JV', 'F' ) THEN r.RegionSSID ELSE ISNULL(cma.CenterManagementAreaSSID, 0) END AS 'AreaID'
		,		CASE WHEN ct.CenterTypeDescriptionShort IN ( 'JV', 'F' ) THEN r.RegionDescription ELSE ISNULL(cma.CenterManagementAreaDescription, 'Corporate') END AS 'Area'
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		ct.CenterTypeDescriptionShort AS 'CenterType'
		,		ctr.CountryRegionDescriptionShort AS 'Country'
		,		d.FullDate
		,		d.FirstDateOfMonth
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate d
		,       HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON r.RegionKey = ctr.RegionKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND ct.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
				AND ( ( ctr.CenterNumber = 199 OR ctr.Active = 'Y' )
						AND ctr.CenterNumber NOT IN ( 104, 901, 902, 903, 904 ) )


/********************************** Get Lead Data *************************************/
SELECT  c.Center AS 'CenterSSID'
,		c.CenterNumber
,		c.CenterDescription
,		c.CenterType
,		d.FullDate AS 'Date'
,       d.FirstDateOfMonth AS 'Period'
,		COUNT(l.Id) AS 'Leads'
INTO    #FactLead
FROM    HC_BI_SFDC.dbo.Lead l
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = CAST(l.ReportCreateDate__c AS DATE)
		INNER JOIN #CentersByType c
			ON c.CenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
WHERE   d.FullDate BETWEEN @MinDate AND @MaxDate
		AND l.Status IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead' )
		AND ISNULL(l.IsDeleted, 0) = 0
GROUP BY c.Center
,		c.CenterNumber
,		c.CenterDescription
,		c.CenterType
,		d.FullDate
,       d.FirstDateOfMonth


/********************************** Get Consultation Data *************************************/
SELECT  c.Center AS 'CenterSSID'
,		c.CenterNumber
,		c.CenterDescription
,		c.CenterType
,		d.FullDate AS 'Date'
,       d.FirstDateOfMonth AS 'Period'
,		COUNT(t.Id) AS 'Consultations'
INTO    #FactActivity
FROM    HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = CAST(t.ActivityDate AS DATE)
		INNER JOIN #CentersByType c
			ON c.CenterNumber = ISNULL(t.CenterNumber__c, t.CenterID__c)
WHERE   d.FullDate BETWEEN @MinDate AND @MaxDate
		AND LTRIM(RTRIM(t.Action__c)) NOT IN ( 'Be Back' )
		AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' )
		AND ISNULL(t.IsDeleted, 0) = 0
GROUP BY c.Center
,		c.CenterNumber
,		c.CenterDescription
,		c.CenterType
,		d.FullDate
,       d.FirstDateOfMonth


/********************************** Combine Data *************************************/
SELECT  CASE WHEN C.RegionSSID NOT IN ( 2, 3, 4, 5 ) THEN 15 ELSE C.RegionSSID END AS 'RegionSSID'
,		CASE WHEN C.CenterType IN ( 'F', 'JV' ) THEN 'Franchise' ELSE C.RegionDescription END AS 'RegionDescription'
,		C.CenterSSID
,		C.CenterDescription
,		CASE WHEN C.CenterType IN ( 'F', 'JV' ) THEN 'F' ELSE 'C' END AS 'CenterType'
,		C.Country
,		C.[Date]
,		C.Period
,       (SELECT ISNULL(SUM(fa.Consultations), 0) FROM #FactActivity fa WHERE fa.CenterNumber = c.CenterNumber AND fa.Date = c.Date) AS 'Consultations'
,       (SELECT ISNULL(SUM(fl.Leads), 0) FROM #FactLead fl WHERE fl.CenterNumber = c.CenterNumber AND fl.Date = c.Date) AS 'Leads'
INTO	#Actuals
FROM    #Centers c


SELECT  D.DateDesc
,       D.DateDescFiscalYear
,       A.RegionSSID
,		A.RegionDescription
,		A.CenterType
,		A.Country
,       D.DateID
,       D.StartDate
,       D.SortOrder
,       CONVERT(DATETIME, CONVERT(VARCHAR, D.EndDate, 101)) AS 'EndDate'
,       SUM(ISNULL(A.Consultations, 0)) AS 'Consultations'
,       SUM(ISNULL(A.Leads, 0)) AS 'Leads'
INTO	#Results
FROM    #Actuals A
		INNER JOIN #Dates D
			ON A.[Date] BETWEEN D.StartDate AND D.EndDate
		INNER JOIN #Centers C
			ON A.CenterSSID = C.CenterSSID
				AND A.Period = C.[Date]
GROUP BY D.DateDesc
,       D.DateDescFiscalYear
,       A.RegionSSID
,		A.RegionDescription
,		A.CenterType
,		A.Country
,       D.DateID
,       D.StartDate
,       CONVERT(DATETIME, CONVERT(VARCHAR, D.EndDate, 101))
,       D.SortOrder
ORDER BY A.RegionSSID
,       D.SortOrder


/********************************** Format Data *************************************/
INSERT	INTO #Final
		SELECT  R.DateDesc
		,		R.DateDescFiscalYear
		,		2
		,		CASE WHEN R.Country = 'US' THEN 16 ELSE 17 END AS 'RegionSSID'
		,		'Corporate ' + R.Country + ' Total' AS 'RegionDescription'
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		,		SUM(R.Leads) AS 'Leads'
		,		SUM(R.Consultations) AS 'Consultations'
		FROM    #Results R
		WHERE	R.DateDesc IN ( 'MTD', 'YTD' )
				AND R.CenterType = 'C'
		GROUP BY R.DateDesc
		,		R.DateDescFiscalYear
		,		R.Country
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		UNION
		SELECT  R.DateDesc
		,		R.DateDescFiscalYear
		,		2
		,		18 AS 'RegionSSID'
		,		'Corporate Total' AS 'RegionDescription'
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		,		SUM(R.Leads) AS 'Leads'
		,		SUM(R.Consultations) AS 'Consultations'
		FROM    #Results R
		WHERE	R.DateDesc IN ( 'MTD', 'YTD' )
				AND R.CenterType = 'C'
		GROUP BY R.DateDesc
		,		R.DateDescFiscalYear
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		UNION
		SELECT  R.DateDesc
		,		R.DateDescFiscalYear
		,		3
		,		CASE WHEN R.Country = 'US' THEN 19 ELSE 20 END AS 'RegionSSID'
		,		'Franchise ' + R.Country + ' Total' AS 'RegionDescription'
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		,		SUM(R.Leads) AS 'Leads'
		,		SUM(R.Consultations) AS 'Consultations'
		FROM    #Results R
		WHERE	R.DateDesc IN ( 'MTD', 'YTD' )
				AND R.CenterType = 'F'
		GROUP BY R.DateDesc
		,		R.DateDescFiscalYear
		,		R.Country
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		UNION
		SELECT  R.DateDesc
		,		R.DateDescFiscalYear
		,		3
		,		21 AS 'RegionSSID'
		,		'Franchise Total' AS 'RegionDescription'
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		,		SUM(R.Leads) AS 'Leads'
		,		SUM(R.Consultations) AS 'Consultations'
		FROM    #Results R
		WHERE	R.DateDesc IN ( 'MTD', 'YTD' )
				AND R.CenterType = 'F'
		GROUP BY R.DateDesc
		,		R.DateDescFiscalYear
		,		R.CenterType
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		UNION
		SELECT  R.DateDesc
		,		R.DateDescFiscalYear
		,		4
		,		CASE WHEN R.Country = 'US' THEN 22 ELSE 23 END AS 'RegionSSID'
		,		R.Country + ' GRAND TOTAL' AS 'RegionDescription'
		,		'G'
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		,		SUM(R.Leads) AS 'Leads'
		,		SUM(R.Consultations) AS 'Consultations'
		FROM    #Results R
		WHERE	R.DateDesc IN ( 'MTD', 'YTD' )
		GROUP BY R.DateDesc
		,		R.DateDescFiscalYear
		,		R.Country
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		UNION
		SELECT  R.DateDesc
		,		R.DateDescFiscalYear
		,		4
		,		24 AS 'RegionSSID'
		,		'GRAND TOTAL' AS 'RegionDescription'
		,		'G'
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate
		,		SUM(R.Leads) AS 'Leads'
		,		SUM(R.Consultations) AS 'Consultations'
		FROM    #Results R
		WHERE	R.DateDesc IN ( 'MTD', 'YTD' )
		GROUP BY R.DateDesc
		,		R.DateDescFiscalYear
		,       R.DateID
		,       R.StartDate
		,       R.SortOrder
		,       R.EndDate


/********************************** Calculate MTD Variances *************************************/
UPDATE  F1
SET     F1.Consultations = F2.Consultations - F3.Consultations
,       F1.Leads = F2.Leads - F3.Leads
FROM    #Final F1
        INNER JOIN #Final F2 -- Current Period
            ON F1.DateDesc = F2.DateDesc
               AND F1.RegionSSID = F2.RegionSSID
               AND F2.DateID = 2
        INNER JOIN #Final F3 -- Previous Period
            ON F1.DateDesc = F3.DateDesc
               AND F1.RegionSSID = F3.RegionSSID
               AND F3.DateID = 5
WHERE   F1.DateID = 7


UPDATE  F1
SET     F1.Consultations = dbo.DIVIDE_DECIMAL(( F2.Consultations - F3.Consultations ), F3.Consultations)
,       F1.Leads = dbo.DIVIDE_DECIMAL(( F2.Leads - F3.Leads ), F3.Leads)
FROM    #Final F1
        INNER JOIN #Final F2 -- Current Period
            ON F1.DateDesc = F2.DateDesc
               AND F1.RegionSSID = F2.RegionSSID
               AND F2.DateID = 2
        INNER JOIN #Final F3 -- Previous Period
            ON F1.DateDesc = F3.DateDesc
               AND F1.RegionSSID = F3.RegionSSID
               AND F3.DateID = 5
WHERE   F1.DateID = 12


/********************************** Calculate YTD Variances *************************************/
UPDATE  F1
SET     F1.Consultations = F2.Consultations - F3.Consultations
,       F1.Leads = F2.Leads - F3.Leads
FROM    #Final F1
        INNER JOIN #Final F2 -- Current Period
            ON F1.DateDesc = F2.DateDesc
               AND F1.RegionSSID = F2.RegionSSID
               AND F2.DateID = 4
        INNER JOIN #Final F3 -- Previous Period
            ON F1.DateDesc = F3.DateDesc
               AND F1.RegionSSID = F3.RegionSSID
               AND F3.DateID = 6
WHERE   F1.DateID = 8


UPDATE  F1
SET     F1.Consultations = dbo.DIVIDE_DECIMAL(( F2.Consultations - F3.Consultations ), F3.Consultations)
,       F1.Leads = dbo.DIVIDE_DECIMAL(( F2.Leads - F3.Leads ), F3.Leads)
FROM    #Final F1
        INNER JOIN #Final F2 -- Current Period
            ON F1.DateDesc = F2.DateDesc
               AND F1.RegionSSID = F2.RegionSSID
               AND F2.DateID = 4
        INNER JOIN #Final F3 -- Previous Period
            ON F1.DateDesc = F3.DateDesc
               AND F1.RegionSSID = F3.RegionSSID
               AND F3.DateID = 6
WHERE   F1.DateID = 13


/********************************** Calculate QTR Variances *************************************/
UPDATE  F1
SET     F1.Consultations = F2.Consultations - F3.Consultations
,       F1.Leads = F2.Leads - F3.Leads
FROM    #Final F1
        INNER JOIN #Final F2 -- Current Period
            ON F1.DateDesc = F2.DateDesc
               AND F1.RegionSSID = F2.RegionSSID
               AND F2.DateID = 9
        INNER JOIN #Final F3 -- Previous Period
            ON F1.DateDesc = F3.DateDesc
               AND F1.RegionSSID = F3.RegionSSID
               AND F3.DateID = 10
WHERE   F1.DateID = 11


UPDATE  F1
SET     F1.Consultations = dbo.DIVIDE_DECIMAL(( F2.Consultations - F3.Consultations ), F3.Consultations)
,       F1.Leads = dbo.DIVIDE_DECIMAL(( F2.Leads - F3.Leads ), F3.Leads)
FROM    #Final F1
        INNER JOIN #Final F2 -- Current Period
            ON F1.DateDesc = F2.DateDesc
               AND F1.RegionSSID = F2.RegionSSID
               AND F2.DateID = 9
        INNER JOIN #Final F3 -- Previous Period
            ON F1.DateDesc = F3.DateDesc
               AND F1.RegionSSID = F3.RegionSSID
               AND F3.DateID = 10
WHERE   F1.DateID = 14


/********************************** Display Data *************************************/
SELECT  F.DateDesc
,       F.DateDescFiscalYear
,		F.GroupID
,       F.RegionSSID
,       F.RegionDescription
,		F.CenterType
,       F.DateID
,       F.StartDate
,       F.SortOrder
,       F.EndDate
,       F.Leads
,       F.Consultations
FROM	#Final F
ORDER BY F.GroupID
,		F.CenterType
,		F.RegionSSID
,		F.SortOrder

END
