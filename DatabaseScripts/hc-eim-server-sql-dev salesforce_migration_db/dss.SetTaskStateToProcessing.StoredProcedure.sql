/****** Object:  StoredProcedure [dss].[SetTaskStateToProcessing]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀吀愀猀欀匀琀愀琀攀吀漀倀爀漀挀攀猀猀椀渀最崀ഀഀ
    @TaskId UNIQUEIDENTIFIER,਍    䀀䄀最攀渀琀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @AgentInstanceId UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    䤀䘀 ⠀⠀嬀搀猀猀崀⸀嬀䤀猀䄀最攀渀琀䤀渀猀琀愀渀挀攀嘀愀氀椀搀崀 ⠀䀀䄀最攀渀琀䤀搀Ⰰ 䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀⤀⤀ 㴀 　⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䤀一嘀䄀䰀䤀䐀开䄀䜀䔀一吀开䤀一匀吀䄀一䌀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    ⴀⴀ 䌀愀渀 漀渀氀礀 甀瀀搀愀琀攀 猀琀愀琀攀 甀猀椀渀最 琀栀椀猀 瀀爀漀挀攀搀甀爀攀 琀漀 瀀爀漀挀攀猀猀椀渀最⸀ഀഀ
    --਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
        SET਍            嬀猀琀愀琀攀崀 㴀 ⴀ㄀ ⴀⴀ ⴀ㄀㨀 瀀爀漀挀攀猀猀椀渀最ഀഀ
        WHERE [id] = @TaskId AND [state] <> -4 AND [owning_instanceid] = @AgentInstanceId -- -4: cancelling਍ഀഀ
END਍䜀伀ഀഀ
