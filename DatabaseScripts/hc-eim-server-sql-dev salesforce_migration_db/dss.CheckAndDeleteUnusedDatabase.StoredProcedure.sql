/****** Object:  StoredProcedure [dss].[CheckAndDeleteUnusedDatabase]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀栀攀挀欀䄀渀搀䐀攀氀攀琀攀唀渀甀猀攀搀䐀愀琀愀戀愀猀攀崀ഀഀ
    @DatabaseId UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    䐀䔀䌀䰀䄀刀䔀 䀀䤀猀伀渀倀爀攀洀椀猀攀 䈀䤀吀ഀഀ
    DECLARE @AgentId	UNIQUEIDENTIFIER਍ഀഀ
    SELECT਍        䀀䤀猀伀渀倀爀攀洀椀猀攀 㴀 嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀Ⰰഀഀ
        @AgentId = [agentid]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
    WHERE [id] = @DatabaseId਍ഀഀ
    IF (@IsOnPremise = 0) -- cloud database਍    䈀䔀䜀䤀一ഀഀ
        -- there is no member for this database or this database is not a hub for any syncgroup਍        䤀䘀 ⠀ഀഀ
            NOT EXISTS (SELECT 1 FROM [dss].[syncgroupmember] WHERE [databaseid] = @DatabaseId) AND਍            一伀吀 䔀堀䤀匀吀匀 ⠀匀䔀䰀䔀䌀吀 ㄀ 䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀 圀䠀䔀刀䔀 嬀栀甀戀开洀攀洀戀攀爀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀搀⤀ഀഀ
            )਍        䈀䔀䜀䤀一ഀഀ
            EXEC [dss].[DeleteUserDatabase] @AgentId, @DatabaseId਍        䔀一䐀ഀഀ
    END਍䔀一䐀ഀഀ
GO਍
