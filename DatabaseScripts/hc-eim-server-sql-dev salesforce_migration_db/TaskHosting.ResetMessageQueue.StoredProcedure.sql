/****** Object:  StoredProcedure [TaskHosting].[ResetMessageQueue]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Reset the message in the particular queue to ready state so that they will be picked up again਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀刀攀猀攀琀䴀攀猀猀愀最攀儀甀攀甀攀崀ഀഀ
    @QueueId uniqueidentifier਍䄀匀ഀഀ
BEGIN਍    䤀䘀 䀀儀甀攀甀攀䤀搀 䤀匀 一唀䰀䰀ഀഀ
    BEGIN਍      刀䄀䤀匀䔀刀刀伀刀⠀✀䀀儀甀攀甀攀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
      RETURN਍    䔀一䐀ഀഀ
਍    ⴀⴀ 䄀氀氀 琀栀攀 洀攀猀猀愀最攀猀 椀渀 琀栀攀 焀甀攀甀攀 椀猀 猀琀椀氀氀 椀渀 爀甀渀渀椀渀最 猀琀愀琀攀 愀渀搀 渀攀攀搀 琀漀 戀攀 爀攀ⴀ瀀椀挀欀攀搀 甀瀀ഀഀ
    UPDATE TaskHosting.MessageQueue਍    匀䔀吀 唀瀀搀愀琀攀吀椀洀攀唀吀䌀 㴀 一唀䰀䰀Ⰰ 圀漀爀欀攀爀䤀搀 㴀 一唀䰀䰀Ⰰ 䔀砀攀挀吀椀洀攀猀 㴀 　Ⰰ 刀攀猀攀琀吀椀洀攀猀 㴀 刀攀猀攀琀吀椀洀攀猀 ⬀ ㄀ഀഀ
    WHERE QueueId = @QueueId਍ഀഀ
    RETURN 0਍䔀一䐀ഀഀ
GO਍
