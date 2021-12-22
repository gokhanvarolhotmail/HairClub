/* CreateDate: 03/25/2014 15:41:13.400 , ModifyDate: 06/28/2021 15:55:49.533 */
GO
/***********************************************************************
PROCEDURE:				spRpt_LeadsConsultationsDetailByCenter
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Leads & Consultations By Center Report
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		02/24/2014
DATE IMPLEMENTED:		03/29/2019
------------------------------------------------------------------------
NOTES: 

02/24/2014 - DL - Created Stored Procedure.
01/11/2016 - RH - Changed to pull Consultations from vwFactActivityResults (#122061)
03/29/2019 - JL - Changed report to group by area/region  (Case #6597)
01/13/2020 - JL - Remove Bosley Consult from leads, appointments & consultation count TrackIT 5322 
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_LeadsConsultationsDetailByCenter
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_LeadsConsultationsDetailByCenter]
AS
BEGIN

    SET FMTONLY OFF;
    SET NOCOUNT OFF;


    DECLARE @YesterdayStart DATETIME
        , @YesterdayEnd DATETIME
        , @CurrentMonthStart DATETIME
        , @CurrentMonthEnd DATETIME
        , @CurrentYearStart DATETIME
        , @CurrentYearEnd DATETIME
        , @CurrentQuarter INT
        , @CurrentQuarterStart DATETIME
        , @CurrentQuarterEnd DATETIME
        , @CurrentFiscalYearStart DATETIME
        , @CurrentFiscalYearEnd DATETIME
        , @MinDate DATETIME
        , @MaxDate DATETIME


    CREATE TABLE #Dates
    (
        DateID             INT,
        DateDesc           VARCHAR(50),
        DateDescFiscalYear VARCHAR(50),
        StartDate          DATETIME,
        EndDate            DATETIME,
        SortOrder          INT
    )

    CREATE TABLE #Centers
    (
        MainGroupID        INT,
        MainGroup          VARCHAR(50),
        MainGroupSortOrder INT,
        CenterSSID         INT,
        CenterNumber       INT,
        CenterDescription  VARCHAR(255),
        CenterType         VARCHAR(50),
        Country            VARCHAR(50),
        Date               DATETIME,
        [Period]           DATETIME
    )

    CREATE TABLE #Final
    (
        DateDesc           VARCHAR(50),
        DateDescFiscalYear VARCHAR(50),
        GroupID            INT,
        GroupDescription   VARCHAR(50),
        MainGroup          VARCHAR(50),
        CenterType         VARCHAR(50),
        DateID             INT,
        StartDate          DATETIME,
        SortOrder          INT,
        EndDate            DATETIME,
        Leads              FLOAT,
        Consultations      FLOAT,
        CenterDescription  VARCHAR(255),
        MainGroupSortOrder INT
    )


/********************************** Get Dates *************************************/
    SET @YesterdayStart = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, GETDATE()), 101))
    SET @YesterdayEnd = @YesterdayStart

    SET @CurrentMonthStart = CONVERT(DATETIME,
                CONVERT(VARCHAR, MONTH(@YesterdayStart)) + '/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
    SET @CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))

    SET @CurrentYearStart = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
    SET @CurrentYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentYearStart))

    SET @CurrentQuarter = (SELECT QuarterNumber
                           FROM HC_BI_ENT_DDS.bief_dds.DimDate
                           WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @YesterdayStart, 101)))
    SET @CurrentQuarterStart = (SELECT MIN(FullDate)
                                FROM HC_BI_ENT_DDS.bief_dds.DimDate
                                WHERE QuarterNumber = @CurrentQuarter
                                  AND YearNumber = YEAR(@YesterdayStart))
    SET @CurrentQuarterEnd = (SELECT MAX(FullDate)
                              FROM HC_BI_ENT_DDS.bief_dds.DimDate
                              WHERE QuarterNumber = @CurrentQuarter
                                AND YearNumber = YEAR(@YesterdayStart))

    SET @CurrentFiscalYearStart = (SELECT CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(FullDate)))
                                   FROM HC_BI_ENT_DDS.bief_dds.DimDate
                                   WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @YesterdayStart, 101)))
    SET @CurrentFiscalYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentFiscalYearStart))


    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (1, 'Day', 'Day', @YesterdayStart, @YesterdayEnd, 1)


