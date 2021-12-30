/* CreateDate: 06/16/2021 18:17:41.447 , ModifyDate: 06/16/2021 18:17:41.447 */
GO
CREATE TABLE [Synapse_pool].[DimCampaign](
	[CampaignKey] [int] NULL,
	[CampaignId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignName] [varchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignDescription] [varchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgencyKey] [int] NULL,
	[AgencyName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignStatus] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusKey] [int] NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[CurrencyIsoCode] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyKey] [int] NULL,
	[PromoCode] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotioKey] [int] NULL,
	[CampaignChannel] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ChannelKey] [int] NULL,
	[CampaignLocation] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignLanguage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageKey] [int] NULL,
	[CampaignMedia] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediaKey] [int] NULL,
	[CampaignSource] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceKey] [int] NULL,
	[Campaigngender] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderKey] [int] NULL,
	[CampaignType] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BudgetedCost] [numeric](38, 18) NULL,
	[ActualCost] [numeric](38, 18) NULL,
	[DNIS] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referrer] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferralFlag] [bit] NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignFormat] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignDeviceType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignDNIS] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignTactic] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignPromoDescription] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollFreeName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollFreeMobileName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollFreeNumber] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalID] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY]
GO
