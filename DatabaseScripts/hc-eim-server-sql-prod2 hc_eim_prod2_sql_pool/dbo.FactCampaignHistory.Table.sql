/****** Object:  Table [dbo].[FactCampaignHistory]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactCampaignHistory]
(
	[CampaignHistoryId] [nvarchar](50) NULL,
	[FactDateKey] [int] NULL,
	[FactTimeKey] [int] NULL,
	[FactDate] [datetime] NULL,
	[CampaignKey] [int] NULL,
	[CampaignId] [nvarchar](50) NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](50) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [nvarchar](50) NULL,
	[ContactId] [nvarchar](50) NULL,
	[StatusKey] [int] NULL,
	[CampaignHistoryStatus] [nvarchar](1024) NULL,
	[IsDeleted] [bit] NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedById] [nvarchar](1024) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](1024) NULL,
	[ContactName] [nvarchar](1024) NULL,
	[ContactAddress] [nvarchar](1024) NULL,
	[ContactCity] [nvarchar](1024) NULL,
	[ContactState] [nvarchar](1024) NULL,
	[ContactPostalCode] [nvarchar](1024) NULL,
	[ContactCountry] [nvarchar](1024) NULL,
	[GeographyKey] [int] NULL,
	[SourceCode] [nvarchar](1024) NULL,
	[LeadSource] [nvarchar](1024) NULL,
	[SourceSystem] [nvarchar](1024) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
