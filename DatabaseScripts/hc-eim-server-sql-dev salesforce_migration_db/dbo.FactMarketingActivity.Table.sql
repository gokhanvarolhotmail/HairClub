/****** Object:  Table [dbo].[FactMarketingActivity]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䴀愀爀欀攀琀椀渀最䄀挀琀椀瘀椀琀礀崀ഀഀ
(਍ऀ嬀䘀愀挀琀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FactDate] [datetime] NULL,਍ऀ嬀䴀愀爀欀攀琀椀渀最䄀挀琀椀瘀椀琀礀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[MarketingActivityTime] [varchar](50) NULL,਍ऀ嬀䰀漀挀愀氀䄀椀爀吀椀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[TransactionId] [int] NULL,਍ऀ嬀䄀最攀渀挀礀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[File] [nvarchar](200) NULL,਍ऀ嬀䈀甀搀最攀琀䄀洀漀甀渀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[GrossSpend] [money] NULL,਍ऀ嬀䐀椀猀挀漀甀渀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[Fees] [money] NULL,਍ऀ嬀一攀琀匀瀀攀渀搀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[SpotDate] [date] NULL,਍ऀ嬀匀瀀漀琀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Telephone] [nvarchar](50) NULL,਍ऀ嬀匀漀甀爀挀攀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PromoCode] [nvarchar](50) NULL,਍ऀ嬀唀爀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Impressions18-65] [int] NULL,਍ऀ嬀䄀昀昀椀氀椀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Station] [varchar](600) NULL,਍ऀ嬀匀栀漀眀崀 嬀瘀愀爀挀栀愀爀崀⠀㘀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ContentType] [varchar](200) NULL,਍ऀ嬀䌀漀渀琀攀渀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Isci] [varchar](200) NULL,਍ऀ嬀䴀愀猀琀攀爀一甀洀戀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DMAkey] [int] NULL,਍ऀ嬀䐀䴀䄀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AgencyKey] [int] NULL,਍ऀ嬀䄀最攀渀挀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AudienceKey] [int] NULL,਍ऀ嬀䄀甀搀椀攀渀挀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ChannelKey] [int] NULL,਍ऀ嬀䌀栀愀渀渀攀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[FormatKey] [int] NULL,਍ऀ嬀䘀漀爀洀愀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[TacticKey] [int] NULL,਍ऀ嬀吀愀挀琀椀挀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceKey] [int] NULL,਍ऀ嬀匀漀甀爀挀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[MediumKey] [int] NULL,਍ऀ嬀䴀攀搀椀甀洀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[PurposeKey] [int] NULL,਍ऀ嬀倀甀爀瀀漀猀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[MethodKey] [int] NULL,਍ऀ嬀䴀攀琀栀漀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[BudgetTypeKey] [int] NULL,਍ऀ嬀䈀甀搀最攀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[BudgetType] [varchar](50) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Campaign] [varchar](3000) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Company] [varchar](50) NULL,਍ऀ嬀䰀漀挀愀琀椀漀渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Location] [varchar](50) NULL,਍ऀ嬀䰀愀渀最甀愀最攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Language] [varchar](50) NULL,਍ऀ嬀一甀洀戀攀爀伀昀䰀攀愀搀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NumberOfLeadsTarget] [int] NULL,਍ऀ嬀一甀洀攀爀琀伀昀伀瀀瀀漀爀琀甀渀椀琀椀攀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NumberOfOpportunitiesTarget] [int] NULL,਍ऀ嬀一甀洀戀攀爀伀昀匀愀氀攀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NumberOfSalesTarget] [int] NULL,਍ऀ嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[LogType] [varchar](50) NULL,਍ऀ嬀䠀愀猀栀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀㘀⤀ 一唀䰀䰀Ⰰഀഀ
	[Impressions] [int] NULL,਍ऀ嬀䘀攀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[MarketingFeeKey] [int] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
