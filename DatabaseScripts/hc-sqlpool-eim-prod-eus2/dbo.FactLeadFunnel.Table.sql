/****** Object:  Table [dbo].[FactLeadFunnel]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactLeadFunnel]
(
	[FactDate] [datetime] NULL,
	[FactDateKey] [int] NULL,
	[FactDateTimeKey] [int] NULL,
	[FunnelTransactionID] [int] NULL,
	[ContactID] [nvarchar](50) NULL,
	[LeadID] [nvarchar](50) NULL,
	[LeadKey] [int] NULL,
	[CompanyName] [nvarchar](100) NULL,
	[CompanyKey] [int] NULL,
	[FunnelStep] [nvarchar](50) NULL,
	[FunnelStepKey] [int] NULL,
	[Funnelstatus] [varchar](100) NULL,
	[OriginalGCLID] [nvarchar](100) NULL,
	[LeadCreateDateUTC] [datetime] NULL,
	[LeadCreateDateEST] [datetime] NULL,
	[ActivityDateUTC] [datetime] NULL,
	[ActivityDateEST] [datetime] NULL,
	[Date] [datetime] NULL,
	[Time] [time](7) NULL,
	[DayPart] [nvarchar](20) NULL,
	[Hour] [varchar](10) NULL,
	[Minute] [smallint] NULL,
	[Seconds] [smallint] NULL,
	[OriginalCampaignKey] [int] NULL,
	[OriginalCampaignName] [nvarchar](200) NULL,
	[RecentCampaingKey] [int] NULL,
	[RecentCampaignName] [nvarchar](200) NULL,
	[GeographyKey] [int] NULL,
	[PostalCode] [nvarchar](50) NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [nvarchar](50) NULL,
	[LanguageKey] [int] NULL,
	[Language] [nvarchar](50) NULL,
	[NewContact] [int] NULL,
	[NewLead] [int] NULL,
	[NewAppointment] [int] NULL,
	[NewShow] [int] NULL,
	[NewSale] [int] NULL,
	[NewLeadToAppointment] [int] NULL,
	[NewLeadToShow] [int] NULL,
	[NewLeadToSale] [int] NULL,
	[QuotedPrice] [money] NULL,
	[PrimarySolution] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [LeadKey]
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [CompanyKey]
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [FunnelStepKey]
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [OriginalCampaignKey]
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [RecentCampaingKey]
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [GeographyKey]
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [CenterKey]
GO
ALTER TABLE [dbo].[FactLeadFunnel] ADD  DEFAULT ((-1)) FOR [LanguageKey]
GO
