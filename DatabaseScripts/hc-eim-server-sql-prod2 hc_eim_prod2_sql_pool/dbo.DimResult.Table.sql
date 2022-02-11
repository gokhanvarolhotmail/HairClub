/****** Object:  Table [dbo].[DimResult]    Script Date: 2/10/2022 9:07:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimResult]
(
	[ResultKey] [int] IDENTITY(1,1) NOT NULL,
	[ResultHash] [varchar](256) NULL,
	[ResultName] [varchar](256) NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
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
