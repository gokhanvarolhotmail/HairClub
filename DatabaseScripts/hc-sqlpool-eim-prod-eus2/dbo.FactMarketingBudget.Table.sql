/****** Object:  Table [dbo].[FactMarketingBudget]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactMarketingBudget]
(
	[FactDate] [varchar](8000) NULL,
	[Month] [varchar](8000) NULL,
	[BudgetType] [varchar](8000) NULL,
	[Agency] [varchar](8000) NULL,
	[Channel] [varchar](8000) NULL,
	[Medium] [varchar](8000) NULL,
	[Source] [varchar](8000) NULL,
	[Budget] [varchar](8000) NULL,
	[Location] [varchar](8000) NULL,
	[BudgetAmount] [varchar](8000) NULL,
	[TaregetLeads] [varchar](8000) NULL,
	[CurrencyConversion] [varchar](8000) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_UpdatedDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
