/* CreateDate: 03/04/2022 08:19:54.130 , ModifyDate: 03/04/2022 08:19:54.130 */
GO
CREATE PROCEDURE [SF].[sp_Lead_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[Lead])
RETURN ;

SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE [SF].[Lead] AS [t]
USING [SFStaging].[Lead] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[MasterRecordId] = [t].[MasterRecordId]
	, [t].[LastName] = [t].[LastName]
	, [t].[FirstName] = [t].[FirstName]
	, [t].[Salutation] = [t].[Salutation]
	, [t].[MiddleName] = [t].[MiddleName]
	, [t].[Suffix] = [t].[Suffix]
	, [t].[Name] = [t].[Name]
	, [t].[RecordTypeId] = [t].[RecordTypeId]
	, [t].[Title] = [t].[Title]
	, [t].[Company] = [t].[Company]
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
	, [t].[Phone] = [t].[Phone]
	, [t].[MobilePhone] = [t].[MobilePhone]
	, [t].[Fax] = [t].[Fax]
	, [t].[Email] = [t].[Email]
	, [t].[Website] = [t].[Website]
	, [t].[PhotoUrl] = [t].[PhotoUrl]
	, [t].[Description] = [t].[Description]
	, [t].[LeadSource] = [t].[LeadSource]
	, [t].[Status] = [t].[Status]
	, [t].[Industry] = [t].[Industry]
	, [t].[Rating] = [t].[Rating]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[AnnualRevenue] = [t].[AnnualRevenue]
	, [t].[NumberOfEmployees] = [t].[NumberOfEmployees]
	, [t].[OwnerId] = [t].[OwnerId]
	, [t].[HasOptedOutOfEmail] = [t].[HasOptedOutOfEmail]
	, [t].[IsConverted] = [t].[IsConverted]
	, [t].[ConvertedDate] = [t].[ConvertedDate]
	, [t].[ConvertedAccountId] = [t].[ConvertedAccountId]
	, [t].[ConvertedContactId] = [t].[ConvertedContactId]
	, [t].[ConvertedOpportunityId] = [t].[ConvertedOpportunityId]
	, [t].[IsUnreadByOwner] = [t].[IsUnreadByOwner]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastActivityDate] = [t].[LastActivityDate]
	, [t].[DoNotCall] = [t].[DoNotCall]
	, [t].[HasOptedOutOfFax] = [t].[HasOptedOutOfFax]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[LastTransferDate] = [t].[LastTransferDate]
	, [t].[Jigsaw] = [t].[Jigsaw]
	, [t].[JigsawContactId] = [t].[JigsawContactId]
	, [t].[EmailBouncedReason] = [t].[EmailBouncedReason]
	, [t].[EmailBouncedDate] = [t].[EmailBouncedDate]
	, [t].[et4ae5__HasOptedOutOfMobile__c] = [t].[et4ae5__HasOptedOutOfMobile__c]
	, [t].[et4ae5__Mobile_Country_Code__c] = [t].[et4ae5__Mobile_Country_Code__c]
	, [t].[Age__c] = [t].[Age__c]
	, [t].[Birthdate__c] = [t].[Birthdate__c]
	, [t].[Cancellation_Reason__c] = [t].[Cancellation_Reason__c]
	, [t].[DoNotContact__c] = [t].[DoNotContact__c]
	, [t].[DoNotEmail__c] = [t].[DoNotEmail__c]
	, [t].[DoNotMail__c] = [t].[DoNotMail__c]
	, [t].[DoNotText__c] = [t].[DoNotText__c]
	, [t].[Ethnicity__c] = [t].[Ethnicity__c]
	, [t].[External_Id__c] = [t].[External_Id__c]
	, [t].[Gender__c] = [t].[Gender__c]
	, [t].[HairLossExperience__c] = [t].[HairLossExperience__c]
	, [t].[HairLossFamily__c] = [t].[HairLossFamily__c]
	, [t].[HairLossOrVolume__c] = [t].[HairLossOrVolume__c]
	, [t].[HairLossProductOther__c] = [t].[HairLossProductOther__c]
	, [t].[HairLossProductUsed__c] = [t].[HairLossProductUsed__c]
	, [t].[HairLossSpot__c] = [t].[HairLossSpot__c]
	, [t].[HardCopyPreferred__c] = [t].[HardCopyPreferred__c]
	, [t].[Language__c] = [t].[Language__c]
	, [t].[Lead_Qualifier__c] = [t].[Lead_Qualifier__c]
	, [t].[Lead_Rescheduler__c] = [t].[Lead_Rescheduler__c]
	, [t].[LudwigScale__c] = [t].[LudwigScale__c]
	, [t].[MaritalStatus__c] = [t].[MaritalStatus__c]
	, [t].[MobilePhone_Number_Normalized__c] = [t].[MobilePhone_Number_Normalized__c]
	, [t].[NorwoodScale__c] = [t].[NorwoodScale__c]
	, [t].[Promo_Code__c] = [t].[Promo_Code__c]
	, [t].[Referral_Code_Expiration_Date__c] = [t].[Referral_Code_Expiration_Date__c]
	, [t].[Referral_Code__c] = [t].[Referral_Code__c]
	, [t].[Service_Territory__c] = [t].[Service_Territory__c]
	, [t].[SolutionOffered__c] = [t].[SolutionOffered__c]
	, [t].[Text_Reminer_Opt_In__c] = [t].[Text_Reminer_Opt_In__c]
	, [t].[Occupation__c] = [t].[Occupation__c]
	, [t].[Ammount__c] = [t].[Ammount__c]
	, [t].[DNCDateMobilePhone__c] = [t].[DNCDateMobilePhone__c]
	, [t].[DNCDatePhone__c] = [t].[DNCDatePhone__c]
	, [t].[DNCValidationMobilePhone__c] = [t].[DNCValidationMobilePhone__c]
	, [t].[DNCValidationPhone__c] = [t].[DNCValidationPhone__c]
	, [t].[GCLID__c] = [t].[GCLID__c]
	, [t].[Goals_Expectations__c] = [t].[Goals_Expectations__c]
	, [t].[How_many_times_a_week_do_you_think__c] = [t].[How_many_times_a_week_do_you_think__c]
	, [t].[How_much_time_a_week_do_you_spend__c] = [t].[How_much_time_a_week_do_you_spend__c]
	, [t].[Other_Reason__c] = [t].[Other_Reason__c]
	, [t].[What_are_your_main_concerns_today__c] = [t].[What_are_your_main_concerns_today__c]
	, [t].[What_else_would_be_helpful_for_your__c] = [t].[What_else_would_be_helpful_for_your__c]
	, [t].[What_methods_have_you_used_or_currently__c] = [t].[What_methods_have_you_used_or_currently__c]
	, [t].[RefersionLogId__c] = [t].[RefersionLogId__c]
	, [t].[Service_Territory_Time_Zone__c] = [t].[Service_Territory_Time_Zone__c]
	, [t].[DB_Created_Date_without_Time__c] = [t].[DB_Created_Date_without_Time__c]
	, [t].[DB_Lead_Age__c] = [t].[DB_Lead_Age__c]
	, [t].[RecordTypeDeveloperName__c] = [t].[RecordTypeDeveloperName__c]
	, [t].[Service_Territory_Area__c] = [t].[Service_Territory_Area__c]
	, [t].[Lead_Owner_Division__c] = [t].[Lead_Owner_Division__c]
	, [t].[Service_Territory_Center_Type__c] = [t].[Service_Territory_Center_Type__c]
	, [t].[Service_Territory_Center_Number__c] = [t].[Service_Territory_Center_Number__c]
	, [t].[No_Lead__c] = [t].[No_Lead__c]
	, [t].[HCUID__c] = [t].[HCUID__c]
	, [t].[GCID__c] = [t].[GCID__c]
	, [t].[MSCLKID__c] = [t].[MSCLKID__c]
	, [t].[FBCLID__c] = [t].[FBCLID__c]
	, [t].[KUID__c] = [t].[KUID__c]
	, [t].[Campaign_Source_Code__c] = [t].[Campaign_Source_Code__c]
	, [t].[Service_Territory_Number__c] = [t].[Service_Territory_Number__c]
	, [t].[Bosley_Center_Number__c] = [t].[Bosley_Center_Number__c]
	, [t].[Bosley_Client_Id__c] = [t].[Bosley_Client_Id__c]
	, [t].[Bosley_Country_Description__c] = [t].[Bosley_Country_Description__c]
	, [t].[Bosley_Gender_Description__c] = [t].[Bosley_Gender_Description__c]
	, [t].[Bosley_Legacy_Source_Code__c] = [t].[Bosley_Legacy_Source_Code__c]
	, [t].[Bosley_Salesforce_Id__c] = [t].[Bosley_Salesforce_Id__c]
	, [t].[Bosley_Siebel_Id__c] = [t].[Bosley_Siebel_Id__c]
	, [t].[Next_Milestone_Event__c] = [t].[Next_Milestone_Event__c]
	, [t].[Next_Milestone_Event_Date__c] = [t].[Next_Milestone_Event_Date__c]
	, [t].[Service_Territory_Center_Owner__c] = [t].[Service_Territory_Center_Owner__c]
	, [t].[Warm_Welcome_Call__c] = [t].[Warm_Welcome_Call__c]
	, [t].[Lead_ID_18_dig__c] = [t].[Lead_ID_18_dig__c]
	, [t].[Initial_Campaign_Source__c] = [t].[Initial_Campaign_Source__c]
	, [t].[Landing_Page_Form_Submitted_Date__c] = [t].[Landing_Page_Form_Submitted_Date__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [MasterRecordId]
	, [LastName]
	, [FirstName]
	, [Salutation]
	, [MiddleName]
	, [Suffix]
	, [Name]
	, [RecordTypeId]
	, [Title]
	, [Company]
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
	, [Phone]
	, [MobilePhone]
	, [Fax]
	, [Email]
	, [Website]
	, [PhotoUrl]
	, [Description]
	, [LeadSource]
	, [Status]
	, [Industry]
	, [Rating]
	, [CurrencyIsoCode]
	, [AnnualRevenue]
	, [NumberOfEmployees]
	, [OwnerId]
	, [HasOptedOutOfEmail]
	, [IsConverted]
	, [ConvertedDate]
	, [ConvertedAccountId]
	, [ConvertedContactId]
	, [ConvertedOpportunityId]
	, [IsUnreadByOwner]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastActivityDate]
	, [DoNotCall]
	, [HasOptedOutOfFax]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [LastTransferDate]
	, [Jigsaw]
	, [JigsawContactId]
	, [EmailBouncedReason]
	, [EmailBouncedDate]
	, [et4ae5__HasOptedOutOfMobile__c]
	, [et4ae5__Mobile_Country_Code__c]
	, [Age__c]
	, [Birthdate__c]
	, [Cancellation_Reason__c]
	, [DoNotContact__c]
	, [DoNotEmail__c]
	, [DoNotMail__c]
	, [DoNotText__c]
	, [Ethnicity__c]
	, [External_Id__c]
	, [Gender__c]
	, [HairLossExperience__c]
	, [HairLossFamily__c]
	, [HairLossOrVolume__c]
	, [HairLossProductOther__c]
	, [HairLossProductUsed__c]
	, [HairLossSpot__c]
	, [HardCopyPreferred__c]
	, [Language__c]
	, [Lead_Qualifier__c]
	, [Lead_Rescheduler__c]
	, [LudwigScale__c]
	, [MaritalStatus__c]
	, [MobilePhone_Number_Normalized__c]
	, [NorwoodScale__c]
	, [Promo_Code__c]
	, [Referral_Code_Expiration_Date__c]
	, [Referral_Code__c]
	, [Service_Territory__c]
	, [SolutionOffered__c]
	, [Text_Reminer_Opt_In__c]
	, [Occupation__c]
	, [Ammount__c]
	, [DNCDateMobilePhone__c]
	, [DNCDatePhone__c]
	, [DNCValidationMobilePhone__c]
	, [DNCValidationPhone__c]
	, [GCLID__c]
	, [Goals_Expectations__c]
	, [How_many_times_a_week_do_you_think__c]
	, [How_much_time_a_week_do_you_spend__c]
	, [Other_Reason__c]
	, [What_are_your_main_concerns_today__c]
	, [What_else_would_be_helpful_for_your__c]
	, [What_methods_have_you_used_or_currently__c]
	, [RefersionLogId__c]
	, [Service_Territory_Time_Zone__c]
	, [DB_Created_Date_without_Time__c]
	, [DB_Lead_Age__c]
	, [RecordTypeDeveloperName__c]
	, [Service_Territory_Area__c]
	, [Lead_Owner_Division__c]
	, [Service_Territory_Center_Type__c]
	, [Service_Territory_Center_Number__c]
	, [No_Lead__c]
	, [HCUID__c]
	, [GCID__c]
	, [MSCLKID__c]
	, [FBCLID__c]
	, [KUID__c]
	, [Campaign_Source_Code__c]
	, [Service_Territory_Number__c]
	, [Bosley_Center_Number__c]
	, [Bosley_Client_Id__c]
	, [Bosley_Country_Description__c]
	, [Bosley_Gender_Description__c]
	, [Bosley_Legacy_Source_Code__c]
	, [Bosley_Salesforce_Id__c]
	, [Bosley_Siebel_Id__c]
	, [Next_Milestone_Event__c]
	, [Next_Milestone_Event_Date__c]
	, [Service_Territory_Center_Owner__c]
	, [Warm_Welcome_Call__c]
	, [Lead_ID_18_dig__c]
	, [Initial_Campaign_Source__c]
	, [Landing_Page_Form_Submitted_Date__c]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[MasterRecordId]
	, [s].[LastName]
	, [s].[FirstName]
	, [s].[Salutation]
	, [s].[MiddleName]
	, [s].[Suffix]
	, [s].[Name]
	, [s].[RecordTypeId]
	, [s].[Title]
	, [s].[Company]
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
	, [s].[Phone]
	, [s].[MobilePhone]
	, [s].[Fax]
	, [s].[Email]
	, [s].[Website]
	, [s].[PhotoUrl]
	, [s].[Description]
	, [s].[LeadSource]
	, [s].[Status]
	, [s].[Industry]
	, [s].[Rating]
	, [s].[CurrencyIsoCode]
	, [s].[AnnualRevenue]
	, [s].[NumberOfEmployees]
	, [s].[OwnerId]
	, [s].[HasOptedOutOfEmail]
	, [s].[IsConverted]
	, [s].[ConvertedDate]
	, [s].[ConvertedAccountId]
	, [s].[ConvertedContactId]
	, [s].[ConvertedOpportunityId]
	, [s].[IsUnreadByOwner]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastActivityDate]
	, [s].[DoNotCall]
	, [s].[HasOptedOutOfFax]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[LastTransferDate]
	, [s].[Jigsaw]
	, [s].[JigsawContactId]
	, [s].[EmailBouncedReason]
	, [s].[EmailBouncedDate]
	, [s].[et4ae5__HasOptedOutOfMobile__c]
	, [s].[et4ae5__Mobile_Country_Code__c]
	, [s].[Age__c]
	, [s].[Birthdate__c]
	, [s].[Cancellation_Reason__c]
	, [s].[DoNotContact__c]
	, [s].[DoNotEmail__c]
	, [s].[DoNotMail__c]
	, [s].[DoNotText__c]
	, [s].[Ethnicity__c]
	, [s].[External_Id__c]
	, [s].[Gender__c]
	, [s].[HairLossExperience__c]
	, [s].[HairLossFamily__c]
	, [s].[HairLossOrVolume__c]
	, [s].[HairLossProductOther__c]
	, [s].[HairLossProductUsed__c]
	, [s].[HairLossSpot__c]
	, [s].[HardCopyPreferred__c]
	, [s].[Language__c]
	, [s].[Lead_Qualifier__c]
	, [s].[Lead_Rescheduler__c]
	, [s].[LudwigScale__c]
	, [s].[MaritalStatus__c]
	, [s].[MobilePhone_Number_Normalized__c]
	, [s].[NorwoodScale__c]
	, [s].[Promo_Code__c]
	, [s].[Referral_Code_Expiration_Date__c]
	, [s].[Referral_Code__c]
	, [s].[Service_Territory__c]
	, [s].[SolutionOffered__c]
	, [s].[Text_Reminer_Opt_In__c]
	, [s].[Occupation__c]
	, [s].[Ammount__c]
	, [s].[DNCDateMobilePhone__c]
	, [s].[DNCDatePhone__c]
	, [s].[DNCValidationMobilePhone__c]
	, [s].[DNCValidationPhone__c]
	, [s].[GCLID__c]
	, [s].[Goals_Expectations__c]
	, [s].[How_many_times_a_week_do_you_think__c]
	, [s].[How_much_time_a_week_do_you_spend__c]
	, [s].[Other_Reason__c]
	, [s].[What_are_your_main_concerns_today__c]
	, [s].[What_else_would_be_helpful_for_your__c]
	, [s].[What_methods_have_you_used_or_currently__c]
	, [s].[RefersionLogId__c]
	, [s].[Service_Territory_Time_Zone__c]
	, [s].[DB_Created_Date_without_Time__c]
	, [s].[DB_Lead_Age__c]
	, [s].[RecordTypeDeveloperName__c]
	, [s].[Service_Territory_Area__c]
	, [s].[Lead_Owner_Division__c]
	, [s].[Service_Territory_Center_Type__c]
	, [s].[Service_Territory_Center_Number__c]
	, [s].[No_Lead__c]
	, [s].[HCUID__c]
	, [s].[GCID__c]
	, [s].[MSCLKID__c]
	, [s].[FBCLID__c]
	, [s].[KUID__c]
	, [s].[Campaign_Source_Code__c]
	, [s].[Service_Territory_Number__c]
	, [s].[Bosley_Center_Number__c]
	, [s].[Bosley_Client_Id__c]
	, [s].[Bosley_Country_Description__c]
	, [s].[Bosley_Gender_Description__c]
	, [s].[Bosley_Legacy_Source_Code__c]
	, [s].[Bosley_Salesforce_Id__c]
	, [s].[Bosley_Siebel_Id__c]
	, [s].[Next_Milestone_Event__c]
	, [s].[Next_Milestone_Event_Date__c]
	, [s].[Service_Territory_Center_Owner__c]
	, [s].[Warm_Welcome_Call__c]
	, [s].[Lead_ID_18_dig__c]
	, [s].[Initial_Campaign_Source__c]
	, [s].[Landing_Page_Form_Submitted_Date__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[Lead] ;

COMMIT ;
GO
