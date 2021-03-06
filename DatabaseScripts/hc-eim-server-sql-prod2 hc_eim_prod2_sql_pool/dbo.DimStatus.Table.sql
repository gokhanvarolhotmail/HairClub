/****** Object:  Table [dbo].[DimStatus]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimStatus]
(
	[StatusKey] [int] IDENTITY(1,1) NOT NULL,
	[Hash] [varchar](100) NOT NULL,
	[StatusName] [varchar](200) NULL,
	[StatusGroup] [varchar](400) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[SourceSystem] [varchar](10) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[StatusKey] ASC
	)
)
GO
