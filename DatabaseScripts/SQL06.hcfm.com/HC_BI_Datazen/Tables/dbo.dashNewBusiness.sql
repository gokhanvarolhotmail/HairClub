/* CreateDate: 05/29/2019 14:14:57.260 , ModifyDate: 05/29/2019 14:14:57.260 */
GO
CREATE TABLE [dbo].[dashNewBusiness](
	[FirstDateOfMonth] [datetime] NOT NULL,
	[YearNumber] [int] NOT NULL,
	[YearMonthNumber] [int] NOT NULL,
	[CenterNumber] [int] NOT NULL,
	[CenterDescription] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Consultations] [decimal](18, 4) NULL,
	[Consultations_Budget] [decimal](18, 4) NULL,
	[TradGradSales] [decimal](18, 4) NULL,
	[TradGradSales_Budget] [decimal](18, 4) NULL,
	[NBApps] [decimal](18, 4) NULL,
	[NBApps_Budget] [decimal](18, 4) NULL,
	[NetSales] [decimal](18, 4) NULL,
	[NetSales_Budget] [decimal](18, 4) NULL,
	[NetRevenue] [decimal](18, 4) NULL,
	[NetRevenue_Budget] [decimal](18, 4) NULL,
	[NetSalesWithoutPExt] [decimal](18, 4) NULL,
	[NetSalesWithoutPExt_Budget] [decimal](18, 4) NULL,
	[ClosingPercent] [decimal](18, 4) NULL,
	[ClosingPercent_Budget] [decimal](18, 4) NULL,
	[XtrPlusSalesMix] [decimal](18, 4) NULL
) ON [PRIMARY]
GO