-- MTD
    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (5, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))),
            DATEADD(YEAR, -1, @CurrentMonthStart), DATEADD(YEAR, -1, @YesterdayEnd), 2)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (2, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentMonthStart, @YesterdayEnd, 3)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (7, 'MTD', 'Difference', @CurrentMonthStart, @YesterdayEnd, 4)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (12, 'MTD', 'Percent', @CurrentMonthStart, @YesterdayEnd, 5)


-- YTD
    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (6, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))),
            DATEADD(YEAR, -1, @CurrentFiscalYearStart), DATEADD(YEAR, -1, @YesterdayEnd), 6)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (4, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentFiscalYearStart, @YesterdayEnd, 7)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (8, 'YTD', 'Difference', @CurrentFiscalYearStart, @YesterdayEnd, 8)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (13, 'YTD', 'Percent', @CurrentMonthStart, @YesterdayEnd, 9)


-- QTR
    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (10, 'QTR', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))),
            DATEADD(YEAR, -1, @CurrentQuarterStart), DATEADD(YEAR, -1, @YesterdayEnd), 10)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (9, 'QTR', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentQuarterStart, @YesterdayEnd, 11)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (11, 'QTR', 'Difference', @CurrentQuarterStart, @YesterdayEnd, 12)

    INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
    VALUES (14, 'QTR', 'Percent', @CurrentMonthStart, @YesterdayEnd, 13)


    SELECT @MinDate = MIN(StartDate)
         , @MaxDate = MAX(EndDate)
    FROM #Dates


    UPDATE D
    SET D.DateDescFiscalYear = CASE
                                   WHEN D.DateID IN (2, 5) THEN DATENAME(MONTH, D.StartDate)
                                   ELSE 'FY'
                                   END + ' ' + CONVERT(VARCHAR, DD.FiscalYear)
    FROM #Dates D
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                        ON D.StartDate = DD.FullDate
    WHERE D.DateID IN (2, 4, 5, 6)


    UPDATE D
    SET D.DateDescFiscalYear = DD.QuarterShortNameWithYear
    FROM #Dates D
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                        ON D.StartDate = DD.FullDate
    WHERE D.DateID IN (9, 10)


    UPDATE D
    SET D.DateDescFiscalYear = 'var +(-)'
    FROM #Dates D
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                        ON D.StartDate = DD.FullDate
    WHERE D.DateID IN (7, 8, 11)


    UPDATE D
    SET D.DateDescFiscalYear = '% Change'
    FROM #Dates D
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                        ON D.StartDate = DD.FullDate
    WHERE D.DateID IN (12, 13, 14)


/********************************** Get list of centers *************************************/
    SELECT DC.CenterSSID             AS 'Center'
         , DC.CenterNumber
         , DC.CenterDescription
         , DCT.CenterTypeDescription AS 'CenterType'
    INTO #CentersByType
    FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
             INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                        ON DCT.CenterTypeKey = DC.CenterTypeKey
    WHERE DCT.CenterTypeDescriptionShort IN ('C', 'JV', 'F')
      AND (DC.CenterNumber IN (199, 360) OR DC.Active = 'Y')


