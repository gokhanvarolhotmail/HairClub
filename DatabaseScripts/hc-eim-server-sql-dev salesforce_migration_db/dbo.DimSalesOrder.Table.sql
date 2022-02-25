/****** Object:  Table [dbo].[DimSalesOrder]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀匀愀氀攀猀伀爀搀攀爀崀ഀഀ
(਍ऀ嬀匀愀氀攀猀伀爀搀攀爀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesOrderID] [uniqueidentifier] NULL,਍ऀ嬀吀攀渀搀攀爀吀爀愀渀猀愀挀琀椀漀渀一甀洀戀攀爀开吀攀洀瀀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[TicketNumber_Temp] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䠀漀洀攀䌀攀渀琀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientHomeCenterID] [int] NULL,਍ऀ嬀匀愀氀攀猀伀爀搀攀爀吀礀瀀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SalesOrderTypeID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientID] [uniqueidentifier] NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipID] [uniqueidentifier] NULL,਍ऀ嬀伀爀搀攀爀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[InvoiceNumber] [nvarchar](50) NULL,਍ऀ嬀䤀猀吀愀砀䔀砀攀洀瀀琀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsVoidedFlag] [bit] NULL,਍ऀ嬀䤀猀䌀氀漀猀攀搀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[EmployeeKey] [int] NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[FulfillmentNumber] [nvarchar](15) NULL,਍ऀ嬀䤀猀圀爀椀琀琀攀渀伀昀昀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsRefundedFlag] [bit] NULL,਍ऀ嬀刀攀昀甀渀搀攀搀匀愀氀攀猀伀爀搀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RefundedSalesOrderID] [uniqueidentifier] NULL,਍ऀ嬀䤀猀匀甀爀最攀爀礀刀攀瘀攀爀猀愀氀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsGuaranteeFlag] [bit] NULL,਍ऀ嬀䤀渀挀漀洀椀渀最刀攀焀甀攀猀琀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [varchar](50) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = REPLICATE,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀ഀഀ
	(਍ऀऀ嬀匀愀氀攀猀伀爀搀攀爀䤀䐀崀 䄀匀䌀ഀഀ
	)਍⤀ഀഀ
GO਍
