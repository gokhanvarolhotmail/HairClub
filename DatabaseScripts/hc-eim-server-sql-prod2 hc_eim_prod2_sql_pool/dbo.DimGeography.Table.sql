/****** Object:  Table [dbo].[DimGeography]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䜀攀漀最爀愀瀀栀礀崀ഀഀ
(਍ऀ嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DigitZIPCode] [varchar](8000) NULL,਍ऀ嬀䰀漀渀最椀琀甀搀攀娀䤀倀䌀漀搀攀崀 嬀昀氀漀愀琀崀 一唀䰀䰀Ⰰഀഀ
	[LatitudeZIPCode] [float] NULL,਍ऀ嬀娀䤀倀䌀漀搀攀䌀氀愀猀猀椀昀椀挀愀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NameOfCityOrORG] [varchar](8000) NULL,਍ऀ嬀䘀䤀倀匀䌀漀搀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[TwoLetterAbbrevForState] [varchar](8000) NULL,਍ऀ嬀䘀甀氀氀一愀洀攀伀昀匀琀愀琀攀伀爀吀攀爀爀椀琀漀爀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FIPSCountyCode] [int] NULL,਍ऀ嬀一愀洀攀伀昀䌀漀甀渀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MetroStatisticalAreaCode] [int] NULL,਍ऀ嬀匀椀渀最氀攀䄀爀攀愀䌀漀搀攀䘀漀爀娀䤀倀䌀漀搀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MultipleAreaCodesForZIPCode] [varchar](8000) NULL,਍ऀ嬀吀椀洀攀娀漀渀攀䘀漀爀娀䤀倀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[HrsDiff] [int] NULL,਍ऀ嬀娀䤀倀䌀漀搀攀伀戀攀礀猀䐀愀礀氀椀最栀琀匀愀瘀椀渀最猀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[USPSPostOfficeName] [varchar](8000) NULL,਍ऀ嬀唀匀倀匀䄀氀琀攀爀渀愀琀攀一愀洀攀猀伀昀䌀椀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LocalAlternateNamesOfCity] [varchar](8000) NULL,਍ऀ嬀䌀氀攀愀渀䌀䤀吀夀一愀洀攀䘀漀爀䜀攀漀挀漀搀椀渀最崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CleanSTATENAMEForGeocoding] [varchar](8000) NULL,਍ऀ嬀䘀䤀倀匀匀琀愀琀攀一甀洀攀爀椀挀䌀漀搀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Name] [varchar](8000) NULL,਍ऀ嬀䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DMAMarketRegion] [varchar](8000) NULL,਍ऀ嬀䐀䴀䄀䌀漀搀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DMANameNielsen] [varchar](8000) NULL,਍ऀ嬀䐀䴀䄀一愀洀攀䤀渀琀攀爀渀愀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DMANameAlternate] [varchar](8000) NULL,਍ऀ嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[DWH_LastUpdateDate] [datetime2](7) NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Country] [varchar](8000) NULL,਍ऀ嬀䐀䴀䄀匀甀戀爀攀最椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
