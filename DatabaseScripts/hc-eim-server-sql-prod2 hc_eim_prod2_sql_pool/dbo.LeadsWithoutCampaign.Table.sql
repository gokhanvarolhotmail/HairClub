/****** Object:  Table [dbo].[LeadsWithoutCampaign]    Script Date: 3/4/2022 8:28:30 AM ******/
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
