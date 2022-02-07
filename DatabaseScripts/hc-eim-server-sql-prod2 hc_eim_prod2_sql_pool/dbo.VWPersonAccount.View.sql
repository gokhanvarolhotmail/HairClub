/****** Object:  View [dbo].[VWPersonAccount]    Script Date: 2/7/2022 10:45:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWPersonAccount]
AS SELECT  [AccountKey]
      ,[AccountId]
      ,[AccountFirstName]
      ,[AccountLastName]
      ,[AccountFullName]
      ,[IsActive]
      ,[CreatedDate]
      ,[CreatedById]
      ,[CreatedDateKey]
      ,[CreatedTimeKey]
      ,[CreatedUserKey]
      ,[LastModifiedDate]
      ,[LastModifiedById]
      ,[LastModifiedUserKey]
      ,[BillingStreet]
      ,[BillingCity]
      ,[BillingState]
      ,[BillingPostalCode]
      ,[BillingCountry]
      ,[BillingStateCode]
      ,[BillingCountryCode]
      ,[BillingGeographyKey]
      ,[EthnicityKey]
      ,[AccountEtnicity]
      ,[GenderKey]
      ,[AccountGender]
      ,[AccountPhone]
      ,[AccountEmail]
      ,[PersonContactId]
      ,[IsPersonAccount]
      ,[DoNotCall]
      ,[DoNotContact]
      ,[DoNotEmail]
      ,[DoNotMail]
      ,[DoNotText]
      ,[NorwoodScale]
      ,[LudwigScale]
      ,[HairLossScaleKey]
      ,[HairLossInFamily]
      ,[HairLossProductUsed]
      ,[HairLossSpot]
      ,[DiscStyle]
      ,[AccountStatusKey]
      ,[AccountStatus]
      ,[CompanyKey]
      ,[AccountCompany]
      ,[SourceKey]
      ,[AccountSource]
      ,[AccountExternalId]
      ,[MaritalStatusKey]
      ,[MaritalStatus]
      ,[SourceSystem]
      ,[DWH_LoadDate]
      ,[DWH_LastUpdateDate]
  FROM [dbo].[DimAccount];
GO
