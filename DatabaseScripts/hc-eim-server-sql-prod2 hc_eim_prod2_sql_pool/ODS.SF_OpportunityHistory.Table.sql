/****** Object:  Table [ODS].[SF_OpportunityHistory]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_OpportunityHistory]
(
	[Id] [nvarchar](max) NULL,
	[OpportunityId] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[StageName] [nvarchar](max) NULL,
	[Amount] [decimal](38, 18) NULL,
	[ExpectedRevenue] [decimal](38, 18) NULL,
	[CloseDate] [datetime2](7) NULL,
	[Probability] [decimal](38, 18) NULL,
	[ForecastCategory] [nvarchar](max) NULL,
	[CurrencyIsoCode] [nvarchar](max) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
