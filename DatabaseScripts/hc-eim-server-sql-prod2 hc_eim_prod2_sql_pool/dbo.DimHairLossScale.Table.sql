/****** Object:  Table [dbo].[DimHairLossScale]    Script Date: 3/4/2022 8:28:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimHairLossScale]
(
	[HairLossScaleKey] [int] IDENTITY(1,1) NOT NULL,
	[HairLossScaleName] [nvarchar](50) NOT NULL,
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
		[HairLossScaleKey] ASC
	)
)
GO
