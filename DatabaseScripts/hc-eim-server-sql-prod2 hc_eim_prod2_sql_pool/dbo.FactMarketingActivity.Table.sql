/****** Object:  Table [dbo].[FactMarketingActivity]    Script Date: 2/10/2022 9:07:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactMarketingActivity]
(
	[FactDateKey] [int] NULL,
	[FactDate] [datetime] NULL,
	[MarketingActivityDate] [date] NULL,
	[MarketingActivityTime] [varchar](50) NULL,
	[LocalAirTime] [varchar](50) NULL,
	[TransactionId] [int] NULL,
	[AgencyName] [nvarchar](50) NULL,
	[File] [nvarchar](200) NULL,
	[BudgetAmount] [money] NULL,
	[GrossSpend] [money] NULL,
	[Discount] [money] NULL,
	[Fees] [money] NULL,
	[NetSpend] [money] NULL,
	[SpotDate] [date] NULL,
	[Spots] [int] NULL,
	[Telephone] [nvarchar](50) NULL,
	[SourceCode] [nvarchar](200) NULL,
	[PromoCode] [nvarchar](50) NULL,
	[Url] [nvarchar](50) NULL,
	[Impressions18-65] [int] NULL,
	[Affiliate] [varchar](200) NULL,
	[Station] [varchar](600) NULL,
	[Show] [varchar](600) NULL,
	[ContentType] [varchar](200) NULL,
	[Content] [varchar](2000) NULL,
	[Isci] [varchar](200) NULL,
	[MasterNumber] [varchar](200) NULL,
	[DMAkey] [int] NULL,
	[DMA] [int] NULL,
	[AgencyKey] [int] NULL,
	[Agency] [varchar](50) NULL,
	[AudienceKey] [int] NULL,
	[Audience] [varchar](50) NULL,
	[ChannelKey] [int] NULL,
	[Channel] [varchar](50) NULL,
	[FormatKey] [int] NULL,
	[Format] [varchar](50) NULL,
	[TacticKey] [int] NULL,
	[Tactic] [varchar](50) NULL,
	[SourceKey] [int] NULL,
	[Source] [varchar](50) NULL,
	[MediumKey] [int] NULL,
	[Medium] [varchar](50) NULL,
	[PurposeKey] [int] NULL,
	[Purpose] [varchar](50) NULL,
	[MethodKey] [int] NULL,
	[Method] [varchar](50) NULL,
	[BudgetTypeKey] [int] NULL,
	[BudgetName] [varchar](50) NULL,
	[BudgetType] [varchar](50) NULL,
	[CampaignKey] [int] NULL,
	[Campaign] [varchar](3000) NULL,
	[CompanyKey] [int] NULL,
	[Company] [varchar](50) NULL,
	[LocationKey] [int] NULL,
	[Location] [varchar](50) NULL,
	[LanguageKey] [int] NULL,
	[Language] [varchar](50) NULL,
	[NumberOfLeads] [int] NULL,
	[NumberOfLeadsTarget] [int] NULL,
	[NumertOfOpportunities] [int] NULL,
	[NumberOfOpportunitiesTarget] [int] NULL,
	[NumberOfSales] [int] NULL,
	[NumberOfSalesTarget] [int] NULL,
	[DWH_LoadDate] [datetime] NULL,
	[LogType] [varchar](50) NULL,
	[Hash] [varchar](256) NULL,
	[Impressions] [int] NULL,
	[Fee] [decimal](10, 8) NULL,
	[MarketingFeeKey] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
