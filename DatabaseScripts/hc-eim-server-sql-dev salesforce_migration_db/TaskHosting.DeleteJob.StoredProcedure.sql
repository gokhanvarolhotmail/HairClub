/****** Object:  StoredProcedure [TaskHosting].[DeleteJob]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Create DeleteJob SP.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[DeleteJob]਍  䀀䨀漀戀䤀搀     甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF @JobId IS NULL਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@JobId argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    SET NOCOUNT ON਍    䐀䔀䰀䔀吀䔀 吀愀猀欀䠀漀猀琀椀渀最⸀䨀漀戀 圀䠀䔀刀䔀 䨀漀戀䤀搀 㴀 䀀䨀漀戀䤀搀ഀഀ
END਍ഀഀ
GO਍
