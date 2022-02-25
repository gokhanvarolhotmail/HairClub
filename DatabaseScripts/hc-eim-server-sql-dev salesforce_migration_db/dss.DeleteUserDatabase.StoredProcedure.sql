/****** Object:  StoredProcedure [dss].[DeleteUserDatabase]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䐀攀氀攀琀攀唀猀攀爀䐀愀琀愀戀愀猀攀崀ഀഀ
    @AgentId UNIQUEIDENTIFIER,਍    䀀䐀愀琀愀戀愀猀攀䤀䐀ऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF NOT EXISTS (SELECT 1 FROM [dss].[userdatabase] WHERE [id] = @DatabaseID AND [agentid] = @AgentId)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('INVALID_DATABASE', 15, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    BEGIN TRY਍        䈀䔀䜀䤀一 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
਍        ⴀⴀ 刀攀洀漀瘀攀 搀愀琀愀戀愀猀攀 昀爀漀洀 愀氀氀 猀礀渀挀 最爀漀甀瀀猀ഀഀ
        DELETE FROM [dss].[syncgroupmember]਍        圀䠀䔀刀䔀 嬀搀愀琀愀戀愀猀攀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀䐀ഀഀ
਍        䐀䔀䰀䔀吀䔀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
        WHERE [id] = @DatabaseID਍ഀഀ
        IF @@TRANCOUNT > 0਍        䈀䔀䜀䤀一ഀഀ
            COMMIT TRANSACTION਍        䔀一䐀ഀഀ
਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一匀䄀䌀吀䤀伀一㬀ഀഀ
        END਍ഀഀ
         -- get error infromation and raise error਍        䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
        RETURN਍ഀഀ
    END CATCH਍䔀一䐀ഀഀ
GO਍
