/****** Object:  View [dbo].[FactFunnelPivot]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FactFunnelPivot]
AS select  a.leadid,a.factdate LeadDate,datediff(day,a.factdate,b.factdate) LeadToAppoinment,b.factdate AppointmentDate, datediff(day,b.factdate,c.factdate) AppointmentToShow, 
c.factdate ShowDate,datediff(day,c.factdate,d.factdate) ShowToNB ,d.factdate NBDate, datediff(day,d.factdate,e.factdate) NBToPCP,e.factdate PCPdate from 
(
SELECT [FactDate]
      ,[Leadkey]
      ,[LeadId]
      ,[Accountkey]
      ,[AccountId]
      ,[ContactId]
      ,[CustomerId]
      ,[Membershipkey]
      ,[MembershipId]
      ,[FunnelStepKey]
      ,[FunnelStep]
      ,[IsvalidLead]
  FROM [dbo].[FactFunnel] 
  where funnelstep='Lead') a
  left join 
  (
  SELECT [FactDate]
      ,[Leadkey]
      ,[LeadId]
      ,[Accountkey]
      ,[AccountId]
      ,[ContactId]
      ,[CustomerId]
      ,[Membershipkey]
      ,[MembershipId]
      ,[FunnelStepKey]
      ,[FunnelStep]
      ,[IsvalidLead]
  FROM [dbo].[FactFunnel] 
  where funnelstep='Appointment') b on a.leadid=b.leadid
  left join 
  (
  SELECT [FactDate]
      ,[Leadkey]
      ,[LeadId]
      ,[Accountkey]
      ,[AccountId]
      ,[ContactId]
      ,[CustomerId]
      ,[Membershipkey]
      ,[MembershipId]
      ,[FunnelStepKey]
      ,[FunnelStep]
      ,[IsvalidLead]
  FROM [dbo].[FactFunnel] 
  where funnelstep='Show') c on a.leadid=c.leadid
   left join 
  (
  SELECT [FactDate]
      ,[Leadkey]
      ,[LeadId]
      ,[Accountkey]
      ,[AccountId]
      ,[ContactId]
      ,[CustomerId]
      ,[Membershipkey]
      ,[MembershipId]
      ,[FunnelStepKey]
      ,[FunnelStep]
      ,[IsvalidLead]
  FROM [dbo].[FactFunnel] 
  where funnelstep='NB') d on a.leadid=d.leadid
   left join 
  (
  SELECT [FactDate]
      ,[Leadkey]
      ,[LeadId]
      ,[Accountkey]
      ,[AccountId]
      ,[ContactId]
      ,[CustomerId]
      ,[Membershipkey]
      ,[MembershipId]
      ,[FunnelStepKey]
      ,[FunnelStep]
      ,[IsvalidLead]
  FROM [dbo].[FactFunnel] 
  where funnelstep='PCP') e on a.leadid=e.leadid;
GO
