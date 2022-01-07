/****** Object:  Table [dbo].[DimHairLossType]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimHairLossType]
(
	[DimHairLossTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[HairLossTypeDescription] [varchar](100) NOT NULL,
	[HairLossClass] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[DimHairLossTypeKey] ASC
	)
)
GO
