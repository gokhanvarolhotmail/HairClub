/****** Object:  StoredProcedure [dss].[SetUserDatabaseTombstoneCleanupTime]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀唀猀攀爀䐀愀琀愀戀愀猀攀吀漀洀戀猀琀漀渀攀䌀氀攀愀渀甀瀀吀椀洀攀崀ഀഀ
    @DatabaseId UNIQUEIDENTIFIER,਍    䀀䰀愀猀琀吀漀洀戀猀琀漀渀攀䌀氀攀愀渀甀瀀 搀愀琀攀琀椀洀攀ഀഀ
AS਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
    SET਍        嬀氀愀猀琀开琀漀洀戀猀琀漀渀攀挀氀攀愀渀甀瀀崀 㴀 䀀䰀愀猀琀吀漀洀戀猀琀漀渀攀䌀氀攀愀渀甀瀀ഀഀ
    WHERE [id] = @DatabaseId਍ഀഀ
    RETURN @@ROWCOUNT਍䜀伀ഀഀ
