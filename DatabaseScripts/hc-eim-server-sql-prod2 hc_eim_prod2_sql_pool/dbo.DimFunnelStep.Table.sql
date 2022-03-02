/****** Object:  Table [dbo].[DimFunnelStep]    Script Date: 3/2/2022 1:09:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimFunnelStep]
(
	[FunnelStepKey] [int] IDENTITY(1,1) NOT NULL,
	[FunnelStepName] [nvarchar](200) NULL,
	[FunnelStepGroup] [nvarchar](200) NULL,
	[DWH_LoadDate] [date] NULL,
	[DWH_LastUpdateDate] [date] NULL,
	[IsActive] [int] NULL,
	[SourceSystem] [varchar](100) NULL,
	[FunnelLogic] [varchar](2000) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[FunnelStepKey] ASC
	)
)
GO
