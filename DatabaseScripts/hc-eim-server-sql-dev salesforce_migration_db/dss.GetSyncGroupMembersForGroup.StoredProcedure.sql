/****** Object:  StoredProcedure [dss].[GetSyncGroupMembersForGroup]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀猀䘀漀爀䜀爀漀甀瀀崀ഀഀ
    @SyncGroupID UNIQUEIDENTIFIER,਍    䀀一攀攀搀唀瀀搀愀琀攀䰀漀挀欀ऀ䈀䤀吀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF (@NeedUpdateLock = 1)਍    䈀䔀䜀䤀一ഀഀ
        SELECT਍            嬀椀搀崀Ⰰഀഀ
            [name],਍            嬀猀挀漀瀀攀渀愀洀攀崀Ⰰഀഀ
            [syncgroupid],਍            嬀猀礀渀挀搀椀爀攀挀琀椀漀渀崀Ⰰഀഀ
            [databaseid],਍            嬀洀攀洀戀攀爀猀琀愀琀攀崀Ⰰഀഀ
            [hubstate],਍            嬀洀攀洀戀攀爀猀琀愀琀攀开氀愀猀琀甀瀀搀愀琀攀搀崀Ⰰഀഀ
            [hubstate_lastupdated],਍            嬀氀愀猀琀猀礀渀挀琀椀洀攀崀Ⰰഀഀ
            [lastsynctime_zerofailures_member],਍            嬀氀愀猀琀猀礀渀挀琀椀洀攀开稀攀爀漀昀愀椀氀甀爀攀猀开栀甀戀崀Ⰰഀഀ
            [jobId],਍            嬀渀漀椀渀椀琀猀礀渀挀崀Ⰰഀഀ
            [memberhasdata]਍            ⴀⴀ 吀栀椀猀 洀攀琀栀漀搀 椀猀 挀愀氀氀攀搀 昀爀漀洀 琀栀攀 䄀挀琀椀漀渀䄀瀀椀 猀漀ഀഀ
            -- we will lock the syncgroupmember rows in the database,਍            ⴀⴀ 猀漀 琀栀愀琀 眀攀 搀漀渀✀琀 攀渀搀 甀瀀 挀爀攀愀琀椀渀最 洀漀爀攀 琀栀愀渀 ㄀ 猀礀渀挀 琀愀猀欀 瀀攀爀 洀攀洀戀攀爀⸀ഀഀ
        FROM [dss].[syncgroupmember] WITH (UPDLOCK)਍        圀䠀䔀刀䔀 嬀猀礀渀挀最爀漀甀瀀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀ഀഀ
    END਍    䔀䰀匀䔀ഀഀ
    BEGIN਍        匀䔀䰀䔀䌀吀ഀഀ
            [id],਍            嬀渀愀洀攀崀Ⰰഀഀ
            [scopename],਍            嬀猀礀渀挀最爀漀甀瀀椀搀崀Ⰰഀഀ
            [syncdirection],਍            嬀搀愀琀愀戀愀猀攀椀搀崀Ⰰഀഀ
            [memberstate],਍            嬀栀甀戀猀琀愀琀攀崀Ⰰഀഀ
            [memberstate_lastupdated],਍            嬀栀甀戀猀琀愀琀攀开氀愀猀琀甀瀀搀愀琀攀搀崀Ⰰഀഀ
            [lastsynctime],਍            嬀氀愀猀琀猀礀渀挀琀椀洀攀开稀攀爀漀昀愀椀氀甀爀攀猀开洀攀洀戀攀爀崀Ⰰഀഀ
            [lastsynctime_zerofailures_hub],਍            嬀䨀漀戀䤀搀崀Ⰰഀഀ
            [noinitsync],਍            嬀洀攀洀戀攀爀栀愀猀搀愀琀愀崀ഀഀ
            -- This method is called from the ActionApi so਍            ⴀⴀ 眀攀 眀椀氀氀 氀漀挀欀 琀栀攀 猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀 爀漀眀猀 椀渀 琀栀攀 搀愀琀愀戀愀猀攀Ⰰഀഀ
            -- so that we don't end up creating more than 1 sync task per member.਍        䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
        WHERE [syncgroupid] = @SyncGroupID਍    䔀一䐀ഀഀ
END਍䜀伀ഀഀ
