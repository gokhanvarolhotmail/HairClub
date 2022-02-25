/****** Object:  StoredProcedure [TaskHosting].[GetCancelStatus]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
--Check whether a job is cancelled. When dss.job.IsCancelled is set, the job is cancelled.਍ⴀⴀ吀栀攀爀攀 愀爀攀 ㈀ 瀀漀猀猀椀戀氀攀 猀琀愀琀攀猀㨀 挀愀渀挀攀氀氀椀渀最 愀渀搀 挀愀渀挀攀氀氀攀搀⸀ 䄀 樀漀戀 椀猀 挀漀渀猀椀搀攀爀 挀愀渀挀攀氀氀椀渀最 漀渀氀礀ഀഀ
--when there's still live message exist for this job. Otherwise, it's in cancelled state.਍ⴀⴀ䄀搀搀 愀渀漀琀栀攀爀 瀀愀爀愀洀攀琀攀爀 䀀䌀栀攀挀欀䌀愀渀挀攀氀氀椀渀最伀渀氀礀 猀漀 琀栀愀琀 眀攀 挀愀渀 甀猀攀 琀栀攀 猀愀洀攀 匀倀 琀漀 挀栀攀挀欀 戀漀琀栀ഀഀ
--Cancelling and Cancelled state without querying the DB twice.਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䜀攀琀䌀愀渀挀攀氀匀琀愀琀甀猀崀ഀഀ
  @JobId     uniqueidentifier,਍  䀀䌀愀渀挀攀氀匀琀愀琀攀  戀椀琀 伀唀吀倀唀吀Ⰰഀഀ
  @IsJobRunning  bit OUTPUT਍䄀匀ഀഀ
BEGIN਍    䤀䘀 䀀䨀漀戀䤀搀 䤀匀 一唀䰀䰀ഀഀ
    BEGIN਍      刀䄀䤀匀䔀刀刀伀刀⠀✀䀀䨀漀戀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
      RETURN਍    䔀一䐀ഀഀ
਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    匀䔀䰀䔀䌀吀 䀀䌀愀渀挀攀氀匀琀愀琀攀 㴀 䤀猀䌀愀渀挀攀氀氀攀搀 䘀刀伀䴀 吀愀猀欀䠀漀猀琀椀渀最⸀䨀漀戀 圀䠀䔀刀䔀 䨀漀戀䤀搀 㴀 䀀䨀漀戀䤀搀ഀഀ
਍    䤀䘀 䔀堀䤀匀吀匀 ⠀匀䔀䰀䔀䌀吀 ⨀ 䘀刀伀䴀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀 圀䠀䔀刀䔀 䨀漀戀䤀搀 㴀 䀀䨀漀戀䤀搀⤀ഀഀ
        SET @IsJobRunning = 1਍    䔀䰀匀䔀ഀഀ
        SET @IsJobRunning = 0;਍ഀഀ
END਍ഀഀ
GO਍
