/****** Object:  Table [dbo].[DimSalesCode]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀匀愀氀攀猀䌀漀搀攀崀ഀഀ
(਍ऀ嬀匀愀氀攀猀䌀漀搀攀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesCodeID] [int] NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesCodeDescriptionShort] [nvarchar](15) NOT NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesCodeTypeDescription] [nvarchar](50) NOT NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ProductVendorID] [int] NULL,਍ऀ嬀倀爀漀搀甀挀琀嘀攀渀搀漀爀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ProductVendorDescriptionShort] [nvarchar](10) NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Barcode] [nvarchar](25) NULL,਍ऀ嬀倀爀椀挀攀䐀攀昀愀甀氀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[GLNumber] [int] NULL,਍ऀ嬀匀攀爀瘀椀挀攀䐀甀爀愀琀椀漀渀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [varchar](50) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = REPLICATE,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀ഀഀ
	(਍ऀऀ嬀匀愀氀攀猀䌀漀搀攀䤀䐀崀 䄀匀䌀ഀഀ
	)਍⤀ഀഀ
GO਍
