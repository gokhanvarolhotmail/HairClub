/****** Object:  Table [dss].[agent_instance]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀愀最攀渀琀开椀渀猀琀愀渀挀攀崀⠀ഀഀ
	[id] [uniqueidentifier] NOT NULL,਍ऀ嬀愀最攀渀琀椀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[lastalivetime] [datetime] NULL,਍ऀ嬀瘀攀爀猀椀漀渀崀 嬀搀猀猀崀⸀嬀嘀䔀刀匀䤀伀一崀 一伀吀 一唀䰀䰀Ⰰഀഀ
PRIMARY KEY CLUSTERED ਍⠀ഀഀ
	[id] ASC਍⤀圀䤀吀䠀 ⠀匀吀䄀吀䤀匀吀䤀䌀匀开一伀刀䔀䌀伀䴀倀唀吀䔀 㴀 伀䘀䘀Ⰰ 䤀䜀一伀刀䔀开䐀唀倀开䬀䔀夀 㴀 伀䘀䘀Ⰰ 伀倀吀䤀䴀䤀娀䔀开䘀伀刀开匀䔀儀唀䔀一吀䤀䄀䰀开䬀䔀夀 㴀 伀䘀䘀⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
) ON [PRIMARY]਍䜀伀ഀഀ
ALTER TABLE [dss].[agent_instance] ADD  DEFAULT (newid()) FOR [id]਍䜀伀ഀഀ
ALTER TABLE [dss].[agent_instance]  WITH CHECK ADD  CONSTRAINT [FK__agent_ins__agent] FOREIGN KEY([agentid])਍刀䔀䘀䔀刀䔀一䌀䔀匀 嬀搀猀猀崀⸀嬀愀最攀渀琀崀 ⠀嬀椀搀崀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀愀最攀渀琀开椀渀猀琀愀渀挀攀崀 䌀䠀䔀䌀䬀 䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开愀最攀渀琀开椀渀猀开开愀最攀渀琀崀ഀഀ
GO਍
