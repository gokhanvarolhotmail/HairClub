/****** Object:  View [ODS].[vSF_Lead_Filtered]    Script Date: 3/2/2022 1:09:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ODS].[vSF_Lead_Filtered] AS SELECT
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
  , [s].[Disc__c]
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
  , [s].[LudwigScale__c]
  , [s].[MaritalStatus__c]
  , [s].[NorwoodScale__c]
  , [s].[Referral_Code_Expiration_Date__c]
  , [s].[Referral_Code__c]
  , [s].[Service_Territory__c]
  , [s].[SolutionOffered__c]
  , [s].[Text_Reminer_Opt_In__c]
  , [s].[Age__c]
  , [s].[Birthdate__c]
  , [s].[Lead_Qualifier__c]
  , [s].[Lead_Rescheduler__c]
  , [s].[Promo_Code__c]
  , [s].[GCLID__c]
  , [s].[Occupation__c]
FROM [ODS].[SF_Lead] AS [s]
WHERE [s].[LastModifiedDate] <= DATEADD(DAY, 1, GETDATE()) AND [s].[LastModifiedDate] > DATEADD(DAY, -4, CAST(GETDATE() AS DATE));
GO
