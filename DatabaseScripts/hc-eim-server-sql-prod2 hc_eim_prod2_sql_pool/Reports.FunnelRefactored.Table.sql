/****** Object:  Table [Reports].[FunnelRefactored]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reports].[FunnelRefactored]
(
	[FunnelTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[SalesForceLeadID] [nvarchar](18) NULL,
	[HCUID] [nvarchar](4000) NULL,
	[GCLID] [nvarchar](4000) NULL,
	[FBCLID] [nvarchar](4000) NULL,
	[GCID] [nvarchar](4000) NULL,
	[MSCLKID] [nvarchar](4000) NULL,
	[HashedEmail] [varchar](4000) NULL,
	[HashedPhone] [varchar](4000) NULL,
	[FunnelStepActivityDateTimeEDT] [datetime] NULL,
	[FunnelStepActivityDateEDT] [datetime] NULL,
	[FunnelStepActivityTimeEDT] [time](7) NULL,
	[FunnelStep] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[MarketDMACode] [nvarchar](100) NULL,
	[MarketDMAName] [nvarchar](100) NULL,
	[PhoneNumberAreaCode] [nvarchar](250) NULL,
	[MobilePhoneNumberAreaCode] [nvarchar](250) NULL,
	[Company] [nvarchar](4000) NULL,
	[CenterID] [nvarchar](4000) NULL,
	[CenterName] [nvarchar](4000) NULL,
	[CenterMarketDMACode] [nvarchar](4000) NULL,
	[CenterMarketDMAName] [nvarchar](4000) NULL,
	[CenterType] [nvarchar](4000) NULL,
	[CenterOwner] [nvarchar](4000) NULL,
	[MarketingCampaignName] [nvarchar](4000) NULL,
	[MarketingCampaignSourcecode] [nvarchar](4000) NULL,
	[MarketingCampaignTelephoneNumber] [nvarchar](4000) NULL,
	[MarketingCampaignChannel] [nvarchar](4000) NULL,
	[MarketingCampaignMedium] [nvarchar](4000) NULL,
	[MarketingCampaignFormat] [nvarchar](4000) NULL,
	[MarketingCampaignSource] [nvarchar](4000) NULL,
	[MarketingCampaignContent] [nvarchar](4000) NULL,
	[MarketingCampaignAgency] [nvarchar](4000) NULL,
	[MarketingCampaignBudget] [nvarchar](4000) NULL,
	[MarketingCampaignLocation] [nvarchar](4000) NULL,
	[MarketingCampaignLanguage] [nvarchar](4000) NULL,
	[MarketingCampaignAudience] [nvarchar](4000) NULL,
	[MarketingCampaignPromotionCode] [nvarchar](4000) NULL,
	[MarketingCampaignLandingPageURL] [nvarchar](4000) NULL,
	[DemographicLanguage] [nvarchar](4000) NULL,
	[DemographicGender] [nvarchar](4000) NULL,
	[DemographicEthnicity] [nvarchar](4000) NULL,
	[DemographicHairLossCondition] [nvarchar](4000) NULL,
	[DemographicBirthYear] [nvarchar](4000) NULL,
	[Leads] [nvarchar](4000) NULL,
	[AppointmentsCreated] [nvarchar](4000) NULL,
	[Appointments] [nvarchar](4000) NULL,
	[Shows] [nvarchar](4000) NULL,
	[Sales] [nvarchar](4000) NULL,
	[InitialSolution] [nvarchar](4000) NULL,
	[NetRevenue] [nvarchar](4000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
