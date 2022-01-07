/****** Object:  Table [Reports].[datScorecard]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reports].[datScorecard]
(
	[Organization] [nvarchar](80) NULL,
	[ID] [int] NULL,
	[Measure] [nvarchar](80) NULL,
	[Date] [date] NULL,
	[Value] [decimal](18, 4) NULL,
	[Threshold1] [decimal](18, 4) NULL,
	[Threshold2] [decimal](18, 4) NULL,
	[Threshold3] [decimal](18, 4) NULL,
	[Threshold4] [decimal](18, 4) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
