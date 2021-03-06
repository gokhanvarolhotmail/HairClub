/****** Object:  Table [ODS].[SF_Account]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_Account]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](8000) NULL,
	[Name] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[FirstName] [varchar](8000) NULL,
	[Salutation] [varchar](8000) NULL,
	[MiddleName] [varchar](8000) NULL,
	[Suffix] [varchar](8000) NULL,
	[Type] [varchar](8000) NULL,
	[RecordTypeId] [varchar](8000) NULL,
	[ParentId] [varchar](8000) NULL,
	[BillingStreet] [varchar](8000) NULL,
	[BillingCity] [varchar](8000) NULL,
	[BillingState] [varchar](8000) NULL,
	[BillingPostalCode] [varchar](8000) NULL,
	[BillingCountry] [varchar](8000) NULL,
	[BillingStateCode] [varchar](8000) NULL,
	[BillingCountryCode] [varchar](8000) NULL,
	[BillingLatitude] [numeric](38, 18) NULL,
	[BillingLongitude] [numeric](38, 18) NULL,
	[BillingGeocodeAccuracy] [varchar](8000) NULL,
	[ShippingStreet] [varchar](8000) NULL,
	[ShippingCity] [varchar](8000) NULL,
	[ShippingState] [varchar](8000) NULL,
	[ShippingPostalCode] [varchar](8000) NULL,
	[ShippingCountry] [varchar](8000) NULL,
	[ShippingStateCode] [varchar](8000) NULL,
	[ShippingCountryCode] [varchar](8000) NULL,
	[ShippingLatitude] [numeric](38, 18) NULL,
	[ShippingLongitude] [numeric](38, 18) NULL,
	[ShippingGeocodeAccuracy] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[Website] [varchar](8000) NULL,
	[PhotoUrl] [varchar](8000) NULL,
	[Industry] [varchar](8000) NULL,
	[NumberOfEmployees] [int] NULL,
	[Description] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[PersonContactId] [varchar](8000) NULL,
	[IsPersonAccount] [bit] NULL,
	[PersonMailingStreet] [varchar](8000) NULL,
	[PersonMailingCity] [varchar](8000) NULL,
	[PersonMailingState] [varchar](8000) NULL,
	[PersonMailingPostalCode] [varchar](8000) NULL,
	[PersonMailingCountry] [varchar](8000) NULL,
	[PersonMailingStateCode] [varchar](8000) NULL,
	[PersonMailingCountryCode] [varchar](8000) NULL,
	[PersonMailingLatitude] [numeric](38, 18) NULL,
	[PersonMailingLongitude] [numeric](38, 18) NULL,
	[PersonMailingGeocodeAccuracy] [varchar](8000) NULL,
	[PersonMobilePhone] [varchar](8000) NULL,
	[PersonEmail] [varchar](8000) NULL,
	[PersonTitle] [varchar](8000) NULL,
	[PersonDepartment] [varchar](8000) NULL,
	[PersonLastCURequestDate] [datetime2](7) NULL,
	[PersonLastCUUpdateDate] [datetime2](7) NULL,
	[PersonEmailBouncedReason] [varchar](8000) NULL,
	[PersonEmailBouncedDate] [datetime2](7) NULL,
	[Jigsaw] [varchar](8000) NULL,
	[JigsawCompanyId] [varchar](8000) NULL,
	[AccountSource] [varchar](8000) NULL,
	[SicDesc] [varchar](8000) NULL,
	[OperatingHoursId] [varchar](8000) NULL,
	[Active__c] [bit] NULL,
	[Company__c] [varchar](8000) NULL,
	[ConectCreationDate__c] [datetime2](7) NULL,
	[ConectLastUpdate__c] [datetime2](7) NULL,
	[External_Id__c] [varchar](8000) NULL,
	[Count_Close_Won_Opportunities__c] [numeric](38, 18) NULL,
	[Customer_Status__c] [varchar](8000) NULL,
	[Disc__pc] [varchar](8000) NULL,
	[DoNotContact__pc] [bit] NULL,
	[DoNotEmail__pc] [bit] NULL,
	[DoNotMail__pc] [bit] NULL,
	[DoNotText__pc] [bit] NULL,
	[Ethnicity__pc] [varchar](8000) NULL,
	[Gender__pc] [varchar](8000) NULL,
	[HairLossExperience__pc] [varchar](8000) NULL,
	[HairLossFamily__pc] [varchar](8000) NULL,
	[HairLossOrVolume__pc] [varchar](8000) NULL,
	[HairLossProductOther__pc] [varchar](8000) NULL,
	[HairLossProductUsed__pc] [varchar](8000) NULL,
	[HairLossSpot__pc] [varchar](8000) NULL,
	[HardCopyPreferred__pc] [bit] NULL,
	[Language__pc] [varchar](8000) NULL,
	[MaritalStatus__pc] [varchar](8000) NULL,
	[Text_Reminder_Opt_In__pc] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
