/****** Object:  StoredProcedure [dss].[SetDatabaseRegion]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀䐀愀琀愀戀愀猀攀刀攀最椀漀渀崀ഀഀ
    @DatabaseID	UNIQUEIDENTIFIER,਍    䀀刀攀最椀漀渀 渀瘀愀爀挀栀愀爀⠀㈀㔀㘀⤀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    UPDATE [dss].[userdatabase]਍    匀䔀吀ഀഀ
        [region] = @Region਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀䐀ഀഀ
END਍䜀伀ഀഀ
