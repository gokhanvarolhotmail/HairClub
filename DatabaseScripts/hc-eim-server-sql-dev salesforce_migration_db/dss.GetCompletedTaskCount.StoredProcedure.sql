/****** Object:  StoredProcedure [dss].[GetCompletedTaskCount]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀䌀漀洀瀀氀攀琀攀搀吀愀猀欀䌀漀甀渀琀崀ഀഀ
    @durationInSeconds INT਍䄀匀ഀഀ
BEGIN਍    匀䔀䰀䔀䌀吀 䌀伀唀一吀⠀⨀⤀ 䄀匀 嬀吀愀猀欀䌀漀甀渀琀崀Ⰰ 嬀琀愀猀欀崀⸀嬀琀礀瀀攀崀 䄀匀 嬀吀愀猀欀吀礀瀀攀崀ഀഀ
    FROM [dss].[task]਍    圀䠀䔀刀䔀ഀഀ
        [task].[state] = 1 -- state:1:Succeed਍        䄀一䐀 䐀䄀吀䔀䐀䤀䘀䘀⠀匀䔀䌀伀一䐀Ⰰ 嬀琀愀猀欀崀⸀嬀挀漀洀瀀氀攀琀攀搀琀椀洀攀崀Ⰰ 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀ 㰀 䀀搀甀爀愀琀椀漀渀䤀渀匀攀挀漀渀搀猀ഀഀ
    GROUP BY [task].[type]਍䔀一䐀ഀഀ
GO਍
