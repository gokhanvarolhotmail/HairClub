/****** Object:  Table [dbo].[SLF_Final_Person_Account_INT]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开䘀椀渀愀氀开倀攀爀猀漀渀开䄀挀挀漀甀渀琀开䤀一吀崀⠀ഀഀ
	[Id] [varchar](1) NOT NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㌀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Phone] [nvarchar](max) NULL,਍ऀ嬀䄀挀挀漀甀渀琀匀漀甀爀挀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Birthdate__c] [nvarchar](4000) NULL,਍ऀ嬀䈀椀氀氀椀渀最䌀椀琀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingCountry] [nvarchar](max) NULL,਍ऀ嬀䈀椀氀氀椀渀最䌀漀甀渀琀爀礀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingGeocodeAccuracy] [nvarchar](max) NULL,਍ऀ嬀䈀椀氀氀椀渀最䰀愀琀椀琀甀搀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingLongitude] [decimal](38, 18) NULL,਍ऀ嬀䈀椀氀氀椀渀最匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingStateCode] [nvarchar](max) NULL,਍ऀ嬀䈀椀氀氀椀渀最匀琀爀攀攀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[BillingPostalCode] [nvarchar](max) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䨀椀最猀愀眀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Disc__pc] [nvarchar](max) NULL,਍ऀ嬀䐀漀一漀琀䌀漀渀琀愀挀琀开开瀀挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotEmail__pc] [bit] NULL,਍ऀ嬀䐀漀一漀琀䴀愀椀氀开开瀀挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotText__pc] [bit] NULL,਍ऀ嬀倀攀爀猀漀渀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PersonEmailBouncedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀倀攀爀猀漀渀䔀洀愀椀氀䈀漀甀渀挀攀搀刀攀愀猀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfEmployees] [int] NULL,਍ऀ嬀䔀琀栀渀椀挀椀琀礀开开瀀挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[External_Id__c] [nvarchar](max) NULL,਍ऀ嬀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Gender__pc] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀䔀砀瀀攀爀椀攀渀挀攀开开瀀挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossFamily__pc] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀伀爀嘀漀氀甀洀攀开开瀀挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossProductOther__pc] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀唀猀攀搀开开瀀挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossSpot__pc] [nvarchar](max) NULL,਍ऀ嬀䠀愀爀搀䌀漀瀀礀倀爀攀昀攀爀爀攀搀开开瀀挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Industry] [nvarchar](max) NULL,਍ऀ嬀䨀椀最猀愀眀䌀漀洀瀀愀渀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Language__pc] [nvarchar](max) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [varchar](1) NOT NULL,਍ऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[MaritalStatus__pc] [nvarchar](max) NULL,਍ऀ嬀䴀椀搀搀氀攀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PersonMobilePhone] [nvarchar](max) NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[PhotoUrl] [nvarchar](max) NULL,਍ऀ嬀刀攀挀漀爀搀吀礀瀀攀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Salutation] [nvarchar](max) NULL,਍ऀ嬀匀甀昀昀椀砀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Text_Reminder_Opt_In__pc] [bit] NULL,਍ऀ嬀圀攀戀猀椀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Age__pc] [decimal](38, 18) NULL,਍ऀ嬀䄀渀渀甀愀氀刀攀瘀攀渀甀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Fax] [nvarchar](max) NULL,਍ऀ嬀倀攀爀猀漀渀䐀漀一漀琀䌀愀氀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[PersonHasOptedOutOfEmail] [bit] NULL,਍ऀ嬀刀愀琀椀渀最崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientIdentifier__c] [int] NULL,਍ऀ嬀䘀氀愀最倀䄀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[RowNumber] [bigint] NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍
