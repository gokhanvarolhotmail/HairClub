/****** Object:  Table [dbo].[T_2102_75021cc182cc4dc8a5966aee51760dea]    Script Date: 3/7/2022 8:42:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2102_75021cc182cc4dc8a5966aee51760dea]
(
	[PromotionId] [nvarchar](max) NULL,
	[PromotionName] [nvarchar](max) NULL,
	[PromotionCurrency] [nvarchar](max) NULL,
	[PromotionLongName] [nvarchar](max) NULL,
	[DiscountType] [nvarchar](max) NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[IsActive] [bit] NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[SourceSystem] [nvarchar](max) NULL,
	[ExternalId] [nvarchar](max) NULL,
	[r7ca4992345114810af093dafc216db8f] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
