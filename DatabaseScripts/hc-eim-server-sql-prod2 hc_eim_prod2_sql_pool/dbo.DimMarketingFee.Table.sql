/****** Object:  Table [dbo].[DimMarketingFee]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimMarketingFee]
(
	[MarketingFeeKey] [int] IDENTITY(1,1) NOT NULL,
	[InitialDate] [date] NULL,
	[FinalDate] [date] NULL,
	[Month] [varchar](50) NULL,
	[DataStream] [varchar](300) NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[Fee] [decimal](18, 0) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[MarketingFeeKey] ASC
	)
)
GO
