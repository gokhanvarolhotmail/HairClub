/****** Object:  Table [dbo].[DimGender]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimGender]
(
	[GenderKey] [int] IDENTITY(1,1) NOT NULL,
	[GenderCode] [varchar](200) NULL,
	[GenderName] [varchar](400) NULL,
	[GenderGroup] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NOT NULL,
	[IsActive] [int] NOT NULL,
	[SourceSystem] [varchar](10) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[GenderKey] ASC
	)
)
GO
