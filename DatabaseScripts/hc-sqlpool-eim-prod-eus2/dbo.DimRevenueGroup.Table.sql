/****** Object:  Table [dbo].[DimRevenueGroup]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimRevenueGroup]
(
	[RevenueGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[RevenueGroupID] [int] NOT NULL,
	[RevenueGroupName] [varchar](200) NULL,
	[RevenueGroupShortName] [varchar](200) NULL,
	[DWH_CreatedDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](100) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[RevenueGroupKey] ASC
	)
)
GO
