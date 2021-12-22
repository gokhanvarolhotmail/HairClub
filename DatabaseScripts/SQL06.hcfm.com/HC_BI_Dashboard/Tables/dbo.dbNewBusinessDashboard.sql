/* CreateDate: 03/25/2019 15:31:05.427 , ModifyDate: 12/21/2021 23:47:21.537 */
GO
CREATE TABLE [dbo].[dbNewBusinessDashboard](
	[Area] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber] [int] NULL,
	[CenterDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[YearNumber] [int] NULL,
	[MonthNumber] [int] NULL,
	[MonthName] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullDate] [datetime] NULL,
	[Consultations] [int] NULL,
	[BeBacks] [int] NULL,
	[Referrals] [int] NULL,
	[NB1Applications] [int] NULL,
	[GrossNB1Count] [int] NULL,
	[NetNB1Count] [int] NULL,
	[NetNB1Sales] [int] NULL,
	[NetTradCount] [int] NULL,
	[NetTradSales] [decimal](18, 4) NULL,
	[NetEXTCount] [int] NULL,
	[NetEXTSales] [decimal](18, 4) NULL,
	[NetXtrCount] [int] NULL,
	[NetXtrSales] [decimal](18, 4) NULL,
	[NetGradCount] [int] NULL,
	[NetGradSales] [decimal](18, 4) NULL,
	[SurgeryCount] [int] NULL,
	[PostEXTCount] [int] NULL,
	[PostEXTSales] [decimal](18, 4) NULL,
	[MDPCount] [int] NULL,
	[MDPSales] [decimal](18, 4) NULL,
	[Consultations_Budget] [int] NULL,
	[TradGradSales_Budget] [int] NULL,
	[NBApps_Budget] [int] NULL,
	[NetSalesWithoutPOSTEXT_Budget] [int] NULL,
	[NetRevenueWithoutSUR_Budget] [decimal](18, 4) NULL,
	[MDP_Budget] [int] NULL,
	[EXT_Budget] [int] NULL,
	[Surgery_Budget] [int] NULL,
	[Xtrands_Budget] [int] NULL,
	[XtrandsPlus_Budget] [int] NULL,
	[XtrandsPlusSalesMix] [decimal](18, 4) NULL,
	[NetNB1Count_Budget] [int] NULL,
	[NetNB1Sales_Budget] [decimal](18, 4) NULL,
	[LaserCount] [int] NULL,
	[LaserSales] [decimal](18, 4) NULL,
	[NBLaserCount] [int] NULL,
	[NBLaserSales] [decimal](18, 4) NULL,
	[PCPLaserCount] [int] NULL,
	[PCPLaserSales] [decimal](18, 4) NULL,
	[ClosingPercent] [decimal](18, 4) NULL,
	[ClosingPercent_Budget] [decimal](18, 4) NULL,
	[SalesMix_XP] [int] NULL,
	[SalesMix_EXT] [int] NULL,
	[SalesMix_SUR] [int] NULL,
	[SalesMix_XTR] [int] NULL,
	[SalesMix_MDP] [int] NULL,
	[SurgerySales] [decimal](18, 4) NULL,
	[SurgerySales_Budget] [decimal](18, 4) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_dbNewBusinessDashboard_Area_INCL] ON [dbo].[dbNewBusinessDashboard]
(
	[Area] ASC
)
INCLUDE([CenterNumber],[FullDate],[YearNumber],[MonthNumber],[MonthName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbNewBusinessDashboard_CenterNumber_INCL] ON [dbo].[dbNewBusinessDashboard]
(
	[CenterNumber] ASC
)
INCLUDE([Area],[FullDate],[YearNumber],[MonthNumber],[MonthName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
