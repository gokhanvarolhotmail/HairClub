/****** Object:  Table [dbo].[DimClient]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䌀氀椀攀渀琀崀ഀഀ
(਍ऀ嬀䌀氀椀攀渀琀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ClientID] [uniqueidentifier] NULL,਍ऀ嬀䌀氀椀攀渀琀一甀洀戀攀爀开吀攀洀瀀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientIdentifier] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientMiddleName] [nvarchar](20) NULL,਍ऀ嬀䌀氀椀攀渀琀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[SalutationID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀匀愀氀甀琀愀琀椀漀渀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientSalutationDescriptionShort] [nvarchar](10) NULL,਍ऀ嬀䌀氀椀攀渀琀䘀甀氀氀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientAddress1] [nvarchar](50) NULL,਍ऀ嬀䌀氀椀攀渀琀䄀搀搀爀攀猀猀㈀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientAddress3] [nvarchar](50) NULL,਍ऀ嬀䌀漀甀渀琀爀礀刀攀最椀漀渀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CountryRegionDescriptionShort] [nvarchar](10) NULL,਍ऀ嬀匀琀愀琀攀倀爀漀瘀椀渀挀攀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[StateProvinceDescriptionShort] [nvarchar](10) NULL,਍ऀ嬀䌀椀琀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[PostalCode] [nvarchar](15) NULL,਍ऀ嬀䌀氀椀攀渀琀䐀愀琀攀伀昀䈀椀爀琀栀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[GenderID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䜀攀渀搀攀爀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientGenderDescriptionShort] [nvarchar](10) NULL,਍ऀ嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMaritalStatusDescription] [nvarchar](50) NULL,਍ऀ嬀䌀氀椀攀渀琀䴀愀爀椀琀愀氀匀琀愀琀甀猀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OccupationID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀伀挀挀甀瀀愀琀椀漀渀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientOccupationDescriptionShort] [nvarchar](10) NULL,਍ऀ嬀䔀琀栀椀渀椀挀椀琀礀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientEthinicityDescription] [nvarchar](50) NULL,਍ऀ嬀䌀氀椀攀渀琀䔀琀栀椀渀椀挀椀琀礀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[DoNotCallFlag] [bit] NULL,਍ऀ嬀䐀漀一漀琀䌀漀渀琀愀挀琀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsHairModelFlag] [bit] NULL,਍ऀ嬀䤀猀吀愀砀䔀砀攀洀瀀琀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientEMailAddress] [nvarchar](100) NULL,਍ऀ嬀䌀氀椀攀渀琀吀攀砀琀䴀攀猀猀愀最攀䄀搀搀爀攀猀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientPhone1] [nvarchar](15) NULL,਍ऀ嬀倀栀漀渀攀㄀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientPhone1TypeDescription] [nvarchar](50) NULL,਍ऀ嬀䌀氀椀攀渀琀倀栀漀渀攀㄀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientPhone2] [nvarchar](15) NULL,਍ऀ嬀倀栀漀渀攀㈀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientPhone2TypeDescription] [nvarchar](50) NULL,਍ऀ嬀䌀氀椀攀渀琀倀栀漀渀攀㈀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientPhone3] [nvarchar](15) NULL,਍ऀ嬀倀栀漀渀攀㌀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientPhone3TypeDescription] [nvarchar](50) NULL,਍ऀ嬀䌀氀椀攀渀琀倀栀漀渀攀㌀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrentBioMatrixClientMembershipID] [uniqueidentifier] NULL,਍ऀ嬀䌀甀爀爀攀渀琀匀甀爀最攀爀礀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[CurrentExtremeTherapyClientMembershipID] [uniqueidentifier] NULL,਍ऀ嬀䌀攀渀琀攀爀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ClientARBalance] [money] NULL,਍ऀ嬀挀漀渀琀愀挀琀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[contactKey] [int] NULL,਍ऀ嬀䌀甀爀爀攀渀琀堀琀爀愀渀搀猀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[BosleyProcedureOffice] [nvarchar](50) NULL,਍ऀ嬀䈀漀猀氀攀礀䌀漀渀猀甀氀琀伀昀昀椀挀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[BosleySiebelID] [nvarchar](50) NULL,਍ऀ嬀䔀砀瀀攀挀琀攀搀䌀漀渀瘀攀爀猀椀漀渀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[SFDC_Leadid] [nvarchar](18) NULL,਍ऀ嬀䌀甀爀爀攀渀琀䴀䐀倀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [varchar](10) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = REPLICATE,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀ഀഀ
	(਍ऀऀ嬀䌀氀椀攀渀琀䤀䐀崀 䄀匀䌀ഀഀ
	)਍⤀ഀഀ
GO਍
