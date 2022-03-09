/****** Object:  Table [dbo].[DimChannel]    Script Date: 3/9/2022 8:40:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimChannel]
(
	[ChannelKey] [int] IDENTITY(1,1) NOT NULL,
	[ChannelName] [nvarchar](50) NULL,
	[Hash] [varchar](256) NULL,
	[DWH_CreatedDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[ChannelKey] ASC
	)
)
GO
