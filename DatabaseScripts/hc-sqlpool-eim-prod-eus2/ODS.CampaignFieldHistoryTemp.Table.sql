/****** Object:  Table [ODS].[CampaignFieldHistoryTemp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CampaignFieldHistoryTemp]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [varchar](8000) NULL,
	[CreatedById] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[Field] [varchar](8000) NULL,
	[OldValue] [varchar](8000) NULL,
	[NewValue] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