-- Get Centers
    INSERT INTO #Centers
    SELECT CASE
               WHEN ct.CenterTypeDescriptionShort IN ('JV', 'F') THEN r.RegionSSID
               ELSE ISNULL(cma.CenterManagementAreaSSID, 0) END                  AS 'MainGroupID'
         , CASE
               WHEN ct.CenterTypeDescriptionShort IN ('JV', 'F') THEN r.RegionDescription
               ELSE ISNULL(cma.CenterManagementAreaDescription, 'Corporate') END AS 'MainGroup'
         , CASE
               WHEN ct.CenterTypeDescriptionShort IN ('JV', 'F') THEN r.RegionSortOrder
               ELSE cma.CenterManagementAreaSortOrder END
         , ctr.CenterSSID
         , ctr.CenterNumber
         , ctr.CenterDescription
         , ct.CenterTypeDescriptionShort                                         AS 'CenterType'
         , ctr.CountryRegionDescriptionShort                                     AS 'Country'
         , d.FullDate
         , d.FirstDateOfMonth
    FROM HC_BI_ENT_DDS.bief_dds.DimDate d
       , HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
             INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
                        ON ct.CenterTypeKey = ctr.CenterTypeKey
             INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
                        ON r.RegionKey = ctr.RegionKey
             LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
                             ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
    WHERE d.FullDate BETWEEN @MinDate AND @MaxDate
      AND ct.CenterTypeDescriptionShort IN ('C', 'JV', 'F')
      AND (ctr.CenterNumber IN (199, 360) OR ctr.Active = 'Y')


    UPDATE c
    SET c.MainGroup = c.CenterDescription
    FROM #Centers c
    WHERE c.CenterNumber = 340


/********************************** Get Lead Data *************************************/
    SELECT c.Center           AS 'CenterSSID'
         , c.CenterNumber
         , c.CenterDescription
         , c.CenterType
         , d.FullDate         AS 'Date'
         , d.FirstDateOfMonth AS 'Period'
         , COUNT(l.Id)        AS 'Leads'
    INTO #FactLead
    FROM HC_BI_SFDC.dbo.Lead l
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
                        ON d.FullDate = CAST(isnull(l.CreatedDateEst, l.ReportCreateDate__c) AS DATE)
             INNER JOIN #CentersByType c
                        ON c.CenterNumber = ISNULL(ISNULL(l.CenterNumber__c, l.CenterID__c), 100)
         OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
    WHERE d.FullDate BETWEEN @MinDate AND @MaxDate
      AND l.Status IN
          ('Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED',
           'CONSULTATION','Pursuing my Story', 'Pursuing_my_Story', 'Scheduled', 'Establishing_Value',
           'Establishing Value', 'Converted')
      AND ISNULL(l.IsDeleted, 0) = 0
      AND (IsValid = 1 or ISNULL(fil.IsInvalidLead, 0) = 0)
    GROUP BY c.Center
           , c.CenterNumber
           , c.CenterDescription
           , c.CenterType
           , d.FullDate
           , d.FirstDateOfMonth


/********************************** Get Consultation Data *************************************/
    SELECT c.Center           AS 'CenterSSID'
         , c.CenterNumber
         , c.CenterDescription
         , c.CenterType
         , d.FullDate         AS 'Date'
         , d.FirstDateOfMonth AS 'Period'
         , t.Action__c
         , t.Result__c
         , CASE
               WHEN (
                       (
                               t.Action__c = 'Be Back'
                               OR t.SourceCode__c IN
                                  ('REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF',
                                   'BOSBIOEMREF', 'BOSNCREF', '4Q2016LWEXLD', 'REFEROTHER', 'IPREFCLRERECA12476',
                                   'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
                                   'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
                                      )
                           )
                       AND t.ActivityDate < '12/1/2020'
                   ) THEN 1
               ELSE 0
        END                   AS 'ExcludeFromConsults'
    INTO #FactActivity
    FROM HC_BI_SFDC.dbo.Task t -- maybe not changes needed
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
                        ON d.FullDate = CAST(t.ActivityDate AS DATE)
             INNER JOIN #CentersByType c
                        ON c.CenterNumber = ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c), 100)
--              LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l --- not used
--                              ON l.Id = t.WhoId
--              LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a -- not used
--                              ON a.PersonContactId = t.WhoId
    WHERE d.FullDate BETWEEN @MinDate AND @MaxDate
      AND LTRIM(RTRIM(t.Action__c)) IN ('Appointment', 'Be Back', 'In House', 'Recovery')
      AND ISNULL(t.IsDeleted, 0) = 0


