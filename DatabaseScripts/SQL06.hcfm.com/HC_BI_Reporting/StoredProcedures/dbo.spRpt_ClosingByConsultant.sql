/***********************************************************************
PROCEDURE:				spRpt_ClosingByConsultant
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Closing By Consultant
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		08/13/2012
------------------------------------------------------------------------
NOTES:
@CenterType = 1 for Corporate, 2 for Franchise, or CenterNumber

------------------------------------------------------------------------
CHANGE HISTORY:
01/06/2020 - RH - Uncommented SUM(ISNULL(FST.S_SurAmt, 0)) for NetNB1Sales
03/13/2020 - RH - TrackIT 7697 Added S_PRPCnt and S_PRPAmt to Surgery, NetNB1Count, NetNB1Sales
-----------------------------------------------------------------------
SAMPLE EXECUTION:


EXEC spRpt_ClosingByConsultant 1, '06/01/2021', '07/27/2021'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClosingByConsultant](
    @CenterType INT
, @StartDate DATETIME
, @EndDate DATETIME
)
AS
BEGIN

    SET FMTONLY OFF;

/********************************** Create temp table objects *************************************/

    CREATE TABLE #Centers
    (
        MainGroupID                INT,
        MainGroup                  VARCHAR(50),
        MainGroupSortOrder         INT,
        CenterKey                  INT,
        CenterNumber               INT,
        CenterSSID                 INT,
        CenterDescription          VARCHAR(50),
        CenterDescriptionNumber    VARCHAR(104),
        CenterTypeDescriptionShort VARCHAR(2)
    )

    CREATE TABLE #Consultations
    (
        MainGroup             VARCHAR(50),
        CenterNumber          INT,
        ActivityKey           INT,
        ActionCodeSSID        NVARCHAR(10),
        ResultCodeSSID        NVARCHAR(10),
        ActivityDate          DATETIME,
        Performer             NVARCHAR(50),
        Consultations         INT,
        InPersonConsultations INT,
        VirtualConsultations  INT,
        ExcludeFromConsults   BIT,
        Accommodation         VARCHAR(50)
    )

    CREATE TABLE #Task
    (
        FullDate            DATETIME,
        Id                  NVARCHAR(18),
        CenterNumber        INT,
        Action__c           NVARCHAR(50),
        Result__c           NVARCHAR(50),
        SourceCode          NVARCHAR(50),
        Accomodation        NVARCHAR(50),
        ExcludeFromConsults INT,
        ExcludeFromBeBacks  INT,
        BeBacksToExclude    INT,
        Performer           NVARCHAR(150)
    )


    CREATE TABLE #BeBacks
    (
        MainGroup           VARCHAR(50),
        CenterNumber        INT,
        ActivityKey         INT,
        ActionCodeSSID      NVARCHAR(10),
        ResultCodeSSID      NVARCHAR(10),
        ActivityDate        DATETIME,
        Performer           NVARCHAR(50),
        BeBacks             INT,
        ExcludeFromConsults BIT,
        ExcludeFromBeBacks  BIT,
        Accommodation       VARCHAR(50)
    )

    CREATE TABLE #Referrals
    (
        MainGroup      VARCHAR(50),
        CenterNumber   INT,
        ActivityKey    INT,
        ActionCodeSSID NVARCHAR(10),
        ResultCodeSSID NVARCHAR(10),
        ActivityDate   DATETIME,
        Performer      NVARCHAR(50),
        Referrals      INT,
        Accommodation  VARCHAR(50)
    )


    CREATE TABLE #CombinedData
    (
        MainGroup        VARCHAR(50),
        CenterNumber     INT,
        FullDate datetime,
        EmployeeFullName NVARCHAR(250),
        Consultations    INT,
        BeBacks          INT,
        BeBacksToExclude INT,
        Referrals        INT,
        NetNB1Count      INT,
        NetNB1Sales      MONEY,
        XTRPlus          INT,
        EXT              INT,
        Xtrands          INT,
        Surgery          INT,
        NB_MDPCnt        INT,
        Accommodation    VARCHAR(50)
    )

