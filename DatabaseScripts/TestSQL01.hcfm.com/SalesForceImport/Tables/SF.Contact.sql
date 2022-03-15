/* CreateDate: 03/04/2022 08:13:40.290 , ModifyDate: 03/04/2022 08:13:40.333 */
GO
CREATE TABLE [SF].[Contact](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPersonAccount] [bit] NULL,
	[LastName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingLatitude] [decimal](25, 15) NULL,
	[MailingLongitude] [decimal](25, 15) NULL,
	[MailingGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherPhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssistantPhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportsToId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[LastCURequestDate] [datetime2](7) NULL,
	[LastCUUpdateDate] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[EmailBouncedReason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailBouncedDate] [datetime2](7) NULL,
	[IsEmailBounced] [bit] NULL,
	[PhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Jigsaw] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JigsawContactId] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age__c] [decimal](18, 0) NULL,
	[Birthdate__c] [date] NULL,
	[DoNotContact__c] [bit] NULL,
	[DoNotEmail__c] [bit] NULL,
	[DoNotMail__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[Ethnicity__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossOrVolume__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCopyPreferred__c] [bit] NULL,
	[Language__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Text_Reminder_Opt_In__c] [bit] NULL,
	[rh2__Currency_Test__c] [decimal](18, 0) NULL,
	[rh2__Describe__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rh2__Formula_Test__c] [decimal](18, 0) NULL,
	[rh2__Integer_Test__c] [decimal](3, 0) NULL,
	[Next_Milestone_Event__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Next_Milestone_Event_Date__c] [date] NULL,
	[Bosley_Center_Number__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Client_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Legacy_Source_Code__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Salesforce_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Siebel_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Contact_ID_18_dig__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Landing_Page_Form_Submitted_Date__c] [datetime2](7) NULL,
 CONSTRAINT [pk_Contact] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Contact]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Contact]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