/********************************** Combine Data *************************************/
    SELECT c.MainGroupID
         , c.MainGroup
         , c.CenterSSID
         , c.CenterDescription
         , CASE WHEN C.CenterType IN ('F', 'JV') THEN 'F' ELSE 'C' END AS 'CenterType'
         , c.Country
         , c.[Date]
         , c.Period
         , (SELECT COUNT(*)
            FROM #FactActivity fa
            WHERE fa.CenterNumber = c.CenterNumber
              AND fa.Date = c.Date
              AND fa.Action__c IN ('Appointment', 'Be back')
              AND ISNULL(fa.Result__c, '') IN ('Completed', 'Show Sale', 'Show No Sale')
              AND ISNULL(fa.ExcludeFromConsults, 0) = 0)               AS 'Consultations'
         , (SELECT ISNULL(SUM(fl.Leads), 0)
            FROM #FactLead fl
            WHERE fl.CenterNumber = c.CenterNumber
              AND fl.Date = c.Date)                                    AS 'Leads'
         , ISNULL(c.MainGroupSortOrder, 0)                             AS 'MainGroupSortOrder'
    INTO #Actuals
    FROM #Centers c


    SELECT D.DateDesc
         , D.DateDescFiscalYear
         , A.MainGroup                                         AS 'AreaDescription'
         , A.CenterSSID
         , A.CenterDescription
         , A.CenterType
         , A.Country
         , D.DateID
         , D.StartDate
         , D.SortOrder
         , CONVERT(DATETIME, CONVERT(VARCHAR, D.EndDate, 101)) AS 'EndDate'
         , SUM(ISNULL(A.Consultations, 0))                     AS 'Consultations'
         , SUM(ISNULL(A.Leads, 0))                             AS 'Leads'
         , A.MainGroupSortOrder
    INTO #Results
    FROM #Actuals A
             INNER JOIN #Dates D
                        ON A.[Date] BETWEEN D.StartDate AND D.EndDate
             INNER JOIN #Centers C
                        ON A.CenterSSID = C.CenterSSID
                            AND A.Period = C.[Date]
    GROUP BY D.DateDesc
           , D.DateDescFiscalYear
           , A.MainGroup
           , A.CenterSSID
           , A.CenterDescription
           , A.CenterType
           , A.Country
           , D.DateID
           , D.StartDate
           , CONVERT(DATETIME, CONVERT(VARCHAR, D.EndDate, 101))
           , D.SortOrder
           , A.MainGroupSortOrder
    ORDER BY A.CenterSSID
           , D.SortOrder


    /********************************** Format Data *************************************/
--Center Total
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 1
         , R.CenterSSID
         , R.AreaDescription    AS 'GroupDescription'
         , R.CenterType
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , R.CenterDescription
         , R.MainGroupSortOrder
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.AreaDescription
           , R.CenterSSID
           , R.CenterDescription
           , R.CenterType
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate
           , R.MainGroupSortOrder


--Area/Region subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 1
         , 'A' + R.AreaDescription
         , R.AreaDescription    AS 'GroupDescription'
         , R.CenterType
         , R.DateID
         , R.StartDate
         , CASE R.DateID
               WHEN 5 THEN 14
               WHEN 2 THEN 15
               WHEN 7 THEN 16
               WHEN 12 THEN 17
               WHEN 6 THEN 18
               WHEN 4 THEN 19
               WHEN 8 THEN 20
               WHEN 13 THEN 21
        END                     AS 'SortOrder'
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , 'ZZ' + AreaDescription + ' Total'
         , R.MainGroupSortOrder
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.AreaDescription
           , R.CenterType
           , R.DateID
           , R.StartDate
           , R.EndDate
           , R.MainGroupSortOrder


