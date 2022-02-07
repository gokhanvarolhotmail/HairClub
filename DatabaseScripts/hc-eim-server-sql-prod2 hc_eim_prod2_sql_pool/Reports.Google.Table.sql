/****** Object:  Table [Reports].[Google]    Script Date: 2/7/2022 10:45:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reports].[Google]
(
	[GoogleClickID] [varchar](2048) NULL,
	[ConversionName] [varchar](1024) NULL,
	[ConversionTime] [varchar](100) NULL,
	[ConversionValue] [varchar](1000) NULL,
	[ConversionCurrency] [varchar](10) NULL,
	[dateTimeG] [datetime] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
