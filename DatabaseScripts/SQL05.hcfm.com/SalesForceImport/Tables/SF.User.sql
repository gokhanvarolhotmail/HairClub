/* CreateDate: 03/03/2022 13:53:57.437 , ModifyDate: 03/03/2022 22:19:13.760 */
GO
CREATE TABLE [SF].[User](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Username] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Division] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [decimal](25, 15) NULL,
	[Longitude] [decimal](25, 15) NULL,
	[GeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailPreferencesAutoBcc] [bit] NULL,
	[EmailPreferencesAutoBccStayInTouch] [bit] NULL,
	[EmailPreferencesStayInTouchReminder] [bit] NULL,
	[SenderEmail] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Signature] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StayInTouchSubject] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StayInTouchSignature] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StayInTouchNote] [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Alias] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommunityNickname] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BadgeText] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActive] [bit] NULL,
	[TimeZoneSidKey] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserRoleId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocaleSidKey] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceivesInfoEmails] [bit] NULL,
	[ReceivesAdminInfoEmails] [bit] NULL,
	[EmailEncodingKey] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultCurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProfileId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageLocaleKey] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DelegatedApproverId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ManagerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastLoginDate] [datetime2](7) NULL,
	[LastPasswordChangeDate] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[NumberOfFailedLogins] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OfflineTrialExpirationDate] [datetime2](7) NULL,
	[OfflinePdaTrialExpirationDate] [datetime2](7) NULL,
	[UserPermissionsMarketingUser] [bit] NULL,
	[UserPermissionsOfflineUser] [bit] NULL,
	[UserPermissionsAvantgoUser] [bit] NULL,
	[UserPermissionsCallCenterAutoLogin] [bit] NULL,
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
	[UserPreferencesReceiveNoNotificationsAsApprover] [bit] NULL,
	[UserPreferencesReceiveNotificationsAsDelegatedApprover] [bit] NULL,
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
	[UserPreferencesHideInvoicesRedirectConfirmation] [bit] NULL,
	[UserPreferencesHideStatementsRedirectConfirmation] [bit] NULL,
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
	[UserPreferencesSRHOverrideActivities] [bit] NULL,
	[UserPreferencesNewLightningReportRunPageEnabled] [bit] NULL,
	[UserPreferencesReverseOpenActivitiesView] [bit] NULL,
	[UserPreferencesShowTerritoryTimeZoneShifts] [bit] NULL,
	[UserPreferencesNativeEmailClient] [bit] NULL,
	[UserPreferencesHideBrowseProductRedirectConfirmation] [bit] NULL,
	[UserPreferencesHideOnlineSalesAppWelcomeMat] [bit] NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallCenterId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Extension] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FederationIdentifier] [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AboutMe] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullPhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SmallPhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsExtIndicatorVisible] [bit] NULL,
	[OutOfOfficeMessage] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediumPhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DigestFrequency] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultGroupNotificationFrequency] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[BannerPhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SmallBannerPhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediumBannerPhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProfilePhotoActive] [bit] NULL,
	[et4ae5__Default_ET_Page__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__Default_MID__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__ExactTargetForAppExchangeAdmin__c] [bit] NULL,
	[et4ae5__ExactTargetForAppExchangeUser__c] [bit] NULL,
	[et4ae5__ExactTargetUsername__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__ExactTarget_OAuth_Token__c] [varchar](175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[et4ae5__ValidExactTargetAdmin__c] [bit] NULL,
	[et4ae5__ValidExactTargetUser__c] [bit] NULL,
	[Chat_Display_Name__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Chat_Photo_Small__c] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DialerID__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SightCall_UseCase_Id__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mobile_Agent_Login__c] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[approver__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DB_Region__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Full_Name__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[User_Deactivation_Details__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BannerPhotoId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EndDay] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkspaceId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserSubtype] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSystemControlled] [bit] NULL,
	[PasswordResetAttempt] [decimal](9, 0) NULL,
	[PasswordResetLockoutDate] [datetime2](7) NULL,
	[StartDay] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_User] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[User]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[User]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
