/****** Object:  Table [dbo].[DimMedium]    Script Date: 2/7/2022 10:45:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimMedium]
(
	[MediumKey] [int] IDENTITY(1,1) NOT NULL,
	[MediumName] [nvarchar](50) NOT NULL,
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
		[MediumKey] ASC
	)
)
GO
