/****** Object:  StoredProcedure [dss].[GetNextTask]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀一攀砀琀吀愀猀欀崀ഀഀ
    @AgentId UNIQUEIDENTIFIER,਍    䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @Version BIGINT = 0਍䄀匀ഀഀ
BEGIN਍    匀䔀吀 吀刀䄀一匀䄀䌀吀䤀伀一 䤀匀伀䰀䄀吀䤀伀一 䰀䔀嘀䔀䰀 刀䔀䄀䐀 䌀伀䴀䴀䤀吀吀䔀䐀㬀ഀഀ
਍    䤀䘀 ⠀⠀嬀搀猀猀崀⸀嬀䤀猀䄀最攀渀琀䤀渀猀琀愀渀挀攀嘀愀氀椀搀崀 ⠀䀀䄀最攀渀琀䤀搀Ⰰ 䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀⤀⤀ 㴀 　⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䤀一嘀䄀䰀䤀䐀开䄀䜀䔀一吀开䤀一匀吀䄀一䌀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        BEGIN TRANSACTION਍ഀഀ
        DECLARE @TaskId UNIQUEIDENTIFIER =਍        ⠀ഀഀ
            SELECT TOP 1 t.[id]਍            䘀刀伀䴀ഀഀ
            (਍                匀䔀䰀䔀䌀吀 吀伀倀 ㄀ 刀攀猀甀氀琀吀愀猀欀⸀嬀椀搀崀ഀഀ
                FROM [dss].[task] ResultTask WITH (UPDLOCK, READPAST, FORCESEEK)਍                圀䠀䔀刀䔀 刀攀猀甀氀琀吀愀猀欀⸀嬀愀最攀渀琀椀搀崀 㴀 䀀䄀最攀渀琀䤀搀 䄀一䐀ഀഀ
                      -- if the task is not processed by another agent਍                      嬀猀琀愀琀攀崀 㴀 　 䄀一䐀 ⴀⴀ 　㨀爀攀愀搀礀ഀഀ
                      [dependency_count] = 0 AND਍                      嬀瘀攀爀猀椀漀渀崀 㰀㴀 䀀嘀攀爀猀椀漀渀 ⴀⴀ 嘀攀爀猀椀漀渀 昀椀氀琀攀爀椀渀最ഀഀ
                ORDER BY ResultTask.[priority] ASC, ResultTask.[creationtime] ASC਍                唀一䤀伀一ഀഀ
                SELECT TOP 1 ResultTask.[id]਍                䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀 刀攀猀甀氀琀吀愀猀欀 圀䤀吀䠀 ⠀唀倀䐀䰀伀䌀䬀Ⰰ 刀䔀䄀䐀倀䄀匀吀Ⰰ 䘀伀刀䌀䔀匀䔀䔀䬀⤀ഀഀ
                WHERE ResultTask.[agentid] = @AgentId AND਍                      ⴀⴀ 椀昀 琀栀攀 琀愀猀欀 椀猀 猀琀椀氀氀 挀愀渀挀攀氀氀椀渀最ഀഀ
                      [state] = -4 AND [owning_instanceid] IS NULL AND -- -4:cancelling਍                      嬀搀攀瀀攀渀搀攀渀挀礀开挀漀甀渀琀崀 㴀 　 䄀一䐀ഀഀ
                      [version] <= @Version -- Version filtering਍                伀刀䐀䔀刀 䈀夀 刀攀猀甀氀琀吀愀猀欀⸀嬀瀀爀椀漀爀椀琀礀崀 䄀匀䌀Ⰰ 刀攀猀甀氀琀吀愀猀欀⸀嬀挀爀攀愀琀椀漀渀琀椀洀攀崀 䄀匀䌀ഀഀ
            ) AS t਍        ⤀ഀഀ
਍        䤀䘀 ⠀䀀吀愀猀欀䤀搀 䤀匀 一伀吀 一唀䰀䰀⤀ഀഀ
        BEGIN਍            ⴀⴀ 椀昀 琀栀攀 琀愀猀欀 椀猀 椀渀 爀攀愀搀礀 猀琀愀琀攀Ⰰ 猀攀琀 椀琀 琀漀 瀀攀渀搀椀渀最ഀഀ
            -- if the task is in cancelling state, no need to update਍            唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
            SET਍                嬀漀眀渀椀渀最开椀渀猀琀愀渀挀攀椀搀崀 㴀 䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀Ⰰഀഀ
                [state] = (CASE [state] WHEN 0 THEN -2 ELSE [state] END),਍                嬀瀀椀挀欀甀瀀琀椀洀攀崀 㴀 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀Ⰰഀഀ
                [lastheartbeat] = GETUTCDATE()਍            圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀吀愀猀欀䤀搀ഀഀ
਍            䤀䘀 ⠀䀀䀀刀伀圀䌀伀唀一吀 ℀㴀 　⤀ഀഀ
            BEGIN਍                匀䔀䰀䔀䌀吀 䀀吀愀猀欀䤀搀ഀഀ
਍                䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
                BEGIN਍                    䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
                END਍ഀഀ
                RETURN਍            䔀一䐀ഀഀ
        END਍ഀഀ
        SELECT NULL਍ഀഀ
        IF @@TRANCOUNT > 0਍        䈀䔀䜀䤀一ഀഀ
            COMMIT TRANSACTION਍        䔀一䐀ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
        IF @@TRANCOUNT > 0਍        䈀䔀䜀䤀一ഀഀ
            ROLLBACK TRANSACTION;਍        䔀一䐀ഀഀ
਍         ⴀⴀ 最攀琀 攀爀爀漀爀 椀渀昀爀漀洀愀琀椀漀渀 愀渀搀 爀愀椀猀攀 攀爀爀漀爀ഀഀ
        EXECUTE [dss].[RethrowError]਍        刀䔀吀唀刀一ഀഀ
਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
਍䔀一䐀ഀഀ
GO਍