/********************************** Create temp table indexes *************************************/
    CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Centers (CenterNumber)
    CREATE NONCLUSTERED INDEX IDX_CombinedData_CenterNumber ON #CombinedData (CenterNumber)


/********************************** Get list of centers *************************************/
    IF @CenterType = 1 --Corporate
        BEGIN
            INSERT INTO #Centers
            SELECT CMA.CenterManagementAreaSSID        AS 'MainGroupID'
                 , CMA.CenterManagementAreaDescription AS 'MainGroup'
                 , CMA.CenterManagementAreaSortOrder   AS 'MainGroupSortOrder'
                 , DC.CenterKey
                 , DC.CenterNumber
                 , DC.CenterSSID
                 , DC.CenterDescription
                 , DC.CenterDescriptionNumber
                 , DCT.CenterTypeDescriptionShort
            FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                     INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                                ON DC.CenterTypeKey = DCT.CenterTypeKey
                     INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
                                ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
            WHERE DCT.CenterTypeDescriptionShort = 'C'
              AND DC.Active = 'Y'
        END

    ELSE
        IF @CenterType = 2 --Franchise
            BEGIN
                INSERT INTO #Centers
                SELECT DR.RegionSSID        AS 'MainGroupID'
                     , DR.RegionDescription AS 'MainGroup'
                     , DR.RegionSortOrder   AS 'MainGroupSortOrder'
                     , DC.CenterKey
                     , DC.CenterNumber
                     , DC.CenterSSID
                     , DC.CenterDescription
                     , DC.CenterDescriptionNumber
                     , DCT.CenterTypeDescriptionShort
                FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                         INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                         INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                                    ON DC.RegionKey = DR.RegionKey
                WHERE DCT.CenterTypeDescriptionShort IN ('F', 'JV')
                  AND DC.Active = 'Y'
            END
        ELSE
            BEGIN
                --One center is selected
                INSERT INTO #Centers
                SELECT CASE
                           WHEN DCT.CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaSSID
                           ELSE DR.RegionSSID END        AS 'MainGroupID'
                     , CASE
                           WHEN DCT.CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaDescription
                           ELSE DR.RegionDescription END AS 'MainGroup'
                     , CASE
                           WHEN DCT.CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaSortOrder
                           ELSE DR.RegionSortOrder END   AS 'MainGroupSortOrder'
                     , DC.CenterKey
                     , DC.CenterNumber
                     , DC.CenterSSID
                     , DC.CenterDescription
                     , DC.CenterDescriptionNumber
                     , DCT.CenterTypeDescriptionShort
                FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                         INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                         LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                                   ON DC.RegionKey = DR.RegionKey
                         LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
                                   ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
                WHERE DC.CenterSSID = @CenterType
                  AND DC.Active = 'Y'
            END


