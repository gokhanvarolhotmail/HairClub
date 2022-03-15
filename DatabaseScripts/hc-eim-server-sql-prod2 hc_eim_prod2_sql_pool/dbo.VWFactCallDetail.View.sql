/****** Object:  View [dbo].[VWFactCallDetail]    Script Date: 3/7/2022 8:42:19 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀䌀愀氀氀䐀攀琀愀椀氀崀 䄀匀 匀䔀䰀䔀䌀吀 挀搀⸀嬀䘀愀挀琀䐀愀琀攀䬀攀礀崀ഀ
      ,cd.[FactTimeKey]਍      Ⰰ挀搀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀ
	  ,dateadd(mi,datepart(tz,CONVERT(datetime,cd.FactDate)    AT TIME ZONE 'Eastern Standard Time'),cd.FactDate) CallDateEST਍      Ⰰ挀搀⸀嬀䌀愀氀氀䤀搀崀ഀ
      ,cd.[CallMediaType]਍      Ⰰ挀搀⸀嬀䴀攀搀椀愀䬀攀礀崀ഀ
      ,cd.[CallPkId]਍      Ⰰ挀搀⸀嬀䌀愀氀氀䐀愀琀攀崀ഀ
      ,cd.[CallIvrTime]਍      Ⰰ挀搀⸀嬀䌀愀氀氀儀甀攀甀攀吀椀洀攀崀ഀ
      ,cd.[CallPendingTime]਍      Ⰰ挀搀⸀嬀䌀愀氀氀吀愀氀欀吀椀洀攀崀ഀ
      ,cd.[CallHoldTime]਍      Ⰰ挀搀⸀嬀䌀愀氀氀䠀攀氀搀崀ഀ
      ,cd.[CallMaxHold]਍      Ⰰ挀搀⸀嬀䌀愀氀氀䄀挀眀吀椀洀攀崀ഀ
      ,cd.[CallDuration]਍      Ⰰ挀搀⸀嬀匀攀爀瘀椀挀攀一愀洀攀崀ഀ
      ,cd.[ServiceKey]਍      Ⰰ挀搀⸀嬀匀挀攀渀愀爀椀漀一愀洀攀崀ഀ
      ,cd.[ScenarioKey]਍      Ⰰ挀搀⸀嬀䰀攀愀搀䬀攀礀崀ഀ
      ,cd.[LeadId]਍      Ⰰ挀搀⸀嬀吀愀猀欀䤀搀崀 愀猀 䤀渀挀漀洀洀椀渀最匀漀甀爀挀攀䌀漀搀攀ഀ
      ,cd.[IncommingSourceCode] as TaskId਍      Ⰰ挀搀⸀嬀匀漀甀爀挀攀䬀攀礀崀ഀ
      ,cd.[CallType]਍      Ⰰ挀搀⸀嬀䌀愀氀氀吀礀瀀攀䬀攀礀崀ഀ
      ,cd.[AgentDisposition]਍      Ⰰ挀搀⸀嬀䄀最攀渀琀䐀椀猀瀀漀猀椀琀椀漀渀䬀攀礀崀ഀ
      ,cd.[AgentLogin]਍      Ⰰ挀搀⸀嬀䄀最攀渀琀䬀攀礀崀ഀ
      ,cd.[IsViableCall]਍      Ⰰ挀搀⸀嬀䤀猀倀爀漀搀甀挀琀椀瘀攀䌀愀氀氀崀ഀ
      ,bcd.from_phone਍      Ⰰ爀椀最栀琀⠀戀挀搀⸀椀渀椀琀椀愀氀开漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀Ⰰ㄀　⤀ 椀渀椀琀椀愀氀开漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀ഀ
      ,vl.CenterNumber਍      Ⰰ瘀氀⸀䌀攀渀琀攀爀䤀䐀ഀ
      ,vl.OriginalCampaignId਍      Ⰰ瘀氀⸀䄀最攀渀挀礀一愀洀攀ഀ
      ,vl.Agencykey਍      Ⰰ挀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀ഀ
  FROM [dbo].[FactCallDetail] cd਍  氀攀昀琀 樀漀椀渀 嘀圀䰀攀愀搀 瘀氀 漀渀 瘀氀⸀䰀攀愀搀䤀搀 㴀 挀搀⸀䰀攀愀搀䤀搀ഀ
  left join DimCenter c on c.CenterNumber = vl.CenterNumber਍  氀攀昀琀 樀漀椀渀 漀搀猀⸀䈀倀开䌀愀氀氀䐀攀琀愀椀氀 戀挀搀 漀渀 戀挀搀⸀瀀欀椀搀 㴀 挀搀⸀䌀愀氀氀倀欀䤀搀㬀ഀഀ
GO਍
