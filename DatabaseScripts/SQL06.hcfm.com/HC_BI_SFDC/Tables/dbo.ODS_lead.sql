/* CreateDate: 03/21/2022 13:00:03.707 , ModifyDate: 03/21/2022 13:00:06.627 */
GO
CREATE TABLE [dbo].[ODS_lead](
	[Street] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Id] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Company] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [numeric](38, 18) NULL,
	[Longitude] [numeric](38, 18) NULL,
	[GeocodeAccuracy] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Website] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoUrl] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSource] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Industry] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rating] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AnnualRevenue] [numeric](38, 18) NULL,
	[NumberOfEmployees] [int] NULL,
	[OwnerId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasOptedOutOfEmail] [bit] NULL,
	[IsConverted] [bit] NULL,
	[ConvertedDate] [datetime2](7) NULL,
	[ConvertedAccountId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedContactId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedOpportunityId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsUnreadByOwner] [bit] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[DoNotCall] [bit] NULL,
	[HasOptedOutOfFax] [bit] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[LastTransferDate] [datetime2](7) NULL,
	[Jigsaw] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JigsawContactId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailBouncedReason] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailBouncedDate] [datetime2](7) NULL,
	[et4ae5__HasOptedOutOfMobile__c] [bit] NULL,
	[et4ae5__Mobile_Country_Code__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Disc__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotContact__c] [bit] NULL,
	[DoNotEmail__c] [bit] NULL,
	[DoNotMail__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[Ethnicity__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossOrVolume__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCopyPreferred__c] [bit] NULL,
	[Language__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referral_Code_Expiration_Date__c] [datetime2](7) NULL,
	[Referral_Code__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Text_Reminer_Opt_In__c] [bit] NULL,
	[Age__c] [numeric](38, 18) NULL,
	[Birthdate__c] [datetime2](7) NULL,
	[Lead_Qualifier__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Rescheduler__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Promo_Code__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GCLID__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation__c] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