/************************* After the Center table is populated, then reset the parameters, so the detail drill-downs will work properly ********************/
    IF (SELECT TOP 1 CenterTypeDescriptionShort FROM #Centers) = 'C'
        BEGIN
            SET @CenterType = 1
        END
    ELSE
        BEGIN
            SET @CenterType = 2
        END


/********************************** Get Task data *************************************/
    INSERT INTO #Task
    SELECT CAST(t.ActivityDate AS DATE)                                                          AS 'FullDate'
         , t.Id
         , ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c), 100)
         , t.Action__c
         , t.Result__c
         , t.SourceCode__c
         , t.Accommodation__c
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
        END                                                                                      AS 'ExcludeFromConsults'
         , CASE
               WHEN t.SourceCode__c IN
                    ('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF',
                     'BOSBIOEMREF', 'BOSBIODMREF', '4Q2016LWEXLD', 'REFEROTHER'
                        ) AND t.ActivityDate < '12/1/2020' THEN 1
               ELSE 0
        END                                                                                      AS 'ExcludeFromBeBacks'
         , CASE
               WHEN (t.Action__c = 'Be Back' AND t.ActivityDate < '12/1/2020') THEN 1
               ELSE 0
        END                                                                                      AS 'BeBacksToExclude'
         , isnull(REPLACE(t.Performer__c, ',', ''), REPLACE(de.[EmployeeFullNameCalc], ',', '')) as Performer
    FROM HC_BI_SFDC.dbo.Task t -----??? sf new dfinition
             LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datappointment AS appt WITH (NOLOCK)
                             ON appt.salesforcetaskid = t.Id AND CAST(t.ActivityDate as date) = appt.AppointmentDate AND
                                appt.CLientGUID IS NOT NULL
             LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datAppointmentEmployee AS datapptemp
                             ON appt.AppointmentGUID = datapptemp.AppointmentGUID
             LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datEmployee AS de
                             ON de.employeeguid = datapptemp.employeeguid
    WHERE LTRIM(RTRIM(t.Action__c)) IN ('Appointment', 'Be Back', 'In House', 'Recovery')
      AND CAST(t.ActivityDate AS DATE) BETWEEN  @StartDate AND @EndDate
      AND ISNULL(t.IsDeleted, 0) = 0


    CREATE NONCLUSTERED INDEX IDX_Task_FullDate ON #Task (FullDate);
    CREATE NONCLUSTERED INDEX IDX_Task_Id ON #Task (Id);
    CREATE NONCLUSTERED INDEX IDX_Task_CenterNumber ON #Task (CenterNumber);
    CREATE NONCLUSTERED INDEX IDX_Task_Action__c ON #Task (Action__c);
    CREATE NONCLUSTERED INDEX IDX_Task_Result__c ON #Task (Result__c);
    CREATE NONCLUSTERED INDEX IDX_Task_SourceCode ON #Task (SourceCode);


    UPDATE STATISTICS #Task;

