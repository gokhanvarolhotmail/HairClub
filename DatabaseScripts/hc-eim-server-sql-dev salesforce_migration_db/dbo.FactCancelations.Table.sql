/****** Object:  Table [dbo].[FactCancelations]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䌀愀渀挀攀氀愀琀椀漀渀猀崀ഀഀ
(਍ऀ嬀䘀愀挀琀䐀愀琀攀欀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FactDate] [datetime] NULL,਍ऀ嬀䰀漀挀愀氀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LocalDate] [datetime] NULL,਍ऀ嬀吀椀洀攀稀漀渀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[TimeZoneID] [int] NULL,਍ऀ嬀䤀渀瘀漀椀挀攀一甀洀戀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountKey] [int] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CustomerKey] [int] NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[GeographyKey] [int] NULL,਍ऀ嬀娀椀瀀䌀漀搀攀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[RevenueGroupkey] [int] NULL,਍ऀ嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterKey] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[BusinessSegmentKey] [int] NULL,਍ऀ嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipKey] [int] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CancellationReasonKey] [int] NULL,਍ऀ嬀䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipStartDate] [datetime] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipCancelDate] [datetime] NULL,਍ऀ嬀䴀漀渀琀栀氀礀䘀攀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ContractPrice] [int] NULL,਍ऀ嬀䤀猀䴀攀洀戀攀爀猀栀椀瀀䌀栀愀渀最攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsCancellation] [bit] NULL,਍ऀ嬀䤀猀吀攀爀洀椀渀愀琀椀漀渀崀 嬀戀椀琀崀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
