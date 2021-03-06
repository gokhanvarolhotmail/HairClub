/****** Object:  Table [TaskHosting].[MessageQueue]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䴀攀猀猀愀最攀儀甀攀甀攀崀⠀ഀഀ
	[MessageId] [uniqueidentifier] NOT NULL,਍ऀ嬀䨀漀戀䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[MessageType] [int] NOT NULL,਍ऀ嬀䴀攀猀猀愀最攀䐀愀琀愀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[InitialInsertTimeUTC] [datetime] NOT NULL,਍ऀ嬀䤀渀猀攀爀琀吀椀洀攀唀吀䌀崀 嬀搀愀琀攀琀椀洀攀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UpdateTimeUTC] [datetime] NULL,਍ऀ嬀䔀砀攀挀吀椀洀攀猀崀 嬀琀椀渀礀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ResetTimes] [int] NOT NULL,਍ऀ嬀嘀攀爀猀椀漀渀崀 嬀戀椀最椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[TracingId] [uniqueidentifier] NULL,਍ऀ嬀儀甀攀甀攀䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[WorkerId] [uniqueidentifier] NULL,਍倀刀䤀䴀䄀刀夀 䬀䔀夀 䌀䰀唀匀吀䔀刀䔀䐀 ഀഀ
(਍ऀ嬀䴀攀猀猀愀最攀䤀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀椀渀搀攀砀开洀攀猀猀愀最攀焀甀攀甀攀开最攀琀渀攀砀琀洀攀猀猀愀最攀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [index_messagequeue_getnextmessage] ON [TaskHosting].[MessageQueue]਍⠀ഀഀ
	[QueueId] ASC,਍ऀ嬀唀瀀搀愀琀攀吀椀洀攀唀吀䌀崀 䄀匀䌀Ⰰഀഀ
	[InsertTimeUTC] ASC,਍ऀ嬀䔀砀攀挀吀椀洀攀猀崀 䄀匀䌀Ⰰഀഀ
	[Version] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀椀渀搀攀砀开洀攀猀猀愀最攀焀甀攀甀攀开最攀琀渀攀砀琀洀攀猀猀愀最攀戀礀琀礀瀀攀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [index_messagequeue_getnextmessagebytype] ON [TaskHosting].[MessageQueue]਍⠀ഀഀ
	[QueueId] ASC,਍ऀ嬀䴀攀猀猀愀最攀吀礀瀀攀崀 䄀匀䌀Ⰰഀഀ
	[UpdateTimeUTC] ASC,਍ऀ嬀䤀渀猀攀爀琀吀椀洀攀唀吀䌀崀 䄀匀䌀Ⰰഀഀ
	[ExecTimes] ASC,਍ऀ嬀嘀攀爀猀椀漀渀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍䜀伀ഀഀ
/****** Object:  Index [index_messagequeue_jobid]    Script Date: 1/10/2022 10:01:48 PM ******/਍䌀刀䔀䄀吀䔀 一伀一䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀 嬀椀渀搀攀砀开洀攀猀猀愀最攀焀甀攀甀攀开樀漀戀椀搀崀 伀一 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䴀攀猀猀愀最攀儀甀攀甀攀崀ഀഀ
(਍ऀ嬀䨀漀戀䤀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[MessageQueue] ADD  DEFAULT (newid()) FOR [MessageId]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[MessageQueue] ADD  DEFAULT ((0)) FOR [MessageType]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[MessageQueue] ADD  DEFAULT (getutcdate()) FOR [InitialInsertTimeUTC]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[MessageQueue] ADD  DEFAULT ((0)) FOR [ExecTimes]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[MessageQueue] ADD  DEFAULT ((0)) FOR [ResetTimes]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[MessageQueue] ADD  DEFAULT ((0)) FOR [Version]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[MessageQueue]  WITH CHECK ADD FOREIGN KEY([JobId])਍刀䔀䘀䔀刀䔀一䌀䔀匀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䨀漀戀崀 ⠀嬀䨀漀戀䤀搀崀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䴀攀猀猀愀最攀儀甀攀甀攀崀  圀䤀吀䠀 䌀䠀䔀䌀䬀 䄀䐀䐀  䌀伀一匀吀刀䄀䤀一吀 嬀䌀栀欀开䔀砀攀挀吀椀洀攀猀开䜀爀攀愀琀攀爀伀爀䔀焀甀愀氀娀攀爀漀崀 䌀䠀䔀䌀䬀  ⠀⠀嬀䔀砀攀挀吀椀洀攀猀崀㸀㴀⠀　⤀⤀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䴀攀猀猀愀最攀儀甀攀甀攀崀 䌀䠀䔀䌀䬀 䌀伀一匀吀刀䄀䤀一吀 嬀䌀栀欀开䔀砀攀挀吀椀洀攀猀开䜀爀攀愀琀攀爀伀爀䔀焀甀愀氀娀攀爀漀崀ഀഀ
GO਍
