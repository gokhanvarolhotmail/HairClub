CREATE TABLE [dbo].[dbTask](
	[Period] [datetime] NULL,
	[ActivityDate] [datetime] NULL,
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Action__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultationType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
	[Appointment] [int] NOT NULL,
	[Consultation] [int] NOT NULL,
	[Beback] [int] NOT NULL,
	[InHouse] [int] NOT NULL,
	[Show] [int] NOT NULL,
	[NoShow] [int] NOT NULL,
	[Sale] [int] NOT NULL,
	[NoSale] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbTask_ActivityDate] ON [dbo].[dbTask]
(
	[ActivityDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbTask_Period] ON [dbo].[dbTask]
(
	[Period] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
