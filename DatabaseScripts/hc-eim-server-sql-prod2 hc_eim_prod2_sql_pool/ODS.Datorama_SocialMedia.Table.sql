/****** Object:  Table [ODS].[Datorama_SocialMedia]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[Datorama_SocialMedia]
(
	[DataStream] [varchar](500) NULL,
	[CRMDay] [date] NULL,
	[CampaignAdvertiserID] [varchar](500) NULL,
	[CampaignAdvertaiser] [varchar](500) NULL,
	[MediaCost] [decimal](18, 0) NULL,
	[Clicks] [int] NULL,
	[FilePath] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[MediaSpend] [decimal](18, 0) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
