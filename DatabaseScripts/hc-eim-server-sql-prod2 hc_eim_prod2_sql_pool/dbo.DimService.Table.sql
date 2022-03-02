/****** Object:  Table [dbo].[DimService]    Script Date: 3/2/2022 1:09:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimService]
(
	[ServiceKey] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [nvarchar](50) NOT NULL,
	[DWH_CreatedDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[ServiceKey] ASC
	)
)
GO
