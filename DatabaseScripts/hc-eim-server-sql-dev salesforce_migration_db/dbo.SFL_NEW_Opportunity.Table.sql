/****** Object:  Table [dbo].[SFL_NEW_Opportunity]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䘀䰀开一䔀圀开伀瀀瀀漀爀琀甀渀椀琀礀崀⠀ഀഀ
	[Id] [nvarchar](18) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountId] [nvarchar](18) NULL,਍ऀ嬀刀攀挀漀爀搀吀礀瀀攀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Name] [nvarchar](360) NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StageName] [nvarchar](765) NULL,਍ऀ嬀䄀洀漀甀渀琀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ ㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[Probability] [decimal](3, 0) NULL,਍ऀ嬀䌀氀漀猀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Type] [nvarchar](765) NULL,਍ऀ嬀一攀砀琀匀琀攀瀀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadSource] [nvarchar](765) NULL,਍ऀ嬀䤀猀䌀氀漀猀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsWon] [bit] NULL,਍ऀ嬀䘀漀爀攀挀愀猀琀䌀愀琀攀最漀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[ForecastCategoryName] [nvarchar](765) NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignId] [nvarchar](18) NULL,਍ऀ嬀䠀愀猀伀瀀瀀漀爀琀甀渀椀琀礀䰀椀渀攀䤀琀攀洀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Pricebook2Id] [nvarchar](18) NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [datetime2](0) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [datetime2](0) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[SystemModstamp] [datetime2](0) NULL,਍ऀ嬀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalQuarter] [int] NULL,਍ऀ嬀䘀椀猀挀愀氀夀攀愀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Fiscal] [nvarchar](6) NULL,਍ऀ嬀䰀愀猀琀嘀椀攀眀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastReferencedDate] [datetime2](0) NULL,਍ऀ嬀匀礀渀挀攀搀儀甀漀琀攀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContractId] [nvarchar](18) NULL,਍ऀ嬀䠀愀猀伀瀀攀渀䄀挀琀椀瘀椀琀礀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[HasOverdueTask] [bit] NULL,਍ऀ嬀䈀甀搀最攀琀开䌀漀渀昀椀爀洀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Discovery_Completed__c] [bit] NULL,਍ऀ嬀刀伀䤀开䄀渀愀氀礀猀椀猀开䌀漀洀瀀氀攀琀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Appointment_Source__c] [nvarchar](765) NULL,਍ऀ嬀䰀漀猀猀开刀攀愀猀漀渀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Cancellation_Reason__c] [nvarchar](765) NULL,਍ऀ嬀䠀愀椀爀开䰀漀猀猀开䔀砀瀀攀爀椀攀渀挀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Hair_Loss_Family__c] [nvarchar](765) NULL,਍ऀ嬀䠀愀椀爀开䰀漀猀猀开伀爀开嘀漀氀甀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Hair_Loss_Product_Other__c] [nvarchar](765) NULL,਍ऀ嬀䠀愀椀爀开䰀漀猀猀开倀爀漀搀甀挀琀开唀猀攀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Hair_Loss_Spot__c] [nvarchar](765) NULL,਍ऀ嬀䤀倀开䄀搀搀爀攀猀猀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Ludwig_Scale__c] [nvarchar](765) NULL,਍ऀ嬀一漀爀眀漀漀搀开匀挀愀氀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Referral_Code_Expiration_Date__c] [datetime2](0) NULL,਍ऀ嬀刀攀昀攀爀爀愀氀开䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Service_Territory__c] [nvarchar](18) NULL,਍ऀ嬀匀漀甀爀挀攀开䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Submitted_for_Approval__c] [bit] NULL,਍ऀ嬀䄀洀洀漀甀渀琀开开挀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ ㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[GCLID__c] [nvarchar](765) NULL,਍ऀ嬀倀爀漀洀漀开䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[SolutionOffered__c] [nvarchar](765) NULL,਍ऀ嬀䄀瀀瀀爀漀瘀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Email__c] [nvarchar](3900) NULL,਍ऀ嬀䜀漀愀氀猀开䔀砀瀀攀挀琀愀琀椀漀渀猀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[How_many_times_a_week_do_you_think__c] [nvarchar](765) NULL,਍ऀ嬀䠀漀眀开洀甀挀栀开琀椀洀攀开愀开眀攀攀欀开搀漀开礀漀甀开猀瀀攀渀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Mobile__c] [nvarchar](3900) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀开伀眀渀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀㤀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Other_Reason__c] [nvarchar](max) NULL,਍ऀ嬀伀眀渀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Phone__c] [nvarchar](3900) NULL,਍ऀ嬀圀栀愀琀开愀爀攀开礀漀甀爀开洀愀椀渀开挀漀渀挀攀爀渀猀开琀漀搀愀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[What_else_would_be_helpful_for_your__c] [nvarchar](max) NULL,਍ऀ嬀圀栀愀琀开洀攀琀栀漀搀猀开栀愀瘀攀开礀漀甀开甀猀攀搀开漀爀开挀甀爀爀攀渀琀氀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