--Canada Subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 2                    AS 'GroupID'
         , 'CA Total'           AS 'GroupDescription'
         , 'CA Total'           AS 'RegionDescription'
         , 'Z'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'CA'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--US Subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 2                    AS 'GroupID'
         , 'US Total'           AS 'GroupDescription'
         , 'US Total'           AS 'RegionDescription'
         , 'ZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'US'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--Canada Corp Subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 3                    AS 'GroupID'
         , 'Corporate CA Total' AS 'GroupDescription'
         , 'Corporate CA Total' AS 'RegionDescription'
         , 'ZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'CA'
      AND R.CenterType = 'C'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--US Corp Subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 3                    AS 'GroupID'
         , 'Corporate US Total' AS 'GroupDescription'
         , 'Corporate US Total' AS 'RegionDescription'
         , 'ZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'US'
      AND R.CenterType = 'C'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--Corp Subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 3                    AS 'GroupID'
         , 'Total Corporate'    AS 'GroupDescription'
         , 'Corporate Total'    AS 'RegionDescription'
         , 'ZZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.CenterType = 'C'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--Franchise Canada Subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 4                    AS 'GroupID'
         , 'Franchise CA Total' AS 'GroupDescription'
         , 'Franchise CA Total' AS 'RegionDescription'
         , 'ZZZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'CA'
      AND R.CenterType = 'F'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--Franchise US Subtotal
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 4                    AS 'GroupID'
         , 'Franchise US Total' AS 'GroupDescription'
         , 'Franchise US Total' AS 'RegionDescription'
         , 'ZZZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'US'
      AND R.CenterType = 'F'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--Franchise total 
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 4                    AS 'GroupID'
         , 'Total Franchise'    AS 'GroupDescription'
         , 'Franchise Total'    AS 'RegionDescription'
         , 'ZZZZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.CenterType = 'F'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--CA TOTAL
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 5                    AS 'GroupID'
         , 'Grand CA Total'     AS 'GroupDescription'
         , 'CA GRAND TOTAL'     AS 'RegionDescription'
         , 'ZZZZZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'CA'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--US Total
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 5                    AS 'GroupID'
         , 'Grand US Total'     AS 'GroupDescription'
         , 'US GRAND TOTAL'     AS 'RegionDescription'
         , 'ZZZZZZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
      AND R.Country = 'US'
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


--Grand Total
    INSERT INTO #Final
    SELECT R.DateDesc
         , R.DateDescFiscalYear
         , 5                    AS 'GroupID'
         , 'Total'              AS 'GroupDescription'
         , 'GRAND TOTAL'        AS 'RegionDescription'
         , 'ZZZZZZZZZ'
         , R.DateID
         , R.StartDate
         , R.SortOrder
         , R.EndDate
         , SUM(R.Leads)         AS 'Leads'
         , SUM(R.Consultations) AS 'Consultations'
         , ''
         , ''
    FROM #Results R
    WHERE R.DateDesc IN ('MTD', 'YTD')
    GROUP BY R.DateDesc
           , R.DateDescFiscalYear
           , R.DateID
           , R.StartDate
           , R.SortOrder
           , R.EndDate


/********************************** Calculate MTD Variances *************************************/
    UPDATE F1
    SET F1.Consultations = F2.Consultations - F3.Consultations
      , F1.Leads         = F2.Leads - F3.Leads
    FROM #Final F1
             INNER JOIN #Final F2 -- Current Period
                        ON F1.DateDesc = F2.DateDesc
                            AND F1.GroupDescription = F2.GroupDescription
                            AND F2.DateID = 2
             INNER JOIN #Final F3 -- Previous Period
                        ON F1.DateDesc = F3.DateDesc
                            AND F1.GroupDescription = F3.GroupDescription
                            AND F3.DateID = 5
    WHERE F1.DateID = 7


    UPDATE F1
    SET F1.Consultations = dbo.DIVIDE_DECIMAL((F2.Consultations - F3.Consultations), F3.Consultations)
      , F1.Leads         = dbo.DIVIDE_DECIMAL((F2.Leads - F3.Leads), F3.Leads)
    FROM #Final F1
             INNER JOIN #Final F2 -- Current Period
                        ON F1.DateDesc = F2.DateDesc
                            AND F1.GroupDescription = F2.GroupDescription
                            AND F2.DateID = 2
             INNER JOIN #Final F3 -- Previous Period
                        ON F1.DateDesc = F3.DateDesc
                            AND F1.GroupDescription = F3.GroupDescription
                            AND F3.DateID = 5
    WHERE F1.DateID = 12