/********************************** Get consultations *************************************/

    Insert into #Consultations
    Select CTR.MainGroup,
           t.CenterNumber,
           -1,
           -1,
           -1,
           FullDate,
           t.Performer,
           1 as 'Consultations',
           CASE
               WHEN
                       (ISNULL(t.Accomodation, 'In Person Consult') = 'In Person Consult' or
                        t.Accomodation like 'center%' or t.Accomodation = 'Company') AND
                       ISNULL(t.Result__c, '') IN ('Completed', 'Show Sale') and
                       ISNULL(t.Action__c, '') in ('Appointment', 'In House', 'Recovery') and
                       --ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
                       ISNULL(t.ExcludeFromConsults, 0) = 0
                   THEN 1
               ELSE
                   0 END
             as 'InPersonConsultations',
           CASE
               WHEN (ISNULL(t.Accomodation, 'In Person Consult') like 'virtual%' or
                     ISNULL(t.Accomodation, 'In Person Consult') like 'Video%') AND
                    ISNULL(t.Result__c, '') IN ('Completed', 'Show Sale') and
                    ISNULL(t.Action__c, '') in ('Appointment', 'In House', 'Recovery') and
                   -- ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
                    ISNULL(t.ExcludeFromConsults, 0) = 0
                   THEN 1
               ELSE
                   0 END
             as 'VirtualConsultations',
           t.ExcludeFromConsults,
           t.Accomodation
    from #Task t
             inner JOIN #Centers CTR
                        ON t.CenterNumber = CTR.CenterNumber
    where ISNULL(t.Result__c, '') IN ('Completed', 'Show Sale', 'Show no sale', 'Reschedule')
      AND ISNULL(t.ExcludeFromConsults, 0) = 0
      and ISNULL(t.Action__c, '') in ('Appointment', 'In House', 'Recovery', 'Be Back')


    insert into #BeBacks
    Select ctr.MainGroup,
           t.CenterNumber,
           -1,
           -1,
           -1,
           FullDate,
           t.Performer,
           CASE
               WHEN t.Action__c IN ('Be Back') AND ISNULL(t.Result__c, '') IN ('BB Manual Credit',
                                                                               'No Show',
                                                                               'Show No Sale',
                                                                               'Show Sale',
                                                                               'Completed',
                                                                               'Scheduled',
                                                                               'No_Show',
                                                                               'Confirmed') AND
                    ISNULL(t.ExcludeFromBeBacks, 0) = 0
                   THEN 1
               ELSE 0 END as 'BeBacks',
           ExcludeFromConsults,
           ExcludeFromBeBacks,
           t.Accomodation
    from #Task t
             inner JOIN #Centers CTR
                        ON t.CenterNumber = CTR.CenterNumber

    insert into #Referrals
    SELECT ctr.MainGroup
         , t.CenterNumber
         , -1
         , -1
         , -1
         , FullDate
         , t.Performer
         , 1 AS 'Referrals'
         , t.Accomodation
    FROM #Task t
             inner JOIN #Centers CTR
                        ON t.CenterNumber = CTR.CenterNumber

    WHERE t.SourceCode in (
                           'CORP REFER',
                           'REFERAFRND',
                           'STYLEREFER',
                           'REGISSTYRFR',
                           'BOSDMREF',
                           'BOSREF',
                           'BOSNCREF',
                           'REFEROTHER',
                           'IPREFCLRERECA12476',
                           'IPREFCLRERECA12476DC',
                           'IPREFCLRERECA12476DF',
                           'IPREFCLRERECA12476DP',
                           'IPREFCLRERECA12476MC',
                           'IPREFCLRERECA12476MF',
                           'IPREFCLRERECA12476MP',
                           'bosref',
                           'other-bos'
        )


    SELECT MainGroup
         , CenterNumber
         , Performer
         , ActivityDate as FullDate
         , SUM(Consultations)                                                  AS 'Consultations'
         , SUM(CASE WHEN ISNULL(ExcludeFromConsults, 0) = 1 THEN 1 ELSE 0 END) AS 'BeBacksToExclude' --to validate
        , Accommodation
    INTO #NetConsultations
    FROM #Consultations
    GROUP BY MainGroup
           , CenterNumber
           , Performer
            , Accommodation
    , ActivityDate

    SELECT MainGroup
         , CenterNumber
         , Performer
         , SUM(BeBacks) AS 'BeBacks'
         , ActivityDate as FullDate
    , Accommodation
    INTO #NetBeBacks
    FROM #BeBacks
    GROUP BY MainGroup
           , CenterNumber
           , Performer
    , Accommodation
    , ActivityDate


    SELECT MainGroup
         , CenterNumber
         , Performer
         , SUM(Referrals) AS 'Referrals'
    , Accommodation
    , ActivityDate as FullDate
    INTO #NetReferrals
    FROM #Referrals
    GROUP BY MainGroup
           , CenterNumber
           , Performer
    , Accommodation
     , ActivityDate


