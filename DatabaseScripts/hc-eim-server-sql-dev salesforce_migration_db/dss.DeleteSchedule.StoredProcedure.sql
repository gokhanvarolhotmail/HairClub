/****** Object:  StoredProcedure [dss].[DeleteSchedule]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䐀攀氀攀琀攀匀挀栀攀搀甀氀攀崀ഀഀ
    @SyncGroupId UNIQUEIDENTIFIER = NULL਍䄀匀ഀഀ
BEGIN਍䈀䔀䜀䤀一 吀刀夀ഀഀ
    DELETE਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
    WHERE [SyncGroupId] = @SyncGroupId਍ഀഀ
END TRY਍䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
         -- get error infromation and raise error਍            䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
        RETURN਍ഀഀ
END CATCH਍ഀഀ
END਍䜀伀ഀഀ
