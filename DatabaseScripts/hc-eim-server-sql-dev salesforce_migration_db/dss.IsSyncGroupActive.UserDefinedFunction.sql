/****** Object:  UserDefinedFunction [dss].[IsSyncGroupActive]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀搀猀猀崀⸀嬀䤀猀匀礀渀挀䜀爀漀甀瀀䄀挀琀椀瘀攀崀ഀഀ
(਍    䀀匀礀渀挀䜀爀漀甀瀀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
)਍刀䔀吀唀刀一匀 䈀䤀吀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @Result BIT = 0਍ഀഀ
    IF EXISTS (SELECT 1 FROM [dss].[syncgroup] WHERE [id] = @SyncGroupId AND [state] = 0)਍    䈀䔀䜀䤀一ഀഀ
        SET @Result = 1਍    䔀一䐀ഀഀ
਍    刀䔀吀唀刀一 䀀刀攀猀甀氀琀ഀഀ
END਍䜀伀ഀഀ
