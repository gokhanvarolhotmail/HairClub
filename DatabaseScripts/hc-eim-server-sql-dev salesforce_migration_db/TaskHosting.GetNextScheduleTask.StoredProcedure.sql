/****** Object:  StoredProcedure [TaskHosting].[GetNextScheduleTask]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- create stored procedure to get the next the due schedule tasks.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[GetNextScheduleTask]਍䄀匀ഀഀ
BEGIN -- stored procedure਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
    BEGIN TRY਍        䈀䔀䜀䤀一 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
਍ഀഀ
            SELECT ScheduleTaskId, TaskType, TaskName,਍                匀琀愀琀攀Ⰰ 一攀砀琀刀甀渀吀椀洀攀Ⰰ 䴀攀猀猀愀最攀䤀搀Ⰰ 吀愀猀欀䤀渀瀀甀琀Ⰰ 儀甀攀甀攀䤀搀Ⰰ 吀爀愀挀椀渀最䤀搀Ⰰ 䨀漀戀䤀搀ഀഀ
            FROM [TaskHosting].[ScheduleTask] WITH (UPDLOCK, READPAST)਍            圀䠀䔀刀䔀 匀琀愀琀攀 㴀 ㄀ऀⴀⴀ 攀渀愀戀氀攀搀 琀愀猀欀⸀ഀഀ
            AND DATEDIFF(SECOND, NextRunTime, GETUTCDATE()) > 0	-- task is due.਍ഀഀ
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
END  -- stored procedure਍䜀伀ഀഀ
