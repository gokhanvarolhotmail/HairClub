/****** Object:  Table [dss].[syncgroupmember]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀⠀ഀഀ
	[id] [uniqueidentifier] NOT NULL,਍ऀ嬀渀愀洀攀崀 嬀搀猀猀崀⸀嬀䐀䤀匀倀䰀䄀夀开一䄀䴀䔀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[scopename] [nvarchar](100) NOT NULL,਍ऀ嬀猀礀渀挀最爀漀甀瀀椀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[syncdirection] [int] NOT NULL,਍ऀ嬀搀愀琀愀戀愀猀攀椀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[memberstate] [int] NOT NULL,਍ऀ嬀栀甀戀猀琀愀琀攀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[memberstate_lastupdated] [datetime] NOT NULL,਍ऀ嬀栀甀戀猀琀愀琀攀开氀愀猀琀甀瀀搀愀琀攀搀崀 嬀搀愀琀攀琀椀洀攀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[lastsynctime] [datetime] NULL,਍ऀ嬀氀愀猀琀猀礀渀挀琀椀洀攀开稀攀爀漀昀愀椀氀甀爀攀猀开洀攀洀戀攀爀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[lastsynctime_zerofailures_hub] [datetime] NULL,਍ऀ嬀樀漀戀䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[hubJobId] [uniqueidentifier] NULL,਍ऀ嬀渀漀椀渀椀琀猀礀渀挀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[memberhasdata] [bit] NULL,਍倀刀䤀䴀䄀刀夀 䬀䔀夀 䌀䰀唀匀吀䔀刀䔀䐀 ഀഀ
(਍ऀ嬀椀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],਍ 䌀伀一匀吀刀䄀䤀一吀 嬀䤀堀开匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀开匀礀渀挀䜀爀漀甀瀀䤀搀开䐀愀琀愀戀愀猀攀䤀搀崀 唀一䤀儀唀䔀 一伀一䌀䰀唀匀吀䔀刀䔀䐀 ഀഀ
(਍ऀ嬀猀礀渀挀最爀漀甀瀀椀搀崀 䄀匀䌀Ⰰഀഀ
	[databaseid] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䤀䜀一伀刀䔀开䐀唀倀开䬀䔀夀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
) ON [PRIMARY]਍䜀伀ഀഀ
/****** Object:  Index [index_syncgroupmember_databaseid]    Script Date: 1/10/2022 10:01:48 PM ******/਍䌀刀䔀䄀吀䔀 一伀一䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀 嬀椀渀搀攀砀开猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀开搀愀琀愀戀愀猀攀椀搀崀 伀一 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
(਍ऀ嬀搀愀琀愀戀愀猀攀椀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT (newid()) FOR [id]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT (newid()) FOR [scopename]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT ((0)) FOR [syncdirection]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT ((0)) FOR [memberstate]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT ((0)) FOR [hubstate]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT (getutcdate()) FOR [memberstate_lastupdated]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT (getutcdate()) FOR [hubstate_lastupdated]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] ADD  DEFAULT ((0)) FOR [noinitsync]਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember]  WITH CHECK ADD  CONSTRAINT [FK__syncmember__datab] FOREIGN KEY([databaseid])਍刀䔀䘀䔀刀䔀一䌀䔀匀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀 ⠀嬀椀搀崀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀 䌀䠀䔀䌀䬀 䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开猀礀渀挀洀攀洀戀攀爀开开搀愀琀愀戀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀  圀䤀吀䠀 䌀䠀䔀䌀䬀 䄀䐀䐀  䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开猀礀渀挀洀攀洀戀攀爀开开猀礀渀挀最崀 䘀伀刀䔀䤀䜀一 䬀䔀夀⠀嬀猀礀渀挀最爀漀甀瀀椀搀崀⤀ഀഀ
REFERENCES [dss].[syncgroup] ([id])਍䜀伀ഀഀ
ALTER TABLE [dss].[syncgroupmember] CHECK CONSTRAINT [FK__syncmember__syncg]਍䜀伀ഀഀ
