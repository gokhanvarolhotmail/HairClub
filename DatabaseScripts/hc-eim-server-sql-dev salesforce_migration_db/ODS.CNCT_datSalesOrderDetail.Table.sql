/****** Object:  Table [ODS].[CNCT_datSalesOrderDetail]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀崀ഀഀ
(਍ऀ嬀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䜀唀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[TransactionNumber_Temp] [int] NULL,਍ऀ嬀匀愀氀攀猀伀爀搀攀爀䜀唀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SalesCodeID] [int] NULL,਍ऀ嬀儀甀愀渀琀椀琀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Price] [decimal](21, 6) NULL,਍ऀ嬀䐀椀猀挀漀甀渀琀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[Tax1] [decimal](19, 4) NULL,਍ऀ嬀吀愀砀㈀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[TaxRate1] [decimal](6, 5) NULL,਍ऀ嬀吀愀砀刀愀琀攀㈀崀 嬀搀攀挀椀洀愀氀崀⠀㘀Ⰰ 㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRefundedFlag] [bit] NULL,਍ऀ嬀刀攀昀甀渀搀攀搀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䜀唀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RefundedTotalQuantity] [int] NULL,਍ऀ嬀刀攀昀甀渀搀攀搀吀漀琀愀氀倀爀椀挀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee1GUID] [nvarchar](max) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㈀䜀唀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee3GUID] [nvarchar](max) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㐀䜀唀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PreviousClientMembershipGUID] [nvarchar](max) NULL,਍ऀ嬀一攀眀䌀攀渀琀攀爀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ExtendedPriceCalc] [decimal](33, 6) NULL,਍ऀ嬀吀漀琀愀氀吀愀砀䌀愀氀挀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[PriceTaxCalc] [decimal](35, 6) NULL,਍ऀ嬀䌀爀攀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreateUser] [nvarchar](max) NULL,਍ऀ嬀䰀愀猀琀唀瀀搀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastUpdateUser] [nvarchar](max) NULL,਍ऀ嬀䌀攀渀琀攀爀开吀攀洀瀀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[performer_temp] [nvarchar](max) NULL,਍ऀ嬀瀀攀爀昀漀爀洀攀爀㈀开琀攀洀瀀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Member1Price_temp] [decimal](21, 6) NULL,਍ऀ嬀䌀愀渀挀攀氀刀攀愀猀漀渀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[EntrySortOrder] [int] NULL,਍ऀ嬀䠀愀椀爀匀礀猀琀攀洀伀爀搀攀爀䜀唀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[DiscountTypeID] [int] NULL,਍ऀ嬀䈀攀渀攀昀椀琀吀爀愀挀欀椀渀最䔀渀愀戀氀攀搀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipPromotionID] [int] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀伀爀搀攀爀刀攀愀猀漀渀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipNotes] [nvarchar](max) NULL,਍ऀ嬀䜀攀渀攀爀椀挀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SalesCodeSerialNumber] [nvarchar](max) NULL,਍ऀ嬀圀爀椀琀攀伀昀昀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䜀唀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[NSFBouncedDate] [datetime2](7) NULL,਍ऀ嬀䤀猀圀爀椀琀琀攀渀伀昀昀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[InterCompanyPrice] [decimal](19, 4) NULL,਍ऀ嬀吀愀砀吀礀瀀攀㄀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[TaxType2ID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䄀搀搀伀渀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NCCMembershipPromotionID] [int] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䠀䔀䄀倀ഀഀ
)਍䜀伀ഀഀ
