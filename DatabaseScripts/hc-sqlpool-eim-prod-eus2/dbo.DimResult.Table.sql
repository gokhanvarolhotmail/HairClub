/****** Object:  Table [dbo].[DimResult]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimResult]
(
	[ResultKey] [int] IDENTITY(1,1) NOT NULL,
	[ResultHash] [varchar](100) NOT NULL,
	[ResultName] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[SourceSystem] [varchar](10) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[ResultKey] ASC
	)
)
GO
