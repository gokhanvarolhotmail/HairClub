/****** Object:  Table [ODS].[CNCT_lkpBusinessSegment]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpBusinessSegment]
(
	[BusinessSegmentID] [int] NULL,
	[BusinessSegmentSortOrder] [int] NULL,
	[BusinessSegmentDescription] [varchar](8000) NULL,
	[BusinessSegmentDescriptionShort] [varchar](8000) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
