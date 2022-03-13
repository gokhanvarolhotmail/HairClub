/****** Object:  View [dbo].[VWODSLead]    Script Date: 3/12/2022 7:09:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWODSLead]
AS select Id,
       IsDeleted,
       MasterRecordId,
       LastName,
       FirstName,
       Salutation,
       MiddleName,
       Suffix,
       Name,
       RecordTypeId,
       Title,
       Company,
       Street,
       City,
       State,
       PostalCode,
       Country,
       StateCode,
       CountryCode,
       Latitude,
       Longitude,
       GeocodeAccuracy,
       Phone,
       MobilePhone,
       Fax,
       Email,
       Website,
       PhotoUrl,
       Description,
       LeadSource,
       Status,
       Industry,
       Rating,
       CurrencyIsoCode,
       AnnualRevenue,
       NumberOfEmployees,
       OwnerId,
       HasOptedOutOfEmail,
       IsConverted,
       ConvertedDate,
       ConvertedAccountId,
       ConvertedContactId,
       ConvertedOpportunityId,
       IsUnreadByOwner,
       CreatedDate,
       CreatedById,
       LastModifiedDate,
       LastModifiedById,
       SystemModstamp,
       LastActivityDate,
       DoNotCall,
       HasOptedOutOfFax,
       LastViewedDate,
       LastReferencedDate,
       LastTransferDate,
       Jigsaw,
       JigsawContactId,
       EmailBouncedReason,
       EmailBouncedDate,
       et4ae5__HasOptedOutOfMobile__c,
       et4ae5__Mobile_Country_Code__c,
       Disc__c,
       DoNotContact__c,
       DoNotEmail__c,
       DoNotMail__c,
       DoNotText__c,
       Ethnicity__c,
       External_Id__c,
       Gender__c,
       HairLossExperience__c,
       HairLossFamily__c,
       HairLossOrVolume__c,
       HairLossProductOther__c,
       HairLossProductUsed__c,
       HairLossSpot__c,
       HardCopyPreferred__c,
       Language__c,
       LudwigScale__c,
       MaritalStatus__c,
       NorwoodScale__c,
       Referral_Code_Expiration_Date__c,
       Referral_Code__c,
       Service_Territory__c,
       SolutionOffered__c,
       Text_Reminer_Opt_In__c,
       Age__c,
       Birthdate__c,
       Lead_Qualifier__c,
       Lead_Rescheduler__c,
       Promo_Code__c,
       GCLID__c,
       dateadd(mi, datepart(tz, CONVERT(datetime, CreatedDate) AT TIME ZONE 'Eastern Standard Time'),
                            CreatedDate) as CreateDateEST
       from ODS.SF_Lead;
GO
