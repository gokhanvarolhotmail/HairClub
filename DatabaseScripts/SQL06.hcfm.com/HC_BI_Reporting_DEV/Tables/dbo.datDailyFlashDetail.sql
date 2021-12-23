/* CreateDate: 03/18/2021 14:16:08.957 , ModifyDate: 03/18/2021 14:16:08.957 */
GO
CREATE TABLE [dbo].[datDailyFlashDetail](
	[FullDate] [datetime] NULL,
	[DayOfWeekName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BudgetLeads] [decimal](18, 4) NULL,
	[Leads] [int] NULL,
	[BudgetAppointments] [decimal](18, 4) NULL,
	[Appointments] [int] NULL,
	[BudgetConsultations] [decimal](18, 4) NULL,
	[Consultations] [int] NULL,
	[InPersonConsultations] [int] NULL,
	[VirtualConsultations] [int] NULL,
	[BudgetGrossNB1Count] [decimal](18, 4) NULL,
	[GrossNB1Count] [int] NULL,
	[BudgetNetNB1Count] [decimal](18, 4) NULL,
	[NetNB1Count] [int] NULL,
	[BudgetNetNB1Sales] [decimal](18, 4) NULL,
	[NetNB1Sales] [decimal](18, 4) NULL,
	[BudgetNB1DollarPerSale] [decimal](18, 4) NULL,
	[NB1DollarPerSale] [decimal](18, 4) NULL,
	[NB1DollarPerSaleVariance] [decimal](19, 4) NULL,
	[BudgetXtrandsPlusCount] [decimal](18, 4) NULL,
	[XtrandsPlusCount] [int] NULL,
	[BudgetXtrandsPlusSales] [decimal](18, 4) NULL,
	[XtrandsPlusSales] [decimal](19, 4) NULL,
	[BudgetXtrandsPlusConversionsCount] [decimal](18, 4) NULL,
	[XtrandsPlusConversionsCount] [int] NULL,
	[BudgetXtrandsCount] [decimal](18, 4) NULL,
	[XtrandsCount] [int] NULL,
	[BudgetXtrandsSales] [decimal](18, 4) NULL,
	[XtrandsSales] [decimal](18, 4) NULL,
	[BudgetXtrandsConversionCount] [decimal](18, 4) NULL,
	[XtrandsConversionsCount] [int] NULL,
	[BudgetEXTCount] [decimal](18, 4) NULL,
	[EXTCount] [int] NULL,
	[BudgetEXTSales] [decimal](18, 4) NULL,
	[EXTSales] [decimal](19, 4) NULL,
	[BudgetEXTConversionCount] [decimal](18, 4) NULL,
	[EXTConversionsCount] [int] NULL,
	[BudgetSurgeryCount] [decimal](18, 4) NULL,
	[SurgeryCount] [int] NULL,
	[BudgetSurgerySales] [decimal](18, 4) NULL,
	[SurgerySales] [decimal](18, 4) NULL,
	[BudgetRestorInkCount] [decimal](18, 4) NULL,
	[RestorInkCount] [int] NULL,
	[BudgetRestorInkSales] [decimal](18, 4) NULL,
	[RestorInkSales] [decimal](18, 4) NULL,
	[BudgetApplicationsCount] [decimal](18, 4) NULL,
	[ApplicationsCount] [int] NULL,
	[BudgetConversionsCount] [decimal](18, 4) NULL,
	[ConversionsCount] [int] NULL,
	[BudgetNetPCPSales] [decimal](18, 4) NULL,
	[NetPCPSales] [decimal](18, 4) NULL,
	[BudgetLaserSales] [decimal](18, 4) NULL,
	[LaserSales] [decimal](18, 4) NULL,
	[BudgetNonProgramSales] [decimal](18, 4) NULL,
	[NonProgramSales] [decimal](18, 4) NULL,
	[BudgetServiceSales] [decimal](18, 4) NULL,
	[ServiceSales] [decimal](18, 4) NULL,
	[BudgetRetailSales] [decimal](18, 4) NULL,
	[RetailSales] [decimal](18, 4) NULL,
	[NBCancels] [int] NULL,
	[PCPCancels] [int] NULL,
	[TotalCancels] [int] NULL
) ON [PRIMARY]
GO