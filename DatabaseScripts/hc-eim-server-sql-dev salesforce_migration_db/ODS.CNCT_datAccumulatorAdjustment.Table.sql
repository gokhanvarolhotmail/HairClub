/****** Object:  Table [ODS].[CNCT_datAccumulatorAdjustment]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䄀挀挀甀洀甀氀愀琀漀爀䄀搀樀甀猀琀洀攀渀琀崀ഀഀ
(਍ऀ嬀䄀挀挀甀洀甀氀愀琀漀爀䄀搀樀甀猀琀洀攀渀琀䜀唀䤀䐀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipGUID] [varchar](8000) NULL,਍ऀ嬀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䜀唀䤀䐀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentGUID] [varchar](8000) NULL,਍ऀ嬀䄀挀挀甀洀甀氀愀琀漀爀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccumulatorActionTypeID] [int] NULL,਍ऀ嬀儀甀愀渀琀椀琀礀唀猀攀搀伀爀椀最椀渀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[QuantityUsedAdjustment] [int] NULL,਍ऀ嬀儀甀愀渀琀椀琀礀吀漀琀愀氀伀爀椀最椀渀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[QuantityTotalAdjustment] [int] NULL,਍ऀ嬀䴀漀渀攀礀伀爀椀最椀渀愀氀崀 嬀渀甀洀攀爀椀挀崀⠀㈀㄀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[MoneyAdjustment] [numeric](21, 6) NULL,਍ऀ嬀䐀愀琀攀伀爀椀最椀渀愀氀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[DateAdjustment] [date] NULL,਍ऀ嬀䌀爀攀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreateUser] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀唀瀀搀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastUpdateUser] [varchar](8000) NULL,਍ऀ嬀唀瀀搀愀琀攀匀琀愀洀瀀崀 嬀瘀愀爀戀椀渀愀爀礀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[QuantityUsedNewCalc] [int] NULL,਍ऀ嬀儀甀愀渀琀椀琀礀唀猀攀搀䌀栀愀渀最攀䌀愀氀挀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[QuantityTotalNewCalc] [int] NULL,਍ऀ嬀儀甀愀渀琀椀琀礀吀漀琀愀氀䌀栀愀渀最攀䌀愀氀挀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MoneyNewCalc] [numeric](22, 6) NULL,਍ऀ嬀䴀漀渀攀礀䌀栀愀渀最攀䌀愀氀挀崀 嬀渀甀洀攀爀椀挀崀⠀㈀㌀Ⰰ 㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[SalesOrderTenderGuid] [varchar](8000) NULL,਍ऀ嬀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䄀搀搀伀渀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
