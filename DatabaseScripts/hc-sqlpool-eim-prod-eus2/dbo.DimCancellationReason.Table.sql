/****** Object:  Table [dbo].[DimCancellationReason]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCancellationReason]
(
	[CancellationReasonkey] [int] IDENTITY(1,1) NOT NULL,
	[CancellationReasonId] [int] NULL,
	[CancellationStatusDescription] [varchar](250) NULL,
	[CancellationReasonDescription] [varchar](250) NULL,
	[CancellationrReasonDescriptionShort] [varchar](250) NULL,
	[RevenueGroupDescription] [varchar](250) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](10) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[CancellationReasonkey] ASC
	)
)
GO
