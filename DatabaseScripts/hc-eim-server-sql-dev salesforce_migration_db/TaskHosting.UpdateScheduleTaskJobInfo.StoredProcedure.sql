/****** Object:  StoredProcedure [TaskHosting].[UpdateScheduleTaskJobInfo]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[UpdateScheduleTaskJobInfo]਍    䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @JobId UNIQUEIDENTIFIER਍䄀匀ഀഀ
    SET NOCOUNT ON਍ഀഀ
    IF NOT EXISTS (਍        匀䔀䰀䔀䌀吀 ⨀ 䘀刀伀䴀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀匀挀栀攀搀甀氀攀吀愀猀欀ഀഀ
        WHERE ScheduleTaskId = @ScheduleTaskId)਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@ScheduleTaskId argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
਍    唀倀䐀䄀吀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀匀挀栀攀搀甀氀攀吀愀猀欀ഀഀ
    SET JobId = @JobId਍    圀䠀䔀刀䔀 匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 㴀 䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀ഀഀ
਍䜀伀ഀഀ
