/****** Object:  StoredProcedure [TaskHosting].[UpdateNextRunTime]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- create stored procedure to get the next the due schedule tasks.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[UpdateNextRunTime]਍䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
AS਍䈀䔀䜀䤀一 ⴀⴀ 猀琀漀爀攀搀 瀀爀漀挀攀搀甀爀攀ഀഀ
    SET NOCOUNT ON਍ഀഀ
    -- update next run time਍    唀倀䐀䄀吀䔀 吀愀猀欀䠀漀猀琀椀渀最⸀匀挀栀攀搀甀氀攀吀愀猀欀 圀䤀吀䠀 ⠀唀倀䐀䰀伀䌀䬀Ⰰ 刀䔀䄀䐀倀䄀匀吀⤀ഀഀ
    SET NextRunTime = TaskHosting.GetNextRunTime(Schedule)਍    圀䠀䔀刀䔀 匀琀愀琀攀 㴀 ㄀ऀⴀⴀ 攀渀愀戀氀攀搀 琀愀猀欀⸀ഀഀ
     AND ScheduleTaskId = @ScheduleTaskId਍䔀一䐀  ⴀⴀ 猀琀漀爀攀搀 瀀爀漀挀攀搀甀爀攀ഀഀ
GO਍
