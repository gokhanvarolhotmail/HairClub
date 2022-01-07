/****** Object:  Table [dbo].[DimMaritalStatus]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimMaritalStatus]
(
	[MaritalStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[MaritalStatusDescription] [varchar](100) NOT NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[MaritalStatusKey] ASC
	)
)
GO
