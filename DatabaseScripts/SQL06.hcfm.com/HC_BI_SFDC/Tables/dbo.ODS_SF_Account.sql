/* CreateDate: 10/04/2021 17:01:09.087 , ModifyDate: 10/04/2021 17:01:09.087 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ODS_SF_Account](
	[CreatedDate] [datetime] NULL,
	[Id] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[Phone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingStreet] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCity] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingState] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingPostalCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCountry] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingStateCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCountryCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingLatitude] [numeric](38, 18) NULL,
	[BillingLongitude] [numeric](38, 18) NULL,
	[BillingGeocodeAccuracy] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingStreet] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCity] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingState] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingPostalCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCountry] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingStateCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCountryCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingLatitude] [numeric](38, 18) NULL,
	[ShippingLongitude] [numeric](38, 18) NULL,
	[ShippingGeocodeAccuracy] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Website] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Industry] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfEmployees] [int] NULL,
	[Description] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[PersonContactId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPersonAccount] [bit] NULL,
	[PersonMailingStreet] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingCity] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingState] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingPostalCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingCountry] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingStateCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingCountryCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingLatitude] [numeric](38, 18) NULL,
	[PersonMailingLongitude] [numeric](38, 18) NULL,
	[PersonMailingGeocodeAccuracy] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMobilePhone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonEmail] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonTitle] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonDepartment] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonLastCURequestDate] [datetime2](7) NULL,
	[PersonLastCUUpdateDate] [datetime2](7) NULL,
	[PersonEmailBouncedReason] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonEmailBouncedDate] [datetime2](7) NULL,
	[Jigsaw] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JigsawCompanyId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountSource] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SicDesc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OperatingHoursId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active__c] [bit] NULL,
	[Company__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConectCreationDate__c] [datetime2](7) NULL,
	[ConectLastUpdate__c] [datetime2](7) NULL,
	[Count_Close_Won_Opportunities__c] [numeric](38, 18) NULL,
	[Customer_Status__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Disc__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotContact__pc] [bit] NULL,
	[DoNotEmail__pc] [bit] NULL,
	[DoNotMail__pc] [bit] NULL,
	[DoNotText__pc] [bit] NULL,
	[Ethnicity__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossOrVolume__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCopyPreferred__pc] [bit] NULL,
	[Language__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__pc] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Text_Reminder_Opt_In__pc] [bit] NULL
) ON [PRIMARY]
GO
