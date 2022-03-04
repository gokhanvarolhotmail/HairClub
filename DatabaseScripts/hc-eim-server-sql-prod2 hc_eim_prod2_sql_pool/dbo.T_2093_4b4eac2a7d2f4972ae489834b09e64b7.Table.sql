/****** Object:  Table [dbo].[T_2093_4b4eac2a7d2f4972ae489834b09e64b7]    Script Date: 3/4/2022 8:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2093_4b4eac2a7d2f4972ae489834b09e64b7]
(
	[Hash] [nvarchar](max) NULL,
	[MediaName] [nvarchar](max) NULL,
	[DWH_CreatedDate] [datetime2](7) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [nvarchar](max) NULL,
	[r1eb8f781367745bd97c439a04d933335] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
