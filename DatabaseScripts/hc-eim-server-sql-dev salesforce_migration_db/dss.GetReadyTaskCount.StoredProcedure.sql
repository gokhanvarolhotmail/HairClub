/****** Object:  StoredProcedure [dss].[GetReadyTaskCount]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀刀攀愀搀礀吀愀猀欀䌀漀甀渀琀崀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    SELECT COUNT(*) AS [TaskCount], [task].[type] AS [TaskType]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
    WHERE਍        嬀琀愀猀欀崀⸀嬀猀琀愀琀攀崀 㴀 　                                             ⴀⴀ 猀琀愀琀攀㨀　㨀刀攀愀搀礀ഀഀ
        AND [task].[agentid] = '28391644-B7E4-4F5A-B8AF-543966779059'  -- Cloud Tasks only਍    䜀刀伀唀倀 䈀夀 嬀琀愀猀欀崀⸀嬀琀礀瀀攀崀ഀഀ
END਍䜀伀ഀഀ
