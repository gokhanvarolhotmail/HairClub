/****** Object:  StoredProcedure [dss].[CreateSchedule]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀爀攀愀琀攀匀挀栀攀搀甀氀攀崀ഀഀ
    @SyncGroupId UNIQUEIDENTIFIER,਍    䀀䤀渀琀攀爀瘀愀氀 戀椀最䤀渀琀Ⰰഀഀ
    @Type int਍䄀匀ഀഀ
BEGIN TRY਍        䤀一匀䔀刀吀 䤀一吀伀 嬀搀猀猀崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
        (਍            匀礀渀挀䜀爀漀甀瀀䤀搀Ⰰഀഀ
            Interval,਍            䰀愀猀琀唀瀀搀愀琀攀Ⰰഀഀ
            ExpirationTime,਍            匀琀愀琀攀Ⰰഀഀ
            Type਍        ⤀ഀഀ
        VALUES਍        ⠀ഀഀ
        @SyncGroupId,਍            䀀䤀渀琀攀爀瘀愀氀Ⰰഀഀ
            GETUTCDATE(),਍            䐀䄀吀䔀䄀䐀䐀⠀匀䔀䌀伀一䐀Ⰰ 䀀䤀渀琀攀爀瘀愀氀Ⰰ䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀Ⰰഀഀ
            0,਍            䀀吀礀瀀攀ഀഀ
        )਍ഀഀ
END TRY਍䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
         -- get error infromation and raise error਍        ⴀⴀ䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
        RETURN਍䔀一䐀 䌀䄀吀䌀䠀ഀഀ
GO਍