/********************************** Get sales data *************************************/
    SELECT c.MainGroup
         , ctr.CenterNumber
         , DD.FullDate as FullDate
         , ISNULL(SOD.Employee1FullName, 'Unknown, Unknown')                AS 'EmployeeFullName'
         , SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0)) + SUM(ISNULL(FST.NB_XTRCnt, 0)) +
           SUM(ISNULL(FST.NB_GradCnt, 0))
        + SUM(ISNULL(FST.S_SurCnt, 0)) + SUM(ISNULL(FST.S_PostExtCnt, 0)) + SUM(ISNULL(FST.NB_MDPCnt, 0)) +
           SUM(ISNULL(FST.S_PRPCnt, 0))                                     AS 'NetNB1Count'
         , SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.NB_XTRAmt, 0)) +
           SUM(ISNULL(FST.NB_GradAmt, 0))
        + SUM(ISNULL(FST.S_SurAmt, 0)) + SUM(ISNULL(FST.S_PostExtAmt, 0)) + SUM(ISNULL(FST.NB_MDPAmt, 0)) +
           SUM(ISNULL(FST.NB_LaserAmt, 0))
        + SUM(ISNULL(FST.S_PRPAmt, 0))                                      AS 'NetNB1Sales'
         , SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0))  AS 'XTRPlus'
         , SUM(ISNULL(FST.NB_ExtCnt, 0)) + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'EXT'
         , SUM(ISNULL(FST.NB_XTRCnt, 0))                                    AS 'Xtrands'
         , SUM(ISNULL(FST.S_SurCnt, 0)) + SUM(ISNULL(FST.S_PRPCnt, 0))      AS 'Surgery'
         , SUM(ISNULL(FST.NB_MDPCnt, 0))                                    AS 'NB_MDPCnt'
    INTO #NetSales
    FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                        ON FST.OrderDateKey = DD.DateKey
             INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                        ON FST.SalesCodeKey = SC.SalesCodeKey
             INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
                        ON FST.SalesOrderKey = SO.SalesOrderKey
             INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                        ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
             INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                        ON SO.ClientMembershipKey = CM.ClientMembershipKey
             INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                        ON CM.MembershipKey = m.MembershipKey
             INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
                        ON ctr.CenterKey = CM.CenterKey
             INNER JOIN #Centers c
                        ON c.CenterNumber = ctr.CenterNumber
             INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
                        ON FST.ClientKey = CLT.ClientKey
    WHERE DD.FullDate BETWEEN  @StartDate AND @EndDate
      AND SC.SalesCodeKey NOT IN (665, 654, 393, 668)
      AND SO.IsVoidedFlag = 0
    GROUP BY c.MainGroup
           , ctr.CenterNumber
           , SOD.Employee1FullName
    , DD.FullDate




/********************************** Combine Results *************************************/
    INSERT INTO #CombinedData
    SELECT NC.MainGroup
         , NC.CenterNumber
         , NC.FullDate
         , NC.Performer AS 'EmployeeFullName'
         , NC.Consultations
         , 0            AS BeBacks
         , NC.BeBacksToExclude
         , 0            AS Referrals
         , 0            AS 'NetNB1Count'
         , 0            AS 'NetNB1Sales'
         , 0            AS 'XTRPlus'
         , 0            AS 'EXT'
         , 0            AS 'Xtrands'
         , 0            AS 'Surgery'
         , 0            AS NB_MDPCnt
    , Accommodation
    FROM #NetConsultations NC
    UNION
    SELECT NB.MainGroup
         , NB.CenterNumber
         , NB.FullDate
         , NB.Performer AS 'EmployeeFullName'
         , 0            AS Consultations
         , NB.BeBacks
         , 0            AS 'BeBacksToExclude'
         , 0            AS Referrals
         , 0            AS 'NetNB1Count'
         , 0            AS 'NetNB1Sales'
         , 0            AS 'XTRPlus'
         , 0            AS 'EXT'
         , 0            AS 'Xtrands'
         , 0            AS 'Surgery'
         , 0            AS NB_MDPCnt
    , Accommodation
    FROM #NetBeBacks NB
    UNION
    SELECT NS.MainGroup
         , NS.CenterNumber
         , FullDate
         , NS.EmployeeFullName
         , 0 AS 'Consultations'
         , 0 AS BeBacks
         , 0 AS 'BeBacksToExclude'
         , 0 AS Referrals
         , NS.NetNB1Count
         , NS.NetNB1Sales
         , NS.XTRPlus
         , NS.EXT
         , NS.Xtrands
         , NS.Surgery
         , NS.NB_MDPCnt
    , '' as Accommodation
    FROM #NetSales NS
    UNION
    SELECT REF.MainGroup
         , REF.CenterNumber
         , REF.FullDate
         , REF.Performer AS EmployeeFullName
         , 0             AS 'Consultations'
         , 0             AS BeBacks
         , 0             AS 'BeBacksToExclude'
         , REF.Referrals
         , 0             AS NetNB1Count
         , 0             AS NetNB1Sales
         , 0             AS XTRPlus
         , 0             AS EXT
         , 0             AS Xtrands
         , 0             AS 'Surgery'
         , 0             AS NB_MDPCnt
    , Accommodation
    FROM #NetReferrals REF


    SELECT CD.MainGroup
         , CD.CenterNumber
         , cd.FullDate
         , CASE
               WHEN CD.EmployeeFullName = ',' THEN 'Unknown, Unknown'
               WHEN CD.EmployeeFullName IS NULL THEN 'Unknown, Unknown'
               ELSE ISNULL(CD.EmployeeFullName, 'Unknown, Unknown') END AS 'EmployeeFullName'
         , SUM(CD.Consultations)                                        AS 'Consultations'
         , SUM(CD.BeBacks)                                              AS 'BeBacks'
         , SUM(CD.BeBacksToExclude)                                     AS 'BeBacksToExclude'
         , SUM(CD.Referrals)                                            AS 'Referrals'
         , SUM(CD.NetNB1Count)                                          AS 'NetNB1Count'
         , SUM(CD.NetNB1Sales)                                          AS 'NetNB1Sales'
         , SUM(CD.XTRPlus)                                              AS 'XTRPlus'
         , SUM(CD.EXT)                                                  AS 'EXT'
         , SUM(CD.Xtrands)                                              AS 'Xtrands'
         , SUM(CD.Surgery)                                              AS 'Surgery'
         , SUM(CD.NB_MDPCnt)                                            AS 'NB_MDPCnt'
    , Accommodation
    INTO #NetSalesEmployee
    FROM #CombinedData CD
    GROUP BY CD.MainGroup
           , CD.CenterNumber
           , CASE
                 WHEN CD.EmployeeFullName = ',' THEN 'Unknown, Unknown'
                 WHEN CD.EmployeeFullName IS NULL THEN 'Unknown, Unknown'
                 ELSE ISNULL(CD.EmployeeFullName, 'Unknown, Unknown') END
    , Accommodation
    , cd.FullDate


