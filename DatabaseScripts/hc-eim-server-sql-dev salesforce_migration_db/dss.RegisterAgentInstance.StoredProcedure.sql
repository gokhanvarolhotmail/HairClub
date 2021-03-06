/****** Object:  StoredProcedure [dss].[RegisterAgentInstance]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀刀攀最椀猀琀攀爀䄀最攀渀琀䤀渀猀琀愀渀挀攀崀ഀഀ
    @AgentInstanceId UNIQUEIDENTIFIER,਍    䀀䄀最攀渀琀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @Version dss.VERSION਍䄀匀ഀഀ
BEGIN਍    䐀䔀䌀䰀䄀刀䔀 䀀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 䈀䤀吀ഀഀ
਍    匀䔀吀 䀀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 㴀 ⠀匀䔀䰀䔀䌀吀 嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀愀最攀渀琀崀 圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀最攀渀琀䤀搀⤀ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        BEGIN TRANSACTION਍ഀഀ
        -- we only want one instance of a local agent to run at any time.਍        䤀䘀 ⠀䀀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 㴀 ㄀⤀ ⴀⴀ ㄀㨀 漀渀 瀀爀攀洀椀猀攀 愀最攀渀琀ഀഀ
        BEGIN਍            ⴀⴀ 䐀攀氀攀琀攀 愀氀氀 瀀爀攀瘀椀漀甀猀 椀渀猀琀愀渀挀攀猀 漀昀 琀栀攀 愀最攀渀琀⸀ഀഀ
            DELETE FROM [dss].[agent_instance] WHERE [agentid] = @AgentId਍        䔀一䐀ഀഀ
਍        䤀一匀䔀刀吀 䤀一吀伀 嬀搀猀猀崀⸀嬀愀最攀渀琀开椀渀猀琀愀渀挀攀崀ഀഀ
        (਍            嬀椀搀崀Ⰰഀഀ
            [agentid],਍            嬀瘀攀爀猀椀漀渀崀ഀഀ
        )਍        嘀䄀䰀唀䔀匀ഀഀ
        (਍            䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀Ⰰഀഀ
            @AgentId,਍            䀀嘀攀爀猀椀漀渀ഀഀ
        )਍ഀഀ
        UPDATE [dss].[agent]਍        匀䔀吀ഀഀ
            [version] = @Version਍        圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀最攀渀琀䤀搀ഀഀ
਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
        END਍ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
        IF @@TRANCOUNT > 0਍        䈀䔀䜀䤀一ഀഀ
            ROLLBACK TRANSACTION;਍        䔀一䐀ഀഀ
਍         ⴀⴀ 最攀琀 攀爀爀漀爀 椀渀昀爀漀洀愀琀椀漀渀 愀渀搀 爀愀椀猀攀 攀爀爀漀爀ഀഀ
        EXECUTE [dss].[RethrowError]਍        刀䔀吀唀刀一ഀഀ
਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
END਍䜀伀ഀഀ
