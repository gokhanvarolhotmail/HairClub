/****** Object:  View [dbo].[VWFactOpportunity]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀崀ഀഀ
AS with factoppcte as਍⠀ഀഀ
       select a.FactDate            AS                  FactDateUTC,   ਍       愀⸀䘀愀挀琀䐀愀琀攀欀攀礀         䄀匀                  䘀愀挀琀䐀愀琀攀欀攀礀唀吀䌀Ⰰഀഀ
       a.LeadKey,਍       愀⸀䰀攀愀搀䤀搀Ⰰഀഀ
       a.AccountKey,਍       愀⸀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀Ⰰഀഀ
       a.AccountId,਍       愀⸀䌀攀渀琀攀爀欀攀礀Ⰰഀഀ
       bebackflag,਍       伀瀀瀀漀爀琀甀渀椀琀礀䤀搀Ⰰഀഀ
       a.isdeleted,਍ऀ   愀⸀椀猀漀氀搀Ⰰഀഀ
       case਍           眀栀攀渀 愀⸀䤀猀伀氀搀 㴀 　 琀栀攀渀 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰഀഀ
                                                    CONVERT(datetime, a.FactDate) AT TIME ZONE਍                                                    ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 愀⸀䘀愀挀琀䐀愀琀攀⤀ഀഀ
           else a.FactDate end AS                  FactDate        ਍  昀爀漀洀 䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀 愀ഀഀ
       where   case਍           眀栀攀渀 䤀猀伀氀搀 㴀 　 琀栀攀渀 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰഀഀ
                                                    CONVERT(datetime, a.FactDate) AT TIME ZONE਍                                                    ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 愀⸀䘀愀挀琀䐀愀琀攀⤀ഀഀ
           else FactDate end >=CONVERT(date,dateadd(d,-(day(getdate()-1)),getdate()),106)    ਍ഀഀ
  union all਍     猀攀氀攀挀琀 愀⸀䘀愀挀琀䐀愀琀攀            䄀匀                  䘀愀挀琀䐀愀琀攀唀吀䌀Ⰰ   ഀഀ
       a.FactDatekey         AS                  FactDatekeyUTC,਍       愀⸀䰀攀愀搀䬀攀礀Ⰰഀഀ
       a.LeadId,਍       愀⸀䄀挀挀漀甀渀琀䬀攀礀Ⰰഀഀ
       a.OpportunityStatus,਍       愀⸀䄀挀挀漀甀渀琀䤀搀Ⰰഀഀ
       a.Centerkey,਍       戀攀戀愀挀欀昀氀愀最Ⰰഀഀ
       OpportunityId,਍       愀⸀椀猀搀攀氀攀琀攀搀Ⰰഀഀ
	   a.isold,਍       挀愀猀攀ഀഀ
           when a.IsOld = 0 then dateadd(mi, datepart(tz,਍                                                    䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 愀⸀䘀愀挀琀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀ഀഀ
                                                    'Eastern Standard Time'), a.FactDate)਍           攀氀猀攀 䘀愀挀琀䐀愀琀攀 攀渀搀 䄀匀                  䘀愀挀琀䐀愀琀攀ഀഀ
  from FactOpportunityTracking a਍⤀ഀഀ
select                  FactDateUTC,   ਍                         䘀愀挀琀䐀愀琀攀欀攀礀唀吀䌀Ⰰഀഀ
       a.LeadKey,਍       愀⸀䰀攀愀搀䤀搀Ⰰഀഀ
       a.AccountKey,਍       愀⸀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀Ⰰഀഀ
       a.AccountId,਍       愀⸀䌀攀渀琀攀爀欀攀礀Ⰰഀഀ
       b.CenterDescription,਍       䌀攀渀琀攀爀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰഀഀ
       isnull(c.leadFullName, d.AccountFullName) Name,਍       戀攀戀愀挀欀昀氀愀最Ⰰഀഀ
       OpportunityId,਍       愀⸀椀猀搀攀氀攀琀攀搀Ⰰഀഀ
       FactDate,਍       搀搀⸀䐀愀琀攀䬀攀礀            䄀匀                  䘀愀挀琀䐀愀琀攀䬀攀礀Ⰰഀഀ
	   dt.TimeOfDayKey		as					FactTimeKey,਍ऀ   椀猀渀甀氀氀⠀愀⸀䰀攀愀搀䤀搀Ⰰ搀⸀䄀挀挀漀甀渀琀䔀砀琀攀爀渀愀氀䤀搀⤀ 愀猀 䰀攀愀搀䤀搀䔀砀琀攀爀渀愀氀ഀഀ
from factoppcte a਍         氀攀昀琀 樀漀椀渀 搀椀洀挀攀渀琀攀爀 戀 漀渀 愀⸀䌀攀渀琀攀爀䬀攀礀 㴀 戀⸀䌀攀渀琀攀爀䬀攀礀ഀഀ
         left join dimlead c on a.leadkey = c.leadkey਍         氀攀昀琀 樀漀椀渀 搀椀洀愀挀挀漀甀渀琀 搀 漀渀 愀⸀愀挀挀漀甀渀琀欀攀礀 㴀 搀⸀愀挀挀漀甀渀琀欀攀礀ഀഀ
		 left join [dbo].[DimTimeOfDay] dt on dt.[Time24] = convert(time,a.FactDate)਍         氀攀昀琀 樀漀椀渀 搀椀洀搀愀琀攀 搀搀 漀渀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ 搀搀⸀䘀甀氀氀䐀愀琀攀⤀ 㴀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ昀愀挀琀搀愀琀攀⤀㬀ഀഀ
GO਍
