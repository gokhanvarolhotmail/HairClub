/****** Object:  Table [TaskHosting].[ScheduleTask]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀⠀ഀഀ
	[ScheduleTaskId] [uniqueidentifier] NOT NULL,਍ऀ嬀吀愀猀欀吀礀瀀攀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[TaskName] [nvarchar](128) NOT NULL,਍ऀ嬀匀挀栀攀搀甀氀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[State] [int] NOT NULL,਍ऀ嬀一攀砀琀刀甀渀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[MessageId] [uniqueidentifier] NULL,਍ऀ嬀吀愀猀欀䤀渀瀀甀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[QueueId] [uniqueidentifier] NOT NULL,਍ऀ嬀吀爀愀挀椀渀最䤀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[JobId] [uniqueidentifier] NOT NULL,਍倀刀䤀䴀䄀刀夀 䬀䔀夀 䌀䰀唀匀吀䔀刀䔀䐀 ഀഀ
(਍ऀ嬀匀挀栀攀搀甀氀攀吀愀猀欀䤀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀匀挀栀攀搀甀氀攀吀愀猀欀开䴀攀猀猀愀最攀䤀搀开䤀渀搀攀砀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE NONCLUSTERED INDEX [ScheduleTask_MessageId_Index] ON [TaskHosting].[ScheduleTask]਍⠀ഀഀ
	[MessageId] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䐀刀伀倀开䔀堀䤀匀吀䤀一䜀 㴀 伀䘀䘀Ⰰ 伀一䰀䤀一䔀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀 䄀䐀䐀  䐀䔀䘀䄀唀䰀吀 ⠀✀　　　　　　　　ⴀ　　　　ⴀ　　　　ⴀ　　　　ⴀ　　　　　　　　　　　　✀⤀ 䘀伀刀 嬀䨀漀戀䤀搀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀  圀䤀吀䠀 䌀䠀䔀䌀䬀 䄀䐀䐀 䘀伀刀䔀䤀䜀一 䬀䔀夀⠀嬀匀挀栀攀搀甀氀攀崀⤀ഀഀ
REFERENCES [TaskHosting].[Schedule] ([ScheduleId])਍䜀伀ഀഀ
