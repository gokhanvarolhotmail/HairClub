/****** Object:  StoredProcedure [dss].[SetDatabaseAndSyncGroupMembersState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀䐀愀琀愀戀愀猀攀䄀渀搀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀猀匀琀愀琀攀崀ഀഀ
    @DatabaseId UNIQUEIDENTIFIER,਍    䀀䴀攀洀戀攀爀匀琀愀琀攀 䤀一吀Ⰰഀഀ
    @DatabaseState INT਍䄀匀ഀഀ
BEGIN਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        BEGIN TRANSACTION਍ഀഀ
        UPDATE [dss].[syncgroupmember]਍        匀䔀吀ഀഀ
            [memberstate] = @MemberState,਍            嬀洀攀洀戀攀爀猀琀愀琀攀开氀愀猀琀甀瀀搀愀琀攀搀崀 㴀 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀Ⰰഀഀ
            [jobId] = NULL਍        圀䠀䔀刀䔀 嬀搀愀琀愀戀愀猀攀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
਍        唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
        SET਍            嬀猀琀愀琀攀崀 㴀 䀀䐀愀琀愀戀愀猀攀匀琀愀琀攀Ⰰഀഀ
            [jobId] = NULL਍        圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
        END਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一匀䄀䌀吀䤀伀一㬀ഀഀ
        END਍ഀഀ
         -- get error infromation and raise error਍        䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
        RETURN਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
਍䔀一䐀ഀഀ
GO਍
