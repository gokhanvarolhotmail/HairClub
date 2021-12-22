CREATE TABLE [dbo].[DimCommissionError](
	[CommissionErrorID] [int] NULL,
	[SortOrder] [int] NULL,
	[CommissionTypeID] [int] NULL,
	[CommissionError] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommissionErrorShort] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
