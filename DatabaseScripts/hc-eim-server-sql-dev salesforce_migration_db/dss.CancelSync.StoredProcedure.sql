/****** Object:  StoredProcedure [dss].[CancelSync]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀愀渀挀攀氀匀礀渀挀崀ഀഀ
    @SyncGroupId	UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    䤀䘀 ⠀⠀嬀搀猀猀崀⸀嬀䤀猀匀礀渀挀䜀爀漀甀瀀䄀挀琀椀瘀攀崀 ⠀䀀匀礀渀挀䜀爀漀甀瀀䤀搀⤀⤀ 㴀 　⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀匀夀一䌀䜀刀伀唀倀开䐀伀䔀匀开一伀吀开䔀堀䤀匀吀开伀刀开一伀吀开䄀䌀吀䤀嘀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
    SET਍        嬀猀琀愀琀攀崀 㴀 ⴀ㐀  ⴀⴀ猀攀琀 琀愀猀欀 猀琀愀琀攀 琀漀 挀愀渀挀攀氀氀椀渀最ഀഀ
    WHERE [type] = 2 AND [state] <= 0   -- all sync tasks in ready, pending and processing states਍        䄀一䐀 ⠀嬀愀挀琀椀漀渀椀搀崀 䤀一ഀഀ
        (SELECT਍            嬀椀搀崀ഀഀ
        FROM [dss].[action]਍        圀䠀䔀刀䔀 ⠀嬀猀礀渀挀最爀漀甀瀀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀⤀⤀⤀ഀഀ
END਍䜀伀ഀഀ
