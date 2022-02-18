/****** Object:  Table [dbo].[DimPurpose]    Script Date: 2/18/2022 8:28:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPurpose]
(
	[PurposeKey] [int] IDENTITY(1,1) NOT NULL,
	[PurposeName] [nvarchar](50) NOT NULL,
	[DWH_CreatedDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Source] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[PurposeKey] ASC
	)
)
GO
