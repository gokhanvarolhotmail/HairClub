/****** Object:  Table [dbo].[DimSalesOrderType]    Script Date: 2/18/2022 8:28:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesOrderType]
(
	[SalesOrderTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderTypeId] [int] NULL,
	[SalesOrderTypeDescription] [varchar](257) NULL,
	[SalesOrderTypeDescriptionShort] [varchar](257) NULL,
	[LastModifiedDate] [datetime] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](250) NULL,
	[SourceSystem] [varchar](50) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[SalesOrderTypeId] ASC
	)
)
GO
