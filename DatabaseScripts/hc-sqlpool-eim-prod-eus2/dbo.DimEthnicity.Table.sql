/****** Object:  Table [dbo].[DimEthnicity]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimEthnicity]
(
	[EthnicityKey] [int] IDENTITY(1,1) NOT NULL,
	[EthnicityCode] [nvarchar](100) NULL,
	[EthnicityName] [nvarchar](100) NULL,
	[DWH_LoadDate] [date] NULL,
	[DWH_LastUpdateDate] [date] NULL,
	[IsActive] [int] NULL,
	[SourceSystem] [nvarchar](100) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[EthnicityKey] ASC
	)
)
GO
