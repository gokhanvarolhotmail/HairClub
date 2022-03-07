/* CreateDate: 03/04/2022 08:04:46.070 , ModifyDate: 03/07/2022 12:17:32.090 */
GO
CREATE TABLE [SF].[Lead](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Company] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [decimal](25, 15) NULL,
	[Longitude] [decimal](25, 15) NULL,
	[GeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Website] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSource] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Industry] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rating] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AnnualRevenue] [decimal](18, 0) NULL,
	[NumberOfEmployees] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasOptedOutOfEmail] [bit] NULL,
	[IsConverted] [bit] NULL,
	[ConvertedDate] [date] NULL,
	[ConvertedAccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedOpportunityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsUnreadByOwner] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[DoNotCall] [bit] NULL,
	[HasOptedOutOfFax] [bit] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[LastTransferDate] [date] NULL,
	[Jigsaw] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JigsawContactId] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailBouncedReason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailBouncedDate] [datetime2](7) NULL,
	[et4ae5__HasOptedOutOfMobile__c] [bit] NULL,
	[et4ae5__Mobile_Country_Code__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age__c] [decimal](18, 0) NULL,
	[Birthdate__c] [date] NULL,
	[Cancellation_Reason__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotContact__c] [bit] NULL,
	[DoNotEmail__c] [bit] NULL,
	[DoNotMail__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[Ethnicity__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossOrVolume__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCopyPreferred__c] [bit] NULL,
	[Language__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Qualifier__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Rescheduler__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone_Number_Normalized__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Promo_Code__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referral_Code_Expiration_Date__c] [date] NULL,
	[Referral_Code__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Text_Reminer_Opt_In__c] [bit] NULL,
	[Occupation__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ammount__c] [decimal](16, 2) NULL,
	[DNCDateMobilePhone__c] [datetime2](7) NULL,
	[DNCDatePhone__c] [datetime2](7) NULL,
	[DNCValidationMobilePhone__c] [bit] NULL,
	[DNCValidationPhone__c] [bit] NULL,
	[GCLID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Goals_Expectations__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_many_times_a_week_do_you_think__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_much_time_a_week_do_you_spend__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Other_Reason__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_are_your_main_concerns_today__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_else_would_be_helpful_for_your__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_methods_have_you_used_or_currently__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefersionLogId__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Time_Zone__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DB_Created_Date_without_Time__c] [date] NULL,
	[DB_Lead_Age__c] [decimal](18, 0) NULL,
	[RecordTypeDeveloperName__c] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Area__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Owner_Division__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Center_Type__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Center_Number__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[No_Lead__c] [decimal](18, 0) NULL,
	[HCUID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GCID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MSCLKID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FBCLID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[KUID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Campaign_Source_Code__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Number__c] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Center_Number__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Client_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Country_Description__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Gender_Description__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Legacy_Source_Code__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Salesforce_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Siebel_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Next_Milestone_Event__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Next_Milestone_Event_Date__c] [date] NULL,
	[Service_Territory_Center_Owner__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Warm_Welcome_Call__c] [bit] NULL,
	[Lead_ID_18_dig__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Initial_Campaign_Source__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Landing_Page_Form_Submitted_Date__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Lead] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Lead]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Lead]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_Account_ConvertedAccountId] FOREIGN KEY([ConvertedAccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_Account_ConvertedAccountId]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_Contact_ConvertedContactId] FOREIGN KEY([ConvertedContactId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_Contact_ConvertedContactId]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_Lead_MasterRecordId] FOREIGN KEY([MasterRecordId])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_Lead_MasterRecordId]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_Opportunity_ConvertedOpportunityId] FOREIGN KEY([ConvertedOpportunityId])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_Opportunity_ConvertedOpportunityId]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_PromoCode__c_Promo_Code__c] FOREIGN KEY([Promo_Code__c])
REFERENCES [SF].[PromoCode__c] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_PromoCode__c_Promo_Code__c]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_ServiceTerritory_Service_Territory__c] FOREIGN KEY([Service_Territory__c])
REFERENCES [SF].[ServiceTerritory] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_ServiceTerritory_Service_Territory__c]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_User_CreatedById]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_User_LastModifiedById]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_User_Lead_Qualifier__c] FOREIGN KEY([Lead_Qualifier__c])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_User_Lead_Qualifier__c]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_User_Lead_Rescheduler__c] FOREIGN KEY([Lead_Rescheduler__c])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_User_Lead_Rescheduler__c]
GO
ALTER TABLE [SF].[Lead]  WITH NOCHECK ADD  CONSTRAINT [fk_Lead_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Lead] NOCHECK CONSTRAINT [fk_Lead_User_OwnerId]
GO
