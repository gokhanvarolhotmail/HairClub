/****** Object:  Table [dbo].[SLF_UAT2_User]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开唀䄀吀㈀开唀猀攀爀崀⠀ഀഀ
	[Id] [int] NULL,਍ऀ嬀䄀戀漀甀琀䴀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountId] [varchar](max) NULL,਍ऀ嬀䤀猀䄀挀琀椀瘀攀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Address] [varchar](max) NULL,਍ऀ嬀刀攀挀攀椀瘀攀猀䄀搀洀椀渀䤀渀昀漀䔀洀愀椀氀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Alias] [varchar](max) NOT NULL,਍ऀ嬀䘀漀爀攀挀愀猀琀䔀渀愀戀氀攀搀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPermissionsMobileUser] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䄀瀀攀砀倀愀最攀猀䐀攀瘀攀氀漀瀀攀爀䴀漀搀攀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPermissionsCallCenterAutoLogin] [bit] NOT NULL,਍ऀ嬀䔀洀愀椀氀倀爀攀昀攀爀攀渀挀攀猀䄀甀琀漀䈀挀挀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[EmailPreferencesAutoBccStayInTouch] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀攀爀洀椀猀猀椀漀渀猀䄀瘀愀渀琀最漀唀猀攀爀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesCacheDiagnostics] [bit] NOT NULL,਍ऀ嬀䌀愀氀氀䌀攀渀琀攀爀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Chat_Display_Name__c] [varchar](max) NULL,਍ऀ嬀䌀栀愀琀开倀栀漀琀漀开匀洀愀氀氀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[UserPermissionsLiveAgentUser] [varchar](max) NOT NULL,਍ऀ嬀䐀椀最攀猀琀䘀爀攀焀甀攀渀挀礀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[City] [varchar](max) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactId] [varchar](max) NULL,਍ऀ嬀䌀漀甀渀琀爀礀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CountryCode] [varchar](max) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [varchar](max) NOT NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[DefaultCurrencyIsoCode] [varchar](max) NOT NULL,਍ऀ嬀䐀攀昀愀甀氀琀䜀爀漀甀瀀一漀琀椀昀椀挀愀琀椀漀渀䘀爀攀焀甀攀渀挀礀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[DelegatedApproverId] [varchar](max) NULL,਍ऀ嬀䐀攀瀀愀爀琀洀攀渀琀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[DialerID__c] [varchar](max) NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀愀戀氀攀䄀氀氀䘀攀攀搀猀䔀洀愀椀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesDisableBookmarkEmail] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀愀戀氀攀䌀栀愀渀最攀䌀漀洀洀攀渀琀䔀洀愀椀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesDisableEndorsementEmail] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀愀戀氀攀䘀椀氀攀匀栀愀爀攀一漀琀椀昀椀挀愀琀椀漀渀猀䘀漀爀䄀瀀椀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesDisableFollowersEmail] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀愀戀氀攀䰀愀琀攀爀䌀漀洀洀攀渀琀䔀洀愀椀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesDisableLikeEmail] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀愀戀氀攀䴀攀渀琀椀漀渀猀倀漀猀琀䔀洀愀椀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesDisableMessageEmail] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀愀戀氀攀倀爀漀昀椀氀攀倀漀猀琀䔀洀愀椀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesDisableSharePostEmail] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀䌀漀洀洀攀渀琀䄀昀琀攀爀䰀椀欀攀䔀洀愀椀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesDisMentionsCommentEmail] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䐀椀猀倀爀漀昀倀漀猀琀䌀漀洀洀攀渀琀䔀洀愀椀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Division] [varchar](max) NULL,਍ऀ嬀䔀洀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[EmailEncodingKey] [varchar](max) NOT NULL,਍ऀ嬀匀攀渀搀攀爀䔀洀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SenderName] [varchar](max) NULL,਍ऀ嬀匀椀最渀愀琀甀爀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[EmployeeNumber] [varchar](max) NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䔀渀愀戀氀攀䄀甀琀漀匀甀戀䘀漀爀䘀攀攀搀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Extension] [varchar](max) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀开䤀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Fax] [varchar](max) NULL,਍ऀ嬀䘀椀爀猀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[UserPermissionsInteractionUser] [bit] NOT NULL,਍ऀ嬀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[GeocodeAccuracy] [varchar](max) NULL,਍ऀ嬀䤀猀倀爀漀昀椀氀攀倀栀漀琀漀䄀挀琀椀瘀攀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesHideBiggerPhotoCallout] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䠀椀搀攀䌀栀愀琀琀攀爀伀渀戀漀愀爀搀椀渀最匀瀀氀愀猀栀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesHideCSNDesktopTask] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䠀椀搀攀䌀匀一䜀攀琀䌀栀愀琀琀攀爀䴀漀戀椀氀攀吀愀猀欀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesHideEndUserOnboardingAssistantModal] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䠀椀搀攀䰀椀最栀琀渀椀渀最䴀椀最爀愀琀椀漀渀䴀漀搀愀氀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesHideS1BrowserUI] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䠀椀搀攀匀攀挀漀渀搀䌀栀愀琀琀攀爀伀渀戀漀愀爀搀椀渀最匀瀀氀愀猀栀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesHideSfxWelcomeMat] [bit] NOT NULL,਍ऀ嬀刀攀挀攀椀瘀攀猀䤀渀昀漀䔀洀愀椀氀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[IsPortalEnabled] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀攀爀洀椀猀猀椀漀渀猀䬀渀漀眀氀攀搀最攀唀猀攀爀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[LanguageLocaleKey] [varchar](max) NOT NULL,਍ऀ嬀䰀愀猀琀䰀漀最椀渀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [varchar](max) NOT NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[LastName] [varchar](max) NOT NULL,਍ऀ嬀䰀愀猀琀倀愀猀猀眀漀爀搀䌀栀愀渀最攀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastReferencedDate] [varchar](max) NULL,਍ऀ嬀䰀愀猀琀嘀椀攀眀攀搀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Latitude] [varchar](max) NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀䰀椀最栀琀渀椀渀最䔀砀瀀攀爀椀攀渀挀攀倀爀攀昀攀爀爀攀搀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[LocaleSidKey] [varchar](max) NOT NULL,਍ऀ嬀䰀漀渀最椀琀甀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ManagerId] [varchar](max) NULL,਍ऀ嬀唀猀攀爀倀攀爀洀椀猀猀椀漀渀猀䴀愀爀欀攀琀椀渀最唀猀攀爀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[MiddleName] [varchar](max) NULL,਍ऀ嬀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CommunityNickname] [varchar](max) NOT NULL,਍ऀ嬀伀昀昀氀椀渀攀吀爀椀愀氀䔀砀瀀椀爀愀琀椀漀渀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[UserPermissionsOfflineUser] [varchar](max) NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀倀愀琀栀䄀猀猀椀猀琀愀渀琀䌀漀氀氀愀瀀猀攀搀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Phone] [varchar](max) NULL,਍ऀ嬀匀洀愀氀氀倀栀漀琀漀唀爀氀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[PortalRole] [varchar](max) NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀倀爀攀瘀椀攀眀䰀椀最栀琀渀椀渀最崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ProfileId] [varchar](max) NOT NULL,਍ऀ嬀唀猀攀爀刀漀氀攀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[OfflinePdaTrialExpirationDate] [varchar](max) NULL,਍ऀ嬀唀猀攀爀倀攀爀洀椀猀猀椀漀渀猀匀䘀䌀漀渀琀攀渀琀唀猀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[FederationIdentifier] [varchar](max) NULL,਍ऀ嬀唀猀攀爀倀攀爀洀椀猀猀椀漀渀猀匀甀瀀瀀漀爀琀唀猀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowCityToExternalUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀䌀椀琀礀吀漀䜀甀攀猀琀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowCountryToExternalUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀䌀漀甀渀琀爀礀吀漀䜀甀攀猀琀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowEmailToExternalUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀䔀洀愀椀氀吀漀䜀甀攀猀琀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowFaxToExternalUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀䘀愀砀吀漀䜀甀攀猀琀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowManagerToExternalUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀䴀愀渀愀最攀爀吀漀䜀甀攀猀琀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowMobilePhoneToExternalUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀䴀漀戀椀氀攀倀栀漀渀攀吀漀䜀甀攀猀琀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowPostalCodeToExternalUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀倀漀猀琀愀氀䌀漀搀攀吀漀䜀甀攀猀琀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowProfilePicToGuestUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀匀琀愀琀攀吀漀䔀砀琀攀爀渀愀氀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowStateToGuestUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀匀琀爀攀攀琀䄀搀搀爀攀猀猀吀漀䔀砀琀攀爀渀愀氀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowStreetAddressToGuestUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀吀椀琀氀攀吀漀䔀砀琀攀爀渀愀氀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowTitleToGuestUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀栀漀眀圀漀爀欀倀栀漀渀攀吀漀䔀砀琀攀爀渀愀氀唀猀攀爀猀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[UserPreferencesShowWorkPhoneToGuestUsers] [bit] NOT NULL,਍ऀ嬀唀猀攀爀倀爀攀昀攀爀攀渀挀攀猀匀漀爀琀䘀攀攀搀䈀礀䌀漀洀洀攀渀琀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[State] [varchar](max) NULL,਍ऀ嬀匀琀愀琀攀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StayInTouchNote] [varchar](max) NULL,਍ऀ嬀匀琀愀礀䤀渀吀漀甀挀栀匀椀最渀愀琀甀爀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StayInTouchSubject] [varchar](max) NULL,਍ऀ嬀䔀洀愀椀氀倀爀攀昀攀爀攀渀挀攀猀匀琀愀礀䤀渀吀漀甀挀栀刀攀洀椀渀搀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Street] [varchar](max) NULL,਍ऀ嬀匀甀昀昀椀砀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SystemModstamp] [varchar](max) NOT NULL,਍ऀ嬀吀椀洀攀娀漀渀攀匀椀搀䬀攀礀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Title] [varchar](max) NULL,਍ऀ嬀䈀愀渀渀攀爀倀栀漀琀漀唀爀氀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[FullPhotoUrl] [varchar](max) NOT NULL,਍ऀ嬀䴀攀搀椀甀洀倀栀漀琀漀唀爀氀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[BadgeText] [varchar](max) NULL,਍ऀ嬀唀猀攀爀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Username] [varchar](max) NOT NULL,਍ऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
