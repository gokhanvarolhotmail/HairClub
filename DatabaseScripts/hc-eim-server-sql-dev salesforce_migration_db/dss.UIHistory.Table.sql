/****** Object:  Table [dss].[UIHistory]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀唀䤀䠀椀猀琀漀爀礀崀⠀ഀഀ
	[id] [uniqueidentifier] NOT NULL,਍ऀ嬀挀漀洀瀀氀攀琀椀漀渀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[taskType] [int] NOT NULL,਍ऀ嬀爀攀挀漀爀搀吀礀瀀攀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[serverid] [uniqueidentifier] NOT NULL,਍ऀ嬀愀最攀渀琀椀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[databaseid] [uniqueidentifier] NOT NULL,਍ऀ嬀猀礀渀挀最爀漀甀瀀䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[detailEnumId] [nvarchar](400) NOT NULL,਍ऀ嬀搀攀琀愀椀氀匀琀爀椀渀最倀愀爀愀洀攀琀攀爀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[isWritable] [bit] NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀搀砀开唀䤀䠀椀猀琀漀爀礀开匀攀爀瘀攀爀䤀搀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE CLUSTERED INDEX [Idx_UIHistory_ServerId] ON [dss].[UIHistory]਍⠀ഀഀ
	[serverid] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀搀砀开唀䤀䠀椀猀琀漀爀礀开䄀最攀渀琀䤀搀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [Idx_UIHistory_AgentId] ON [dss].[UIHistory]਍⠀ഀഀ
	[agentid] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀搀砀开唀䤀䠀椀猀琀漀爀礀开䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [Idx_UIHistory_CompletionTime] ON [dss].[UIHistory]਍⠀ഀഀ
	[completionTime] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀搀砀开唀䤀䠀椀猀琀漀爀礀开䐀愀琀愀戀愀猀攀䤀搀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [Idx_UIHistory_DatabaseId] ON [dss].[UIHistory]਍⠀ഀഀ
	[databaseid] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀搀砀开唀䤀䠀椀猀琀漀爀礀开䤀搀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [Idx_UIHistory_Id] ON [dss].[UIHistory]਍⠀ഀഀ
	[id] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀搀砀开唀䤀䠀椀猀琀漀爀礀开匀礀渀挀最爀漀甀瀀䤀搀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [Idx_UIHistory_SyncgroupId] ON [dss].[UIHistory]਍⠀ഀഀ
	[syncgroupId] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀唀䤀䠀椀猀琀漀爀礀崀 䄀䐀䐀  䐀䔀䘀䄀唀䰀吀 ⠀⠀㄀⤀⤀ 䘀伀刀 嬀椀猀圀爀椀琀愀戀氀攀崀ഀഀ
GO਍
