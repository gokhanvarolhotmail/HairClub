/****** Object:  View [ODS].[SF_Campaign_Missing]    Script Date: 3/1/2022 8:53:35 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀伀䐀匀崀⸀嬀匀䘀开䌀愀洀瀀愀椀最渀开䴀椀猀猀椀渀最崀ഀഀ
AS SELECT *਍䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀开䌀愀洀瀀愀椀最渀崀 䄀匀 嬀猀崀ഀഀ
WHERE NOT EXISTS ( SELECT 1 FROM [dbo].[DimCampaign] AS [d] WHERE [d].[CampaignId] = [s].[Id] );਍䜀伀ഀഀ
