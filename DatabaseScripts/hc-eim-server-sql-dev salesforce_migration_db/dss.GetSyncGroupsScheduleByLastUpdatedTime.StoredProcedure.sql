/****** Object:  StoredProcedure [dss].[GetSyncGroupsScheduleByLastUpdatedTime]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀匀礀渀挀䜀爀漀甀瀀猀匀挀栀攀搀甀氀攀䈀礀䰀愀猀琀唀瀀搀愀琀攀搀吀椀洀攀崀ഀഀ
    @LastUpdatedTime DATETIME਍䄀匀ഀഀ
BEGIN਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀猀礀渀挀开椀渀琀攀爀瘀愀氀崀Ⰰഀഀ
        [sync_enabled],਍        嬀氀愀猀琀甀瀀搀愀琀攀琀椀洀攀崀ഀഀ
    FROM [dss].[syncgroup]਍    圀䠀䔀刀䔀 嬀氀愀猀琀甀瀀搀愀琀攀琀椀洀攀崀 㸀㴀 䀀䰀愀猀琀唀瀀搀愀琀攀搀吀椀洀攀ഀഀ
END਍䜀伀ഀഀ
