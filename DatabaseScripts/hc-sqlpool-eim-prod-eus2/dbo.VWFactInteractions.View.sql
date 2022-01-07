/****** Object:  View [dbo].[VWFactInteractions]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactInteractions]
AS SELECT  factdate TaskDateUTC
  ,dateadd(mi,datepart(tz,CONVERT(datetime,factdate)    AT TIME ZONE 'Eastern Standard Time'),factdate) TaskDateEST
      ,[TaskId]
      ,[TaskSubject]
      ,[TaskStatusKey]
      ,Statusname
	  ,TaskStatus
      ,[TaskPriority]
      ,[IsHighPriority]
      ,[Description]
      ,[ActivityCost]
      ,a.[LeadKey]
      ,a.[LeadId]
	  ,c.LeadFullName
      ,[CustomerId]
      ,[AccountId]
      ,[TaskTypeKey] 
      ,[TaskType]
      ,a.[CampaignKey] TaskCampaignKey
      ,f.[CampaignName] TaskCampaignName
	  ,f.[AgencyKey] TaskAgencyKey
	  ,f.[AgencyName] TaskAgencyName
	  ,f.[CampaignStatus] TaskCampaignStatus
	  ,f.[CampaignChannel] TaskCampaignChannel 
	  ,f.[CampaignLocation] TaskCampaignLocation
	  ,f.[CampaignLanguage] TaskCampaignLanguage
	  ,f.[CampaignMedia] TaskCampaignMedia
	  ,f.[CampaignSource] TaskCampaignCreative
	  ,f.[CampaignTactic] TaskCampaignTactic
	  ,f.[PromoCode] TaskCampaignPromoCode
	  ,h.CampaignKey LeadCampaignKey
	  ,h.[CampaignName] LeadCampaignName
	  ,h.[AgencyKey] LeadAgencyKey
	  ,h.[AgencyName] LeadAgencyName
	  ,h.[CampaignStatus] LeadCampaignStatus
	  ,h.[CampaignChannel] LeadCampaignChannel
	  ,h.[CampaignLocation] LeadCampaignLocation
	  ,h.[CampaignLanguage] LeadCampaignLanguage
	  ,h.[CampaignMedia] LeadCampaignMedia
	  ,h.[CampaignSource] LeadCampaignCreative
	  ,h.[CampaignTactic] LeadCampaignTactic
	  ,h.[PromoCode] LeadPromoCode
	  , [ActionKey]
	  ,a.[Accommodation] Accommodation
      ,[TaskAction]
      ,a.[ResultKey]
      ,a.[TaskResult]
      ,a.[CenterKey]
      ,a.[CenterNumber]
	  ,d.[CenterTypeDescription]
	  ,d.[CenterDescription]
        ,[ActivityTypeKey]
      ,[ActivityType]
      ,[ActivityDateKey]
	  ,[ActivityDate]
      ,a.[CreatedDateKey]
      ,a.[CreatedDate]
      ,a.[AppointmentDate]
      ,[CallBackDate]
      ,[DeviceType]
      ,[ActivitySource]
      ,[UniqueTaskId]
      ,[PromotionCode]
      ,a.[PromotionKey]
      ,a.[DWH_LoadDate]
      ,a.[CreateUser]
      ,a.[UpdateUser]
	  ,Case When (TaskAction= 'Be back') and (taskResult not in ('Reschedule', 'Cancel', 'Center Exception', 'Void')) then 1 else 0 END Beback
,Case When (taskAction in ('Appointment', 'In house','Recovery')) and (taskResult Not in ('Reschedule', 'Cancel', 'Center Exception', 'Void') or taskResult is null or taskResult = '') then 1 else 0 END Appointment
,Case when TaskResult in ('Show Sale', 'Show No Sale') then 1 else 0 END Show
,Case when TaskResult in ('Show Sale') then 1 else 0 END Sale
,Case when TaskResult in ('Show No Sale') then 1 else 0 END NoSale
,Case when TaskResult in ('No Show') then 1 else 0 END NoShow
,Case when taskAction = 'In house'  then 1 else 0 END InHouse
,Case when TaskResult in ('Show Sale', 'Show No Sale') then 1 else 0 END Consultation
  FROM [dbo].[FactInteraction] a
  left join [dbo].[DimStatus] b on a.TaskStatusKey=b.statuskey
  left join [dbo].DimLead c on a.leadkey=c.leadkey
  left Join [dbo].[DimGeography] g on c.geographykey=g.geographykey 
  left join [dbo].[DimCenter] d on a.centerkey=d.centerkey
  left join [dbo].[DimCampaign] f on a.campaignkey=f.campaignkey
  left join [dbo].[DimCampaign] h on c.OriginalCampaignKey=h.campaignkey;
GO