/********************************** Calculate YTD Variances *************************************/
    UPDATE F1
    SET F1.Consultations = F2.Consultations - F3.Consultations
      , F1.Leads         = F2.Leads - F3.Leads
    FROM #Final F1
             INNER JOIN #Final F2 -- Current Period
                        ON F1.DateDesc = F2.DateDesc
                            AND F1.GroupDescription = F2.GroupDescription
                            AND F2.DateID = 4
             INNER JOIN #Final F3 -- Previous Period
                        ON F1.DateDesc = F3.DateDesc
                            AND F1.GroupDescription = F3.GroupDescription
                            AND F3.DateID = 6
    WHERE F1.DateID = 8


    UPDATE F1
    SET F1.Consultations = dbo.DIVIDE_DECIMAL((F2.Consultations - F3.Consultations), F3.Consultations)
      , F1.Leads         = dbo.DIVIDE_DECIMAL((F2.Leads - F3.Leads), F3.Leads)
    FROM #Final F1
             INNER JOIN #Final F2 -- Current Period
                        ON F1.DateDesc = F2.DateDesc
                            AND F1.GroupDescription = F2.GroupDescription
                            AND F2.DateID = 4
             INNER JOIN #Final F3 -- Previous Period
                        ON F1.DateDesc = F3.DateDesc
                            AND F1.GroupDescription = F3.GroupDescription
                            AND F3.DateID = 6
    WHERE F1.DateID = 13


/********************************** Calculate QTR Variances *************************************/
    UPDATE F1
    SET F1.Consultations = F2.Consultations - F3.Consultations
      , F1.Leads         = F2.Leads - F3.Leads
    FROM #Final F1
             INNER JOIN #Final F2 -- Current Period
                        ON F1.DateDesc = F2.DateDesc
                            AND F1.GroupDescription = F2.GroupDescription
                            AND F2.DateID = 9
             INNER JOIN #Final F3 -- Previous Period
                        ON F1.DateDesc = F3.DateDesc
                            AND F1.GroupDescription = F3.GroupDescription
                            AND F3.DateID = 10
    WHERE F1.DateID = 11


    UPDATE F1
    SET F1.Consultations = dbo.DIVIDE_DECIMAL((F2.Consultations - F3.Consultations), F3.Consultations)
      , F1.Leads         = dbo.DIVIDE_DECIMAL((F2.Leads - F3.Leads), F3.Leads)
    FROM #Final F1
             INNER JOIN #Final F2 -- Current Period
                        ON F1.DateDesc = F2.DateDesc
                            AND F1.GroupDescription = F2.GroupDescription
                            AND F2.DateID = 9
             INNER JOIN #Final F3 -- Previous Period
                        ON F1.DateDesc = F3.DateDesc
                            AND F1.GroupDescription = F3.GroupDescription
                            AND F3.DateID = 10
    WHERE F1.DateID = 14


/********************************** Display Data *************************************/
    SELECT F.DateDesc
         , F.DateDescFiscalYear
         , F.GroupID
         , F.GroupDescription
         , F.MainGroup
         , CASE WHEN F.CenterType = 'JV' THEN 'F' ELSE F.CenterType END AS 'CenterType'
         , F.DateID
         , F.StartDate
         , F.SortOrder
         , F.EndDate
         , F.Leads
         , F.Consultations
         , CASE
               WHEN SUBSTRING(F.CenterDescription, 1, 2) = 'ZZ' THEN REPLACE(F.CenterDescription, 'ZZ', '')
               WHEN ISNULL(F.CenterDescription, '') = '' THEN F.MainGroup
               ELSE F.CenterDescription
        END                                                             AS 'RegionDescription'
         , F.MainGroupSortOrder
    FROM #Final F
    ORDER BY CASE WHEN F.CenterType = 'JV' THEN 'F' ELSE F.CenterType END
           , F.MainGroup
           , F.CenterDescription

END
GO
