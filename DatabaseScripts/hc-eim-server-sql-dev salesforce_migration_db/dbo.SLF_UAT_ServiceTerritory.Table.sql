/****** Object:  Table [dbo].[SLF_UAT_ServiceTerritory]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开唀䄀吀开匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀崀⠀ഀഀ
	[Id] [nvarchar](18) NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](765) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](18) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [nvarchar](18) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastViewedDate] [datetime2](0) NULL,਍ऀ嬀䰀愀猀琀刀攀昀攀爀攀渀挀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ParentTerritoryId] [nvarchar](18) NULL,਍ऀ嬀吀漀瀀䰀攀瘀攀氀吀攀爀爀椀琀漀爀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Description] [nvarchar](max) NULL,਍ऀ嬀伀瀀攀爀愀琀椀渀最䠀漀甀爀猀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Street] [nvarchar](765) NULL,਍ऀ嬀䌀椀琀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
	[State] [nvarchar](240) NULL,਍ऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㘀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Country] [nvarchar](240) NULL,਍ऀ嬀匀琀愀琀攀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[CountryCode] [nvarchar](765) NULL,਍ऀ嬀䰀愀琀椀琀甀搀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ ㄀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Longitude] [decimal](18, 15) NULL,਍ऀ嬀䜀攀漀挀漀搀攀䄀挀挀甀爀愀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsActive] [bit] NULL,਍ऀ嬀吀礀瀀椀挀愀氀䤀渀吀攀爀爀椀琀漀爀礀吀爀愀瘀攀氀吀椀洀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ ㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[Alternative_Phone__c] [nvarchar](120) NULL,਍ऀ嬀䄀爀攀愀䴀愀渀愀最攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Area__c] [nvarchar](765) NULL,਍ऀ嬀䄀猀猀椀猀琀愀渀琀䴀愀渀愀最攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[BackLinePhone__c] [nvarchar](120) NULL,਍ऀ嬀䈀攀猀琀吀爀攀猀猀攀搀伀昀昀攀爀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Caller_Id__c] [nvarchar](120) NULL,਍ऀ嬀䌀攀渀琀攀爀䄀氀攀爀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterNumber__c] [nvarchar](9) NULL,਍ऀ嬀䌀攀渀琀攀爀伀眀渀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterType__c] [nvarchar](765) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Company__c] [nvarchar](765) NULL,਍ऀ嬀䌀漀渀昀椀爀洀愀琀椀漀渀䌀愀氀氀攀爀䤀䐀䔀渀最氀椀猀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㤀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ConfirmationCallerIDFrench__c] [nvarchar](90) NULL,਍ऀ嬀䌀漀渀昀椀爀洀愀琀椀漀渀䌀愀氀氀攀爀䤀䐀匀瀀愀渀椀猀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㤀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerServiceLine__c] [nvarchar](120) NULL,਍ऀ嬀䐀椀猀瀀氀愀礀一愀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[External_Id__c] [nvarchar](60) NULL,਍ऀ嬀䤀洀愀最攀䌀漀渀猀甀氀琀愀渀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MDPOffered__c] [bit] NULL,਍ऀ嬀䴀䐀倀倀攀爀昀漀爀洀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Main_Phone__c] [nvarchar](120) NULL,਍ऀ嬀䴀愀渀愀最攀爀一愀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Map_Short_Link__c] [nvarchar](120) NULL,਍ऀ嬀䴀最爀䌀攀氀氀倀栀漀渀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OfferPRP__c] [bit] NULL,਍ऀ嬀伀琀栀攀爀䌀愀氀氀攀爀䤀䐀䔀渀最氀椀猀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㤀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OtherCallerIDFrench__c] [nvarchar](90) NULL,਍ऀ嬀伀琀栀攀爀䌀愀氀氀攀爀䤀䐀匀瀀愀渀椀猀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㤀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OutboundDialingAllowed__c] [bit] NULL,਍ऀ嬀倀爀漀昀椀氀攀䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Region__c] [nvarchar](765) NULL,਍ऀ嬀匀琀愀琀甀猀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Supported_Appointment_Types__c] [nvarchar](max) NULL,਍ऀ嬀匀甀爀最攀爀礀伀昀昀攀爀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[TimeZone__c] [nvarchar](765) NULL,਍ऀ嬀吀礀瀀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[WebPhone__c] [nvarchar](120) NULL,਍ऀ嬀圀攀戀开倀栀漀渀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
	[X1Apptperslot__c] [bit] NULL,਍ऀ嬀嘀椀爀琀甀愀氀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[English_Directions__c] [nvarchar](max) NULL,਍ऀ嬀䘀爀攀渀挀栀开䐀椀爀攀挀琀椀漀渀猀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Spanish_Directions__c] [nvarchar](max) NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍
