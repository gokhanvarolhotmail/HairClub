/****** Object:  StoredProcedure [TaskHosting].[ResetMessageById]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Create ResetMessageById SP.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[ResetMessageById]਍  䀀䴀攀猀猀愀最攀䤀搀 甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF @MessageId IS NULL਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@MessageId argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    SET NOCOUNT ON਍    唀倀䐀䄀吀䔀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀ഀഀ
    SET [InsertTimeUTC] = GETUTCDATE(),਍        嬀唀瀀搀愀琀攀吀椀洀攀唀吀䌀崀 㴀 一唀䰀䰀Ⰰഀഀ
        [ExecTimes] = 0,਍        嬀圀漀爀欀攀爀䤀搀崀 㴀 一唀䰀䰀Ⰰഀഀ
        [ResetTimes] = [ResetTimes] + 1਍    圀䠀䔀刀䔀 嬀䴀攀猀猀愀最攀䤀搀崀 㴀 䀀䴀攀猀猀愀最攀䤀搀ഀഀ
END਍ഀഀ
GO਍
