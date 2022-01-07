/****** Object:  Table [dbo].[DimAccount_FlashReport]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAccount_FlashReport]
(
	[AccountKey] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[LedgerGroup] [varchar](255) NULL,
	[AccountDescription] [nvarchar](255) NULL,
	[EBIDA] [varchar](50) NULL,
	[Level0] [varchar](50) NULL,
	[Level0Sort] [int] NULL,
	[Level1] [varchar](50) NULL,
	[Level1Sort] [int] NULL,
	[Level2] [varchar](50) NULL,
	[Level2Sort] [int] NULL,
	[Level3] [varchar](50) NULL,
	[Level3Sort] [int] NULL,
	[Level4] [varchar](255) NULL,
	[Level4Sort] [int] NULL,
	[Level5] [varchar](50) NULL,
	[Level5Sort] [int] NULL,
	[Level6] [varchar](50) NULL,
	[Level6Sort] [int] NULL,
	[RevenueOrExpenses] [varchar](50) NULL,
	[ExpenseType] [varchar](50) NULL,
	[CalculateGrossProfit] [int] NULL,
	[Description] [varchar](5) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[AccountID] ASC
	)
)
GO