/********************************** Display Results *************************************/
    SELECT r.fullDate
         , C.MainGroupID                                                                 AS 'RegionID'
         , C.MainGroup                                                                   AS 'Region'
         , C.MainGroupSortOrder                                                          AS 'RegionSortOrder'
         , C.CenterNumber                                                                AS 'CenterID'
         , C.CenterSSID
         , C.CenterDescription
         , C.CenterDescriptionNumber                                                     AS 'Center'
         , NULL                                                                          AS 'performer'
         , NULL                                                                          AS 'EmployeeKey'
         , CASE
               WHEN R.EmployeeFullName = ',' THEN 'Unknown, Unknown'
               ELSE ISNULL(replace(R.EmployeeFullName, ',', ''), 'Unknown, Unknown') END AS 'PerformerName'
         , R.Consultations                                                               AS 'Consultations'
         , R.BeBacks                                                                     AS 'BeBacks'
         , R.BeBacksToExclude
         , R.Referrals                                                                   AS 'Referrals'
         , ISNULL(R.NetNB1Count, 0)                                                      AS 'netSale'
         , ISNULL(R.NetNB1Sales, 0)                                                      AS 'netRevenue'
         , ISNULL(R.XTRPlus, 0)                                                          AS 'XTRPlus'
         , ISNULL(R.EXT, 0)                                                              AS 'EXT'
         , ISNULL(R.Xtrands, 0)                                                          AS 'Xtrands'
         , ISNULL(R.Surgery, 0)                                                          AS 'Surgery'
         , ISNULL(R.NB_MDPCnt, 0)                                                        AS 'NB_MDPCnt'
         , ISNULL(
            dbo.DIVIDE_DECIMAL(ISNULL(R.NetNB1Count, 0), (ISNULL(R.Consultations, 0) - ISNULL(R.BeBacksToExclude, 0))),
            0)                                                                           AS 'ConversionPercent'
         , ISNULL(dbo.DIVIDE_DECIMAL(R.XTRPlus, R.NetNB1Count), 0)                       AS 'XTRPlusPercent'
         , ISNULL(dbo.DIVIDE_DECIMAL(R.EXT, R.NetNB1Count), 0)                           AS 'EXTPercent'
         , ISNULL(dbo.DIVIDE_DECIMAL(R.Xtrands, R.NetNB1Count), 0)                       AS 'XtrandsPercent'
         , ISNULL(dbo.DIVIDE_DECIMAL(R.Surgery, R.NetNB1Count), 0)                       AS 'SurgeryPercent'
         , ISNULL(dbo.DIVIDE_DECIMAL(R.NB_MDPCnt, R.NetNB1Count), 0)                     AS 'MDPPercent'
    , Accommodation
    INTO #Results
    FROM #NetSalesEmployee R
             INNER JOIN #Centers C
                        ON C.CenterNumber = R.CenterNumber
    WHERE (R.Consultations <> 0
        OR ISNULL(R.BeBacks, 0) <> 0
        OR ISNULL(R.Referrals, 0) <> 0
        OR ISNULL(R.NetNB1Count, 0) <> 0
        OR ISNULL(R.NetNB1Sales, 0) <> 0)


