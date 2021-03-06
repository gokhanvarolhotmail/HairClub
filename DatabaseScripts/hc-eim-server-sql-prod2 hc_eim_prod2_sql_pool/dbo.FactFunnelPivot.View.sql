/****** Object:  View [dbo].[FactFunnelPivot]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FactFunnelPivot]
AS select  a.leadid,a.leadkey,a.factdate LeadDate,datediff(day,a.factdate,b.factdate) LeadToAppoinment,b.factdate AppointmentDate, datediff(day,b.factdate,c.factdate) AppointmentToShow,
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
  where funnelstep='Appointment') b on a.leadkey=b.leadkey
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
  where funnelstep='Show') c on a.leadkey=c.leadkey
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
  where funnelstep='NB') d on a.leadkey=d.leadkey
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
  where funnelstep='PCP') e on a.leadkey=e.leadkey;
GO
