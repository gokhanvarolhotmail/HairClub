/****** Object:  StoredProcedure [dss].[GetAgentById]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀䄀最攀渀琀䈀礀䤀搀崀ഀഀ
    @AgentId	UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀渀愀洀攀崀Ⰰഀഀ
        [subscriptionid],਍        嬀猀琀愀琀攀崀Ⰰഀഀ
        [lastalivetime],਍        嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀Ⰰഀഀ
        [version],਍        嬀瀀愀猀猀眀漀爀搀开栀愀猀栀崀Ⰰഀഀ
        [password_salt]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀愀最攀渀琀崀ഀഀ
    WHERE [id] = @AgentId਍䔀一䐀ഀഀ
GO਍
