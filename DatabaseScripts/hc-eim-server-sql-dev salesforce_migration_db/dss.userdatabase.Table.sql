/****** Object:  Table [dss].[userdatabase]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀⠀ഀഀ
	[id] [uniqueidentifier] NOT NULL,਍ऀ嬀猀攀爀瘀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[database] [nvarchar](256) NULL,਍ऀ嬀猀琀愀琀攀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[subscriptionid] [uniqueidentifier] NOT NULL,਍ऀ嬀愀最攀渀琀椀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[connection_string] [varbinary](max) NULL,਍ऀ嬀搀戀开猀挀栀攀洀愀崀 嬀搀猀猀崀⸀嬀䐀䈀开匀䌀䠀䔀䴀䄀崀 一唀䰀䰀Ⰰഀഀ
	[is_on_premise] [bit] NOT NULL,਍ऀ嬀猀焀氀愀稀甀爀攀开椀渀昀漀崀 嬀砀洀氀崀 一唀䰀䰀Ⰰഀഀ
	[last_schema_updated] [datetime] NULL,਍ऀ嬀氀愀猀琀开琀漀洀戀猀琀漀渀攀挀氀攀愀渀甀瀀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[region] [nvarchar](256) NULL,਍ऀ嬀樀漀戀䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
PRIMARY KEY CLUSTERED ਍⠀ഀഀ
	[id] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䤀䜀一伀刀䔀开䐀唀倀开䬀䔀夀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
ALTER TABLE [dss].[userdatabase] ADD  DEFAULT (newid()) FOR [id]਍䜀伀ഀഀ
ALTER TABLE [dss].[userdatabase] ADD  DEFAULT ((0)) FOR [state]਍䜀伀ഀഀ
ALTER TABLE [dss].[userdatabase]  WITH CHECK ADD  CONSTRAINT [FK__userdatab__subsc] FOREIGN KEY([subscriptionid])਍刀䔀䘀䔀刀䔀一䌀䔀匀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 ⠀嬀椀搀崀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀 䌀䠀䔀䌀䬀 䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开甀猀攀爀搀愀琀愀戀开开猀甀戀猀挀崀ഀഀ
GO਍
