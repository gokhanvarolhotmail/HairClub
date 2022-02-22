/* CreateDate: 02/21/2022 15:33:38.550 , ModifyDate: 02/21/2022 15:33:38.550 */
GO
CREATE TABLE [dbo].[SF_Lead](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[MasterRecordId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FirstName] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](121) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RecordTypeId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Company] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[GeocodeAccuracy] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Website] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoUrl] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSource] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Industry] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rating] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AnnualRevenue] [float] NULL,
	[NumberOfEmployees] [int] NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HasOptedOutOfEmail] [bit] NOT NULL,
	[IsConverted] [bit] NOT NULL,
	[ConvertedDate] [date] NULL,
	[ConvertedAccountId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedContactId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedOpportunityId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsUnreadByOwner] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SystemModstamp] [datetime2](7) NOT NULL,
	[LastActivityDate] [date] NULL,
	[DoNotCall] [bit] NOT NULL,
	[HasOptedOutOfFax] [bit] NOT NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[LastTransferDate] [date] NULL,
	[Jigsaw] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JigsawContactId] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailBouncedReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailBouncedDate] [datetime2](7) NULL,
	[et4ae5__HasOptedOutOfMobile__c] [bit] NULL,
	[et4ae5__Mobile_Country_Code__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age__c] [float] NULL,
	[Birthdate__c] [date] NULL,
	[Cancellation_Reason__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotContact__c] [bit] NULL,
	[DoNotEmail__c] [bit] NULL,
	[DoNotMail__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[Ethnicity__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossOrVolume__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCopyPreferred__c] [bit] NULL,
	[Language__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Qualifier__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Rescheduler__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone_Number_Normalized__c] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Promo_Code__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referral_Code_Expiration_Date__c] [date] NULL,
	[Referral_Code__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Text_Reminer_Opt_In__c] [bit] NULL,
	[Occupation__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ammount__c] [float] NULL,
	[DNCDateMobilePhone__c] [datetime2](7) NULL,
	[DNCDatePhone__c] [datetime2](7) NULL,
	[DNCValidationMobilePhone__c] [bit] NULL,
	[DNCValidationPhone__c] [bit] NULL,
	[GCLID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Goals_Expectations__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_many_times_a_week_do_you_think__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_much_time_a_week_do_you_spend__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Other_Reason__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_are_your_main_concerns_today__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_else_would_be_helpful_for_your__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_methods_have_you_used_or_currently__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefersionLogId__c] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Time_Zone__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DB_Created_Date_without_Time__c] [date] NULL,
	[DB_Lead_Age__c] [float] NULL,
	[RecordTypeDeveloperName__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Area__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Owner_Division__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Center_Type__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Center_Number__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[No_Lead__c] [float] NULL,
	[HCUID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GCID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MSCLKID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FBCLID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[KUID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Campaign_Source_Code__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Number__c] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Center_Number__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Client_Id__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Country_Description__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Gender_Description__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Legacy_Source_Code__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Salesforce_Id__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Siebel_Id__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Next_Milestone_Event__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Next_Milestone_Event_Date__c] [date] NULL,
	[Service_Territory_Center_Owner__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Warm_Welcome_Call__c] [bit] NULL,
	[Lead_ID_18_dig__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
