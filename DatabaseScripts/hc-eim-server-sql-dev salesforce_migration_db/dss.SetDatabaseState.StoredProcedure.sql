/****** Object:  StoredProcedure [dss].[SetDatabaseState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀䐀愀琀愀戀愀猀攀匀琀愀琀攀崀ഀഀ
    @DatabaseID	UNIQUEIDENTIFIER,਍    䀀䐀愀琀愀戀愀猀攀匀琀愀琀攀 椀渀琀Ⰰഀഀ
    @JobId      UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    ⴀⴀ 䌀栀愀渀最攀 琀栀攀 搀愀琀愀戀愀猀攀 猀琀愀琀攀ഀഀ
    UPDATE [dss].[userdatabase]਍    匀䔀吀ഀഀ
        [state] = @DatabaseState,਍        嬀樀漀戀䤀搀崀 㴀 䀀䨀漀戀䤀搀ഀഀ
    WHERE [id] = @DatabaseID਍䔀一䐀ഀഀ
GO਍
