/****** Object:  StoredProcedure [TaskHosting].[GetRunningMessageCount]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[GetRunningMessageCount]਍䄀匀ഀഀ
    SELECT [MessageType], COUNT(*) as [MessageCount] FROM [TaskHosting].[MessageQueue] WITH (NOLOCK)਍    圀䠀䔀刀䔀 唀瀀搀愀琀攀吀椀洀攀唀吀䌀 䤀匀 一伀吀 一唀䰀䰀 䄀一䐀 䔀砀攀挀吀椀洀攀猀 㰀 ㌀ഀഀ
    GROUP BY [MessageType]਍    刀䔀吀唀刀一 　ഀഀ
GO਍
