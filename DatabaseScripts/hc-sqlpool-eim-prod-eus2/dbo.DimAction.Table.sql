/****** Object:  Table [dbo].[DimAction]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAction]
(
	[ActionKey] [int] IDENTITY(1,1) NOT NULL,
	[ActionHash] [varchar](100) NOT NULL,
	[ActionName] [varchar](200) NULL,
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
		[ActionKey] ASC
	)
)
GO
