/****** Object:  Table [dbo].[DimCallType]    Script Date: 2/22/2022 9:20:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCallType]
(
	[CallTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[CallTypeName] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[SourceSystem] [varchar](10) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[CallTypeKey] ASC
	)
)
GO
