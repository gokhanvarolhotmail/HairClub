/****** Object:  Table [dbo].[DimCommunicationMethod]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCommunicationMethod]
(
	[ComMethodKey] [int] IDENTITY(1,1) NOT NULL,
	[ComMethodCode] [varchar](50) NULL,
	[ComMethodName] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[SourceSystem] [varchar](50) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[ComMethodKey] ASC
	)
)
GO
