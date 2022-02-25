/****** Object:  StoredProcedure [TaskHosting].[UpdateScheduleTaskMessageInfoV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[UpdateScheduleTaskMessageInfoV2]਍    䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @MessageId UNIQUEIDENTIFIER,਍    䀀䨀漀戀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
AS਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    䤀䘀 一伀吀 䔀堀䤀匀吀匀 ⠀ഀഀ
        SELECT * FROM [TaskHosting].ScheduleTask਍        圀䠀䔀刀䔀 匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 㴀 䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀⤀ഀഀ
    BEGIN਍      刀䄀䤀匀䔀刀刀伀刀⠀✀䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
      RETURN਍    䔀一䐀ഀഀ
਍    唀倀䐀䄀吀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀匀挀栀攀搀甀氀攀吀愀猀欀ഀഀ
    SET MessageId = @MessageId,਍        䨀漀戀䤀搀 㴀 䀀䨀漀戀䤀搀Ⰰഀഀ
        NextRunTime = TaskHosting.GetNextRunTime(Schedule)਍    圀䠀䔀刀䔀 匀挀栀攀搀甀氀攀吀愀猀欀䤀搀 㴀 䀀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀ഀഀ
਍ഀഀ
GO਍
