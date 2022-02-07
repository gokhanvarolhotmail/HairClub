/****** Object:  Table [dbo].[DimEthnicity]    Script Date: 2/7/2022 10:45:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimEthnicity]
(
	[EthnicityKey] [int] IDENTITY(1,1) NOT NULL,
	[EthnicityName] [nvarchar](50) NULL,
	[Hash] [varchar](256) NULL,
	[DWH_CreatedDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL,
	[EthnicityID] [int] NULL
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
