/****** Object:  StoredProcedure [TaskHosting].[UpdateScheduleTask]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- create stored procedure [UpdateScheduleTask]਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀唀瀀搀愀琀攀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
    @ScheduleTaskId UNIQUEIDENTIFIER,਍    䀀吀愀猀欀吀礀瀀攀 䤀一吀Ⰰഀഀ
    @TaskName NVARCHAR(128),਍    䀀匀挀栀攀搀甀氀攀吀礀瀀攀 䤀一吀Ⰰഀഀ
    @ScheduleInterval INT,਍    䀀吀愀猀欀䤀渀瀀甀琀 一嘀䄀刀䌀䠀䄀刀⠀䴀䄀堀⤀Ⰰഀഀ
    @State INT,਍    䀀儀甀攀甀攀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
਍䄀匀ഀഀ
BEGIN -- stored procedure਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        BEGIN TRANSACTION਍ഀഀ
            -- Check parameter਍            䤀䘀 䀀匀挀栀攀搀甀氀攀吀礀瀀攀 ℀㴀 ㈀ 䄀一䐀 䀀匀挀栀攀搀甀氀攀吀礀瀀攀 ℀㴀 㐀 䄀一䐀 䀀匀挀栀攀搀甀氀攀吀礀瀀攀 ℀㴀 㠀ഀഀ
            BEGIN਍                刀䄀䤀匀䔀刀刀伀刀⠀✀匀甀瀀瀀漀爀琀攀搀 匀挀栀攀搀甀氀攀 琀礀瀀攀 愀爀攀㨀 ㈀⠀匀攀挀漀渀搀⤀ ⼀ 㐀⠀䴀椀渀甀琀攀⤀ ⼀ 㠀⠀䠀漀甀爀⤀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
                RETURN਍            䔀一䐀ഀഀ
਍            䤀䘀 一伀吀 䔀堀䤀匀吀匀 ⠀ഀഀ
                SELECT * FROM [TaskHosting].ScheduleTask਍                圀䠀䔀刀䔀 匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 㴀 䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀⤀ഀഀ
            BEGIN਍              刀䄀䤀匀䔀刀刀伀刀⠀✀䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
              RETURN਍            䔀一䐀ഀഀ
਍            ⴀⴀ 挀爀攀愀琀攀 猀挀栀攀搀甀氀攀 昀椀爀猀琀ഀഀ
            DECLARE @ScheduleId INT਍ഀഀ
            SELECT @ScheduleId = [Schedule]਍            䘀刀伀䴀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
            WHERE [ScheduleTaskId] = @ScheduleTaskId਍ഀഀ
            UPDATE [TaskHosting].[Schedule]਍            匀䔀吀 嬀䘀爀攀焀吀礀瀀攀崀 㴀 䀀匀挀栀攀搀甀氀攀吀礀瀀攀Ⰰ 嬀䘀爀攀焀䤀渀琀攀爀瘀愀氀崀 㴀 䀀匀挀栀攀搀甀氀攀䤀渀琀攀爀瘀愀氀ഀഀ
            WHERE [ScheduleId] = @ScheduleId਍ഀഀ
            -- update the schedule task.਍            唀倀䐀䄀吀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
                SET਍                        嬀吀愀猀欀吀礀瀀攀崀 㴀 䀀吀愀猀欀吀礀瀀攀Ⰰഀഀ
                        [TaskName] = @TaskName,਍                        嬀吀愀猀欀䤀渀瀀甀琀崀 㴀 䀀吀愀猀欀䤀渀瀀甀琀Ⰰഀഀ
                        [State] = @State,਍                        嬀儀甀攀甀攀䤀搀崀 㴀 䀀儀甀攀甀攀䤀搀Ⰰഀഀ
                        [NextRunTime] = TaskHosting.GetNextRunTime(@ScheduleId)਍                圀䠀䔀刀䔀ऀ嬀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀崀 㴀 䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀ഀഀ
਍        䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
        IF XACT_STATE() != 0਍        䈀䔀䜀䤀一ഀഀ
            ROLLBACK TRANSACTION਍        䔀一䐀ഀഀ
਍        ⴀⴀ 一漀眀 爀愀椀猀攀爀爀漀爀 昀漀爀 琀栀攀 攀爀爀漀爀 搀攀琀愀椀氀猀⸀ഀഀ
        -- Note: business logic should catch the error and possibly retry.਍        䐀䔀䌀䰀䄀刀䔀 䀀䔀爀爀漀爀开匀攀瘀攀爀椀琀礀 䤀一吀 㴀 䔀刀刀伀刀开匀䔀嘀䔀刀䤀吀夀⠀⤀Ⰰഀഀ
              @Error_State INT = ERROR_STATE(),਍              䀀䔀爀爀漀爀开一甀洀戀攀爀 䤀一吀 㴀 䔀刀刀伀刀开一唀䴀䈀䔀刀⠀⤀Ⰰഀഀ
              @Error_Line INT = ERROR_LINE(),਍              䀀䔀爀爀漀爀开䴀攀猀猀愀最攀 一嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ 㴀 䔀刀刀伀刀开䴀䔀匀匀䄀䜀䔀⠀⤀㬀ഀഀ
਍        刀䄀䤀匀䔀刀刀伀刀 ⠀✀䴀猀最 ─搀Ⰰ 䰀椀渀攀 ─搀㨀 ─猀✀Ⰰഀഀ
              @Error_Severity, @Error_State,਍              䀀䔀爀爀漀爀开一甀洀戀攀爀Ⰰ 䀀䔀爀爀漀爀开䰀椀渀攀Ⰰ 䀀䔀爀爀漀爀开䴀攀猀猀愀最攀⤀㬀ഀഀ
    END CATCH਍䔀一䐀 ⴀⴀ 猀琀漀爀攀搀 瀀爀漀挀攀搀甀爀攀ഀഀ
਍ഀഀ
਍䜀伀ഀഀ
