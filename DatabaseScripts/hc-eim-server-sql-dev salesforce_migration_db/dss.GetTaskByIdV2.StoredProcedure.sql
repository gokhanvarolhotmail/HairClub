/****** Object:  StoredProcedure [dss].[GetTaskByIdV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀吀愀猀欀䈀礀䤀搀嘀㈀崀ഀഀ
    @TaskId UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀愀挀琀椀漀渀椀搀崀Ⰰഀഀ
        [agentid],਍        嬀爀攀焀甀攀猀琀崀Ⰰഀഀ
        [response],਍        嬀猀琀愀琀攀崀Ⰰഀഀ
        [retry_count],਍        嬀搀攀瀀攀渀搀攀渀挀礀开挀漀甀渀琀崀Ⰰഀഀ
        [owning_instanceid],਍        嬀挀爀攀愀琀椀漀渀琀椀洀攀崀Ⰰഀഀ
        [pickuptime],਍        嬀瀀爀椀漀爀椀琀礀崀Ⰰഀഀ
        [type],਍        嬀挀漀洀瀀氀攀琀攀搀琀椀洀攀崀Ⰰഀഀ
        [lastheartbeat],਍        嬀氀愀猀琀爀攀猀攀琀琀椀洀攀崀Ⰰഀഀ
        [taskNumber],਍        嬀瘀攀爀猀椀漀渀崀ഀഀ
    FROM [dss].[task]਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀吀愀猀欀䤀搀ഀഀ
END਍䜀伀ഀഀ
