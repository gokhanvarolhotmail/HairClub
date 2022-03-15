/****** Object:  Table [dbo].[DimWorkType]    Script Date: 3/15/2022 2:11:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimWorkType]
(
	[WorkTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[WorkTypeName] [nvarchar](50) NOT NULL,
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
		[WorkTypeKey] ASC
	)
)
GO
