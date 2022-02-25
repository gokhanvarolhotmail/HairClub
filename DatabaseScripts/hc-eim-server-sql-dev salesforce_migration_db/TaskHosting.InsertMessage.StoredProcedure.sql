/****** Object:  StoredProcedure [TaskHosting].[InsertMessage]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Create InsertMessage SP.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[InsertMessage]਍  䀀䴀攀猀猀愀最攀䤀搀ऀ甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀Ⰰഀഀ
  @JobId		uniqueidentifier,਍  䀀䴀攀猀猀愀最攀吀礀瀀攀ऀ椀渀琀Ⰰഀഀ
  @MessageData	nvarchar(max),਍  䀀儀甀攀甀攀䤀搀ऀऀ甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀Ⰰഀഀ
  @TracingId	uniqueidentifier,਍  䀀嘀攀爀猀椀漀渀ऀऀ戀椀最椀渀琀 㴀 　ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF @MessageId IS NULL਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@MessageId argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    IF @JobId IS NULL਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@JobId argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    SET NOCOUNT ON਍    䤀一匀䔀刀吀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀 ⠀嬀䴀攀猀猀愀最攀䤀搀崀Ⰰ 嬀䨀漀戀䤀搀崀Ⰰ 嬀䴀攀猀猀愀最攀吀礀瀀攀崀Ⰰ 嬀䴀攀猀猀愀最攀䐀愀琀愀崀Ⰰ 嬀儀甀攀甀攀䤀搀崀Ⰰ 嬀吀爀愀挀椀渀最䤀搀崀Ⰰ 嬀䤀渀椀琀椀愀氀䤀渀猀攀爀琀吀椀洀攀唀吀䌀崀Ⰰ 嬀䤀渀猀攀爀琀吀椀洀攀唀吀䌀崀Ⰰ 嬀嘀攀爀猀椀漀渀崀⤀ഀഀ
    VALUES (@MessageId, @JobId, @MessageType, @MessageData, @QueueId, @TracingId, GETUTCDATE(), GETUTCDATE(), @Version)਍䔀一䐀ഀഀ
਍䜀伀ഀഀ
