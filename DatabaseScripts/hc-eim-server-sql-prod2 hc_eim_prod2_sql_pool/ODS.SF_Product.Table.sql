/****** Object:  Table [ODS].[SF_Product]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_Product]
(
	[Id] [varchar](8000) NULL,
	[Name] [varchar](8000) NULL,
	[ProductCode] [varchar](8000) NULL,
	[Description] [varchar](8000) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[Family] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[ExternalDataSourceId] [varchar](8000) NULL,
	[ExternalId] [varchar](8000) NULL,
	[DisplayUrl] [varchar](8000) NULL,
	[QuantityUnitOfMeasure] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[IsArchived] [bit] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[StockKeepingUnit] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
