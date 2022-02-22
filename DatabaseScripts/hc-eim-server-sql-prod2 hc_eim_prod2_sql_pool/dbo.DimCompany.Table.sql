/****** Object:  Table [dbo].[DimCompany]    Script Date: 2/22/2022 9:20:32 AM ******/
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
