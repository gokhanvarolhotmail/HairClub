/****** Object:  Table [dss].[agent]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀愀最攀渀琀崀⠀ഀഀ
	[id] [uniqueidentifier] NOT NULL,਍ऀ嬀渀愀洀攀崀 嬀搀猀猀崀⸀嬀䐀䤀匀倀䰀䄀夀开一䄀䴀䔀崀 一唀䰀䰀Ⰰഀഀ
	[subscriptionid] [uniqueidentifier] NULL,਍ऀ嬀猀琀愀琀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[lastalivetime] [datetime] NULL,਍ऀ嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[version] [dss].[VERSION] NULL,਍ऀ嬀瀀愀猀猀眀漀爀搀开栀愀猀栀崀 嬀搀猀猀崀⸀嬀倀䄀匀匀圀伀刀䐀开䠀䄀匀䠀崀 一唀䰀䰀Ⰰഀഀ
	[password_salt] [dss].[PASSWORD_SALT] NULL,਍倀刀䤀䴀䄀刀夀 䬀䔀夀 䌀䰀唀匀吀䔀刀䔀䐀 ഀഀ
(਍ऀ嬀椀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍匀䔀吀 䄀一匀䤀开倀䄀䐀䐀䤀一䜀 伀一ഀഀ
GO਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  䤀渀搀攀砀 嬀䤀堀开䄀最攀渀琀开匀甀戀䤀搀开一愀洀攀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀⼀㄀　⼀㈀　㈀㈀ ㄀　㨀　㄀㨀㐀㠀 倀䴀 ⨀⨀⨀⨀⨀⨀⼀ഀഀ
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agent_SubId_Name] ON [dss].[agent]਍⠀ഀഀ
	[subscriptionid] ASC,਍ऀ嬀渀愀洀攀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍䜀伀ഀഀ
ALTER TABLE [dss].[agent] ADD  DEFAULT (newid()) FOR [id]਍䜀伀ഀഀ
ALTER TABLE [dss].[agent] ADD  DEFAULT ((1)) FOR [state]਍䜀伀ഀഀ
ALTER TABLE [dss].[agent]  WITH CHECK ADD  CONSTRAINT [FK__agent__subscript] FOREIGN KEY([subscriptionid])਍刀䔀䘀䔀刀䔀一䌀䔀匀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 ⠀嬀椀搀崀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀愀最攀渀琀崀 䌀䠀䔀䌀䬀 䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开愀最攀渀琀开开猀甀戀猀挀爀椀瀀琀崀ഀഀ
GO਍
