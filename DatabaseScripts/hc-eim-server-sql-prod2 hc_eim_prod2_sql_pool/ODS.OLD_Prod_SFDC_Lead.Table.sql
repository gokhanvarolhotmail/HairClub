/****** Object:  Table [ODS].[OLD_Prod_SFDC_Lead]    Script Date: 3/4/2022 8:28:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[OLD_Prod_SFDC_Lead]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](8000) NULL,
	[LastName] [nvarchar](4000) NULL,
	[FirstName] [nvarchar](4000) NULL,
	[Salutation] [varchar](8000) NULL,
	[MiddleName] [varchar](8000) NULL,
	[Suffix] [varchar](8000) NULL,
	[Name] [nvarchar](4000) NULL,
	[Title] [varchar](8000) NULL,
	[Company] [varchar](8000) NULL,
	[Street] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[State] [varchar](8000) NULL,
	[PostalCode] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[StateCode] [varchar](8000) NULL,
	[CountryCode] [varchar](8000) NULL,
	[Latitude] [numeric](38, 18) NULL,
	[Longitude] [numeric](38, 18) NULL,
	[GeocodeAccuracy] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[MobilePhone] [varchar](8000) NULL,
	[Fax] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[Website] [varchar](8000) NULL,
	[PhotoUrl] [varchar](8000) NULL,
	[Description] [varchar](8000) NULL,
	[LeadSource] [varchar](8000) NULL,
	[Status] [varchar](8000) NULL,
	[Industry] [varchar](8000) NULL,
	[Rating] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[AnnualRevenue] [numeric](38, 18) NULL,
	[NumberOfEmployees] [int] NULL,
	[OwnerId] [varchar](8000) NULL,
	[HasOptedOutOfEmail] [bit] NULL,
	[IsConverted] [bit] NULL,
	[ConvertedDate] [datetime2](7) NULL,
	[ConvertedAccountId] [varchar](8000) NULL,
	[ConvertedContactId] [varchar](8000) NULL,
	[ConvertedOpportunityId] [varchar](8000) NULL,
	[IsUnreadByOwner] [bit] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[DoNotCall] [bit] NULL,
	[HasOptedOutOfFax] [bit] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[LastTransferDate] [datetime2](7) NULL,
	[Jigsaw] [varchar](8000) NULL,
	[JigsawContactId] [varchar](8000) NULL,
	[EmailBouncedReason] [varchar](8000) NULL,
	[EmailBouncedDate] [datetime2](7) NULL,
	[IndividualId] [varchar](8000) NULL,
	[Gender__c] [varchar](8000) NULL,
	[Language__c] [varchar](8000) NULL,
	[Center__c] [varchar](8000) NULL,
	[OriginalCampaign__c] [varchar](8000) NULL,
	[PromoCode__c] [varchar](8000) NULL,
	[DoNotEmail__c] [bit] NULL,
	[DoNotMail__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[HairLossSpot__c] [varchar](8000) NULL,
	[HairLossExperience__c] [varchar](8000) NULL,
	[HairLossFamily__c] [varchar](8000) NULL,
	[HairLossProductUsed__c] [varchar](8000) NULL,
	[DoNotContact__c] [bit] NULL,
	[OpenTasks__c] [numeric](38, 18) NULL,
	[OnCSessionID__c] [varchar](8000) NULL,
	[OnCAffiliateID__c] [varchar](8000) NULL,
	[AgeRange__c] [varchar](8000) NULL,
	[Age__c] [numeric](38, 18) NULL,
	[Birthday__c] [datetime2](7) NULL,
	[DateofLastAppoint__c] [datetime2](7) NULL,
	[ContactID__c] [varchar](8000) NULL,
	[ContactStatus__c] [varchar](8000) NULL,
	[HairLossProductOther__c] [varchar](8000) NULL,
	[ZipCode__c] [varchar](8000) NULL,
	[PhoneAbr__c] [varchar](8000) NULL,
	[Accommodation__c] [varchar](8000) NULL,
	[Promo_Code_Legacy__c] [varchar](8000) NULL,
	[Source_Code_Legacy__c] [varchar](8000) NULL,
	[TotalNumberofAppointments__c] [numeric](38, 18) NULL,
	[RecentCampaign__c] [varchar](8000) NULL,
	[RecentPromoCode__c] [varchar](8000) NULL,
	[DeviceType__c] [varchar](8000) NULL,
	[IPAddress__c] [varchar](8000) NULL,
	[HTTPReferrer__c] [varchar](8000) NULL,
	[OnCtLastModifyDate__c] [datetime2](7) NULL,
	[OnCtCreatedDate__c] [datetime2](7) NULL,
	[Duplicate__c] [varchar](8000) NULL,
	[OnCtCreatedByUser__c] [varchar](8000) NULL,
	[TimeZone__c] [varchar](8000) NULL,
	[ClientID__c] [varchar](8000) NULL,
	[DISC__c] [varchar](8000) NULL,
	[Ethnicity__c] [varchar](8000) NULL,
	[LudwigScale__c] [varchar](8000) NULL,
	[MaritalStatus__c] [varchar](8000) NULL,
	[NorwoodScale__c] [varchar](8000) NULL,
	[Occupation__c] [varchar](8000) NULL,
	[OriginalCampaignID__c] [varchar](8000) NULL,
	[SolutionOffered__c] [varchar](8000) NULL,
	[CenterNumber__c] [varchar](8000) NULL,
	[OncOriginalCampaign__c] [varchar](8000) NULL,
	[OncLastUpdatedUserCode__c] [varchar](8000) NULL,
	[CenterID__c] [varchar](8000) NULL,
	[SiebelID__c] [varchar](8000) NULL,
	[LastProcessedDate__c] [datetime2](7) NULL,
	[ToBeProcessed__c] [bit] NULL,
	[LastModifiedBy__c] [varchar](8000) NULL,
	[FullName__c] [varchar](8000) NULL,
	[RecentCampaignID__c] [varchar](8000) NULL,
	[SCName__c] [varchar](8000) NULL,
	[Notes__c] [varchar](8000) NULL,
	[OncBatchProcessedDate__c] [varchar](8000) NULL,
	[OncMinsSinceModified__c] [numeric](38, 18) NULL,
	[PCName__c] [varchar](8000) NULL,
	[NoShows__c] [numeric](38, 18) NULL,
	[ShowNoSale__c] [numeric](38, 18) NULL,
	[ShowSales__c] [numeric](38, 18) NULL,
	[SCMatch__c] [varchar](8000) NULL,
	[LastModifiedDate__c] [datetime2](7) NULL,
	[CampaignMatch__c] [varchar](8000) NULL,
	[et4ae5__HasOptedOutOfMobile__c] [bit] NULL,
	[et4ae5__Mobile_Country_Code__c] [varchar](8000) NULL,
	[CaseSafeID__c] [varchar](8000) NULL,
	[Reschedules__c] [numeric](38, 18) NULL,
	[ReportCreateDate__c] [datetime2](7) NULL,
	[OpenAppointCount__c] [numeric](38, 18) NULL,
	[GCLID__c] [varchar](8000) NULL,
	[Initial_Task_ID__c] [varchar](8000) NULL,
	[State_Text__c] [varchar](8000) NULL,
	[StatusMatch__c] [varchar](8000) NULL,
	[SourceTest__c] [varchar](8000) NULL,
	[UnbouncePageID__c] [varchar](8000) NULL,
	[Source__c] [varchar](8000) NULL,
	[SubmitterIP__c] [varchar](8000) NULL,
	[UnbounceSubmissionTime__c] [varchar](8000) NULL,
	[UnbouncePageVariant__c] [varchar](8000) NULL,
	[UnbounceSubmissionDate__c] [datetime2](7) NULL,
	[leadcap__Facebook_Lead_ID__c] [varchar](8000) NULL,
	[HairLossOrVolume__c] [varchar](8000) NULL,
	[LeadCreationDate__c] [datetime2](7) NULL,
	[Consultation_Form__c] [varchar](8000) NULL,
	[Active_User_Owner__c] [bit] NULL,
	[PostalCodeClean__c] [varchar](8000) NULL,
	[BosleySFID__c] [varchar](8000) NULL,
	[CancelAppointCount__c] [numeric](38, 18) NULL,
	[CompletionDate__c] [datetime2](7) NULL,
	[Current_Task_ActivityDate__c] [datetime2](7) NULL,
	[Current_Task_ActivityType__c] [varchar](8000) NULL,
	[Current_Task_StartTime__c] [varchar](8000) NULL,
	[Last_Activity__c] [datetime2](7) NULL,
	[Last_Task_ActivityDate__c] [datetime2](7) NULL,
	[Last_Task_Result__c] [varchar](8000) NULL,
	[RecentSourceCode__c] [varchar](8000) NULL,
	[ConsultationFormURL__c] [varchar](8000) NULL,
	[ReferralCode__c] [varchar](8000) NULL,
	[ReferralCodeExpireDate__c] [datetime2](7) NULL,
	[PreferredAppointmentTime__c] [varchar](8000) NULL,
	[HardCopyPreferred__c] [bit] NULL,
	[SFMCExempt__c] [bit] NULL,
	[Lead_Activity_Status__c] [varchar](8000) NULL,
	[Service_Territory__c] [varchar](8000) NULL,
	[Allow_Virtual_Center__c] [bit] NULL,
	[HWFormID__c] [varchar](8000) NULL,
	[Text_Reminer_Opt_In__c] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
