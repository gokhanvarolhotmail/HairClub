/****** Object:  Table [dbo].[DimCenter]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀ഀഀ
(਍ऀ嬀䌀攀渀琀攀爀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CenterID] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀倀愀礀䜀爀漀甀瀀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterDescription] [varchar](500) NULL,਍ऀ嬀䄀搀搀爀攀猀猀㄀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Address2] [varchar](500) NULL,਍ऀ嬀䄀搀搀爀攀猀猀㌀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterGeographykey] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀倀漀猀琀愀氀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterPhone1] [varchar](200) NULL,਍ऀ嬀䌀攀渀琀攀爀倀栀漀渀攀㈀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterPhone3] [varchar](200) NULL,਍ऀ嬀倀栀漀渀攀㄀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Phone2TypeID] [int] NULL,਍ऀ嬀倀栀漀渀攀㌀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsPhone1PrimaryFlag] [bit] NULL,਍ऀ嬀䤀猀倀栀漀渀攀㈀倀爀椀洀愀爀礀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsPhone3PrimaryFlag] [bit] NULL,਍ऀ嬀䤀猀䄀挀琀椀瘀攀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreateDate] [datetime] NULL,਍ऀ嬀䰀愀猀琀唀瀀搀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[UpdateStamp] [varchar](200) NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterOwnershipID] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀匀漀爀琀伀爀搀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterOwnershipDescription] [varchar](100) NULL,਍ऀ嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnerLastName] [varchar](100) NULL,਍ऀ嬀伀眀渀攀爀䘀椀爀猀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CorporateName] [varchar](500) NULL,਍ऀ嬀伀眀渀攀爀猀栀椀瀀䄀搀搀爀攀猀猀㄀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnershipAddress2] [varchar](100) NULL,਍ऀ嬀伀眀渀攀爀猀栀椀瀀䜀攀漀最爀愀瀀栀礀欀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[OwnershipPostalCode] [varchar](50) NULL,਍ऀ嬀䌀攀渀琀攀爀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterTypeSortOrder] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterTypeDescriptionShort] [varchar](10) NULL,਍ऀ嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LastUpdateDate] [datetime] NULL,਍ऀ嬀䤀猀䄀挀琀椀瘀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [varchar](10) NOT NULL,਍ऀ嬀吀椀洀攀娀漀渀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ServiceTerritoryId] [varchar](100) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Region1] [varchar](50) NULL,਍ऀ嬀刀攀最椀漀渀㈀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[RegioAM] [nvarchar](100) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = REPLICATE,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀ഀഀ
	(਍ऀऀ嬀䌀攀渀琀攀爀䤀䐀崀 䄀匀䌀ഀഀ
	)਍⤀ഀഀ
GO਍
