/****** Object:  Table [dbo].[DimClientMembership]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀崀ഀഀ
(਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipID] [uniqueidentifier] NULL,਍ऀ嬀䴀攀洀戀攀爀㄀开䤀䐀开吀攀洀瀀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientKey] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[CenterKey] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipKey] [int] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipStatusID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipStatusDescriptionShort] [nvarchar](10) NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䌀漀渀琀爀愀挀琀倀爀椀挀攀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipContractPaidAmount] [money] NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䴀漀渀琀栀氀礀䘀攀攀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipBeginDate] [datetime] NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipCancelDate] [datetime] NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䤀搀攀渀琀椀昀椀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[NationalMonthlyFee] [money] NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀䔀倀䰀䤀䌀䄀吀䔀Ⰰഀഀ
	CLUSTERED INDEX਍ऀ⠀ഀഀ
		[ClientMembershipID] ASC਍ऀ⤀ഀഀ
)਍䜀伀ഀഀ
