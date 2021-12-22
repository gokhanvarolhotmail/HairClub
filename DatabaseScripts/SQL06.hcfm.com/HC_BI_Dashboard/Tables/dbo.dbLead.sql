CREATE TABLE [dbo].[dbLead](
	[Period] [datetime] NULL,
	[CreationDate] [datetime] NULL,
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine1] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine2] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine3] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine4] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRange] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthday] [datetime] NULL,
	[Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ethnicity] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISCStyle] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted] [decimal](18, 2) NULL,
	[NoSaleReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegmentOfferedOrSold] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossInFamily] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadStatus] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignSourceCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignChannel] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignOwnerType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCodeGender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignGoal] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignBudgetedCost] [money] NULL,
	[CampaignActualCost] [money] NULL,
	[CampaignMedia] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignOrigin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignLocation] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignLanguage] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignFormat] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignDeviceType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignDNIS] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignPromoCodeDescription] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HCReferral] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbLead_CreationDate] ON [dbo].[dbLead]
(
	[CreationDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbLead_Period] ON [dbo].[dbLead]
(
	[Period] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
