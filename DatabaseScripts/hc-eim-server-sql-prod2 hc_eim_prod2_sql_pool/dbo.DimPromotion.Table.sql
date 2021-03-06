/****** Object:  Table [dbo].[DimPromotion]    Script Date: 3/23/2022 10:16:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPromotion]
(
	[Promotionkey] [int] IDENTITY(1,1) NOT NULL,
	[PromotionId] [varchar](50) NULL,
	[PromotionName] [varchar](300) NULL,
	[PromotionCurrency] [varchar](100) NULL,
	[PromotionLongName] [varchar](300) NULL,
	[DiscountType] [varchar](200) NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[IsActive] [bit] NULL,
	[ExternalId] [varchar](50) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NOT NULL,
	[SourceSystem] [varchar](10) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[PromotionId] ASC
	)
)
GO
