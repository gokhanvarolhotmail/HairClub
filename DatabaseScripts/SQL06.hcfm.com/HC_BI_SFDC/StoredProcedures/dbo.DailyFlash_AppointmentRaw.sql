/* CreateDate: 12/01/2021 01:06:09.153 , ModifyDate: 12/01/2021 08:02:10.833 */
GO
CREATE PROCEDURE [dbo].[DailyFlash_AppointmentRaw]
    AS
    BEGIN

        SELECT ctr.CenterKey
             , ctr.CenterSSID
             , ctr.CenterNumber
             , ctr.CenterDescription
        INTO #CenterTempp
        FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
                 INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
                            ON ct.CenterTypeSSID = ctr.CenterTypeSSID
        WHERE ct.CenterTypeDescriptionShort = 'C'
          AND (--ctr.CenterNumber IN (360, 199) OR
            ctr.Active = 'Y')


        SELECT CAST(t.ActivityDate AS DATE) AS 'FullDate'
             , t.Id
             , ISNULL(t.CenterNumber__c, 100)  CenterNumber
             , c.CenterDescription
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
            END                             AS 'ExcludeFromConsults'
             , CASE
                   WHEN t.SourceCode__c IN
                        ('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF',
                         'BOSBIOEMREF', 'BOSBIODMREF', '4Q2016LWEXLD', 'REFEROTHER'
                            ) AND t.ActivityDate < '12/1/2020' THEN 1
                   ELSE 0
            END                             AS 'ExcludeFromBeBacks'
             , CASE
                   WHEN (t.Action__c = 'Be Back' AND t.ActivityDate < '12/1/2020') THEN 1
                   ELSE 0
            END                             AS 'BeBacksToExclude'
        INTO #Task
        FROM HC_BI_SFDC.dbo.VWTask_MS t
                 INNER JOIN #CenterTempp c
                            ON c.CenterNumber = ISNULL(t.CenterNumber__c, 100)
        WHERE LTRIM(RTRIM(t.Action__c)) IN ('Appointment', 'Be Back', 'In House', 'Recovery')
          AND month(CAST(t.ActivityDate AS DATE)) >= month(dateadd(Day, -1, getdate()))
          and year(CAST(t.ActivityDate AS DATE)) = year(dateadd(Day, -1, getdate()))
          AND ISNULL(t.IsDeleted, 0) = 0

        select CASE
                   WHEN t.Action__c IN ('Appointment', 'In House', 'Recovery', 'be back') AND
                        ISNULL(t.Result__c, '') IN ('BB Manual Credit',
                                                    'No Show',
                                                    'Show No Sale',
                                                    'Show Sale',
                                                    'Completed',
                            --'Scheduled',
                                                    'No_Show',
                                                    'Confirmed'
                            ) THEN 1
                   ELSE 0 END as appointment,
               CASE
                   WHEN ISNULL(t.Result__c, '') IN ('Completed', 'Show Sale', 'Show No Sale') AND
                        ISNULL(t.ExcludeFromConsults, 0) = 0 and
                        ISNULL(t.Action__c, '') in ('Appointment', 'In House', 'Recovery', 'be back')
                       THEN 1
                   ELSE 0 END as consultation,
               *
        into #activity
        from #task t

        select * from #activity

    end
GO