/*****************UPDATE records with EmployeeKey for performer and EmployeeKey *****************************/
    UPDATE #Results
    SET #Results.performer = ISNULL(E.EmployeeKey, -1)
    FROM #Results
             LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
                       ON replace(replace(ltrim(#Results.PerformerName), ' ', ''), ',', '') =
                          replace(replace(ltrim(E.EmployeeFullName), ' ', ''), ',', '')
    WHERE #Results.performer IS NULL


    UPDATE #Results
    SET #Results.EmployeeKey = ISNULL(E.EmployeeKey, -1)
    FROM #Results
             LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
                       ON replace(replace(Ltrim(#Results.PerformerName), ' ', ''), ',', '') =
                          replace(replace(Ltrim(E.EmployeeFullName), ' ', ''), ',', '')
    WHERE #Results.EmployeeKey IS NULL


    UPDATE #Results
    SET performer = (-1)
    WHERE PerformerName = 'Unknown, Unknown'
      AND performer = NULL


    UPDATE #Results
    SET EmployeeKey = (-1)
    WHERE PerformerName = 'Unknown, Unknown'
      AND EmployeeKey = NULL


    UPDATE #Results
    SET PerformerName = 'Unknown, Unknown'
    WHERE (PerformerName IS NULL OR PerformerName = '')


/***************** Combine 'Unknown, Unknown' records into one per center ***************************************/
    SELECT FullDate
        , RegionID
         , Region
         , RegionSortOrder
         , CenterID --CenterNumber
         , CenterSSID
         , CenterDescription
         , Center
         , performer
         , EmployeeKey
         , PerformerName
         , SUM(Consultations)     AS 'Consultations'
         , SUM(BeBacks)           AS 'BeBacks'
         , SUM(BeBacksToExclude)  AS 'BeBacksToExclude'
         , SUM(Referrals)         AS 'Referrals'
         , SUM(netSale)           AS 'netSale'
         , SUM(netRevenue)        AS 'netRevenue'
         , SUM(XTRPlus)           AS 'XTRPlus'
         , SUM(EXT)               AS 'EXT'
         , SUM(Xtrands)           AS 'Xtrands'
         , SUM(Surgery)           AS 'Surgery'
         , SUM(NB_MDPCnt)         AS 'NB_MDPCnt'
         , MAX(ConversionPercent) AS 'ConversionPercent'
         , MAX(XTRPlusPercent)    AS 'XTRPlusPercent'
         , MAX(EXTPercent)        AS 'EXTPercent'
         , MAX(XtrandsPercent)    AS 'XtrandsPercent'
         , MAX(SurgeryPercent)    AS 'SurgeryPercent'
         , MAX(MDPPercent)        AS 'MDPPercent'
    , Accommodation
    FROM #Results
    GROUP BY RegionID
           , Region
           , RegionSortOrder
           , CenterID
           , CenterSSID
           , CenterDescription
           , Center
           , performer
           , EmployeeKey
           , PerformerName
        , Accommodation
    , fullDate
END
