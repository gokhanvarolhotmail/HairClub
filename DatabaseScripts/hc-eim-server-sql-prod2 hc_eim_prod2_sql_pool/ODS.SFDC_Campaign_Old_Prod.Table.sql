/****** Object:  Table [ODS].[SFDC_Campaign_Old_Prod]    Script Date: 3/9/2022 8:40:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SFDC_Campaign_Old_Prod]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](8000) NULL,
	[ParentId] [varchar](8000) NULL,
	[Type] [varchar](8000) NULL,
	[RecordTypeId] [varchar](8000) NULL,
	[Status] [varchar](8000) NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[ExpectedRevenue] [numeric](38, 18) NULL,
	[BudgetedCost] [numeric](38, 18) NULL,
	[ActualCost] [numeric](38, 18) NULL,
	[ExpectedResponse] [numeric](38, 18) NULL,
	[NumberSent] [numeric](38, 18) NULL,
	[IsActive] [bit] NULL,
	[Description] [varchar](8000) NULL,
	[CampaignImageId] [varchar](8000) NULL,
	[NumberOfLeads] [int] NULL,
	[NumberOfConvertedLeads] [int] NULL,
	[NumberOfContacts] [int] NULL,
	[NumberOfResponses] [int] NULL,
	[NumberOfOpportunities] [int] NULL,
	[NumberOfWonOpportunities] [int] NULL,
	[AmountAllOpportunities] [numeric](38, 18) NULL,
	[AmountWonOpportunities] [numeric](38, 18) NULL,
	[OwnerId] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[CampaignMemberRecordTypeId] [varchar](8000) NULL,
	[PromoCode__c] [varchar](8000) NULL,
	[SourceCode__c] [varchar](8000) NULL,
	[PromoCodeName__c] [varchar](8000) NULL,
	[Channel__c] [varchar](8000) NULL,
	[Location__c] [varchar](8000) NULL,
	[Language__c] [varchar](8000) NULL,
	[Media__c] [varchar](8000) NULL,
	[Source__c] [varchar](8000) NULL,
	[Goal__c] [varchar](8000) NULL,
	[Format__c] [varchar](8000) NULL,
	[ACE_Decription__c] [varchar](8000) NULL,
	[Gender__c] [varchar](8000) NULL,
	[CampaignType__c] [varchar](8000) NULL,
	[CommunicationType__c] [varchar](8000) NULL,
	[Toll_Free_Number__c] [varchar](8000) NULL,
	[DNIS__c] [varchar](8000) NULL,
	[SourceCode_L__c] [varchar](8000) NULL,
	[SourceID_L__c] [varchar](8000) NULL,
	[SourceName_L__c] [varchar](8000) NULL,
	[IsInHouseSourceFlag_L__c] [varchar](8000) NULL,
	[PhoneID_L__c] [varchar](8000) NULL,
	[Number_L__c] [varchar](8000) NULL,
	[NumberTypeID_L__c] [varchar](8000) NULL,
	[MediaID_L__c] [varchar](8000) NULL,
	[NumberType_L__c] [varchar](8000) NULL,
	[MediaCode_L__c] [varchar](8000) NULL,
	[Media_L__c] [varchar](8000) NULL,
	[Level02Location_L__c] [varchar](8000) NULL,
	[Notes_L__c] [varchar](8000) NULL,
	[CreationDate_L__c] [varchar](8000) NULL,
	[LastUpdateDate_L__c] [varchar](8000) NULL,
	[Level02LocationCode_L__c] [varchar](8000) NULL,
	[Level05ID_L__c] [varchar](8000) NULL,
	[Level05CreativeCode_L__c] [varchar](8000) NULL,
	[Level05Creative_L__c] [varchar](8000) NULL,
	[Level03ID_L__c] [varchar](8000) NULL,
	[Level03LanguageCode_L__c] [varchar](8000) NULL,
	[Level03Language_L__c] [varchar](8000) NULL,
	[Level04ID_L__c] [varchar](8000) NULL,
	[Level04FormatCode_L__c] [varchar](8000) NULL,
	[Level04Format_L__c] [varchar](8000) NULL,
	[Promo_Code_L__c] [varchar](8000) NULL,
	[PromoCodeDisplay__c] [varchar](8000) NULL,
	[TollFreeNumberMobile__c] [varchar](8000) NULL,
	[DNISMobile__c] [numeric](38, 18) NULL,
	[URLDomain__c] [varchar](8000) NULL,
	[Referrer__c] [varchar](8000) NULL,
	[Campaign_Counter__c] [varchar](8000) NULL,
	[TollFreeName__c] [varchar](8000) NULL,
	[TollFreeMobileName__c] [varchar](8000) NULL,
	[SourceCodeNumber__c] [varchar](8000) NULL,
	[SCNumber__c] [varchar](8000) NULL,
	[DPNCode__c] [varchar](8000) NULL,
	[DWCCode__c] [varchar](8000) NULL,
	[DWFCode__c] [varchar](8000) NULL,
	[GenerateCodes__c] [bit] NULL,
	[MPNCode__c] [varchar](8000) NULL,
	[MWCCode__c] [varchar](8000) NULL,
	[MWFCode__c] [varchar](8000) NULL,
	[ShortcodeChannel__c] [varchar](8000) NULL,
	[ShortcodeFormat__c] [varchar](8000) NULL,
	[ShortcodeMedia__c] [varchar](8000) NULL,
	[ShortcodeOrigin__c] [varchar](8000) NULL,
	[WebCode__c] [varchar](8000) NULL,
	[ShortcodeLocation__c] [varchar](8000) NULL,
	[DialerMiscCode__c] [varchar](8000) NULL,
	[Company__c] [varchar](8000) NULL,
	[Action_Criteria__c] [varchar](8000) NULL,
	[Excluded_Centers__c] [varchar](8000) NULL,
	[Gender_Criteria__c] [varchar](8000) NULL,
	[Language_Criteria__c] [varchar](8000) NULL,
	[Leads_Created_From__c] [datetime2](7) NULL,
	[Leads_Created_Until__c] [datetime2](7) NULL,
	[Priority__c] [varchar](8000) NULL,
	[DB_Campaign_Tactic__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [Id] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
