/****** Object:  StoredProcedure [dss].[CreateActionAndTasksV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀爀攀愀琀攀䄀挀琀椀漀渀䄀渀搀吀愀猀欀猀嘀㈀崀ഀഀ
    @ActionId UNIQUEIDENTIFIER,਍    䀀匀礀渀挀䜀爀漀甀瀀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 一唀䰀䰀Ⰰഀഀ
    @Type INT,਍    䀀吀愀猀欀䰀椀猀琀 嬀搀猀猀崀⸀嬀吀愀猀欀吀愀戀氀攀吀礀瀀攀嘀㈀崀 刀䔀䄀䐀伀一䰀夀Ⰰഀഀ
    @TaskDependencyList [dss].[TaskDependencyTableType] READONLY਍䄀匀ഀഀ
BEGIN਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        BEGIN TRANSACTION਍ഀഀ
        INSERT INTO [dss].[action]਍        ⠀ഀഀ
            [id],਍            嬀猀礀渀挀最爀漀甀瀀椀搀崀Ⰰഀഀ
            [type],਍            嬀猀琀愀琀攀崀Ⰰഀഀ
            [creationtime],਍            嬀氀愀猀琀甀瀀搀愀琀攀琀椀洀攀崀ഀഀ
        )਍        嘀䄀䰀唀䔀匀ഀഀ
        (਍            䀀䄀挀琀椀漀渀䤀搀Ⰰഀഀ
            @SyncGroupId,਍            䀀吀礀瀀攀Ⰰഀഀ
            0, -- 0: ready਍            䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀Ⰰഀഀ
            GETUTCDATE()਍        ⤀ഀഀ
਍        ⴀⴀ 䤀渀猀攀爀琀 琀愀猀欀猀ഀഀ
        INSERT INTO [dss].[task]਍        ⠀ഀഀ
            [id],਍            嬀愀挀琀椀漀渀椀搀崀Ⰰഀഀ
            [agentid],਍            嬀爀攀焀甀攀猀琀崀Ⰰഀഀ
            [state],਍            嬀搀攀瀀攀渀搀攀渀挀礀开挀漀甀渀琀崀Ⰰഀഀ
            [priority],਍            嬀琀礀瀀攀崀Ⰰഀഀ
            [version]਍        ⤀ഀഀ
        SELECT਍            嬀椀搀崀Ⰰഀഀ
            [actionid],਍            嬀愀最攀渀琀椀搀崀Ⰰഀഀ
            [request],਍            　Ⰰ ⴀⴀ 　㨀 爀攀愀搀礀ഀഀ
            [dependency_count],਍            嬀瀀爀椀漀爀椀琀礀崀Ⰰഀഀ
            [type],਍            嬀瘀攀爀猀椀漀渀崀ഀഀ
        FROM @TaskList਍ഀഀ
        -- Insert task dependencies਍        䤀一匀䔀刀吀 䤀一吀伀 嬀搀猀猀崀⸀嬀琀愀猀欀搀攀瀀攀渀搀攀渀挀礀崀ഀഀ
        (਍            嬀渀攀砀琀琀愀猀欀椀搀崀Ⰰഀഀ
            [prevtaskid]਍        ⤀ഀഀ
        SELECT਍            嬀渀攀砀琀琀愀猀欀椀搀崀Ⰰഀഀ
            [prevtaskid]਍        䘀刀伀䴀 䀀吀愀猀欀䐀攀瀀攀渀搀攀渀挀礀䰀椀猀琀ഀഀ
਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
        END਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一匀䄀䌀吀䤀伀一㬀ഀഀ
        END਍ഀഀ
         -- get error infromation and raise error਍        䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
        RETURN਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
END਍䜀伀ഀഀ
