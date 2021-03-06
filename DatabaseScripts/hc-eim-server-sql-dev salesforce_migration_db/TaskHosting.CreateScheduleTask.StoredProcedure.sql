/****** Object:  StoredProcedure [TaskHosting].[CreateScheduleTask]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- create stored procedure [CreateScheduleTask]਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䌀爀攀愀琀攀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
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
਍            ⴀⴀ 挀爀攀愀琀攀 猀挀栀攀搀甀氀攀 昀椀爀猀琀ഀഀ
            DECLARE @ScheduleId INT਍ഀഀ
            INSERT INTO [TaskHosting].[Schedule]਍                   ⠀嬀䘀爀攀焀吀礀瀀攀崀ഀഀ
                   ,[FreqInterval])਍            嘀䄀䰀唀䔀匀ഀഀ
                   (@ScheduleType, @ScheduleInterval)਍ഀഀ
            SET @ScheduleId = @@IDENTITY਍ഀഀ
            -- add one schedule task.਍            䤀一匀䔀刀吀 䤀一吀伀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
                   ([ScheduleTaskId]਍                   Ⰰ嬀吀愀猀欀吀礀瀀攀崀ഀഀ
                   ,[TaskName]਍                   Ⰰ嬀匀挀栀攀搀甀氀攀崀ഀഀ
                   ,[TaskInput]਍                   Ⰰ嬀匀琀愀琀攀崀ഀഀ
                   ,[QueueId]਍                   Ⰰ嬀吀爀愀挀椀渀最䤀搀崀ഀഀ
                   ,[NextRunTime])਍                嘀䄀䰀唀䔀匀 ⠀ഀഀ
                    @ScheduleTaskId,਍                    䀀吀愀猀欀吀礀瀀攀Ⰰഀഀ
                    @TaskName,਍                    䀀匀挀栀攀搀甀氀攀䤀搀Ⰰഀഀ
                    @TaskInput,਍                    䀀匀琀愀琀攀Ⰰഀഀ
                    @QueueId,਍                    一䔀圀䤀䐀⠀⤀Ⰰഀഀ
                    TaskHosting.GetNextRunTime(@ScheduleId)਍                    ⤀ഀഀ
        COMMIT TRANSACTION਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍        䤀䘀 堀䄀䌀吀开匀吀䄀吀䔀⠀⤀ ℀㴀 　ഀഀ
        BEGIN਍            刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
        END਍ഀഀ
        -- Now raiserror for the error details.਍        ⴀⴀ 一漀琀攀㨀 戀甀猀椀渀攀猀猀 氀漀最椀挀 猀栀漀甀氀搀 挀愀琀挀栀 琀栀攀 攀爀爀漀爀 愀渀搀 瀀漀猀猀椀戀氀礀 爀攀琀爀礀⸀ഀഀ
        DECLARE @Error_Severity INT = ERROR_SEVERITY(),਍              䀀䔀爀爀漀爀开匀琀愀琀攀 䤀一吀 㴀 䔀刀刀伀刀开匀吀䄀吀䔀⠀⤀Ⰰഀഀ
              @Error_Number INT = ERROR_NUMBER(),਍              䀀䔀爀爀漀爀开䰀椀渀攀 䤀一吀 㴀 䔀刀刀伀刀开䰀䤀一䔀⠀⤀Ⰰഀഀ
              @Error_Message NVARCHAR(2048) = ERROR_MESSAGE();਍ഀഀ
        RAISERROR ('Msg %d, Line %d: %s',਍              䀀䔀爀爀漀爀开匀攀瘀攀爀椀琀礀Ⰰ 䀀䔀爀爀漀爀开匀琀愀琀攀Ⰰഀഀ
              @Error_Number, @Error_Line, @Error_Message);਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
END -- stored procedure਍ഀഀ
਍ഀഀ
GO਍
