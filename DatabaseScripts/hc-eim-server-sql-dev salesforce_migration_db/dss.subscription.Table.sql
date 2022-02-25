/****** Object:  Table [dss].[subscription]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀⠀ഀഀ
	[id] [uniqueidentifier] NOT NULL,਍ऀ嬀渀愀洀攀崀 嬀搀猀猀崀⸀嬀䐀䤀匀倀䰀䄀夀开一䄀䴀䔀崀 一唀䰀䰀Ⰰഀഀ
	[creationtime] [datetime] NULL,਍ऀ嬀氀愀猀琀氀漀最椀渀琀椀洀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[tombstoneretentionperiodindays] [int] NOT NULL,਍ऀ嬀瀀漀氀椀挀礀椀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[subscriptionstate] [tinyint] NOT NULL,਍ऀ嬀圀椀渀搀漀眀猀䄀稀甀爀攀匀甀戀猀挀爀椀瀀琀椀漀渀䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[EnableDetailedProviderTracing] [bit] NULL,਍ऀ嬀猀礀渀挀猀攀爀瘀攀爀甀渀椀焀甀攀渀愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[version] [dss].[VERSION] NULL,਍倀刀䤀䴀䄀刀夀 䬀䔀夀 䌀䰀唀匀吀䔀刀䔀䐀 ഀഀ
(਍ऀ嬀椀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍匀䔀吀 䄀一匀䤀开倀䄀䐀䐀䤀一䜀 伀一ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀堀开匀礀渀挀匀攀爀瘀攀爀唀渀椀焀甀攀一愀洀攀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE UNIQUE NONCLUSTERED INDEX [IX_SyncServerUniqueName] ON [dss].[subscription]਍⠀ഀഀ
	[syncserveruniquename] ASC਍⤀ഀഀ
WHERE ([syncserveruniquename] IS NOT NULL)਍圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䤀䜀一伀刀䔀开䐀唀倀开䬀䔀夀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 䄀䐀䐀  䐀䔀䘀䄀唀䰀吀 ⠀渀攀眀椀搀⠀⤀⤀ 䘀伀刀 嬀椀搀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 䄀䐀䐀  䐀䔀䘀䄀唀䰀吀 ⠀⠀　⤀⤀ 䘀伀刀 嬀瀀漀氀椀挀礀椀搀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 䄀䐀䐀  䐀䔀䘀䄀唀䰀吀 ⠀⠀　⤀⤀ 䘀伀刀 嬀猀甀戀猀挀爀椀瀀琀椀漀渀猀琀愀琀攀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 䄀䐀䐀  䐀䔀䘀䄀唀䰀吀 ⠀⠀　⤀⤀ 䘀伀刀 嬀䔀渀愀戀氀攀䐀攀琀愀椀氀攀搀倀爀漀瘀椀搀攀爀吀爀愀挀椀渀最崀ഀഀ
GO਍
