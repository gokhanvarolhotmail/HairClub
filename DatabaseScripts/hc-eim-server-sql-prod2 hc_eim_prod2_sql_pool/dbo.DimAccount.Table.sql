/****** Object:  Table [dbo].[DimAccount]    Script Date: 2/22/2022 9:20:30 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䄀挀挀漀甀渀琀崀ഀഀ
(਍ऀ嬀䄀挀挀漀甀渀琀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[AccountId] [varchar](50) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䘀椀爀猀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountLastName] [varchar](250) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䘀甀氀氀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsActive] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [varchar](50) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedTimeKey] [int] NULL,਍ऀ嬀䌀爀攀愀琀攀搀唀猀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [datetime] NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedUserKey] [int] NULL,਍ऀ嬀䈀椀氀氀椀渀最匀琀爀攀攀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingCity] [varchar](150) NULL,਍ऀ嬀䈀椀氀氀椀渀最匀琀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingPostalCode] [varchar](150) NULL,਍ऀ嬀䈀椀氀氀椀渀最䌀漀甀渀琀爀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingStateCode] [varchar](150) NULL,਍ऀ嬀䈀椀氀氀椀渀最䌀漀甀渀琀爀礀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingGeographyKey] [int] NULL,਍ऀ嬀䔀琀栀渀椀挀椀琀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountEtnicity] [varchar](150) NULL,਍ऀ嬀䜀攀渀搀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountGender] [varchar](150) NULL,਍ऀ嬀䄀挀挀漀甀渀琀倀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountEmail] [varchar](250) NULL,਍ऀ嬀倀攀爀猀漀渀䌀漀渀琀愀挀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsPersonAccount] [bit] NULL,਍ऀ嬀䐀漀一漀琀䌀愀氀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotContact] [bit] NULL,਍ऀ嬀䐀漀一漀琀䔀洀愀椀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotMail] [bit] NULL,਍ऀ嬀䐀漀一漀琀吀攀砀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[NorwoodScale] [varchar](150) NULL,਍ऀ嬀䰀甀搀眀椀最匀挀愀氀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossScaleKey] [int] NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀䤀渀䘀愀洀椀氀礀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[HairLossProductUsed] [varchar](250) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀匀瀀漀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[DiscStyle] [varchar](250) NULL,਍ऀ嬀䄀挀挀漀甀渀琀匀琀愀琀甀猀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountStatus] [varchar](250) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountCompany] [varchar](250) NULL,਍ऀ嬀匀漀甀爀挀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountSource] [varchar](250) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䔀砀琀攀爀渀愀氀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[MaritalStatusKey] [int] NULL,਍ऀ嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [varchar](250) NULL,਍ऀ嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LastUpdateDate] [datetime] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = REPLICATE,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀ഀഀ
	(਍ऀऀ嬀䄀挀挀漀甀渀琀䬀攀礀崀 䄀匀䌀ഀഀ
	)਍⤀ഀഀ
GO਍
