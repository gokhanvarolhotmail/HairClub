/****** Object:  Table [dbo].[DimBudget]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimBudget]
(
	[BudgetKey] [int] IDENTITY(1,1) NOT NULL,
	[BudgetName] [nvarchar](50) NULL,
	[BudgetType] [varchar](50) NULL,
	[Hash] [varchar](257) NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[BudgetKey] ASC
	)
)
GO
