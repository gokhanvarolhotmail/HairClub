/****** Object:  StoredProcedure [dss].[GetSyncGroupMembersByDatabaseId]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀猀䈀礀䐀愀琀愀戀愀猀攀䤀搀崀ഀഀ
    @DatabaseId UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀渀愀洀攀崀Ⰰഀഀ
        [scopename],਍        嬀猀礀渀挀最爀漀甀瀀椀搀崀Ⰰഀഀ
        [syncdirection],਍        嬀搀愀琀愀戀愀猀攀椀搀崀Ⰰഀഀ
        [memberstate],਍        嬀栀甀戀猀琀愀琀攀崀Ⰰഀഀ
        [memberstate_lastupdated],਍        嬀栀甀戀猀琀愀琀攀开氀愀猀琀甀瀀搀愀琀攀搀崀Ⰰഀഀ
        [lastsynctime],਍        嬀氀愀猀琀猀礀渀挀琀椀洀攀开稀攀爀漀昀愀椀氀甀爀攀猀开洀攀洀戀攀爀崀Ⰰഀഀ
        [lastsynctime_zerofailures_hub],਍        嬀樀漀戀䤀搀崀Ⰰഀഀ
        [noinitsync],਍        嬀洀攀洀戀攀爀栀愀猀搀愀琀愀崀ഀഀ
    -- This method is called from the ActionApi so਍    ⴀⴀ 眀攀 眀椀氀氀 氀漀挀欀 琀栀攀 猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀 爀漀眀猀 椀渀 琀栀攀 搀愀琀愀戀愀猀攀Ⰰഀഀ
    -- so that we don't end up creating more than 1 sync task per member.਍    ⴀⴀ 䘀漀爀 漀琀栀攀爀 椀渀瘀漀欀挀愀琀椀漀渀猀 琀栀攀 唀倀䐀䰀伀䌀䬀 爀攀氀攀愀猀攀猀 琀栀攀 氀漀挀欀 眀栀攀渀 琀栀攀 瀀爀漀挀攀搀甀爀攀 攀砀攀挀甀琀椀漀渀 挀漀洀瀀氀攀琀攀猀⸀ഀഀ
    FROM [dss].[syncgroupmember] WITH (UPDLOCK)਍    圀䠀䔀刀䔀 嬀搀愀琀愀戀愀猀攀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
END਍䜀伀ഀഀ
