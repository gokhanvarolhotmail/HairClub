/****** Object:  Table [dbo].[SLF_NEW_CampaignMember]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开一䔀圀开䌀愀洀瀀愀椀最渀䴀攀洀戀攀爀崀⠀ഀഀ
	[Id] [nvarchar](18) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[CampaignId] [nvarchar](18) NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactId] [nvarchar](18) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[HasResponded] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](18) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [nvarchar](18) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[FirstRespondedDate] [datetime2](0) NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Salutation] [nvarchar](765) NULL,਍ऀ嬀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[FirstName] [nvarchar](120) NULL,਍ऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Title] [nvarchar](384) NULL,਍ऀ嬀匀琀爀攀攀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[City] [nvarchar](120) NULL,਍ऀ嬀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀　⤀ 一唀䰀䰀Ⰰഀഀ
	[PostalCode] [nvarchar](60) NULL,਍ऀ嬀䌀漀甀渀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Email] [nvarchar](240) NULL,਍ऀ嬀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Fax] [nvarchar](120) NULL,਍ऀ嬀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Description] [nvarchar](max) NULL,਍ऀ嬀䐀漀一漀琀䌀愀氀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[HasOptedOutOfEmail] [bit] NULL,਍ऀ嬀䠀愀猀伀瀀琀攀搀伀甀琀伀昀䘀愀砀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadSource] [nvarchar](765) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀伀爀䄀挀挀漀甀渀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Type] [nvarchar](120) NULL,਍ऀ嬀䰀攀愀搀伀爀䌀漀渀琀愀挀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOrContactOwnerId] [nvarchar](18) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceCode__c] [nvarchar](765) NULL,਍ऀ嬀䐀攀瘀椀挀攀开吀礀瀀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀㤀　　⤀ 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
