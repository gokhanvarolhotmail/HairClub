/****** Object:  StoredProcedure [dss].[SetAgentCredentials]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀䄀最攀渀琀䌀爀攀搀攀渀琀椀愀氀猀崀ഀഀ
    @AgentID	UNIQUEIDENTIFIER,਍    䀀倀愀猀猀眀漀爀搀䠀愀猀栀ऀ嬀搀猀猀崀⸀嬀倀䄀匀匀圀伀刀䐀开䠀䄀匀䠀崀Ⰰഀഀ
    @PasswordSalt	[dss].[PASSWORD_SALT]਍䄀匀ഀഀ
BEGIN਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀愀最攀渀琀崀ഀഀ
    SET਍        嬀瀀愀猀猀眀漀爀搀开栀愀猀栀崀 㴀 䀀倀愀猀猀眀漀爀搀䠀愀猀栀Ⰰഀഀ
        [password_salt] = @PasswordSalt਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀最攀渀琀䤀䐀ഀഀ
END਍䜀伀ഀഀ
