/****** Object:  StoredProcedure [dss].[GetTaskById]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀吀愀猀欀䈀礀䤀搀崀ഀഀ
    @TaskId UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀愀挀琀椀漀渀椀搀崀Ⰰഀഀ
        [agentid],਍        嬀爀攀焀甀攀猀琀崀Ⰰഀഀ
        [response],਍        嬀猀琀愀琀攀崀Ⰰഀഀ
        [retry_count],਍        嬀搀攀瀀攀渀搀攀渀挀礀开挀漀甀渀琀崀Ⰰഀഀ
        [owning_instanceid],਍        嬀挀爀攀愀琀椀漀渀琀椀洀攀崀Ⰰഀഀ
        [pickuptime],਍        嬀瀀爀椀漀爀椀琀礀崀Ⰰഀഀ
        [type],਍        嬀挀漀洀瀀氀攀琀攀搀琀椀洀攀崀Ⰰഀഀ
        [lastheartbeat],਍        嬀琀愀猀欀一甀洀戀攀爀崀Ⰰഀഀ
        [version]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
    WHERE [id] = @TaskId਍䔀一䐀ഀഀ
GO਍
