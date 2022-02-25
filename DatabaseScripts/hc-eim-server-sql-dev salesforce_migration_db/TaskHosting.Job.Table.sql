/****** Object:  Table [TaskHosting].[Job]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䨀漀戀崀⠀ഀഀ
	[JobId] [uniqueidentifier] NOT NULL,਍ऀ嬀䤀猀䌀愀渀挀攀氀氀攀搀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[InitialInsertTimeUTC] [datetime] NOT NULL,਍ऀ嬀䨀漀戀吀礀瀀攀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[InputData] [nvarchar](max) NULL,਍ऀ嬀吀愀猀欀䌀漀甀渀琀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CompletedTaskCount] [int] NOT NULL,਍ऀ嬀吀爀愀挀椀渀最䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
PRIMARY KEY CLUSTERED ਍⠀ഀഀ
	[JobId] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䤀䜀一伀刀䔀开䐀唀倀开䬀䔀夀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
/****** Object:  Index [index_job_iscancelled]    Script Date: 1/10/2022 10:01:48 PM ******/਍䌀刀䔀䄀吀䔀 一伀一䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀 嬀椀渀搀攀砀开樀漀戀开椀猀挀愀渀挀攀氀氀攀搀崀 伀一 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䨀漀戀崀ഀഀ
(਍ऀ嬀䤀猀䌀愀渀挀攀氀氀攀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[Job] ADD  DEFAULT (newid()) FOR [JobId]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[Job] ADD  DEFAULT ((0)) FOR [IsCancelled]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[Job] ADD  DEFAULT (getutcdate()) FOR [InitialInsertTimeUTC]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[Job] ADD  DEFAULT ((0)) FOR [JobType]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[Job] ADD  DEFAULT ((0)) FOR [TaskCount]਍䜀伀ഀഀ
ALTER TABLE [TaskHosting].[Job] ADD  DEFAULT ((0)) FOR [CompletedTaskCount]਍䜀伀ഀഀ
