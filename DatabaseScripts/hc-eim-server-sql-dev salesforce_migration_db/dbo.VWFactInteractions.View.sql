/****** Object:  View [dbo].[VWFactInteractions]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀䤀渀琀攀爀愀挀琀椀漀渀猀崀ഀഀ
AS SELECT  factdate TaskDateUTC਍  Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ昀愀挀琀搀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ昀愀挀琀搀愀琀攀⤀ 吀愀猀欀䐀愀琀攀䔀匀吀ഀഀ
      ,[TaskId]਍      Ⰰ嬀吀愀猀欀匀甀戀樀攀挀琀崀ഀഀ
      ,[TaskStatusKey]਍      Ⰰ匀琀愀琀甀猀渀愀洀攀ഀഀ
	  ,TaskStatus਍      Ⰰ嬀吀愀猀欀倀爀椀漀爀椀琀礀崀ഀഀ
      ,[IsHighPriority]਍      Ⰰ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
      ,[ActivityCost]਍      Ⰰ愀⸀嬀䰀攀愀搀䬀攀礀崀ഀഀ
      ,a.[LeadId]਍ऀ  Ⰰ挀⸀䰀攀愀搀䘀甀氀氀一愀洀攀ഀഀ
      ,[CustomerId]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
      ,[TaskTypeKey] ਍      Ⰰ嬀吀愀猀欀吀礀瀀攀崀ഀഀ
      ,a.[CampaignKey] TaskCampaignKey਍      Ⰰ昀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 吀愀猀欀䌀愀洀瀀愀椀最渀一愀洀攀ഀഀ
	  ,f.[AgencyKey] TaskAgencyKey਍ऀ  Ⰰ昀⸀嬀䄀最攀渀挀礀一愀洀攀崀 吀愀猀欀䄀最攀渀挀礀一愀洀攀ഀഀ
	  ,f.[CampaignStatus] TaskCampaignStatus਍ऀ  Ⰰ昀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 吀愀猀欀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀 ഀഀ
	  ,f.[CampaignLocation] TaskCampaignLocation਍ऀ  Ⰰ昀⸀嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 吀愀猀欀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀ഀഀ
	  ,f.[CampaignMedia] TaskCampaignMedia਍ऀ  Ⰰ昀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀 吀愀猀欀䌀愀洀瀀愀椀最渀䌀爀攀愀琀椀瘀攀ഀഀ
	  ,f.[CampaignTactic] TaskCampaignTactic਍ऀ  Ⰰ昀⸀嬀倀爀漀洀漀䌀漀搀攀崀 吀愀猀欀䌀愀洀瀀愀椀最渀倀爀漀洀漀䌀漀搀攀ഀഀ
	  ,h.CampaignKey LeadCampaignKey਍ऀ  Ⰰ栀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀攀愀搀䌀愀洀瀀愀椀最渀一愀洀攀ഀഀ
	  ,h.[AgencyKey] LeadAgencyKey਍ऀ  Ⰰ栀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀攀愀搀䄀最攀渀挀礀一愀洀攀ഀഀ
	  ,h.[CampaignStatus] LeadCampaignStatus਍ऀ  Ⰰ栀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 䰀攀愀搀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀ഀഀ
	  ,h.[CampaignLocation] LeadCampaignLocation਍ऀ  Ⰰ栀⸀嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 䰀攀愀搀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀ഀഀ
	  ,h.[CampaignMedia] LeadCampaignMedia਍ऀ  Ⰰ栀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀 䰀攀愀搀䌀愀洀瀀愀椀最渀䌀爀攀愀琀椀瘀攀ഀഀ
	  ,h.[CampaignTactic] LeadCampaignTactic਍ऀ  Ⰰ栀⸀嬀倀爀漀洀漀䌀漀搀攀崀 䰀攀愀搀倀爀漀洀漀䌀漀搀攀ഀഀ
	  , [ActionKey]਍ऀ  Ⰰ愀⸀嬀䄀挀挀漀洀洀漀搀愀琀椀漀渀崀 䄀挀挀漀洀洀漀搀愀琀椀漀渀ഀഀ
      ,[TaskAction]਍      Ⰰ愀⸀嬀刀攀猀甀氀琀䬀攀礀崀ഀഀ
      ,a.[TaskResult]਍      Ⰰ愀⸀嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
      ,a.[CenterNumber]਍ऀ  Ⰰ搀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
	  ,d.[CenterDescription]਍        Ⰰ嬀䄀挀琀椀瘀椀琀礀吀礀瀀攀䬀攀礀崀ഀഀ
      ,[ActivityType]਍      Ⰰ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀崀ഀഀ
	  ,[ActivityDate]਍      Ⰰ愀⸀嬀䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀ഀഀ
      ,a.[CreatedDate]਍      Ⰰ愀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀ഀഀ
      ,[CallBackDate]਍      Ⰰ嬀䐀攀瘀椀挀攀吀礀瀀攀崀ഀഀ
      ,[ActivitySource]਍      Ⰰ嬀唀渀椀焀甀攀吀愀猀欀䤀搀崀ഀഀ
      ,[PromotionCode]਍      Ⰰ愀⸀嬀倀爀漀洀漀琀椀漀渀䬀攀礀崀ഀഀ
      ,a.[DWH_LoadDate]਍      Ⰰ愀⸀嬀䌀爀攀愀琀攀唀猀攀爀崀ഀഀ
      ,a.[UpdateUser]਍ऀ  Ⰰ䌀愀猀攀 圀栀攀渀 ⠀吀愀猀欀䄀挀琀椀漀渀㴀 ✀䈀攀 戀愀挀欀✀⤀ 愀渀搀 ⠀琀愀猀欀刀攀猀甀氀琀 渀漀琀 椀渀 ⠀✀刀攀猀挀栀攀搀甀氀攀✀Ⰰ ✀䌀愀渀挀攀氀✀Ⰰ ✀䌀攀渀琀攀爀 䔀砀挀攀瀀琀椀漀渀✀Ⰰ ✀嘀漀椀搀✀⤀⤀ 琀栀攀渀 ㄀ 攀氀猀攀 　 䔀一䐀 䈀攀戀愀挀欀ഀഀ
,Case When (taskAction in ('Appointment', 'In house','Recovery')) and (taskResult Not in ('Reschedule', 'Cancel', 'Center Exception', 'Void') or taskResult is null or taskResult = '') then 1 else 0 END Appointment਍Ⰰ䌀愀猀攀 眀栀攀渀 吀愀猀欀刀攀猀甀氀琀 椀渀 ⠀✀匀栀漀眀 匀愀氀攀✀Ⰰ ✀匀栀漀眀 一漀 匀愀氀攀✀⤀ 琀栀攀渀 ㄀ 攀氀猀攀 　 䔀一䐀 匀栀漀眀ഀഀ
,Case when TaskResult in ('Show Sale') then 1 else 0 END Sale਍Ⰰ䌀愀猀攀 眀栀攀渀 吀愀猀欀刀攀猀甀氀琀 椀渀 ⠀✀匀栀漀眀 一漀 匀愀氀攀✀⤀ 琀栀攀渀 ㄀ 攀氀猀攀 　 䔀一䐀 一漀匀愀氀攀ഀഀ
,Case when TaskResult in ('No Show') then 1 else 0 END NoShow਍Ⰰ䌀愀猀攀 眀栀攀渀 琀愀猀欀䄀挀琀椀漀渀 㴀 ✀䤀渀 栀漀甀猀攀✀  琀栀攀渀 ㄀ 攀氀猀攀 　 䔀一䐀 䤀渀䠀漀甀猀攀ഀഀ
,Case when TaskResult in ('Show Sale', 'Show No Sale') then 1 else 0 END Consultation਍  䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䤀渀琀攀爀愀挀琀椀漀渀崀 愀ഀഀ
  left join [dbo].[DimStatus] b on a.TaskStatusKey=b.statuskey਍  氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀䐀椀洀䰀攀愀搀 挀 漀渀 愀⸀氀攀愀搀欀攀礀㴀挀⸀氀攀愀搀欀攀礀ഀഀ
  left Join [dbo].[DimGeography] g on c.geographykey=g.geographykey ਍  氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 搀 漀渀 愀⸀挀攀渀琀攀爀欀攀礀㴀搀⸀挀攀渀琀攀爀欀攀礀ഀഀ
  left join [dbo].[DimCampaign] f on a.campaignkey=f.campaignkey਍  氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䌀愀洀瀀愀椀最渀崀 栀 漀渀 挀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀㴀栀⸀挀愀洀瀀愀椀最渀欀攀礀㬀ഀഀ
GO਍
