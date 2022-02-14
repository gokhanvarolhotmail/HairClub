/****** Object:  Table [dbo].[DimMeetingPlatform]    Script Date: 2/14/2022 11:44:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimMeetingPlatform]
(
	[MeetingPlatformKey] [int] IDENTITY(1,1) NOT NULL,
	[MeetingPlatformName] [nvarchar](50) NOT NULL,
	[Hash] [varchar](256) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[MeetingPlatformKey] ASC
	)
)
GO
