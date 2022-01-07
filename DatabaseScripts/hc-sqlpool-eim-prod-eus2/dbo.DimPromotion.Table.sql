/****** Object:  Table [dbo].[DimPromotion]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPromotion]
(
	[Promokey] [int] IDENTITY(1,1) NOT NULL,
	[PromoId] [varchar](8000) NULL,
	[PromoName] [varchar](8000) NULL,
	[Promocurrency] [varchar](8000) NULL,
	[PromoLongName] [varchar](8000) NULL,
	[DiscountType] [varchar](8000) NULL,
	[StartDate__c] [datetime2](7) NULL,
	[EndDate__c] [datetime2](7) NULL,
	[IsActive] [bit] NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NOT NULL,
	[SourceSystem] [varchar](10) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Promokey] ASC
	)
)
GO
