/****** Object:  StoredProcedure [dss].[GetNextScheduleTaskCount]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀一攀砀琀匀挀栀攀搀甀氀攀吀愀猀欀䌀漀甀渀琀崀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
਍    匀䔀䰀䔀䌀吀 䌀伀唀一吀⠀猀挀栀⸀䤀搀⤀ഀഀ
    FROM [dss].[ScheduleTask] sch਍    䨀伀䤀一 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀 最爀瀀 伀一 猀挀栀⸀匀礀渀挀䜀爀漀甀瀀䤀搀 㴀 最爀瀀⸀椀搀ഀഀ
    JOIN [dss].[subscription] sub ON grp.subscriptionid = sub.id਍    圀䠀䔀刀䔀ഀഀ
    (sch.State = 0 OR਍     ⠀䐀䄀吀䔀䐀䤀䘀䘀⠀匀䔀䌀伀一䐀Ⰰ嬀䔀砀瀀椀爀愀琀椀漀渀吀椀洀攀崀Ⰰ䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀ 㸀 　 䄀一䐀 猀挀栀⸀匀琀愀琀攀 ℀㴀 ㄀⤀ 伀刀ऀⴀⴀ 倀椀挀欀 琀愀猀欀猀 琀栀愀琀 愀爀攀 搀甀攀 愀渀搀 渀漀琀 瀀攀渀搀椀渀最ഀഀ
     (DATEDIFF(SECOND,DATEADD(MINUTE,5,[LastUpdate]),GETUTCDATE()) > 0 AND sch.State = 1)	 --pick rows that was not updated even after 5min...suggesting a worker role crash਍     ⤀ഀഀ
    AND Interval > 0਍    䄀一䐀 猀甀戀⸀猀甀戀猀挀爀椀瀀琀椀漀渀猀琀愀琀攀 㴀 　ഀഀ
਍䔀一䐀ഀഀ
GO਍
