/****** Object:  Table [dbo].[DimTactic]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimTactic]
(
	[TacticKey] [int] IDENTITY(1,1) NOT NULL,
	[TacticName] [nvarchar](50) NOT NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Source] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[TacticKey] ASC
	)
)
GO
