/****** Object:  Table [dbo].[FactSalesTransaction]    Script Date: 3/1/2022 8:53:34 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀匀愀氀攀猀吀爀愀渀猀愀挀琀椀漀渀崀ഀഀ
(਍ऀ嬀伀爀搀攀爀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[OrderDateKey] [int] NULL,਍ऀ嬀伀爀搀攀爀吀椀洀攀伀昀䐀愀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[OrderId] [nvarchar](250) NULL,਍ऀ嬀伀爀搀攀爀䐀攀琀愀椀氀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[SalesCodeId] [int] NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SalesCodeDepartmentId] [int] NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[OrderTypeId] [int] NULL,਍ऀ嬀伀爀搀攀爀吀礀瀀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterId] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[OrderUserId] [nvarchar](250) NULL,਍ऀ嬀伀爀搀攀爀唀猀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[OrderQuantity] [int] NULL,਍ऀ嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 嬀搀攀挀椀洀愀氀崀⠀㈀㄀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[OrderPrice] [decimal](21, 6) NULL,਍ऀ嬀伀爀搀攀爀䐀椀猀挀漀甀渀琀崀 嬀搀攀挀椀洀愀氀崀⠀㈀㄀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[OrderTax1] [decimal](21, 6) NULL,਍ऀ嬀伀爀搀攀爀吀愀砀㈀崀 嬀搀攀挀椀洀愀氀崀⠀㈀㄀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[OrderTaxRate1] [decimal](21, 6) NULL,਍ऀ嬀伀爀搀攀爀吀愀砀刀愀琀攀㈀崀 嬀搀攀挀椀洀愀氀崀⠀㈀㄀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContBalMoneyAdjustment] [numeric](23, 6) NULL,਍ऀ嬀䌀漀渀琀䈀愀氀儀甀愀渀琀椀琀礀吀漀琀愀氀䌀栀愀渀最攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ContBalMoneyChange] [numeric](23, 6) NULL,਍ऀ嬀䜀爀愀昀琀猀䴀漀渀攀礀䄀搀樀甀猀琀洀攀渀琀崀 嬀渀甀洀攀爀椀挀崀⠀㈀㌀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[GraftsQuantityTotalChange] [int] NULL,਍ऀ嬀䜀爀愀昀琀猀䴀漀渀攀礀䌀栀愀渀最攀崀 嬀渀甀洀攀爀椀挀崀⠀㈀㌀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[PPSGMoneyAdjustment] [numeric](23, 6) NULL,਍ऀ嬀倀倀匀䜀儀甀愀渀琀椀琀礀吀漀琀愀氀䌀栀愀渀最攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[PPSGMoneyChange] [numeric](23, 6) NULL,਍ऀ嬀䤀猀嘀漀椀搀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsClosed] [bit] NULL,਍ऀ嬀䤀猀䜀甀愀爀愀渀琀攀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[PreviousCustomerMembershipId] [nvarchar](250) NULL,਍ऀ嬀倀爀攀瘀椀漀甀猀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[PreviousMembershipKey] [int] NULL,਍ऀ嬀倀爀攀瘀椀漀甀猀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipId] [nvarchar](250) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MembershipId] [int] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CustomerId] [nvarchar](250) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[GeographyKey] [int] NULL,਍ऀ嬀䜀攀渀搀攀爀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Genderkey] [int] NULL,਍ऀ嬀䰀愀渀最甀愀最攀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LanguageKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountKey] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRefunded] [bit] NULL,਍ऀ嬀倀攀爀昀漀爀洀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PerformerName] [nvarchar](200) NULL,਍ऀ嬀匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
