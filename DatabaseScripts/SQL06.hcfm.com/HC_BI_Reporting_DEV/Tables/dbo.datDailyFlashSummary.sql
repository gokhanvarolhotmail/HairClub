/* CreateDate: 05/25/2021 13:34:13.587 , ModifyDate: 05/25/2021 13:34:13.587 */
GO
CREATE TABLE [dbo].[datDailyFlashSummary](
	[ReportDate] [date] NULL,
	[DateID] [int] NULL,
	[DateDesc] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateDescFiscalYear] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[SortOrder] [int] NULL,
	[BudgetLeads] [decimal](18, 4) NULL,
	[Leads] [int] NULL,
	[LeadsVariance] [decimal](19, 4) NULL,
	[BudgetAppointments] [decimal](18, 4) NULL,
	[Appointments] [int] NULL,
	[AppointmentsVariance] [decimal](19, 4) NULL,
	[BudgetConsultations] [decimal](18, 4) NULL,
	[Consultations] [int] NULL,
	[ConsultationsVariance] [decimal](19, 4) NULL,
	[InPersonConsultations] [int] NULL,
	[VirtualConsultations] [int] NULL,
	[BudgetGrossNB1Count] [decimal](18, 4) NULL,
	[GrossNB1Count] [int] NULL,
	[GrossNB1CountVariance] [decimal](19, 4) NULL,
	[BudgetNetNB1Count] [decimal](18, 4) NULL,
	[NetNB1Count] [int] NULL,
	[NetNB1CountVariance] [decimal](19, 4) NULL,
	[BudgetNetNB1Sales] [decimal](18, 4) NULL,
	[NetNB1Sales] [decimal](18, 4) NULL,
	[NetNB1SalesVariance] [decimal](19, 4) NULL,
	[BudgetNB1DollarPerSale] [decimal](18, 4) NULL,
	[NB1DollarPerSale] [decimal](18, 4) NULL,
	[NB1DollarPerSaleVariance] [decimal](19, 4) NULL,
	[BudgetXtrandsPlusCount] [decimal](18, 4) NULL,
	[XtrandsPlusCount] [int] NULL,
	[XtrandsPlusCountVariance] [decimal](19, 4) NULL,
	[BudgetXtrandsPlusSales] [decimal](18, 4) NULL,
	[XtrandsPlusSales] [decimal](19, 4) NULL,
	[XtrandsPlusSalesVariance] [decimal](20, 4) NULL,
	[BudgetXtrandsPlusConversionsCount] [decimal](18, 4) NULL,
	[XtrandsPlusConversionsCount] [int] NULL,
	[XtrandsPlusConversionsCountVariance] [decimal](19, 4) NULL,
	[BudgetXtrandsCount] [decimal](18, 4) NULL,
	[XtrandsCount] [int] NULL,
	[XtrandsCountVariance] [decimal](19, 4) NULL,
	[BudgetXtrandsSales] [decimal](18, 4) NULL,
	[XtrandsSales] [decimal](18, 4) NULL,
	[XtrandsSalesVariance] [decimal](19, 4) NULL,
	[BudgetXtrandsConversionCount] [decimal](18, 4) NULL,
	[XtrandsConversionsCount] [int] NULL,
	[XtrandsConversionsCountVariance] [decimal](19, 4) NULL,
	[BudgetEXTCount] [decimal](18, 4) NULL,
	[EXTCount] [int] NULL,
	[EXTCountVariance] [decimal](19, 4) NULL,
	[BudgetEXTSales] [decimal](18, 4) NULL,
	[EXTSales] [decimal](19, 4) NULL,
	[EXTSalesVariance] [decimal](20, 4) NULL,
	[BudgetEXTConversionCount] [decimal](18, 4) NULL,
	[EXTConversionsCount] [int] NULL,
	[EXTConversionsCountVariance] [decimal](19, 4) NULL,
	[BudgetSurgeryCount] [decimal](18, 4) NULL,
	[SurgeryCount] [int] NULL,
	[SurgeryCountVariance] [decimal](19, 4) NULL,
	[BudgetSurgerySales] [decimal](18, 4) NULL,
	[SurgerySales] [decimal](18, 4) NULL,
	[SurgerySalesVariance] [decimal](19, 4) NULL,
	[BudgetRestorInkCount] [decimal](18, 4) NULL,
	[RestorInkCount] [int] NULL,
	[RestorInkCountVariance] [decimal](19, 4) NULL,
	[BudgetRestorInkSales] [decimal](18, 4) NULL,
	[RestorInkSales] [decimal](18, 4) NULL,
	[RestorInkSalesVariance] [decimal](19, 4) NULL,
	[BudgetApplicationsCount] [decimal](18, 4) NULL,
	[ApplicationsCount] [int] NULL,
	[ApplicationsCountVariance] [decimal](19, 4) NULL,
	[BudgetConversionsCount] [decimal](18, 4) NULL,
	[ConversionsCount] [int] NULL,
	[ConversionsCountVariance] [decimal](19, 4) NULL,
	[BudgetNetPCPSales] [decimal](18, 4) NULL,
	[NetPCPSales] [decimal](18, 4) NULL,
	[NetPCPSalesVariance] [decimal](19, 4) NULL,
	[BudgetLaserSales] [decimal](18, 4) NULL,
	[NBLaserSales] [decimal](18, 4) NULL,
	[PCPLaserSales] [decimal](18, 4) NULL,
	[LaserSales] [decimal](18, 4) NULL,
	[LaserSalesVariance] [decimal](19, 4) NULL,
	[BudgetNonProgramSales] [decimal](18, 4) NULL,
	[NonProgramSales] [decimal](18, 4) NULL,
	[NonProgramSalesVariance] [decimal](19, 4) NULL,
	[BudgetServiceSales] [decimal](18, 4) NULL,
	[ServiceSales] [decimal](18, 4) NULL,
	[ServiceSalesVariance] [decimal](19, 4) NULL,
	[BudgetRetailSales] [decimal](18, 4) NULL,
	[RetailSales] [decimal](18, 4) NULL,
	[RetailSalesVariance] [decimal](19, 4) NULL,
	[Royalty] [decimal](19, 4) NULL,
	[Receivables] [int] NULL,
	[ReceivablesClientCount] [int] NULL,
	[NBCancels] [int] NULL,
	[PCPCancels] [int] NULL,
	[TotalCancels] [int] NULL
) ON [PRIMARY]
GO
