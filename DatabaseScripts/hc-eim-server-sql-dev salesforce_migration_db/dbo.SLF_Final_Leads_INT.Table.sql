/****** Object:  Table [dbo].[SLF_Final_Leads_INT]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开䘀椀渀愀氀开䰀攀愀搀猀开䤀一吀崀⠀ഀഀ
	[Id] [varchar](1) NOT NULL,਍ऀ嬀䄀搀搀爀攀猀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Age__c] [decimal](38, 18) NULL,਍ऀ嬀䄀渀渀甀愀氀刀攀瘀攀渀甀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[City] [nvarchar](max) NULL,਍ऀ嬀䈀椀爀琀栀搀愀琀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsConverted] [bit] NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ConvertedContactId] [nvarchar](max) NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀䐀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ConvertedOpportunityId] [nvarchar](max) NULL,਍ऀ嬀䌀漀甀渀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CountryCode] [nvarchar](max) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䨀椀最猀愀眀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Disc__c] [nvarchar](max) NULL,਍ऀ嬀䐀漀一漀琀䌀愀氀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotContact__c] [bit] NULL,਍ऀ嬀䐀漀一漀琀䔀洀愀椀氀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotMail__c] [bit] NULL,਍ऀ嬀䐀漀一漀琀吀攀砀琀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Email] [nvarchar](max) NULL,਍ऀ嬀䔀洀愀椀氀䈀漀甀渀挀攀搀䐀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[EmailBouncedReason] [nvarchar](max) NULL,਍ऀ嬀䠀愀猀伀瀀琀攀搀伀甀琀伀昀䔀洀愀椀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[NumberOfEmployees] [int] NULL,਍ऀ嬀䔀琀栀渀椀挀椀琀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[External_Id__c] [nvarchar](max) NULL,਍ऀ嬀䘀愀砀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HasOptedOutOfFax] [bit] NULL,਍ऀ嬀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Name] [nvarchar](max) NULL,਍ऀ嬀䜀攀渀搀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[GCLID__c] [nvarchar](max) NULL,਍ऀ嬀䜀攀漀挀漀搀攀䄀挀挀甀爀愀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossExperience__c] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀䘀愀洀椀氀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossOrVolume__c] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀伀琀栀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossProductUsed__c] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀匀瀀漀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HardCopyPreferred__c] [bit] NULL,਍ऀ嬀䤀渀搀甀猀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[JigsawContactId] [nvarchar](max) NULL,਍ऀ嬀䰀愀渀最甀愀最攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastActivityDate] [nvarchar](4000) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastReferencedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䰀愀猀琀吀爀愀渀猀昀攀爀䐀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastViewedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䰀愀琀椀琀甀搀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [varchar](3) NOT NULL,਍ऀ嬀䰀攀愀搀匀漀甀爀挀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Longitude] [decimal](38, 18) NULL,਍ऀ嬀䰀甀搀眀椀最匀挀愀氀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[MaritalStatus__c] [nvarchar](max) NULL,਍ऀ嬀䴀愀猀琀攀爀刀攀挀漀爀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[MiddleName] [nvarchar](max) NULL,਍ऀ嬀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[NorwoodScale__c] [nvarchar](max) NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[PartnerAccountId] [varchar](1) NOT NULL,਍ऀ嬀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PhotoUrl] [nvarchar](max) NULL,਍ऀ嬀刀愀琀椀渀最崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecordTypeId] [varchar](18) NOT NULL,਍ऀ嬀匀愀氀甀琀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SolutionOffered__c] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StateCode] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Street] [nvarchar](max) NULL,਍ऀ嬀匀甀昀昀椀砀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SystemModstamp] [varchar](1) NOT NULL,਍ऀ嬀吀攀砀琀开刀攀洀椀渀攀爀开伀瀀琀开䤀渀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Title] [nvarchar](max) NULL,਍ऀ嬀䤀猀唀渀爀攀愀搀䈀礀伀眀渀攀爀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Website] [nvarchar](max) NULL,਍ऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IndividualId] [varchar](1) NOT NULL,਍ऀ嬀匀攀爀瘀椀挀攀开吀攀爀爀椀琀漀爀礀开开䌀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ReferralCode__c] [nvarchar](max) NULL,਍ऀ嬀刀攀昀攀爀爀愀氀䌀漀搀攀䔀砀瀀椀爀攀䐀愀琀攀开开䌀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Promo_Code__c] [nvarchar](max) NULL,਍ऀ嬀刀漀眀一甀洀戀攀爀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
