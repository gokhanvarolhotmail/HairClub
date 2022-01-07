/****** Object:  Table [dbo].[DimCampaign]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCampaign]
(
	[CampaignKey] [int] IDENTITY(1,1) NOT NULL,
	[id] [varchar](50) NULL,
	[CampaignName] [varchar](2000) NULL,
	[CampaignDescription] [varchar](2000) NULL,
	[AgencyKey] [int] NOT NULL,
	[AgencyName] [varchar](200) NULL,
	[CampaignStatus] [varchar](200) NULL,
	[StatusKey] [int] NOT NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[CurrencyIsoCode] [varchar](200) NULL,
	[CurrencyKey] [int] NOT NULL,
	[PromoCode] [varchar](200) NULL,
	[PromotionKey] [int] NOT NULL,
	[CampaignChannel] [varchar](200) NULL,
	[ChannelKey] [int] NOT NULL,
	[CampaignLocation] [varchar](200) NULL,
	[CampaignLanguage] [varchar](200) NULL,
	[LanguageKey] [int] NULL,
	[CampaignMedia] [varchar](200) NULL,
	[MediaKey] [int] NULL,
	[CampaignSource] [varchar](200) NULL,
	[SourceKey] [int] NULL,
	[Campaigngender] [varchar](200) NULL,
	[GenderKey] [int] NULL,
	[CampaignType] [varchar](200) NULL,
	[BudgetedCost] [numeric](38, 18) NULL,
	[ActualCost] [numeric](38, 18) NULL,
	[DNIS] [varchar](200) NULL,
	[Referrer] [varchar](200) NULL,
	[ReferralFlag] [bit] NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](200) NULL,
	[CampaignOrigin] [varchar](100) NULL,
	[CampaignFormat] [varchar](50) NULL,
	[CampaignDeviceType] [varchar](50) NULL,
	[CampaignDNIS] [varchar](50) NULL,
	[CampaignTactic] [varchar](8000) NULL,
	[CampaignPromoDescription] [varchar](8000) NULL,
	[SourceCode] [varchar](100) NULL,
	[TollFreeName] [varchar](200) NULL,
	[TollFreeMobileName] [varchar](200) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[CampaignKey] ASC
	)
)
GO
