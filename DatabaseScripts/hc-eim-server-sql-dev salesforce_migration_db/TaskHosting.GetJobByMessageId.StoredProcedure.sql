/****** Object:  StoredProcedure [TaskHosting].[GetJobByMessageId]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Currently, this sproc is created as place holder for test purpose.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[GetJobByMessageId]਍    䀀䴀攀猀猀愀最攀䤀搀 甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
  IF @MessageId IS NULL਍  䈀䔀䜀䤀一ഀഀ
     RAISERROR('@MessageId argument is wrong.', 16, 1)਍     刀䔀吀唀刀一ഀഀ
  END਍ഀഀ
  SET NOCOUNT ON਍  匀䔀䰀䔀䌀吀 䨀漀戀䤀搀 䘀刀伀䴀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀ഀഀ
      WHERE MessageId = @MessageId਍ഀഀ
RETURN 0਍䔀一䐀ഀഀ
਍䜀伀ഀഀ
