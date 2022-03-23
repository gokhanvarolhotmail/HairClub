/****** Object:  Table [ODS].[SF_User]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_User]
(
	[Id] [varchar](8000) NULL,
	[Username] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[FirstName] [varchar](8000) NULL,
	[MiddleName] [varchar](8000) NULL,
	[Suffix] [varchar](8000) NULL,
	[Name] [varchar](8000) NULL,
	[CompanyName] [varchar](8000) NULL,
	[Division] [varchar](8000) NULL,
	[Department] [varchar](8000) NULL,
	[Title] [varchar](8000) NULL,
	[Street] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[State] [varchar](8000) NULL,
	[PostalCode] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[StateCode] [varchar](8000) NULL,
	[CountryCode] [varchar](8000) NULL,
	[Latitude] [numeric](38, 18) NULL,
	[Longitude] [numeric](38, 18) NULL,
	[GeocodeAccuracy] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[EmailPreferencesAutoBcc] [bit] NULL,
	[EmailPreferencesAutoBccStayInTouch] [bit] NULL,
	[EmailPreferencesStayInTouchReminder] [bit] NULL,
	[SenderEmail] [varchar](8000) NULL,
	[SenderName] [varchar](8000) NULL,
	[Signature] [varchar](8000) NULL,
	[StayInTouchSubject] [varchar](8000) NULL,
	[StayInTouchSignature] [varchar](8000) NULL,
	[StayInTouchNote] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[Fax] [varchar](8000) NULL,
	[MobilePhone] [varchar](8000) NULL,
	[Alias] [varchar](8000) NULL,
	[CommunityNickname] [varchar](8000) NULL,
	[BadgeText] [varchar](8000) NULL,
	[IsActive] [bit] NULL,
	[TimeZoneSidKey] [varchar](8000) NULL,
	[UserRoleId] [varchar](8000) NULL,
	[LocaleSidKey] [varchar](8000) NULL,
	[ReceivesInfoEmails] [bit] NULL,
	[ReceivesAdminInfoEmails] [bit] NULL,
	[EmailEncodingKey] [varchar](8000) NULL,
	[DefaultCurrencyIsoCode] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[ProfileId] [varchar](8000) NULL,
	[UserType] [varchar](8000) NULL,
	[LanguageLocaleKey] [varchar](8000) NULL,
	[EmployeeNumber] [varchar](8000) NULL,
	[DelegatedApproverId] [varchar](8000) NULL,
	[ManagerId] [varchar](8000) NULL,
	[LastLoginDate] [datetime2](7) NULL,
	[LastPasswordChangeDate] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[OfflineTrialExpirationDate] [datetime2](7) NULL,
	[OfflinePdaTrialExpirationDate] [datetime2](7) NULL,
	[UserPermissionsMarketingUser] [bit] NULL,
	[UserPermissionsOfflineUser] [bit] NULL,
	[UserPermissionsAvantgoUser] [bit] NULL,
	[UserPermissionsCallCenterAutoLogin] [bit] NULL,
	[UserPermissionsMobileUser] [bit] NULL,
	[UserPermissionsSFContentUser] [bit] NULL,
	[UserPermissionsKnowledgeUser] [bit] NULL,
	[UserPermissionsInteractionUser] [bit] NULL,
	[UserPermissionsSupportUser] [bit] NULL,
	[UserPermissionsLiveAgentUser] [bit] NULL,
	[ForecastEnabled] [bit] NULL,
	[UserPreferencesActivityRemindersPopup] [bit] NULL,
	[UserPreferencesEventRemindersCheckboxDefault] [bit] NULL,
	[UserPreferencesTaskRemindersCheckboxDefault] [bit] NULL,
	[UserPreferencesReminderSoundOff] [bit] NULL,
	[UserPreferencesDisableAllFeedsEmail] [bit] NULL,
	[UserPreferencesDisableFollowersEmail] [bit] NULL,
	[UserPreferencesDisableProfilePostEmail] [bit] NULL,
	[UserPreferencesDisableChangeCommentEmail] [bit] NULL,
	[UserPreferencesDisableLaterCommentEmail] [bit] NULL,
	[UserPreferencesDisProfPostCommentEmail] [bit] NULL,
	[UserPreferencesApexPagesDeveloperMode] [bit] NULL,
	[UserPreferencesHideCSNGetChatterMobileTask] [bit] NULL,
	[UserPreferencesDisableMentionsPostEmail] [bit] NULL,
	[UserPreferencesDisMentionsCommentEmail] [bit] NULL,
	[UserPreferencesHideCSNDesktopTask] [bit] NULL,
	[UserPreferencesHideChatterOnboardingSplash] [bit] NULL,
	[UserPreferencesHideSecondChatterOnboardingSplash] [bit] NULL,
	[UserPreferencesDisCommentAfterLikeEmail] [bit] NULL,
	[UserPreferencesDisableLikeEmail] [bit] NULL,
	[UserPreferencesSortFeedByComment] [bit] NULL,
	[UserPreferencesDisableMessageEmail] [bit] NULL,
	[UserPreferencesDisableBookmarkEmail] [bit] NULL,
	[UserPreferencesDisableSharePostEmail] [bit] NULL,
	[UserPreferencesEnableAutoSubForFeeds] [bit] NULL,
	[UserPreferencesDisableFileShareNotificationsForApi] [bit] NULL,
	[UserPreferencesShowTitleToExternalUsers] [bit] NULL,
	[UserPreferencesShowManagerToExternalUsers] [bit] NULL,
	[UserPreferencesShowEmailToExternalUsers] [bit] NULL,
	[UserPreferencesShowWorkPhoneToExternalUsers] [bit] NULL,
	[UserPreferencesShowMobilePhoneToExternalUsers] [bit] NULL,
	[UserPreferencesShowFaxToExternalUsers] [bit] NULL,
	[UserPreferencesShowStreetAddressToExternalUsers] [bit] NULL,
	[UserPreferencesShowCityToExternalUsers] [bit] NULL,
	[UserPreferencesShowStateToExternalUsers] [bit] NULL,
	[UserPreferencesShowPostalCodeToExternalUsers] [bit] NULL,
	[UserPreferencesShowCountryToExternalUsers] [bit] NULL,
	[UserPreferencesShowProfilePicToGuestUsers] [bit] NULL,
	[UserPreferencesShowTitleToGuestUsers] [bit] NULL,
	[UserPreferencesShowCityToGuestUsers] [bit] NULL,
	[UserPreferencesShowStateToGuestUsers] [bit] NULL,
	[UserPreferencesShowPostalCodeToGuestUsers] [bit] NULL,
	[UserPreferencesShowCountryToGuestUsers] [bit] NULL,
	[UserPreferencesPipelineViewHideHelpPopover] [bit] NULL,
	[UserPreferencesHideS1BrowserUI] [bit] NULL,
	[UserPreferencesDisableEndorsementEmail] [bit] NULL,
	[UserPreferencesPathAssistantCollapsed] [bit] NULL,
	[UserPreferencesCacheDiagnostics] [bit] NULL,
	[UserPreferencesShowEmailToGuestUsers] [bit] NULL,
	[UserPreferencesShowManagerToGuestUsers] [bit] NULL,
	[UserPreferencesShowWorkPhoneToGuestUsers] [bit] NULL,
	[UserPreferencesShowMobilePhoneToGuestUsers] [bit] NULL,
	[UserPreferencesShowFaxToGuestUsers] [bit] NULL,
	[UserPreferencesShowStreetAddressToGuestUsers] [bit] NULL,
	[UserPreferencesLightningExperiencePreferred] [bit] NULL,
	[UserPreferencesPreviewLightning] [bit] NULL,
	[UserPreferencesHideEndUserOnboardingAssistantModal] [bit] NULL,
	[UserPreferencesHideLightningMigrationModal] [bit] NULL,
	[UserPreferencesHideSfxWelcomeMat] [bit] NULL,
	[UserPreferencesHideBiggerPhotoCallout] [bit] NULL,
	[UserPreferencesGlobalNavBarWTShown] [bit] NULL,
	[UserPreferencesGlobalNavGridMenuWTShown] [bit] NULL,
	[UserPreferencesCreateLEXAppsWTShown] [bit] NULL,
	[UserPreferencesFavoritesWTShown] [bit] NULL,
	[UserPreferencesRecordHomeSectionCollapseWTShown] [bit] NULL,
	[UserPreferencesRecordHomeReservedWTShown] [bit] NULL,
	[UserPreferencesFavoritesShowTopFavorites] [bit] NULL,
	[UserPreferencesExcludeMailAppAttachments] [bit] NULL,
	[UserPreferencesSuppressTaskSFXReminders] [bit] NULL,
	[UserPreferencesSuppressEventSFXReminders] [bit] NULL,
	[UserPreferencesPreviewCustomTheme] [bit] NULL,
	[UserPreferencesHasCelebrationBadge] [bit] NULL,
	[UserPreferencesUserDebugModePref] [bit] NULL,
	[UserPreferencesNewLightningReportRunPageEnabled] [bit] NULL,
	[ContactId] [varchar](8000) NULL,
	[AccountId] [varchar](8000) NULL,
	[CallCenterId] [varchar](8000) NULL,
	[Extension] [varchar](8000) NULL,
	[FederationIdentifier] [varchar](8000) NULL,
	[AboutMe] [varchar](8000) NULL,
	[FullPhotoUrl] [varchar](8000) NULL,
	[SmallPhotoUrl] [varchar](8000) NULL,
	[IsExtIndicatorVisible] [bit] NULL,
	[OutOfOfficeMessage] [varchar](8000) NULL,
	[MediumPhotoUrl] [varchar](8000) NULL,
	[DigestFrequency] [varchar](8000) NULL,
	[DefaultGroupNotificationFrequency] [varchar](8000) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[BannerPhotoUrl] [varchar](8000) NULL,
	[SmallBannerPhotoUrl] [varchar](8000) NULL,
	[MediumBannerPhotoUrl] [varchar](8000) NULL,
	[IsProfilePhotoActive] [bit] NULL,
	[et4ae5__Default_ET_Page__c] [varchar](8000) NULL,
	[et4ae5__Default_MID__c] [varchar](8000) NULL,
	[et4ae5__ExactTargetForAppExchangeAdmin__c] [bit] NULL,
	[et4ae5__ExactTargetForAppExchangeUser__c] [bit] NULL,
	[et4ae5__ExactTargetUsername__c] [varchar](8000) NULL,
	[et4ae5__ExactTarget_OAuth_Token__c] [varchar](8000) NULL,
	[et4ae5__ValidExactTargetAdmin__c] [bit] NULL,
	[et4ae5__ValidExactTargetUser__c] [bit] NULL,
	[Chat_Display_Name__c] [varchar](8000) NULL,
	[Chat_Photo_Small__c] [varchar](8000) NULL,
	[DialerID__c] [varchar](8000) NULL,
	[External_Id__c] [varchar](8000) NULL,
	[SightCall_UseCase_Id__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
