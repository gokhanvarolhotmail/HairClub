/****** Object:  StoredProcedure [TaskHosting].[InsertJob]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Create InsertJob SP.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[InsertJob]਍  䀀䨀漀戀䤀搀     甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀Ⰰഀഀ
  @JobType int,਍  䀀吀爀愀挀椀渀最䤀搀 甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF @JobId IS NULL਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@JobId argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    SET NOCOUNT ON਍    䤀一匀䔀刀吀 吀愀猀欀䠀漀猀琀椀渀最⸀䨀漀戀⠀嬀䨀漀戀䤀搀崀Ⰰ 嬀䨀漀戀吀礀瀀攀崀Ⰰ 嬀吀爀愀挀椀渀最䤀搀崀⤀ഀഀ
    VALUES (@JobId, @JobType, @TracingId)਍䔀一䐀ഀഀ
਍䜀伀ഀഀ
