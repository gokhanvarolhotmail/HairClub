/****** Object:  Table [dbo].[DimLead]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀ഀഀ
(਍ऀ嬀䰀攀愀搀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[LeadId] [nvarchar](50) NOT NULL,਍ऀ嬀䰀攀愀搀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadLastname] [nvarchar](100) NULL,਍ऀ嬀䰀攀愀搀䘀甀氀氀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadBirthday] [date] NULL,਍ऀ嬀䰀攀愀搀䄀搀搀爀攀猀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsActive] [int] NULL,਍ऀ嬀䤀猀䌀漀渀猀甀氀琀䘀漀爀洀䌀漀洀瀀氀攀琀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Isvalid] [int] NULL,਍ऀ嬀䤀猀刀攀昀攀爀爀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadScore] [numeric](18, 0) NULL,਍ऀ嬀䰀攀愀搀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadPhone] [nvarchar](50) NULL,਍ऀ嬀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadAddress1] [nvarchar](400) NULL,਍ऀ嬀一漀爀眀漀漀搀匀挀愀氀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LudwigScale] [nvarchar](200) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀匀挀愀氀攀䬀攀礀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossInFamily] [nvarchar](100) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀唀猀攀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossSpot] [nvarchar](200) NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SegmentKey] [numeric](18, 0) NULL,਍ऀ嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadPostalCode] [nvarchar](50) NULL,਍ऀ嬀䔀琀栀渀椀挀椀琀礀䬀攀礀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadEthnicity] [nvarchar](100) NULL,਍ऀ嬀䜀攀渀搀攀爀䬀攀礀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadGender] [nvarchar](100) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalCampaignCode] [varchar](100) NULL,਍ऀ嬀伀爀椀最椀渀愀氀匀漀甀爀挀攀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterKey] [numeric](18, 0) NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LanguageKey] [numeric](18, 0) NULL,਍ऀ嬀䰀攀愀搀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusKey] [numeric](18, 0) NULL,਍ऀ嬀䰀攀愀搀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FunnelStepKey] [numeric](18, 0) NULL,਍ऀ嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CreatedDateKey] [int] NULL,਍ऀ嬀䌀爀攀愀琀攀搀吀椀洀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecentCampaignKey] [int] NULL,਍ऀ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentSourceCode] [nvarchar](100) NULL,਍ऀ嬀䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[LastActivityDateKey] [int] NULL,਍ऀ嬀䰀愀猀琀䄀挀琀椀瘀椀琀礀吀椀洀攀欀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DISCStyle] [nvarchar](100) NULL,਍ऀ嬀䰀攀愀搀䴀愀爀椀琀愀氀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOccupation] [nvarchar](100) NULL,਍ऀ嬀䰀攀愀搀䌀漀渀猀甀氀琀刀攀愀搀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ConsultationFormReady] [int] NULL,਍ऀ嬀䐀圀䠀䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[DWHLastUpdateDate] [datetime] NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotCall] [bit] NULL,਍ऀ嬀䐀漀一漀琀䌀漀渀琀愀挀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotEmail] [bit] NULL,਍ऀ嬀䐀漀一漀琀䴀愀椀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotText] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀唀猀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[UpdateUser] [varchar](100) NULL,਍ऀ嬀䌀椀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[State] [varchar](100) NULL,਍ऀ嬀伀挀挀甀瀀愀琀椀漀渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MaritalStatusKey] [int] NULL,਍ऀ嬀䰀攀愀搀匀漀甀爀挀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceKey] [int] NULL,਍ऀ嬀䘀甀渀渀攀氀匀琀攀瀀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalCommMethodkey] [int] NULL,਍ऀ嬀刀攀挀攀渀琀䌀漀洀洀䴀攀琀栀漀搀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CommunicationMethod] [varchar](250) NULL,਍ऀ嬀䤀猀嘀愀氀椀搀䰀攀愀搀一愀洀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsValidLeadLastName] [bit] NULL,਍ऀ嬀䤀猀嘀愀氀椀搀䰀攀愀搀䘀甀氀氀一愀洀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsValidLeadPhone] [bit] NULL,਍ऀ嬀䤀猀嘀愀氀椀搀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsValidLeadEmail] [bit] NULL,਍ऀ嬀刀攀瘀椀攀眀一攀攀搀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ConvertedContactId] [nvarchar](200) NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ConvertedOpportunityId] [varchar](1024) NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ReportCreateDate] [datetime] NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀䔀倀䰀䤀䌀䄀吀䔀Ⰰഀഀ
	CLUSTERED INDEX਍ऀ⠀ഀഀ
		[LeadKey] ASC਍ऀ⤀ഀഀ
)਍䜀伀ഀഀ
