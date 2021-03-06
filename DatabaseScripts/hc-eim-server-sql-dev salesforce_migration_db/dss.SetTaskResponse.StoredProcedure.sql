/****** Object:  StoredProcedure [dss].[SetTaskResponse]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀吀愀猀欀刀攀猀瀀漀渀猀攀崀ഀഀ
    @TaskId UNIQUEIDENTIFIER,਍    䀀䄀最攀渀琀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @AgentInstanceId UNIQUEIDENTIFIER,਍    䀀刀攀猀瀀漀渀猀攀 嬀搀猀猀崀⸀嬀吀䄀匀䬀开刀䔀儀唀䔀匀吀开刀䔀匀倀伀一匀䔀崀Ⰰഀഀ
    @TaskState INT,਍    䀀䄀挀琀椀漀渀匀琀愀琀甀猀 䤀一吀 伀唀吀倀唀吀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF (([dss].[IsAgentInstanceValid] (@AgentId, @AgentInstanceId)) = 0)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('INVALID_AGENT_INSTANCE', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    DECLARE @ActionId UNIQUEIDENTIFIER਍    䐀䔀䌀䰀䄀刀䔀 䀀匀琀愀琀攀 䤀一吀ഀഀ
    DECLARE @InstanceId UNIQUEIDENTIFIER਍ഀഀ
    -- temporary table to hold the tasks related to an action.਍    䐀䔀䌀䰀䄀刀䔀 䀀琀愀猀欀䤀搀猀 吀䄀䈀䰀䔀 ⠀嬀椀搀崀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 倀刀䤀䴀䄀刀夀 䬀䔀夀 一伀吀 一唀䰀䰀Ⰰ 嬀猀琀愀琀攀崀 䤀一吀 一伀吀 一唀䰀䰀⤀ഀഀ
਍    匀䔀吀 䀀䄀挀琀椀漀渀匀琀愀琀甀猀 㴀 　 ⴀⴀ 　㨀 椀渀瀀爀漀最爀攀猀猀ഀഀ
਍    匀䔀䰀䔀䌀吀ഀഀ
        @ActionId = [actionid],਍        䀀匀琀愀琀攀 㴀 嬀猀琀愀琀攀崀Ⰰഀഀ
        @InstanceId = [owning_instanceid]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
    WHERE [id] = @TaskId਍ഀഀ
    -- Check Agent Instance Id਍    䤀䘀 ⠀䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀 㰀㸀 䀀䤀渀猀琀愀渀挀攀䤀搀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䤀一嘀䄀䰀䤀䐀开䄀䜀䔀一吀开䤀一匀吀䄀一䌀䔀开䘀伀刀开吀䄀匀䬀✀Ⰰ ㄀㔀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    ⴀⴀ 䌀栀攀挀欀 猀琀愀琀攀ഀഀ
    -- Raise error when the task is processing or cancelling਍    䤀䘀 ⠀䀀匀琀愀琀攀 㰀㸀 ⴀ㄀ 䄀一䐀 䀀匀琀愀琀攀 㰀㸀 ⴀ㐀⤀  ⴀⴀ ⴀ㄀㨀 瀀爀漀挀攀猀猀椀渀最 ⴀ㐀㨀 挀愀渀挀攀氀氀椀渀最ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀吀䄀匀䬀开一伀吀开䤀一开倀刀伀䌀䔀匀匀䤀一䜀开匀吀䄀吀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    ⴀⴀ 甀瀀搀愀琀攀猀 琀漀 琀栀攀 琀愀猀欀 琀愀戀氀攀 猀栀漀甀氀搀 戀攀 搀漀渀攀 愀昀琀攀爀 愀氀氀 猀攀氀攀挀琀猀 昀爀漀洀 琀栀攀 琀愀戀氀攀 琀漀 愀瘀漀椀搀 搀攀愀搀氀漀挀欀猀⸀ഀഀ
    -- the temporary table will avoid writing select statements after the update statement.਍    ⴀⴀ 琀栀攀 唀倀䐀䰀伀䌀䬀 眀椀氀氀 愀挀焀甀椀爀攀 甀瀀搀愀琀攀 氀漀挀欀猀 漀渀 琀栀攀猀攀 琀愀猀欀猀 琀栀愀琀 戀攀氀漀渀最 琀漀 琀栀攀 愀挀琀椀漀渀ഀഀ
    -- This would prevent other responses for this action to run concurrently beyond this point and਍    ⴀⴀ 爀攀愀搀 椀渀挀漀爀爀攀挀琀 搀愀琀愀⸀ഀഀ
    INSERT INTO @taskIds ([id], [state])਍        匀䔀䰀䔀䌀吀 嬀椀搀崀Ⰰ 嬀猀琀愀琀攀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀 圀䤀吀䠀 ⠀唀倀䐀䰀伀䌀䬀⤀ 圀䠀䔀刀䔀 嬀愀挀琀椀漀渀椀搀崀 㴀 䀀䄀挀琀椀漀渀䤀搀ഀഀ
਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
    SET਍        嬀爀攀猀瀀漀渀猀攀崀 㴀 䀀刀攀猀瀀漀渀猀攀Ⰰഀഀ
        [state] = @TaskState,਍        嬀挀漀洀瀀氀攀琀攀搀琀椀洀攀崀 㴀 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀ഀഀ
    WHERE [id] = @TaskId AND [owning_instanceid] = @AgentInstanceId਍ഀഀ
    -- also update the temporary table਍    唀倀䐀䄀吀䔀 䀀琀愀猀欀䤀搀猀ഀഀ
    SET [state] = @TaskState਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀吀愀猀欀䤀搀ഀഀ
਍    ⴀⴀ 䤀昀 眀攀 搀漀渀✀琀 栀愀瘀攀 愀渀礀 漀琀栀攀爀 琀愀猀欀猀 椀渀 爀攀愀搀礀 猀琀愀琀攀 昀漀爀 琀栀椀猀 愀挀琀椀漀渀Ⰰ 琀栀攀渀 眀攀 挀愀渀 洀愀爀欀 琀栀攀 愀挀琀椀漀渀 猀琀愀琀攀⸀ഀഀ
    IF NOT EXISTS (SELECT [id] FROM @taskIds WHERE [state] <= 0) -- all tasks have completed. 0: ready਍    䈀䔀䜀䤀一ഀഀ
        -- If any task did not succeed, then the action has Failed਍        䤀䘀 䔀堀䤀匀吀匀 ⠀匀䔀䰀䔀䌀吀 嬀椀搀崀 䘀刀伀䴀 䀀琀愀猀欀䤀搀猀 圀䠀䔀刀䔀 嬀猀琀愀琀攀崀 㰀㸀 ㄀⤀ ⴀⴀ ㄀㨀猀甀挀挀攀攀搀攀搀ഀഀ
        BEGIN਍            ⴀⴀ 䄀挀琀椀漀渀 䘀愀椀氀攀搀ഀഀ
            UPDATE [dss].[action]਍            匀䔀吀ഀഀ
                [state] = 2 -- 2:failed਍            圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀挀琀椀漀渀䤀搀ഀഀ
਍            匀䔀吀 䀀䄀挀琀椀漀渀匀琀愀琀甀猀 㴀 ㈀ ⴀⴀ ㈀㨀昀愀椀氀攀搀ഀഀ
        END਍        䔀䰀匀䔀ഀഀ
        BEGIN਍            ⴀⴀ 䄀挀琀椀漀渀 匀甀挀挀攀攀搀攀搀ഀഀ
            UPDATE [dss].[action]਍            匀䔀吀ഀഀ
                [state] = 1 -- 1:succeeded਍            圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀挀琀椀漀渀䤀搀ഀഀ
਍            匀䔀吀 䀀䄀挀琀椀漀渀匀琀愀琀甀猀 㴀 ㄀ ⴀⴀ ㄀㨀猀甀挀挀攀攀搀攀搀ഀഀ
        END਍    䔀一䐀ഀഀ
END਍䜀伀ഀഀ
