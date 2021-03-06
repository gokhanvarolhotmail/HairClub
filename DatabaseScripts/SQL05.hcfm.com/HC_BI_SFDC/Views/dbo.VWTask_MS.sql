/* CreateDate: 03/21/2022 07:55:17.753 , ModifyDate: 03/21/2022 07:55:17.753 */
GO
CREATE VIEW [dbo].[VWTask_MS]
AS
With vwTask_CTE as (
    select id,
           Result__c,
           CreatedDate,
           Action__c,
           ActivityDate,
           SourceCode__c,
           CenterNumber__c,
           WhoId,
           Accommodation__c,
           CompletionDate__c,
           EndTime__c,
           0 as IsNew,
           IsDeleted,
           1 as IsOld,
           null as [ContactKey],
           null as [ContactId],
           ReferralCode__c
    from Task
    where convert(date, ActivityDate) <= '2021-06-15'
    UNION all
    select AppointmentId,
           CASE
               WHEN AppointmentStatus IN ('Complete', 'Completed') AND OpportunityStatus = 'Closed Won' THEN 'Show Sale'
               WHEN AppointmentStatus IN ('Complete', 'Completed') AND OpportunityStatus = 'Closed Lost'
                   THEN 'Show No Sale'
               WHEN AppointmentStatus IN ('Complete', 'Completed') AND OpportunityStatus IS NULL THEN 'Show No Sale'
               WHEN AppointmentStatus IN ('Cancel', 'Canceled') THEN 'Canceled'
               WHEN AppointmentStatus IN ('No Show', 'No_Show') THEN 'No Show'
               WHEN AppoinmentStatusCategory IN ('Cancel', 'Canceled') THEN 'Canceled'
               ELSE AppointmentStatus END                                 as Result,
           fa.FactDate,
           case when BeBackFlag = 1 then 'Be back' else 'Appointment' end as Action,
           fa.AppointmentDateEST                                          as ActivityDate,
           dc.SourceCode,
           fa.centerNumber,
           fa.LeadId,
           AppointmentType,

           convert(date, fa.AppointmentDateEST)                           as ColseDate,
           convert(time, fa.AppointmentDate)                              as ColseTime,
           1                                                              as new,
           fa.IsDeleted,
           fa.IsOld,
           ContactKey,
           ContactId,
           OpportunityReferralCode
    from Synapse_pool.FactAppointmentTracking fa
             left join Synapse_pool.DimLead dl
                       ON dl.LeadId = fa.LeadId
             left join Synapse_pool.DimCampaign dc on dl.OriginalCampaignKey = dc.CampaignKey
    where fa.IsOld = 0
      and convert(date, AppointmentDateEST) > '2021-06-15'
      and (month(AppointmentDateEST) <= month(dateadd(month, -1, dateadd(day, -1, getdate())))
      and year(convert(date, fa.AppointmentDateEST)) = year(dateadd(day, -1, getdate())))
    Union all
    select id,
           Result__c,
           CreatedDate,
           Action__c,
           ActivityDate,
           SourceCode__c,
           CenterNumber__c,
           WhoId,
           Accommodation__c,
           CompletionDate__c,
           EndTime__c,
           IsNew,
           IsDeleted,
           IsOld,
           null as [ContactKey],
           null as [ContactId],
           ReferralCode__c
    from Task
    where month(convert(date, ActivityDate)) = month(dateadd(day, -1, getdate()))
      and year(convert(date, ActivityDate)) = year(dateadd(day, -1, getdate()))
)
select id,
       Result__c,
       CreatedDate,
       Action__c,
       ActivityDate,
       SourceCode__c,
       CenterNumber__c,
       WhoId,
       Accommodation__c,
       CompletionDate__c,
       EndTime__c,
       IsNew,
       IsDeleted,
       IsOld,
       [ContactKey],
       [ContactId],
       ReferralCode__c
from vwTask_CTE
GO
