/****** Object:  Table [dbo].[FactCancellations]    Script Date: 3/23/2022 10:16:57 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䌀愀渀挀攀氀氀愀琀椀漀渀猀崀ഀഀ
(਍ऀ嬀䘀愀挀琀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FactDate] [datetime] NULL,਍ऀ嬀䰀漀挀愀氀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LocalDate] [datetime] NULL,਍ऀ嬀吀椀洀攀稀漀渀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[TimezoneId] [nvarchar](1024) NULL,਍ऀ嬀䤀渀瘀漀椀挀攀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountKey] [int] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerKey] [int] NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[GeographyKey] [int] NULL,਍ऀ嬀娀椀瀀䌀漀搀攀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[RevenueGroupkey] [int] NULL,਍ऀ嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterKey] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterNumber] [int] NULL,਍ऀ嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[BusinessSegmentId] [nvarchar](1024) NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipId] [nvarchar](1024) NULL,਍ऀ嬀䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CancellationReasonId] [nvarchar](1024) NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipEndDate] [datetime] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䌀愀渀挀攀氀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[MonthlyFee] [nvarchar](199) NULL,਍ऀ嬀䌀漀渀琀爀愀挀琀倀爀椀挀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㤀㤀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsMembershipChange] [bit] NULL,਍ऀ嬀䤀猀䌀愀渀挀攀氀氀愀琀椀漀渀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsTermination] [bit] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
