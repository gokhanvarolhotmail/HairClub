/****** Object:  Table [dbo].[DimCustomer]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䌀甀猀琀漀洀攀爀崀ഀഀ
(਍ऀ嬀䌀甀猀琀漀洀攀爀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CustomerGUID] [nvarchar](100) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䤀搀攀渀琀椀昀椀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Centerkey] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CountryId] [nvarchar](100) NULL,਍ऀ嬀䌀漀渀琀愀挀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerFirstName] [nvarchar](200) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀椀搀搀氀攀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerLastName] [nvarchar](200) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䄀搀搀爀攀猀猀㄀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerCity] [nvarchar](100) NULL,਍ऀ嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[StateId] [nvarchar](100) NULL,਍ऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Genderkey] [int] NULL,਍ऀ嬀䜀攀渀搀攀爀䤀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DateOfBirth] [date] NULL,਍ऀ嬀䐀漀一漀琀䌀愀氀氀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotContactFlag] [bit] NULL,਍ऀ嬀䤀猀䠀愀椀爀䴀漀搀攀氀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[EmailAddress] [nvarchar](100) NULL,਍ऀ嬀倀栀漀渀攀㄀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Phone2] [nvarchar](100) NULL,਍ऀ嬀䰀愀渀最甀愀最攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LanguageId] [nvarchar](100) NULL,਍ऀ嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadCreateDate] [date] NULL,਍ऀ嬀䈀漀猀氀攀礀匀愀氀攀猀昀漀爀挀攀䄀挀挀漀甀渀琀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [nvarchar](100) NULL,਍ऀ嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[DWH_LastUpdateDate] [datetime] NULL,਍ऀ嬀䤀猀䄀挀琀椀瘀攀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀䔀倀䰀䤀䌀䄀吀䔀Ⰰഀഀ
	CLUSTERED INDEX਍ऀ⠀ഀഀ
		[CustomerKey] ASC਍ऀ⤀ഀഀ
)਍䜀伀ഀഀ
