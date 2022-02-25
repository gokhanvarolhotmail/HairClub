/****** Object:  Table [dss].[syncgroup]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀⠀ഀഀ
	[id] [uniqueidentifier] NOT NULL,਍ऀ嬀渀愀洀攀崀 嬀搀猀猀崀⸀嬀䐀䤀匀倀䰀䄀夀开一䄀䴀䔀崀 一唀䰀䰀Ⰰഀഀ
	[subscriptionid] [uniqueidentifier] NULL,਍ऀ嬀猀挀栀攀洀愀开搀攀猀挀爀椀瀀琀椀漀渀崀 嬀砀洀氀崀 一唀䰀䰀Ⰰഀഀ
	[state] [int] NULL,਍ऀ嬀栀甀戀开洀攀洀戀攀爀椀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[conflict_resolution_policy] [int] NOT NULL,਍ऀ嬀猀礀渀挀开椀渀琀攀爀瘀愀氀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[sync_enabled] [bit] NOT NULL,਍ऀ嬀氀愀猀琀甀瀀搀愀琀攀琀椀洀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[ocsschemadefinition] [dss].[DB_SCHEMA] NULL,਍ऀ嬀栀甀戀栀愀猀搀愀琀愀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ConflictLoggingEnabled] [bit] NOT NULL,਍ऀ嬀䌀漀渀昀氀椀挀琀吀愀戀氀攀刀攀琀攀渀琀椀漀渀䤀渀䐀愀礀猀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
PRIMARY KEY CLUSTERED ਍⠀ഀഀ
	[id] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䤀䜀一伀刀䔀开䐀唀倀开䬀䔀夀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
/****** Object:  Index [index_syncgroup_hub_memberid]    Script Date: 1/10/2022 10:01:48 PM ******/਍䌀刀䔀䄀吀䔀 一伀一䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀 嬀椀渀搀攀砀开猀礀渀挀最爀漀甀瀀开栀甀戀开洀攀洀戀攀爀椀搀崀 伀一 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀ഀഀ
(਍ऀ嬀栀甀戀开洀攀洀戀攀爀椀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroup] ADD  DEFAULT (newid()) FOR [id]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroup] ADD  DEFAULT ((0)) FOR [state]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroup] ADD  DEFAULT ((1)) FOR [sync_enabled]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroup] ADD  DEFAULT ((0)) FOR [ConflictLoggingEnabled]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroup] ADD  DEFAULT ((30)) FOR [ConflictTableRetentionInDays]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroup]  WITH CHECK ADD  CONSTRAINT [FK__syncgroup__hub_m] FOREIGN KEY([hub_memberid])਍刀䔀䘀䔀刀䔀一䌀䔀匀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀 ⠀嬀椀搀崀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀 䌀䠀䔀䌀䬀 䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开猀礀渀挀最爀漀甀瀀开开栀甀戀开洀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀  圀䤀吀䠀 䌀䠀䔀䌀䬀 䄀䐀䐀  䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开猀礀渀挀最爀漀甀瀀开开猀甀戀猀挀崀 䘀伀刀䔀䤀䜀一 䬀䔀夀⠀嬀猀甀戀猀挀爀椀瀀琀椀漀渀椀搀崀⤀ഀഀ
REFERENCES [dss].[subscription] ([id])਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroup] CHECK CONSTRAINT [FK__syncgroup__subsc]਍䜀伀ഀഀ
