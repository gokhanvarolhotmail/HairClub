/****** Object:  Table [dbo].[DimCompany]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCompany]
(
	[CompanyKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](50) NULL,
	[Hash] [varchar](256) NULL,
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
		[CompanyKey] ASC
	)
)
GO
