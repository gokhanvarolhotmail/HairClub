/****** Object:  Table [dss].[taskdependency]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀琀愀猀欀搀攀瀀攀渀搀攀渀挀礀崀⠀ഀഀ
	[nexttaskid] [uniqueidentifier] NOT NULL,਍ऀ嬀瀀爀攀瘀琀愀猀欀椀搀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
 CONSTRAINT [PK_TaskTask] PRIMARY KEY CLUSTERED ਍⠀ഀഀ
	[nexttaskid] ASC,਍ऀ嬀瀀爀攀瘀琀愀猀欀椀搀崀 䄀匀䌀ഀഀ
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀琀愀猀欀搀攀瀀攀渀搀攀渀挀礀崀  圀䤀吀䠀 䌀䠀䔀䌀䬀 䄀䐀䐀  䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开琀愀猀欀搀攀瀀攀渀开开渀攀砀琀琀崀 䘀伀刀䔀䤀䜀一 䬀䔀夀⠀嬀渀攀砀琀琀愀猀欀椀搀崀⤀ഀഀ
REFERENCES [dss].[task] ([id])਍䜀伀ഀഀ
ALTER TABLE [dss].[taskdependency] CHECK CONSTRAINT [FK__taskdepen__nextt]਍䜀伀ഀഀ
ALTER TABLE [dss].[taskdependency]  WITH CHECK ADD  CONSTRAINT [FK__taskdepen__prevt] FOREIGN KEY([prevtaskid])਍刀䔀䘀䔀刀䔀一䌀䔀匀 嬀搀猀猀崀⸀嬀琀愀猀欀崀 ⠀嬀椀搀崀⤀ഀഀ
GO਍䄀䰀吀䔀刀 吀䄀䈀䰀䔀 嬀搀猀猀崀⸀嬀琀愀猀欀搀攀瀀攀渀搀攀渀挀礀崀 䌀䠀䔀䌀䬀 䌀伀一匀吀刀䄀䤀一吀 嬀䘀䬀开开琀愀猀欀搀攀瀀攀渀开开瀀爀攀瘀琀崀ഀഀ
GO਍
