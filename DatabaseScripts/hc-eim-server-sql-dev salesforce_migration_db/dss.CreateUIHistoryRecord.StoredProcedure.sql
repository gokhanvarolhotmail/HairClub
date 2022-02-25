/****** Object:  StoredProcedure [dss].[CreateUIHistoryRecord]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ⴀⴀ 䌀爀攀愀琀攀 琀栀攀 䤀渀猀攀爀琀椀漀渀 匀倀ഀഀ
-- Make sure this file is in ANSI format਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀爀攀愀琀攀唀䤀䠀椀猀琀漀爀礀刀攀挀漀爀搀崀ഀഀ
    @Id	            UNIQUEIDENTIFIER,਍    䀀䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀 䐀䄀吀䔀吀䤀䴀䔀Ⰰഀഀ
    @TaskType       INT,਍    䀀刀攀挀漀爀搀吀礀瀀攀     䤀一吀Ⰰഀഀ
    @ServerId		UNIQUEIDENTIFIER,਍    䀀䄀最攀渀琀䤀搀ऀऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @DatabaseId		UNIQUEIDENTIFIER,਍    䀀匀礀渀挀䜀爀漀甀瀀䤀搀    唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @DisplayEnumId  nvarchar(MAX),਍    䀀䐀椀猀瀀氀愀礀倀愀爀愀洀攀琀攀爀猀ऀ渀瘀愀爀挀栀愀爀⠀䴀䄀堀⤀ 㴀 渀甀氀氀Ⰰഀഀ
    @IsWritable		bit = null਍䄀匀ഀഀ
BEGIN਍    䴀䔀刀䜀䔀 嬀搀猀猀崀⸀嬀唀䤀䠀椀猀琀漀爀礀崀 愀猀 琀愀爀最攀琀ഀഀ
    USING (SELECT @Id, @CompletionTime, @TaskType, @RecordType, @ServerId, @AgentId, @DatabaseId, @SyncGroupId, @DisplayEnumId, @DisplayParameters, @IsWritable)਍        䄀匀 猀漀甀爀挀攀⠀嬀䤀搀崀Ⰰ 嬀䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀崀Ⰰ嬀吀愀猀欀吀礀瀀攀崀Ⰰ 嬀刀攀挀漀爀搀吀礀瀀攀崀Ⰰ 嬀匀攀爀瘀攀爀䤀搀崀Ⰰ 嬀䄀最攀渀琀䤀搀崀Ⰰ 嬀䐀愀琀愀戀愀猀攀䤀搀崀Ⰰ 嬀匀礀渀挀䜀爀漀甀瀀䤀搀崀Ⰰ 嬀䐀攀琀愀椀氀䔀渀甀洀䤀搀崀Ⰰ 嬀䐀攀琀愀椀氀匀琀爀椀渀最倀愀爀愀洀攀琀攀爀猀崀Ⰰ 嬀䤀猀圀爀椀琀愀戀氀攀崀⤀ഀഀ
    ON source.Id = target.id਍    圀䠀䔀一 䴀䄀吀䌀䠀䔀䐀 䄀一䐀 ⠀琀愀爀最攀琀⸀嬀椀猀圀爀椀琀愀戀氀攀崀 㴀 ㄀⤀ 吀䠀䔀一ഀഀ
        UPDATE SET਍            嬀椀搀崀 㴀 猀漀甀爀挀攀⸀嬀䤀搀崀Ⰰഀഀ
            [completionTime] = source.[CompletionTime],਍            嬀琀愀猀欀吀礀瀀攀崀 㴀 猀漀甀爀挀攀⸀嬀吀愀猀欀吀礀瀀攀崀Ⰰഀഀ
            [recordType] = source.[RecordType],਍            嬀猀攀爀瘀攀爀椀搀崀 㴀 猀漀甀爀挀攀⸀嬀匀攀爀瘀攀爀䤀搀崀Ⰰഀഀ
            [agentid] = source.[AgentId],਍            嬀搀愀琀愀戀愀猀攀椀搀崀 㴀 猀漀甀爀挀攀⸀嬀䐀愀琀愀戀愀猀攀䤀搀崀Ⰰഀഀ
            [syncgroupId] = source.[SyncGroupId],਍            嬀搀攀琀愀椀氀䔀渀甀洀䤀搀崀 㴀 猀漀甀爀挀攀⸀嬀䐀攀琀愀椀氀䔀渀甀洀䤀搀崀Ⰰഀഀ
            [detailStringParameters] = source.[DetailStringParameters],਍            嬀椀猀圀爀椀琀愀戀氀攀崀 㴀 猀漀甀爀挀攀⸀嬀䤀猀圀爀椀琀愀戀氀攀崀ഀഀ
    WHEN NOT MATCHED THEN਍        䤀一匀䔀刀吀ഀഀ
        (਍            嬀椀搀崀Ⰰഀഀ
            [completionTime],਍            嬀琀愀猀欀吀礀瀀攀崀Ⰰഀഀ
            [recordType],਍            嬀猀攀爀瘀攀爀椀搀崀Ⰰഀഀ
            [agentid],਍            嬀搀愀琀愀戀愀猀攀椀搀崀Ⰰഀഀ
            [syncgroupId],਍            嬀搀攀琀愀椀氀䔀渀甀洀䤀搀崀Ⰰഀഀ
            [detailStringParameters],਍            嬀椀猀圀爀椀琀愀戀氀攀崀ഀഀ
        )਍        嘀䄀䰀唀䔀匀ഀഀ
        (਍            猀漀甀爀挀攀⸀嬀䤀搀崀Ⰰഀഀ
            source.[CompletionTime],਍            猀漀甀爀挀攀⸀嬀吀愀猀欀吀礀瀀攀崀Ⰰഀഀ
            source.[RecordType],਍            猀漀甀爀挀攀⸀嬀匀攀爀瘀攀爀䤀搀崀Ⰰഀഀ
            source.[AgentId],਍            猀漀甀爀挀攀⸀嬀䐀愀琀愀戀愀猀攀䤀搀崀Ⰰഀഀ
            source.[SyncGroupId],਍            猀漀甀爀挀攀⸀嬀䐀攀琀愀椀氀䔀渀甀洀䤀搀崀Ⰰഀഀ
            source.[DetailStringParameters],਍            猀漀甀爀挀攀⸀嬀䤀猀圀爀椀琀愀戀氀攀崀ഀഀ
        );਍䔀一䐀ഀഀ
GO਍
