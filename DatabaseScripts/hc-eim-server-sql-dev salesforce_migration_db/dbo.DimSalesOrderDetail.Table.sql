/****** Object:  Table [dbo].[DimSalesOrderDetail]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀崀ഀഀ
(਍ऀ嬀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesOrderDetailID] [uniqueidentifier] NULL,਍ऀ嬀吀爀愀渀猀愀挀琀椀漀渀一甀洀戀攀爀开吀攀洀瀀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SalesOrderKey] [int] NULL,਍ऀ嬀匀愀氀攀猀伀爀搀攀爀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[SalesCodeKey] [int] NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SalesCodeDescription] [nvarchar](50) NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsVoidedFlag] [bit] NULL,਍ऀ嬀䤀猀䌀氀漀猀攀搀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Quantity] [int] NULL,਍ऀ嬀倀爀椀挀攀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[Discount] [money] NULL,਍ऀ嬀吀愀砀㄀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[Tax2] [money] NULL,਍ऀ嬀吀愀砀刀愀琀攀㄀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[TaxRate2] [money] NULL,਍ऀ嬀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[TotalTaxCalc] [money] NULL,਍ऀ嬀倀爀椀挀攀吀愀砀䌀愀氀挀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[IsRefundedFlag] [bit] NULL,਍ऀ嬀刀攀昀甀渀搀攀搀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[RefundedTotalQuantity] [int] NULL,਍ऀ嬀刀攀昀甀渀搀攀搀吀漀琀愀氀倀爀椀挀攀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[Employee1ID] [uniqueidentifier] NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㄀䘀甀氀氀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee1FirstName] [nvarchar](50) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㄀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee1Initials] [nvarchar](5) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㈀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[Employee2FullName] [nvarchar](50) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㈀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee2LastName] [nvarchar](50) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㈀䤀渀椀琀椀愀氀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee3ID] [uniqueidentifier] NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㌀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee3LastName] [nvarchar](50) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㌀䤀渀椀琀椀愀氀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee4ID] [uniqueidentifier] NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㐀䘀甀氀氀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee4FirstName] [nvarchar](50) NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㐀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Employee4Initials] [nvarchar](5) NULL,਍ऀ嬀倀爀攀瘀椀漀甀猀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[NewCenterID] [int] NULL,਍ऀ嬀倀攀爀昀漀爀洀攀爀㈀开琀攀洀瀀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Member1Price_Temp] [money] NULL,਍ऀ嬀䌀愀渀挀攀氀刀攀愀猀漀渀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[employee3fullname] [nvarchar](50) NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀伀爀搀攀爀刀攀愀猀漀渀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipPromotionID] [int] NULL,਍ऀ嬀䠀愀椀爀匀礀猀琀攀洀伀爀搀攀爀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipAddOnID] [int] NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀䔀倀䰀䤀䌀䄀吀䔀Ⰰഀഀ
	CLUSTERED INDEX਍ऀ⠀ഀഀ
		[SalesOrderDetailID] ASC਍ऀ⤀ഀഀ
)਍䜀伀ഀഀ
