/****** Object:  Table [ODS].[TestAttributeScan2]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[TestAttributeScan2]
(
	[Key] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NULL,
	[LoadDate] [datetime] NOT NULL,
	[LastUpdateDate] [datetime] NULL,
	[NewCol] [varchar](20) NULL,
	[NewCol2] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED INDEX
	(
		[Key] ASC
	)
)
GO
