/****** Object:  Table [dbo].[DimDimMeetingPlatform]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDimMeetingPlatform]
(
	[DimMeetingPlatformKey] [int] IDENTITY(1,1) NOT NULL,
	[DimMeetingPlatformName] [nvarchar](50) NULL,
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
		[DimMeetingPlatformKey] ASC
	)
)
GO
