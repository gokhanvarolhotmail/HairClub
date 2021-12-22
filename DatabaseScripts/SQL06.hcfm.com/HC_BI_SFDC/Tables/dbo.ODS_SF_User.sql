CREATE TABLE [dbo].[ODS_SF_User](
	[CreatedDate] [datetime] NULL,
	[Id] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[AccountId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [numeric](38, 18) NULL,
	[Longitude] [numeric](38, 18) NULL,
	[GeocodeAccuracy] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Username] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Division] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailPreferencesAutoBcc] [bit] NULL,
	[EmailPreferencesAutoBccStayInTouch] [bit] NULL,
	[EmailPreferencesStayInTouchReminder] [bit] NULL,
	[SenderEmail] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Signature] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StayInTouchSubject] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StayInTouchSignature] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StayInTouchNote] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Alias] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommunityNickname] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BadgeText] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActive] [bit] NULL,
	[TimeZoneSidKey] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserRoleId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocaleSidKey] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceivesInfoEmails] [bit] NULL,
	[ReceivesAdminInfoEmails] [bit] NULL,
	[EmailEncodingKey] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultCurrencyIsoCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProfileId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserType] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageLocaleKey] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeNumber] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DelegatedApproverId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ManagerId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastLoginDate] [datetime2](7) NULL,
	[LastPasswordChangeDate] [datetime2](7) NULL,
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
	[CallCenterId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Extension] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FederationIdentifier] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AboutMe] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullPhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SmallPhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsExtIndicatorVisible] [bit] NULL,
	[OutOfOfficeMessage] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediumPhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DigestFrequency] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultGroupNotificationFrequency] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BannerPhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SmallBannerPhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediumBannerPhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProfilePhotoActive] [bit] NULL,
	[et4ae5__Default_ET_Page__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__Default_MID__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__ExactTargetForAppExchangeAdmin__c] [bit] NULL,
	[et4ae5__ExactTargetForAppExchangeUser__c] [bit] NULL,
	[et4ae5__ExactTargetUsername__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__ExactTarget_OAuth_Token__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__ValidExactTargetAdmin__c] [bit] NULL,
	[et4ae5__ValidExactTargetUser__c] [bit] NULL,
	[Chat_Display_Name__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Chat_Photo_Small__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DialerID__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SightCall_UseCase_Id__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
