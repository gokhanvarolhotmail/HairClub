/****** Object:  Table [dbo].[DimMaritalStatus]    Script Date: 3/7/2022 8:42:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimMaritalStatus]
(
	[MaritalStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[MaritalStatusName] [nvarchar](50) NOT NULL,
	[Hash] [varchar](256) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
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
