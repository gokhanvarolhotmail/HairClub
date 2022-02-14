/****** Object:  Table [ODS].[CNCT_RevenueGroup]    Script Date: 2/14/2022 11:44:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_RevenueGroup]
(
	[RevenueGroupID] [int] NULL,
	[RevenueGroupSortOrder] [int] NULL,
	[RevenueGroupDescription] [varchar](8000) NULL,
	[RevenueGroupDescriptionShort] [varchar](8000) NULL,
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
