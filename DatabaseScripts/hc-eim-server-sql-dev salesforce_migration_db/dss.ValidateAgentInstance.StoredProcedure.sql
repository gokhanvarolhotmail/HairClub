/****** Object:  StoredProcedure [dss].[ValidateAgentInstance]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ⴀⴀ 嘀愀氀椀搀愀琀攀 眀栀攀琀栀攀爀 愀 愀最攀渀琀 椀渀猀琀愀渀挀攀 椀猀 瘀愀氀椀搀⸀ഀഀ
-- Return 0 if agent instance is valid.਍ⴀⴀ 刀攀琀甀爀渀 ㄀ 椀昀 愀 愀最攀渀琀 椀搀 椀猀 椀渀瘀愀氀椀搀⸀ഀഀ
-- Return 2 if a agent id is valid but the agent instance id is invalid.਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀嘀愀氀椀搀愀琀攀䄀最攀渀琀䤀渀猀琀愀渀挀攀崀ഀഀ
    @AgentId			UNIQUEIDENTIFIER,਍    䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀ऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF NOT EXISTS (SELECT 1 FROM [dss].[agent] WHERE [id] = @AgentId)਍    䈀䔀䜀䤀一ഀഀ
        SELECT 1਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    IF EXISTS (SELECT 1 FROM [dss].[agent_instance] WHERE [id] = @AgentInstanceId AND [agentid] = @AgentId)਍    䈀䔀䜀䤀一ഀഀ
        SELECT 0਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    SELECT 2਍䔀一䐀ഀഀ
GO਍
