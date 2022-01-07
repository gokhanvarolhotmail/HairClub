/****** Object:  Table [ODS].[MA_OTTSpend]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[MA_OTTSpend]
(
	[Date] [varchar](8000) NULL,
	[Advertiser] [varchar](8000) NULL,
	[AdvertiserCurrencyCode] [varchar](8000) NULL,
	[Campaign] [varchar](8000) NULL,
	[AdGroup] [varchar](8000) NULL,
	[Creative] [varchar](8000) NULL,
	[Impressions] [varchar](8000) NULL,
	[CNSpend] [varchar](8000) NULL,
	[FilePath] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
