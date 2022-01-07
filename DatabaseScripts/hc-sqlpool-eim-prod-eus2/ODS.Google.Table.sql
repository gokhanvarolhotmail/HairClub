/****** Object:  Table [ODS].[Google]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[Google]
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
