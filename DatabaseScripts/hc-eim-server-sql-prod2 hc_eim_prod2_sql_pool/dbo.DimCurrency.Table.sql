/****** Object:  Table [dbo].[DimCurrency]    Script Date: 2/18/2022 8:28:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCurrency]
(
	[CurrencyKey] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyName] [nvarchar](50) NULL,
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
		[CurrencyKey] ASC
	)
)
GO
