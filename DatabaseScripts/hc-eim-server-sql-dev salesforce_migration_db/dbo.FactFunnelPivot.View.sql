/****** Object:  View [dbo].[FactFunnelPivot]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀倀椀瘀漀琀崀ഀഀ
AS select  a.leadid,a.factdate LeadDate,datediff(day,a.factdate,b.factdate) LeadToAppoinment,b.factdate AppointmentDate, datediff(day,b.factdate,c.factdate) AppointmentToShow, ਍挀⸀昀愀挀琀搀愀琀攀 匀栀漀眀䐀愀琀攀Ⰰ搀愀琀攀搀椀昀昀⠀搀愀礀Ⰰ挀⸀昀愀挀琀搀愀琀攀Ⰰ搀⸀昀愀挀琀搀愀琀攀⤀ 匀栀漀眀吀漀一䈀 Ⰰ搀⸀昀愀挀琀搀愀琀攀 一䈀䐀愀琀攀Ⰰ 搀愀琀攀搀椀昀昀⠀搀愀礀Ⰰ搀⸀昀愀挀琀搀愀琀攀Ⰰ攀⸀昀愀挀琀搀愀琀攀⤀ 一䈀吀漀倀䌀倀Ⰰ攀⸀昀愀挀琀搀愀琀攀 倀䌀倀搀愀琀攀 昀爀漀洀 ഀഀ
(਍匀䔀䰀䔀䌀吀 嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
      ,[Leadkey]਍      Ⰰ嬀䰀攀愀搀䤀搀崀ഀഀ
      ,[Accountkey]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
      ,[ContactId]਍      Ⰰ嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀഀ
      ,[Membershipkey]਍      Ⰰ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀഀ
      ,[FunnelStepKey]਍      Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀഀ
      ,[IsvalidLead]਍  䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀崀 ഀഀ
  where funnelstep='Lead') a਍  氀攀昀琀 樀漀椀渀 ഀഀ
  (਍  匀䔀䰀䔀䌀吀 嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
      ,[Leadkey]਍      Ⰰ嬀䰀攀愀搀䤀搀崀ഀഀ
      ,[Accountkey]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
      ,[ContactId]਍      Ⰰ嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀഀ
      ,[Membershipkey]਍      Ⰰ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀഀ
      ,[FunnelStepKey]਍      Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀഀ
      ,[IsvalidLead]਍  䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀崀 ഀഀ
  where funnelstep='Appointment') b on a.leadid=b.leadid਍  氀攀昀琀 樀漀椀渀 ഀഀ
  (਍  匀䔀䰀䔀䌀吀 嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
      ,[Leadkey]਍      Ⰰ嬀䰀攀愀搀䤀搀崀ഀഀ
      ,[Accountkey]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
      ,[ContactId]਍      Ⰰ嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀഀ
      ,[Membershipkey]਍      Ⰰ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀഀ
      ,[FunnelStepKey]਍      Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀഀ
      ,[IsvalidLead]਍  䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀崀 ഀഀ
  where funnelstep='Show') c on a.leadid=c.leadid਍   氀攀昀琀 樀漀椀渀 ഀഀ
  (਍  匀䔀䰀䔀䌀吀 嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
      ,[Leadkey]਍      Ⰰ嬀䰀攀愀搀䤀搀崀ഀഀ
      ,[Accountkey]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
      ,[ContactId]਍      Ⰰ嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀഀ
      ,[Membershipkey]਍      Ⰰ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀഀ
      ,[FunnelStepKey]਍      Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀഀ
      ,[IsvalidLead]਍  䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀崀 ഀഀ
  where funnelstep='NB') d on a.leadid=d.leadid਍   氀攀昀琀 樀漀椀渀 ഀഀ
  (਍  匀䔀䰀䔀䌀吀 嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
      ,[Leadkey]਍      Ⰰ嬀䰀攀愀搀䤀搀崀ഀഀ
      ,[Accountkey]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
      ,[ContactId]਍      Ⰰ嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀഀ
      ,[Membershipkey]਍      Ⰰ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀഀ
      ,[FunnelStepKey]਍      Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀഀ
      ,[IsvalidLead]਍  䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀崀 ഀഀ
  where funnelstep='PCP') e on a.leadid=e.leadid;਍䜀伀ഀഀ
