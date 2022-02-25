/****** Object:  StoredProcedure [dss].[GetDatabaseFillRatio]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀䐀愀琀愀戀愀猀攀䘀椀氀氀刀愀琀椀漀崀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @DbName varchar(255)਍    匀䔀吀 䀀䐀戀一愀洀攀 㴀 搀戀开渀愀洀攀⠀⤀ഀഀ
਍    䐀䔀䌀䰀䄀刀䔀 䀀䐀戀䴀愀砀匀椀稀攀 戀椀最椀渀琀ഀഀ
    SET @DbMaxSize = CAST(DATABASEPROPERTYEX(@DbName,'MaxSizeInBytes') AS BIGINT)/1024਍ഀഀ
    IF (@DbMaxSize IS NULL)਍    䈀䔀䜀䤀一ഀഀ
        -- The extended property 'MaxSizeInBytes' is only available in SQL Azure਍        匀䔀䰀䔀䌀吀 ⴀ㄀⸀　 ✀䘀椀氀氀刀愀琀椀漀✀㬀ഀഀ
    END਍ഀഀ
    declare @DbSize bigint਍    匀䔀䰀䔀䌀吀 䀀䐀戀匀椀稀攀 㴀 匀唀䴀⠀爀攀猀攀爀瘀攀搀开瀀愀最攀开挀漀甀渀琀⤀ ⨀ 㠀⸀　 䘀刀伀䴀 猀礀猀⸀搀洀开搀戀开瀀愀爀琀椀琀椀漀渀开猀琀愀琀猀ഀഀ
਍    匀䔀䰀䔀䌀吀  䌀䄀匀吀⠀䀀䐀戀匀椀稀攀 愀猀 渀甀洀攀爀椀挀⠀㄀　Ⰰ　⤀⤀⨀㄀　　⸀　⼀䌀䄀匀吀⠀䀀䐀戀䴀愀砀匀椀稀攀 愀猀 渀甀洀攀爀椀挀⠀㄀　Ⰰ　⤀⤀ ✀䘀椀氀氀刀愀琀椀漀✀ഀഀ
END਍䜀伀ഀഀ
