/* CreateDate: 03/17/2022 15:12:16.800 , ModifyDate: 03/17/2022 15:12:16.800 */
GO
CREATE PROCEDURE [SF].[sp_User_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[User])
RETURN ;

BEGIN TRY
;MERGE [SF].[User] AS [t]
USING [SFStaging].[User] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[Username] = [t].[Username]
	, [t].[LastName] = [t].[LastName]
	, [t].[FirstName] = [t].[FirstName]
	, [t].[MiddleName] = [t].[MiddleName]
	, [t].[Suffix] = [t].[Suffix]
	, [t].[Name] = [t].[Name]
	, [t].[CompanyName] = [t].[CompanyName]
	, [t].[Division] = [t].[Division]
	, [t].[Department] = [t].[Department]
	, [t].[Title] = [t].[Title]
	, [t].[Street] = [t].[Street]
	, [t].[City] = [t].[City]
	, [t].[State] = [t].[State]
	, [t].[PostalCode] = [t].[PostalCode]
	, [t].[Country] = [t].[Country]
	, [t].[StateCode] = [t].[StateCode]
	, [t].[CountryCode] = [t].[CountryCode]
	, [t].[Latitude] = [t].[Latitude]
	, [t].[Longitude] = [t].[Longitude]
	, [t].[GeocodeAccuracy] = [t].[GeocodeAccuracy]
	, [t].[Address] = [t].[Address]
	, [t].[Email] = [t].[Email]
	, [t].[EmailPreferencesAutoBcc] = [t].[EmailPreferencesAutoBcc]
	, [t].[EmailPreferencesAutoBccStayInTouch] = [t].[EmailPreferencesAutoBccStayInTouch]
	, [t].[EmailPreferencesStayInTouchReminder] = [t].[EmailPreferencesStayInTouchReminder]
	, [t].[SenderEmail] = [t].[SenderEmail]
	, [t].[SenderName] = [t].[SenderName]
	, [t].[Signature] = [t].[Signature]
	, [t].[StayInTouchSubject] = [t].[StayInTouchSubject]
	, [t].[StayInTouchSignature] = [t].[StayInTouchSignature]
	, [t].[StayInTouchNote] = [t].[StayInTouchNote]
	, [t].[Phone] = [t].[Phone]
	, [t].[Fax] = [t].[Fax]
	, [t].[MobilePhone] = [t].[MobilePhone]
	, [t].[Alias] = [t].[Alias]
	, [t].[CommunityNickname] = [t].[CommunityNickname]
	, [t].[BadgeText] = [t].[BadgeText]
	, [t].[IsActive] = [t].[IsActive]
	, [t].[TimeZoneSidKey] = [t].[TimeZoneSidKey]
	, [t].[UserRoleId] = [t].[UserRoleId]
	, [t].[LocaleSidKey] = [t].[LocaleSidKey]
	, [t].[ReceivesInfoEmails] = [t].[ReceivesInfoEmails]
	, [t].[ReceivesAdminInfoEmails] = [t].[ReceivesAdminInfoEmails]
	, [t].[EmailEncodingKey] = [t].[EmailEncodingKey]
	, [t].[DefaultCurrencyIsoCode] = [t].[DefaultCurrencyIsoCode]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[ProfileId] = [t].[ProfileId]
	, [t].[UserType] = [t].[UserType]
	, [t].[LanguageLocaleKey] = [t].[LanguageLocaleKey]
	, [t].[EmployeeNumber] = [t].[EmployeeNumber]
	, [t].[DelegatedApproverId] = [t].[DelegatedApproverId]
	, [t].[ManagerId] = [t].[ManagerId]
	, [t].[LastLoginDate] = [t].[LastLoginDate]
	, [t].[LastPasswordChangeDate] = [t].[LastPasswordChangeDate]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[NumberOfFailedLogins] = [t].[NumberOfFailedLogins]
	, [t].[OfflineTrialExpirationDate] = [t].[OfflineTrialExpirationDate]
	, [t].[OfflinePdaTrialExpirationDate] = [t].[OfflinePdaTrialExpirationDate]
	, [t].[UserPermissionsMarketingUser] = [t].[UserPermissionsMarketingUser]
	, [t].[UserPermissionsOfflineUser] = [t].[UserPermissionsOfflineUser]
	, [t].[UserPermissionsAvantgoUser] = [t].[UserPermissionsAvantgoUser]
	, [t].[UserPermissionsCallCenterAutoLogin] = [t].[UserPermissionsCallCenterAutoLogin]
	, [t].[UserPermissionsSFContentUser] = [t].[UserPermissionsSFContentUser]
	, [t].[UserPermissionsKnowledgeUser] = [t].[UserPermissionsKnowledgeUser]
	, [t].[UserPermissionsInteractionUser] = [t].[UserPermissionsInteractionUser]
	, [t].[UserPermissionsSupportUser] = [t].[UserPermissionsSupportUser]
	, [t].[UserPermissionsLiveAgentUser] = [t].[UserPermissionsLiveAgentUser]
	, [t].[ForecastEnabled] = [t].[ForecastEnabled]
	, [t].[UserPreferencesActivityRemindersPopup] = [t].[UserPreferencesActivityRemindersPopup]
	, [t].[UserPreferencesEventRemindersCheckboxDefault] = [t].[UserPreferencesEventRemindersCheckboxDefault]
	, [t].[UserPreferencesTaskRemindersCheckboxDefault] = [t].[UserPreferencesTaskRemindersCheckboxDefault]
	, [t].[UserPreferencesReminderSoundOff] = [t].[UserPreferencesReminderSoundOff]
	, [t].[UserPreferencesDisableAllFeedsEmail] = [t].[UserPreferencesDisableAllFeedsEmail]
	, [t].[UserPreferencesDisableFollowersEmail] = [t].[UserPreferencesDisableFollowersEmail]
	, [t].[UserPreferencesDisableProfilePostEmail] = [t].[UserPreferencesDisableProfilePostEmail]
	, [t].[UserPreferencesDisableChangeCommentEmail] = [t].[UserPreferencesDisableChangeCommentEmail]
	, [t].[UserPreferencesDisableLaterCommentEmail] = [t].[UserPreferencesDisableLaterCommentEmail]
	, [t].[UserPreferencesDisProfPostCommentEmail] = [t].[UserPreferencesDisProfPostCommentEmail]
	, [t].[UserPreferencesApexPagesDeveloperMode] = [t].[UserPreferencesApexPagesDeveloperMode]
	, [t].[UserPreferencesReceiveNoNotificationsAsApprover] = [t].[UserPreferencesReceiveNoNotificationsAsApprover]
	, [t].[UserPreferencesReceiveNotificationsAsDelegatedApprover] = [t].[UserPreferencesReceiveNotificationsAsDelegatedApprover]
	, [t].[UserPreferencesHideCSNGetChatterMobileTask] = [t].[UserPreferencesHideCSNGetChatterMobileTask]
	, [t].[UserPreferencesDisableMentionsPostEmail] = [t].[UserPreferencesDisableMentionsPostEmail]
	, [t].[UserPreferencesDisMentionsCommentEmail] = [t].[UserPreferencesDisMentionsCommentEmail]
	, [t].[UserPreferencesHideCSNDesktopTask] = [t].[UserPreferencesHideCSNDesktopTask]
	, [t].[UserPreferencesHideChatterOnboardingSplash] = [t].[UserPreferencesHideChatterOnboardingSplash]
	, [t].[UserPreferencesHideSecondChatterOnboardingSplash] = [t].[UserPreferencesHideSecondChatterOnboardingSplash]
	, [t].[UserPreferencesDisCommentAfterLikeEmail] = [t].[UserPreferencesDisCommentAfterLikeEmail]
	, [t].[UserPreferencesDisableLikeEmail] = [t].[UserPreferencesDisableLikeEmail]
	, [t].[UserPreferencesSortFeedByComment] = [t].[UserPreferencesSortFeedByComment]
	, [t].[UserPreferencesDisableMessageEmail] = [t].[UserPreferencesDisableMessageEmail]
	, [t].[UserPreferencesDisableBookmarkEmail] = [t].[UserPreferencesDisableBookmarkEmail]
	, [t].[UserPreferencesDisableSharePostEmail] = [t].[UserPreferencesDisableSharePostEmail]
	, [t].[UserPreferencesEnableAutoSubForFeeds] = [t].[UserPreferencesEnableAutoSubForFeeds]
	, [t].[UserPreferencesDisableFileShareNotificationsForApi] = [t].[UserPreferencesDisableFileShareNotificationsForApi]
	, [t].[UserPreferencesShowTitleToExternalUsers] = [t].[UserPreferencesShowTitleToExternalUsers]
	, [t].[UserPreferencesShowManagerToExternalUsers] = [t].[UserPreferencesShowManagerToExternalUsers]
	, [t].[UserPreferencesShowEmailToExternalUsers] = [t].[UserPreferencesShowEmailToExternalUsers]
	, [t].[UserPreferencesShowWorkPhoneToExternalUsers] = [t].[UserPreferencesShowWorkPhoneToExternalUsers]
	, [t].[UserPreferencesShowMobilePhoneToExternalUsers] = [t].[UserPreferencesShowMobilePhoneToExternalUsers]
	, [t].[UserPreferencesShowFaxToExternalUsers] = [t].[UserPreferencesShowFaxToExternalUsers]
	, [t].[UserPreferencesShowStreetAddressToExternalUsers] = [t].[UserPreferencesShowStreetAddressToExternalUsers]
	, [t].[UserPreferencesShowCityToExternalUsers] = [t].[UserPreferencesShowCityToExternalUsers]
	, [t].[UserPreferencesShowStateToExternalUsers] = [t].[UserPreferencesShowStateToExternalUsers]
	, [t].[UserPreferencesShowPostalCodeToExternalUsers] = [t].[UserPreferencesShowPostalCodeToExternalUsers]
	, [t].[UserPreferencesShowCountryToExternalUsers] = [t].[UserPreferencesShowCountryToExternalUsers]
	, [t].[UserPreferencesShowProfilePicToGuestUsers] = [t].[UserPreferencesShowProfilePicToGuestUsers]
	, [t].[UserPreferencesShowTitleToGuestUsers] = [t].[UserPreferencesShowTitleToGuestUsers]
	, [t].[UserPreferencesShowCityToGuestUsers] = [t].[UserPreferencesShowCityToGuestUsers]
	, [t].[UserPreferencesShowStateToGuestUsers] = [t].[UserPreferencesShowStateToGuestUsers]
	, [t].[UserPreferencesShowPostalCodeToGuestUsers] = [t].[UserPreferencesShowPostalCodeToGuestUsers]
	, [t].[UserPreferencesShowCountryToGuestUsers] = [t].[UserPreferencesShowCountryToGuestUsers]
	, [t].[UserPreferencesHideInvoicesRedirectConfirmation] = [t].[UserPreferencesHideInvoicesRedirectConfirmation]
	, [t].[UserPreferencesHideStatementsRedirectConfirmation] = [t].[UserPreferencesHideStatementsRedirectConfirmation]
	, [t].[UserPreferencesHideS1BrowserUI] = [t].[UserPreferencesHideS1BrowserUI]
	, [t].[UserPreferencesDisableEndorsementEmail] = [t].[UserPreferencesDisableEndorsementEmail]
	, [t].[UserPreferencesPathAssistantCollapsed] = [t].[UserPreferencesPathAssistantCollapsed]
	, [t].[UserPreferencesCacheDiagnostics] = [t].[UserPreferencesCacheDiagnostics]
	, [t].[UserPreferencesShowEmailToGuestUsers] = [t].[UserPreferencesShowEmailToGuestUsers]
	, [t].[UserPreferencesShowManagerToGuestUsers] = [t].[UserPreferencesShowManagerToGuestUsers]
	, [t].[UserPreferencesShowWorkPhoneToGuestUsers] = [t].[UserPreferencesShowWorkPhoneToGuestUsers]
	, [t].[UserPreferencesShowMobilePhoneToGuestUsers] = [t].[UserPreferencesShowMobilePhoneToGuestUsers]
	, [t].[UserPreferencesShowFaxToGuestUsers] = [t].[UserPreferencesShowFaxToGuestUsers]
	, [t].[UserPreferencesShowStreetAddressToGuestUsers] = [t].[UserPreferencesShowStreetAddressToGuestUsers]
	, [t].[UserPreferencesLightningExperiencePreferred] = [t].[UserPreferencesLightningExperiencePreferred]
	, [t].[UserPreferencesPreviewLightning] = [t].[UserPreferencesPreviewLightning]
	, [t].[UserPreferencesHideEndUserOnboardingAssistantModal] = [t].[UserPreferencesHideEndUserOnboardingAssistantModal]
	, [t].[UserPreferencesHideLightningMigrationModal] = [t].[UserPreferencesHideLightningMigrationModal]
	, [t].[UserPreferencesHideSfxWelcomeMat] = [t].[UserPreferencesHideSfxWelcomeMat]
	, [t].[UserPreferencesHideBiggerPhotoCallout] = [t].[UserPreferencesHideBiggerPhotoCallout]
	, [t].[UserPreferencesGlobalNavBarWTShown] = [t].[UserPreferencesGlobalNavBarWTShown]
	, [t].[UserPreferencesGlobalNavGridMenuWTShown] = [t].[UserPreferencesGlobalNavGridMenuWTShown]
	, [t].[UserPreferencesCreateLEXAppsWTShown] = [t].[UserPreferencesCreateLEXAppsWTShown]
	, [t].[UserPreferencesFavoritesWTShown] = [t].[UserPreferencesFavoritesWTShown]
	, [t].[UserPreferencesRecordHomeSectionCollapseWTShown] = [t].[UserPreferencesRecordHomeSectionCollapseWTShown]
	, [t].[UserPreferencesRecordHomeReservedWTShown] = [t].[UserPreferencesRecordHomeReservedWTShown]
	, [t].[UserPreferencesFavoritesShowTopFavorites] = [t].[UserPreferencesFavoritesShowTopFavorites]
	, [t].[UserPreferencesExcludeMailAppAttachments] = [t].[UserPreferencesExcludeMailAppAttachments]
	, [t].[UserPreferencesSuppressTaskSFXReminders] = [t].[UserPreferencesSuppressTaskSFXReminders]
	, [t].[UserPreferencesSuppressEventSFXReminders] = [t].[UserPreferencesSuppressEventSFXReminders]
	, [t].[UserPreferencesPreviewCustomTheme] = [t].[UserPreferencesPreviewCustomTheme]
	, [t].[UserPreferencesHasCelebrationBadge] = [t].[UserPreferencesHasCelebrationBadge]
	, [t].[UserPreferencesUserDebugModePref] = [t].[UserPreferencesUserDebugModePref]
	, [t].[UserPreferencesSRHOverrideActivities] = [t].[UserPreferencesSRHOverrideActivities]
	, [t].[UserPreferencesNewLightningReportRunPageEnabled] = [t].[UserPreferencesNewLightningReportRunPageEnabled]
	, [t].[UserPreferencesReverseOpenActivitiesView] = [t].[UserPreferencesReverseOpenActivitiesView]
	, [t].[UserPreferencesShowTerritoryTimeZoneShifts] = [t].[UserPreferencesShowTerritoryTimeZoneShifts]
	, [t].[UserPreferencesNativeEmailClient] = [t].[UserPreferencesNativeEmailClient]
	, [t].[UserPreferencesHideBrowseProductRedirectConfirmation] = [t].[UserPreferencesHideBrowseProductRedirectConfirmation]
	, [t].[UserPreferencesHideOnlineSalesAppWelcomeMat] = [t].[UserPreferencesHideOnlineSalesAppWelcomeMat]
	, [t].[ContactId] = [t].[ContactId]
	, [t].[AccountId] = [t].[AccountId]
	, [t].[CallCenterId] = [t].[CallCenterId]
	, [t].[Extension] = [t].[Extension]
	, [t].[FederationIdentifier] = [t].[FederationIdentifier]
	, [t].[AboutMe] = [t].[AboutMe]
	, [t].[FullPhotoUrl] = [t].[FullPhotoUrl]
	, [t].[SmallPhotoUrl] = [t].[SmallPhotoUrl]
	, [t].[IsExtIndicatorVisible] = [t].[IsExtIndicatorVisible]
	, [t].[OutOfOfficeMessage] = [t].[OutOfOfficeMessage]
	, [t].[MediumPhotoUrl] = [t].[MediumPhotoUrl]
	, [t].[DigestFrequency] = [t].[DigestFrequency]
	, [t].[DefaultGroupNotificationFrequency] = [t].[DefaultGroupNotificationFrequency]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[BannerPhotoUrl] = [t].[BannerPhotoUrl]
	, [t].[SmallBannerPhotoUrl] = [t].[SmallBannerPhotoUrl]
	, [t].[MediumBannerPhotoUrl] = [t].[MediumBannerPhotoUrl]
	, [t].[IsProfilePhotoActive] = [t].[IsProfilePhotoActive]
	, [t].[et4ae5__Default_ET_Page__c] = [t].[et4ae5__Default_ET_Page__c]
	, [t].[et4ae5__Default_MID__c] = [t].[et4ae5__Default_MID__c]
	, [t].[et4ae5__ExactTargetForAppExchangeAdmin__c] = [t].[et4ae5__ExactTargetForAppExchangeAdmin__c]
	, [t].[et4ae5__ExactTargetForAppExchangeUser__c] = [t].[et4ae5__ExactTargetForAppExchangeUser__c]
	, [t].[et4ae5__ExactTargetUsername__c] = [t].[et4ae5__ExactTargetUsername__c]
	, [t].[et4ae5__ExactTarget_OAuth_Token__c] = [t].[et4ae5__ExactTarget_OAuth_Token__c]
	, [t].[et4ae5__ValidExactTargetAdmin__c] = [t].[et4ae5__ValidExactTargetAdmin__c]
	, [t].[et4ae5__ValidExactTargetUser__c] = [t].[et4ae5__ValidExactTargetUser__c]
	, [t].[Chat_Display_Name__c] = [t].[Chat_Display_Name__c]
	, [t].[Chat_Photo_Small__c] = [t].[Chat_Photo_Small__c]
	, [t].[DialerID__c] = [t].[DialerID__c]
	, [t].[External_Id__c] = [t].[External_Id__c]
	, [t].[SightCall_UseCase_Id__c] = [t].[SightCall_UseCase_Id__c]
	, [t].[Mobile_Agent_Login__c] = [t].[Mobile_Agent_Login__c]
	, [t].[approver__c] = [t].[approver__c]
	, [t].[DB_Region__c] = [t].[DB_Region__c]
	, [t].[Full_Name__c] = [t].[Full_Name__c]
	, [t].[User_Deactivation_Details__c] = [t].[User_Deactivation_Details__c]
	, [t].[BannerPhotoId] = [t].[BannerPhotoId]
	, [t].[EndDay] = [t].[EndDay]
	, [t].[WorkspaceId] = [t].[WorkspaceId]
	, [t].[UserSubtype] = [t].[UserSubtype]
	, [t].[IsSystemControlled] = [t].[IsSystemControlled]
	, [t].[PasswordResetAttempt] = [t].[PasswordResetAttempt]
	, [t].[PasswordResetLockoutDate] = [t].[PasswordResetLockoutDate]
	, [t].[StartDay] = [t].[StartDay]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [Username]
	, [LastName]
	, [FirstName]
	, [MiddleName]
	, [Suffix]
	, [Name]
	, [CompanyName]
	, [Division]
	, [Department]
	, [Title]
	, [Street]
	, [City]
	, [State]
	, [PostalCode]
	, [Country]
	, [StateCode]
	, [CountryCode]
	, [Latitude]
	, [Longitude]
	, [GeocodeAccuracy]
	, [Address]
	, [Email]
	, [EmailPreferencesAutoBcc]
	, [EmailPreferencesAutoBccStayInTouch]
	, [EmailPreferencesStayInTouchReminder]
	, [SenderEmail]
	, [SenderName]
	, [Signature]
	, [StayInTouchSubject]
	, [StayInTouchSignature]
	, [StayInTouchNote]
	, [Phone]
	, [Fax]
	, [MobilePhone]
	, [Alias]
	, [CommunityNickname]
	, [BadgeText]
	, [IsActive]
	, [TimeZoneSidKey]
	, [UserRoleId]
	, [LocaleSidKey]
	, [ReceivesInfoEmails]
	, [ReceivesAdminInfoEmails]
	, [EmailEncodingKey]
	, [DefaultCurrencyIsoCode]
	, [CurrencyIsoCode]
	, [ProfileId]
	, [UserType]
	, [LanguageLocaleKey]
	, [EmployeeNumber]
	, [DelegatedApproverId]
	, [ManagerId]
	, [LastLoginDate]
	, [LastPasswordChangeDate]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [NumberOfFailedLogins]
	, [OfflineTrialExpirationDate]
	, [OfflinePdaTrialExpirationDate]
	, [UserPermissionsMarketingUser]
	, [UserPermissionsOfflineUser]
	, [UserPermissionsAvantgoUser]
	, [UserPermissionsCallCenterAutoLogin]
	, [UserPermissionsSFContentUser]
	, [UserPermissionsKnowledgeUser]
	, [UserPermissionsInteractionUser]
	, [UserPermissionsSupportUser]
	, [UserPermissionsLiveAgentUser]
	, [ForecastEnabled]
	, [UserPreferencesActivityRemindersPopup]
	, [UserPreferencesEventRemindersCheckboxDefault]
	, [UserPreferencesTaskRemindersCheckboxDefault]
	, [UserPreferencesReminderSoundOff]
	, [UserPreferencesDisableAllFeedsEmail]
	, [UserPreferencesDisableFollowersEmail]
	, [UserPreferencesDisableProfilePostEmail]
	, [UserPreferencesDisableChangeCommentEmail]
	, [UserPreferencesDisableLaterCommentEmail]
	, [UserPreferencesDisProfPostCommentEmail]
	, [UserPreferencesApexPagesDeveloperMode]
	, [UserPreferencesReceiveNoNotificationsAsApprover]
	, [UserPreferencesReceiveNotificationsAsDelegatedApprover]
	, [UserPreferencesHideCSNGetChatterMobileTask]
	, [UserPreferencesDisableMentionsPostEmail]
	, [UserPreferencesDisMentionsCommentEmail]
	, [UserPreferencesHideCSNDesktopTask]
	, [UserPreferencesHideChatterOnboardingSplash]
	, [UserPreferencesHideSecondChatterOnboardingSplash]
	, [UserPreferencesDisCommentAfterLikeEmail]
	, [UserPreferencesDisableLikeEmail]
	, [UserPreferencesSortFeedByComment]
	, [UserPreferencesDisableMessageEmail]
	, [UserPreferencesDisableBookmarkEmail]
	, [UserPreferencesDisableSharePostEmail]
	, [UserPreferencesEnableAutoSubForFeeds]
	, [UserPreferencesDisableFileShareNotificationsForApi]
	, [UserPreferencesShowTitleToExternalUsers]
	, [UserPreferencesShowManagerToExternalUsers]
	, [UserPreferencesShowEmailToExternalUsers]
	, [UserPreferencesShowWorkPhoneToExternalUsers]
	, [UserPreferencesShowMobilePhoneToExternalUsers]
	, [UserPreferencesShowFaxToExternalUsers]
	, [UserPreferencesShowStreetAddressToExternalUsers]
	, [UserPreferencesShowCityToExternalUsers]
	, [UserPreferencesShowStateToExternalUsers]
	, [UserPreferencesShowPostalCodeToExternalUsers]
	, [UserPreferencesShowCountryToExternalUsers]
	, [UserPreferencesShowProfilePicToGuestUsers]
	, [UserPreferencesShowTitleToGuestUsers]
	, [UserPreferencesShowCityToGuestUsers]
	, [UserPreferencesShowStateToGuestUsers]
	, [UserPreferencesShowPostalCodeToGuestUsers]
	, [UserPreferencesShowCountryToGuestUsers]
	, [UserPreferencesHideInvoicesRedirectConfirmation]
	, [UserPreferencesHideStatementsRedirectConfirmation]
	, [UserPreferencesHideS1BrowserUI]
	, [UserPreferencesDisableEndorsementEmail]
	, [UserPreferencesPathAssistantCollapsed]
	, [UserPreferencesCacheDiagnostics]
	, [UserPreferencesShowEmailToGuestUsers]
	, [UserPreferencesShowManagerToGuestUsers]
	, [UserPreferencesShowWorkPhoneToGuestUsers]
	, [UserPreferencesShowMobilePhoneToGuestUsers]
	, [UserPreferencesShowFaxToGuestUsers]
	, [UserPreferencesShowStreetAddressToGuestUsers]
	, [UserPreferencesLightningExperiencePreferred]
	, [UserPreferencesPreviewLightning]
	, [UserPreferencesHideEndUserOnboardingAssistantModal]
	, [UserPreferencesHideLightningMigrationModal]
	, [UserPreferencesHideSfxWelcomeMat]
	, [UserPreferencesHideBiggerPhotoCallout]
	, [UserPreferencesGlobalNavBarWTShown]
	, [UserPreferencesGlobalNavGridMenuWTShown]
	, [UserPreferencesCreateLEXAppsWTShown]
	, [UserPreferencesFavoritesWTShown]
	, [UserPreferencesRecordHomeSectionCollapseWTShown]
	, [UserPreferencesRecordHomeReservedWTShown]
	, [UserPreferencesFavoritesShowTopFavorites]
	, [UserPreferencesExcludeMailAppAttachments]
	, [UserPreferencesSuppressTaskSFXReminders]
	, [UserPreferencesSuppressEventSFXReminders]
	, [UserPreferencesPreviewCustomTheme]
	, [UserPreferencesHasCelebrationBadge]
	, [UserPreferencesUserDebugModePref]
	, [UserPreferencesSRHOverrideActivities]
	, [UserPreferencesNewLightningReportRunPageEnabled]
	, [UserPreferencesReverseOpenActivitiesView]
	, [UserPreferencesShowTerritoryTimeZoneShifts]
	, [UserPreferencesNativeEmailClient]
	, [UserPreferencesHideBrowseProductRedirectConfirmation]
	, [UserPreferencesHideOnlineSalesAppWelcomeMat]
	, [ContactId]
	, [AccountId]
	, [CallCenterId]
	, [Extension]
	, [FederationIdentifier]
	, [AboutMe]
	, [FullPhotoUrl]
	, [SmallPhotoUrl]
	, [IsExtIndicatorVisible]
	, [OutOfOfficeMessage]
	, [MediumPhotoUrl]
	, [DigestFrequency]
	, [DefaultGroupNotificationFrequency]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [BannerPhotoUrl]
	, [SmallBannerPhotoUrl]
	, [MediumBannerPhotoUrl]
	, [IsProfilePhotoActive]
	, [et4ae5__Default_ET_Page__c]
	, [et4ae5__Default_MID__c]
	, [et4ae5__ExactTargetForAppExchangeAdmin__c]
	, [et4ae5__ExactTargetForAppExchangeUser__c]
	, [et4ae5__ExactTargetUsername__c]
	, [et4ae5__ExactTarget_OAuth_Token__c]
	, [et4ae5__ValidExactTargetAdmin__c]
	, [et4ae5__ValidExactTargetUser__c]
	, [Chat_Display_Name__c]
	, [Chat_Photo_Small__c]
	, [DialerID__c]
	, [External_Id__c]
	, [SightCall_UseCase_Id__c]
	, [Mobile_Agent_Login__c]
	, [approver__c]
	, [DB_Region__c]
	, [Full_Name__c]
	, [User_Deactivation_Details__c]
	, [BannerPhotoId]
	, [EndDay]
	, [WorkspaceId]
	, [UserSubtype]
	, [IsSystemControlled]
	, [PasswordResetAttempt]
	, [PasswordResetLockoutDate]
	, [StartDay]
	)
	VALUES(
	[s].[Id]
	, [s].[Username]
	, [s].[LastName]
	, [s].[FirstName]
	, [s].[MiddleName]
	, [s].[Suffix]
	, [s].[Name]
	, [s].[CompanyName]
	, [s].[Division]
	, [s].[Department]
	, [s].[Title]
	, [s].[Street]
	, [s].[City]
	, [s].[State]
	, [s].[PostalCode]
	, [s].[Country]
	, [s].[StateCode]
	, [s].[CountryCode]
	, [s].[Latitude]
	, [s].[Longitude]
	, [s].[GeocodeAccuracy]
	, [s].[Address]
	, [s].[Email]
	, [s].[EmailPreferencesAutoBcc]
	, [s].[EmailPreferencesAutoBccStayInTouch]
	, [s].[EmailPreferencesStayInTouchReminder]
	, [s].[SenderEmail]
	, [s].[SenderName]
	, [s].[Signature]
	, [s].[StayInTouchSubject]
	, [s].[StayInTouchSignature]
	, [s].[StayInTouchNote]
	, [s].[Phone]
	, [s].[Fax]
	, [s].[MobilePhone]
	, [s].[Alias]
	, [s].[CommunityNickname]
	, [s].[BadgeText]
	, [s].[IsActive]
	, [s].[TimeZoneSidKey]
	, [s].[UserRoleId]
	, [s].[LocaleSidKey]
	, [s].[ReceivesInfoEmails]
	, [s].[ReceivesAdminInfoEmails]
	, [s].[EmailEncodingKey]
	, [s].[DefaultCurrencyIsoCode]
	, [s].[CurrencyIsoCode]
	, [s].[ProfileId]
	, [s].[UserType]
	, [s].[LanguageLocaleKey]
	, [s].[EmployeeNumber]
	, [s].[DelegatedApproverId]
	, [s].[ManagerId]
	, [s].[LastLoginDate]
	, [s].[LastPasswordChangeDate]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[NumberOfFailedLogins]
	, [s].[OfflineTrialExpirationDate]
	, [s].[OfflinePdaTrialExpirationDate]
	, [s].[UserPermissionsMarketingUser]
	, [s].[UserPermissionsOfflineUser]
	, [s].[UserPermissionsAvantgoUser]
	, [s].[UserPermissionsCallCenterAutoLogin]
	, [s].[UserPermissionsSFContentUser]
	, [s].[UserPermissionsKnowledgeUser]
	, [s].[UserPermissionsInteractionUser]
	, [s].[UserPermissionsSupportUser]
	, [s].[UserPermissionsLiveAgentUser]
	, [s].[ForecastEnabled]
	, [s].[UserPreferencesActivityRemindersPopup]
	, [s].[UserPreferencesEventRemindersCheckboxDefault]
	, [s].[UserPreferencesTaskRemindersCheckboxDefault]
	, [s].[UserPreferencesReminderSoundOff]
	, [s].[UserPreferencesDisableAllFeedsEmail]
	, [s].[UserPreferencesDisableFollowersEmail]
	, [s].[UserPreferencesDisableProfilePostEmail]
	, [s].[UserPreferencesDisableChangeCommentEmail]
	, [s].[UserPreferencesDisableLaterCommentEmail]
	, [s].[UserPreferencesDisProfPostCommentEmail]
	, [s].[UserPreferencesApexPagesDeveloperMode]
	, [s].[UserPreferencesReceiveNoNotificationsAsApprover]
	, [s].[UserPreferencesReceiveNotificationsAsDelegatedApprover]
	, [s].[UserPreferencesHideCSNGetChatterMobileTask]
	, [s].[UserPreferencesDisableMentionsPostEmail]
	, [s].[UserPreferencesDisMentionsCommentEmail]
	, [s].[UserPreferencesHideCSNDesktopTask]
	, [s].[UserPreferencesHideChatterOnboardingSplash]
	, [s].[UserPreferencesHideSecondChatterOnboardingSplash]
	, [s].[UserPreferencesDisCommentAfterLikeEmail]
	, [s].[UserPreferencesDisableLikeEmail]
	, [s].[UserPreferencesSortFeedByComment]
	, [s].[UserPreferencesDisableMessageEmail]
	, [s].[UserPreferencesDisableBookmarkEmail]
	, [s].[UserPreferencesDisableSharePostEmail]
	, [s].[UserPreferencesEnableAutoSubForFeeds]
	, [s].[UserPreferencesDisableFileShareNotificationsForApi]
	, [s].[UserPreferencesShowTitleToExternalUsers]
	, [s].[UserPreferencesShowManagerToExternalUsers]
	, [s].[UserPreferencesShowEmailToExternalUsers]
	, [s].[UserPreferencesShowWorkPhoneToExternalUsers]
	, [s].[UserPreferencesShowMobilePhoneToExternalUsers]
	, [s].[UserPreferencesShowFaxToExternalUsers]
	, [s].[UserPreferencesShowStreetAddressToExternalUsers]
	, [s].[UserPreferencesShowCityToExternalUsers]
	, [s].[UserPreferencesShowStateToExternalUsers]
	, [s].[UserPreferencesShowPostalCodeToExternalUsers]
	, [s].[UserPreferencesShowCountryToExternalUsers]
	, [s].[UserPreferencesShowProfilePicToGuestUsers]
	, [s].[UserPreferencesShowTitleToGuestUsers]
	, [s].[UserPreferencesShowCityToGuestUsers]
	, [s].[UserPreferencesShowStateToGuestUsers]
	, [s].[UserPreferencesShowPostalCodeToGuestUsers]
	, [s].[UserPreferencesShowCountryToGuestUsers]
	, [s].[UserPreferencesHideInvoicesRedirectConfirmation]
	, [s].[UserPreferencesHideStatementsRedirectConfirmation]
	, [s].[UserPreferencesHideS1BrowserUI]
	, [s].[UserPreferencesDisableEndorsementEmail]
	, [s].[UserPreferencesPathAssistantCollapsed]
	, [s].[UserPreferencesCacheDiagnostics]
	, [s].[UserPreferencesShowEmailToGuestUsers]
	, [s].[UserPreferencesShowManagerToGuestUsers]
	, [s].[UserPreferencesShowWorkPhoneToGuestUsers]
	, [s].[UserPreferencesShowMobilePhoneToGuestUsers]
	, [s].[UserPreferencesShowFaxToGuestUsers]
	, [s].[UserPreferencesShowStreetAddressToGuestUsers]
	, [s].[UserPreferencesLightningExperiencePreferred]
	, [s].[UserPreferencesPreviewLightning]
	, [s].[UserPreferencesHideEndUserOnboardingAssistantModal]
	, [s].[UserPreferencesHideLightningMigrationModal]
	, [s].[UserPreferencesHideSfxWelcomeMat]
	, [s].[UserPreferencesHideBiggerPhotoCallout]
	, [s].[UserPreferencesGlobalNavBarWTShown]
	, [s].[UserPreferencesGlobalNavGridMenuWTShown]
	, [s].[UserPreferencesCreateLEXAppsWTShown]
	, [s].[UserPreferencesFavoritesWTShown]
	, [s].[UserPreferencesRecordHomeSectionCollapseWTShown]
	, [s].[UserPreferencesRecordHomeReservedWTShown]
	, [s].[UserPreferencesFavoritesShowTopFavorites]
	, [s].[UserPreferencesExcludeMailAppAttachments]
	, [s].[UserPreferencesSuppressTaskSFXReminders]
	, [s].[UserPreferencesSuppressEventSFXReminders]
	, [s].[UserPreferencesPreviewCustomTheme]
	, [s].[UserPreferencesHasCelebrationBadge]
	, [s].[UserPreferencesUserDebugModePref]
	, [s].[UserPreferencesSRHOverrideActivities]
	, [s].[UserPreferencesNewLightningReportRunPageEnabled]
	, [s].[UserPreferencesReverseOpenActivitiesView]
	, [s].[UserPreferencesShowTerritoryTimeZoneShifts]
	, [s].[UserPreferencesNativeEmailClient]
	, [s].[UserPreferencesHideBrowseProductRedirectConfirmation]
	, [s].[UserPreferencesHideOnlineSalesAppWelcomeMat]
	, [s].[ContactId]
	, [s].[AccountId]
	, [s].[CallCenterId]
	, [s].[Extension]
	, [s].[FederationIdentifier]
	, [s].[AboutMe]
	, [s].[FullPhotoUrl]
	, [s].[SmallPhotoUrl]
	, [s].[IsExtIndicatorVisible]
	, [s].[OutOfOfficeMessage]
	, [s].[MediumPhotoUrl]
	, [s].[DigestFrequency]
	, [s].[DefaultGroupNotificationFrequency]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[BannerPhotoUrl]
	, [s].[SmallBannerPhotoUrl]
	, [s].[MediumBannerPhotoUrl]
	, [s].[IsProfilePhotoActive]
	, [s].[et4ae5__Default_ET_Page__c]
	, [s].[et4ae5__Default_MID__c]
	, [s].[et4ae5__ExactTargetForAppExchangeAdmin__c]
	, [s].[et4ae5__ExactTargetForAppExchangeUser__c]
	, [s].[et4ae5__ExactTargetUsername__c]
	, [s].[et4ae5__ExactTarget_OAuth_Token__c]
	, [s].[et4ae5__ValidExactTargetAdmin__c]
	, [s].[et4ae5__ValidExactTargetUser__c]
	, [s].[Chat_Display_Name__c]
	, [s].[Chat_Photo_Small__c]
	, [s].[DialerID__c]
	, [s].[External_Id__c]
	, [s].[SightCall_UseCase_Id__c]
	, [s].[Mobile_Agent_Login__c]
	, [s].[approver__c]
	, [s].[DB_Region__c]
	, [s].[Full_Name__c]
	, [s].[User_Deactivation_Details__c]
	, [s].[BannerPhotoId]
	, [s].[EndDay]
	, [s].[WorkspaceId]
	, [s].[UserSubtype]
	, [s].[IsSystemControlled]
	, [s].[PasswordResetAttempt]
	, [s].[PasswordResetLockoutDate]
	, [s].[StartDay]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[User] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
