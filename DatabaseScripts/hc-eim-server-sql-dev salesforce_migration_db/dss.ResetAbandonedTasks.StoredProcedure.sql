/****** Object:  StoredProcedure [dss].[ResetAbandonedTasks]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀刀攀猀攀琀䄀戀愀渀搀漀渀攀搀吀愀猀欀猀崀ഀഀ
    @TimeInSeconds	INT਍䄀匀ഀഀ
BEGIN਍    ⴀⴀ 刀攀猀攀琀 琀栀攀 琀愀猀欀猀 愀渀搀 猀攀琀 琀栀攀洀 琀漀 爀攀愀搀礀 椀昀 眀攀 栀愀瘀攀 渀漀琀 爀攀挀攀椀瘀攀搀 愀 栀攀愀爀琀戀攀愀琀 昀漀爀 猀漀洀攀 琀椀洀攀⸀ഀഀ
    UPDATE [dss].[task]਍    匀䔀吀ഀഀ
        [state] = (CASE [state] WHEN -4 THEN [state] ELSE 0 END), -- 0: ready -4: cancelling਍        嬀爀攀琀爀礀开挀漀甀渀琀崀 㴀 　Ⰰഀഀ
        [owning_instanceid] = NULL,਍        嬀瀀椀挀欀甀瀀琀椀洀攀崀 㴀 一唀䰀䰀Ⰰഀഀ
        [response] = NULL,਍        嬀氀愀猀琀栀攀愀爀琀戀攀愀琀崀 㴀 一唀䰀䰀Ⰰഀഀ
        [lastresettime] = GETUTCDATE()਍    ⴀⴀ 嬀猀琀愀琀攀崀 㰀 　 洀攀愀渀猀 琀愀猀欀 椀猀 瀀椀挀欀攀搀 甀瀀 愀渀搀 渀漀琀 挀漀洀瀀氀攀琀攀搀 礀攀琀⸀ഀഀ
    -- Date comparison will be false if [lastheartbeat] is NULL਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀 圀䤀吀䠀 ⠀䘀伀刀䌀䔀匀䔀䔀䬀⤀ഀഀ
    WHERE [state] < 0 AND਍    嬀氀愀猀琀栀攀愀爀琀戀攀愀琀崀 㰀 䐀䄀吀䔀䄀䐀䐀⠀匀䔀䌀伀一䐀Ⰰ ⴀ䀀吀椀洀攀䤀渀匀攀挀漀渀搀猀Ⰰ 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀ഀഀ
END਍䜀伀ഀഀ
