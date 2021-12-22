CREATE TABLE [dbo].[dashSalesMix](
	[FirstDateOfMonth] [datetime] NOT NULL,
	[YearNumber] [int] NOT NULL,
	[YearMonthNumber] [int] NOT NULL,
	[CenterNumber] [int] NOT NULL,
	[CenterDescription] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterTypeDescriptionShort] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegment] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegmentSortOrder] [int] NULL,
	[Sales] [int] NULL,
	[SalesBudget] [int] NULL,
	[Revenue] [int] NULL,
	[RevenueBudget] [int] NULL
) ON [PRIMARY]
