/****** Object:  StoredProcedure [dss].[GetRegisteredDatabasesForAgent]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀刀攀最椀猀琀攀爀攀搀䐀愀琀愀戀愀猀攀猀䘀漀爀䄀最攀渀琀崀ഀഀ
    @AgentId	UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀猀攀爀瘀攀爀崀Ⰰഀഀ
        [database],਍        嬀猀琀愀琀攀崀Ⰰഀഀ
        [subscriptionid],਍        嬀愀最攀渀琀椀搀崀Ⰰഀഀ
        [connection_string] = null,਍        嬀搀戀开猀挀栀攀洀愀崀 㴀 渀甀氀氀Ⰰഀഀ
        [is_on_premise],਍        嬀猀焀氀愀稀甀爀攀开椀渀昀漀崀Ⰰഀഀ
        [last_schema_updated],਍        嬀氀愀猀琀开琀漀洀戀猀琀漀渀攀挀氀攀愀渀甀瀀崀Ⰰഀഀ
        [region],਍        嬀樀漀戀䤀搀崀ഀഀ
    FROM [dss].[userdatabase]਍    圀䠀䔀刀䔀 嬀愀最攀渀琀椀搀崀 㴀 䀀䄀最攀渀琀䤀搀ഀഀ
END਍䜀伀ഀഀ
