/****** Object:  StoredProcedure [TaskHosting].[CancelJob]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Cancel Job SP਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䌀愀渀挀攀氀䨀漀戀崀ഀഀ
  @JobId     uniqueidentifier਍䄀匀ഀഀ
BEGIN਍    䤀䘀 䀀䨀漀戀䤀搀 䤀匀 一唀䰀䰀ഀഀ
    BEGIN਍      刀䄀䤀匀䔀刀刀伀刀⠀✀䀀䨀漀戀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
      RETURN਍    䔀一䐀ഀഀ
਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
    UPDATE TaskHosting.Job SET IsCancelled = 1 WHERE JobId = @JobId਍䔀一䐀ഀഀ
GO਍
