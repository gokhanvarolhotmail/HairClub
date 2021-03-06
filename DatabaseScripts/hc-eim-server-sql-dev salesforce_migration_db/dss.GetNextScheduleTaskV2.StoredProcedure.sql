/****** Object:  StoredProcedure [dss].[GetNextScheduleTaskV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀一攀砀琀匀挀栀攀搀甀氀攀吀愀猀欀嘀㈀崀ഀഀ
    @NoOfTasks int਍䄀匀ഀഀ
BEGIN਍ഀഀ
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;਍    䐀䔀䌀䰀䄀刀䔀 䀀樀漀戀猀 吀䄀䈀䰀䔀ഀഀ
    ( Id uniqueidentifier,਍      匀琀愀琀攀 琀椀渀礀椀渀琀ഀഀ
    )਍ഀഀ
    INSERT into @jobs਍    匀䔀䰀䔀䌀吀 吀伀倀⠀䀀一漀伀昀吀愀猀欀猀⤀ഀഀ
        sch.Id, sch.State਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀 猀挀栀 圀䤀吀䠀 ⠀唀倀䐀䰀伀䌀䬀Ⰰ 刀䔀䄀䐀倀䄀匀吀⤀ഀഀ
    JOIN [dss].[syncgroup] grp ON sch.SyncGroupId = grp.id਍    䨀伀䤀一 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 猀甀戀 伀一 最爀瀀⸀猀甀戀猀挀爀椀瀀琀椀漀渀椀搀 㴀 猀甀戀⸀椀搀ഀഀ
    WHERE਍    ⠀猀挀栀⸀匀琀愀琀攀 㴀 　 伀刀ഀഀ
     (DATEDIFF(SECOND,[ExpirationTime],GETUTCDATE()) > 0 AND sch.State != 1) OR	-- Pick tasks that are due and not pending਍     ⠀䐀䄀吀䔀䐀䤀䘀䘀⠀匀䔀䌀伀一䐀Ⰰ䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ嬀䰀愀猀琀唀瀀搀愀琀攀崀⤀Ⰰ䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀ 㸀 　 䄀一䐀 猀挀栀⸀匀琀愀琀攀 㴀 ㄀⤀ऀ ⴀⴀ瀀椀挀欀 爀漀眀猀 琀栀愀琀 眀愀猀 渀漀琀 甀瀀搀愀琀攀搀 攀瘀攀渀 愀昀琀攀爀 㔀洀椀渀⸀⸀⸀猀甀最最攀猀琀椀渀最 愀 眀漀爀欀攀爀 爀漀氀攀 挀爀愀猀栀ഀഀ
     )਍    䄀一䐀 䤀渀琀攀爀瘀愀氀 㸀 　ഀഀ
    AND sub.subscriptionstate = 0 AND sch.Type > 0਍ഀഀ
    IF (@@ROWCOUNT > 0)਍    䈀䔀䜀䤀一ഀഀ
਍        唀倀䐀䄀吀䔀 匀吀ഀഀ
        SET਍        匀吀⸀嬀匀琀愀琀攀崀 㴀 ㄀Ⰰ ⴀⴀ 瀀攀渀搀椀渀最ഀഀ
        ST.[LastUpdate] = GETUTCDATE(),਍        匀吀⸀嬀倀漀瀀刀攀挀攀椀瀀琀崀 㴀 一䔀圀䤀䐀⠀⤀Ⰰഀഀ
        ST.[DequeueCount] =਍                䌀䄀匀䔀ഀഀ
                    WHEN ST.[DequeueCount] < 254 -- This is a tinyint, so make sure we don't overflow਍                        吀䠀䔀一 匀吀⸀嬀䐀攀焀甀攀甀攀䌀漀甀渀琀崀 ⬀ ㄀ഀഀ
                    ELSE਍                        匀吀⸀嬀䐀攀焀甀攀甀攀䌀漀甀渀琀崀ഀഀ
                    END਍        䘀刀伀䴀 嬀搀猀猀崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀 䄀匀 匀吀ഀഀ
        JOIN @jobs AS jbs਍        伀一 匀吀⸀嬀䤀搀崀 㴀 樀戀猀⸀䤀搀ഀഀ
    END਍ഀഀ
    SELECT਍        匀吀⸀䤀搀 䄀猀 䤀搀Ⰰഀഀ
        ST.SyncGroupId as SyncGroupId,਍        匀吀⸀倀漀瀀刀攀挀攀椀瀀琀 愀猀 倀漀瀀刀攀挀攀椀瀀琀Ⰰഀഀ
        ST.Type as TaskType਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀 䄀匀 匀吀ഀഀ
    JOIN @jobs as jbs਍    伀一 匀吀⸀嬀䤀搀崀 㴀 樀戀猀⸀䤀搀ഀഀ
਍    刀䔀吀唀刀一ഀഀ
END਍䜀伀ഀഀ
