/****** Object:  Table [dbo].[DimBusinessSegment]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimBusinessSegment]
(
	[BusinessSegmentKey] [int] IDENTITY(1,1) NOT NULL,
	[BusinessSegmentID] [int] NOT NULL,
	[BusinessSegmentName] [nvarchar](200) NULL,
	[BusinessSegmentShortName] [nvarchar](200) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[SourceSystem] [nvarchar](20) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[BusinessSegmentKey] ASC
	)
)
GO
