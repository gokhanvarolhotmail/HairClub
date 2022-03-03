/****** Object:  Table [dbo].[T_2066_e8a03cc8186c45428cb97090406af123]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2066_e8a03cc8186c45428cb97090406af123]
(
	[CampaignHistoryId] [nvarchar](max) NULL,
	[FactDateKey] [int] NULL,
	[FactTimeKey] [int] NULL,
	[FactDate] [datetime2](7) NULL,
	[CampaignKey] [int] NULL,
	[CampaignId] [nvarchar](max) NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](max) NULL,
	[ContactId] [nvarchar](max) NULL,
	[StatusKey] [int] NULL,
	[CampaignHistoryStatus] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [nvarchar](max) NULL,
	[ContactName] [nvarchar](max) NULL,
	[ContactAddress] [nvarchar](max) NULL,
	[ContactCity] [nvarchar](max) NULL,
	[ContactState] [nvarchar](max) NULL,
	[ContactPostalCode] [nvarchar](max) NULL,
	[ContactCountry] [nvarchar](max) NULL,
	[GeographyKey] [int] NULL,
	[LeadSource] [nvarchar](max) NULL,
	[SourceSystem] [nvarchar](max) NULL,
	[r35006836f2d0435bbc95de19c5d183a6] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
