/****** Object:  Table [dbo].[LeadsWithoutCampaign]    Script Date: 2/7/2022 10:45:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LeadsWithoutCampaign]
(
	[ID] [nvarchar](50) NULL,
	[NewCampaignId] [varchar](256) NULL,
	[ExternalIdCampaign] [varchar](256) NULL,
	[CreatedDate] [datetime] NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
