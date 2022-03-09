/****** Object:  Table [ODS].[MA_Targets]    Script Date: 3/9/2022 8:40:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[MA_Targets]
(
	[Date] [varchar](8000) NULL,
	[Month] [varchar](8000) NULL,
	[BudgetType] [varchar](8000) NULL,
	[Agency] [varchar](8000) NULL,
	[Channel] [varchar](8000) NULL,
	[Medium] [varchar](8000) NULL,
	[Source] [varchar](8000) NULL,
	[Budget] [varchar](8000) NULL,
	[Location] [varchar](8000) NULL,
	[BudgetAmount] [varchar](8000) NULL,
	[TargetLeads] [varchar](8000) NULL,
	[CurrencyConversion] [varchar](8000) NULL,
	[Fee] [varchar](50) NULL,
	[DataStreamID] [int] NULL,
	[DataStreamName] [varchar](200) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
