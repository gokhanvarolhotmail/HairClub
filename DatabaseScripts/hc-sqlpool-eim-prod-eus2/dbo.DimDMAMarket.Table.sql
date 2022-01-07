/****** Object:  Table [dbo].[DimDMAMarket]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDMAMarket]
(
	[DMAkey] [int] IDENTITY(1,1) NOT NULL,
	[DMACode] [bigint] NULL,
	[DMADescription] [varchar](8000) NULL,
	[DMAMarketRegion] [varchar](8000) NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
