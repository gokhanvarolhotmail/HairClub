/****** Object:  StoredProcedure [dss].[GetConcurrentSyncTaskCount]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀䌀漀渀挀甀爀爀攀渀琀匀礀渀挀吀愀猀欀䌀漀甀渀琀崀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    SELECT COUNT(*) AS 'SyncTaskCount'਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
    WHERE [type] = 2 AND [state] = -1 -- type:2:sync਍䔀一䐀ഀഀ
GO਍
