/****** Object:  Table [ODS].[CNCT_datClientMembership]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀崀ഀഀ
(਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䜀唀䤀䐀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Member1_ID_Temp] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䜀唀䤀䐀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterID] [int] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipStatusID] [int] NULL,਍ऀ嬀䌀漀渀琀爀愀挀琀倀爀椀挀攀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContractPaidAmount] [numeric](19, 4) NULL,਍ऀ嬀䴀漀渀琀栀氀礀䘀攀攀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[BeginDate] [date] NULL,਍ऀ嬀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipCancelReasonID] [int] NULL,਍ऀ嬀䌀愀渀挀攀氀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsGuaranteeFlag] [bit] NULL,਍ऀ嬀䤀猀刀攀渀攀眀愀氀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsMultipleSurgeryFlag] [bit] NULL,਍ऀ嬀刀攀渀攀眀愀氀䌀漀甀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsActiveFlag] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreateUser] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀唀瀀搀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastUpdateUser] [varchar](8000) NULL,਍ऀ嬀唀瀀搀愀琀攀匀琀愀洀瀀崀 嬀瘀愀爀戀椀渀愀爀礀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipIdentifier] [varchar](8000) NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䌀愀渀挀攀氀刀攀愀猀漀渀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[HasInHousePaymentPlan] [bit] NULL,਍ऀ嬀一愀琀椀漀渀愀氀䴀漀渀琀栀氀礀䘀攀攀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[MembershipProfileTypeID] [int] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
