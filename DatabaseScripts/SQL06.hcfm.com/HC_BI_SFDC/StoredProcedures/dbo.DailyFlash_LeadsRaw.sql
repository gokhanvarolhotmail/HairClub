CREATE PROCEDURE [dbo].[DailyFlash_LeadsRaw]
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


SELECT CAST(l.CreatedDate AS DATE) AS 'FullDate'
     ,*
into #LeadsTempp
FROM HC_BI_SFDC.dbo.VWLead_MS l --SF
         INNER JOIN #CenterTempp c
                    ON c.CenterNumber = ISNULL(l.CenterNumber__c, 100)
WHERE l.Status IN
      ('Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED',
       'CONSULTATION', 'Pursuing my Story', 'Pursuing_my_Story', 'Scheduled',
       'Establishing_Value',
       'Establishing Value',
       'Converted')
  AND month(CAST(l.CreatedDate AS DATE)) >= month(dateadd(Day,  -1, getdate()))
  and year(CAST(l.CreatedDate AS DATE)) = year(dateadd(Day,  -1, getdate()))
  AND ISNULL(l.IsDeleted, 0) = 0
  and isvalid = 1

select * from #LeadsTempp


end
