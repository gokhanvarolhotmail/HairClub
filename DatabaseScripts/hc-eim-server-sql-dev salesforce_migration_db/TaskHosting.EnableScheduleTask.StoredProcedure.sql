/****** Object:  StoredProcedure [TaskHosting].[EnableScheduleTask]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[EnableScheduleTask]਍    䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
AS਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    䐀䔀䌀䰀䄀刀䔀 䀀匀琀愀琀攀 䤀一吀ഀഀ
    IF NOT EXISTS (਍        匀䔀䰀䔀䌀吀 ⨀ 䘀刀伀䴀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀匀挀栀攀搀甀氀攀吀愀猀欀ഀഀ
        WHERE ScheduleTaskId = @ScheduleTaskId)਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@ScheduleTaskId argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
਍    唀倀䐀䄀吀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀匀挀栀攀搀甀氀攀吀愀猀欀ഀഀ
    SET State = 1, NextRunTime = TaskHosting.GetNextRunTime(Schedule)਍    圀䠀䔀刀䔀 匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 㴀 䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 䄀一䐀ഀഀ
        State = 0	-- only enabled the task in disabled state, otherwise, keep the current state.਍ഀഀ
਍䜀伀ഀഀ
