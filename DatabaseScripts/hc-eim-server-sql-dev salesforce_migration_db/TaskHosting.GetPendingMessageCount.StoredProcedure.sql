/****** Object:  StoredProcedure [TaskHosting].[GetPendingMessageCount]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[GetPendingMessageCount]਍䄀匀ഀഀ
    SELECT [MessageType], COUNT(*) as [MessageCount] FROM [TaskHosting].[MessageQueue] WITH (NOLOCK) WHERE UpdateTimeUTC IS NULL਍    䜀刀伀唀倀 䈀夀 嬀䴀攀猀猀愀最攀吀礀瀀攀崀ഀഀ
    RETURN 0਍䜀伀ഀഀ
