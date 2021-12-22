/* CreateDate: 03/18/2021 13:18:36.840 , ModifyDate: 03/19/2021 13:29:50.670 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_PopulateDailyFlashVariance
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		2/11/2021
DESCRIPTION:			2/11/2021
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_PopulateDailyFlashVariance
***********************************************************************/
CREATE PROCEDURE [dbo].spSvc_PopulateDailyFlashVariance
AS
BEGIN

SET NOCOUNT ON;
SET FMTONLY OFF;


CREATE TABLE #DailyFlashSummary (
	ReportDate DATE
,	DateID INT
,	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	SortOrder INT
,	BudgetLeads DECIMAL(18, 4)
,	Leads INT
,	LeadsVariance DECIMAL(19, 4)
,	BudgetAppointments DECIMAL(18, 4)
,	Appointments INT
,	AppointmentsVariance DECIMAL(19, 4)
,	BudgetConsultations DECIMAL(18, 4)
,	Consultations INT
,	ConsultationsVariance DECIMAL(19, 4)
,	InPersonConsultations INT
,	VirtualConsultations INT
,	BudgetGrossNB1Count DECIMAL(18, 4)
,	GrossNB1Count INT
,	GrossNB1CountVariance DECIMAL(19, 4)
,	BudgetNetNB1Count DECIMAL(18, 4)
,	NetNB1Count INT
,	NetNB1CountVariance DECIMAL(19, 4)
,	BudgetNetNB1Sales DECIMAL(18, 4)
,	NetNB1Sales DECIMAL(18, 4)
,	NetNB1SalesVariance DECIMAL(19, 4)
,	BudgetNB1DollarPerSale DECIMAL(18, 4)
,	NB1DollarPerSale DECIMAL(18, 4)
,	NB1DollarPerSaleVariance DECIMAL(19, 4)
,	BudgetXtrandsPlusCount DECIMAL(18, 4)
,	XtrandsPlusCount INT
,	XtrandsPlusCountVariance DECIMAL(19, 4)
,	BudgetXtrandsPlusSales DECIMAL(18, 4)
,	XtrandsPlusSales DECIMAL(19, 4)
,	XtrandsPlusSalesVariance DECIMAL(20, 4)
,	BudgetXtrandsPlusConversionsCount DECIMAL(18, 4)
,	XtrandsPlusConversionsCount INT
,	XtrandsPlusConversionsCountVariance DECIMAL(19, 4)
,	BudgetXtrandsCount DECIMAL(18, 4)
,	XtrandsCount INT
,	XtrandsCountVariance DECIMAL(19, 4)
,	BudgetXtrandsSales DECIMAL(18, 4)
,	XtrandsSales DECIMAL(18, 4)
,	XtrandsSalesVariance DECIMAL(19, 4)
,	BudgetXtrandsConversionCount DECIMAL(18, 4)
,	XtrandsConversionsCount INT
,	XtrandsConversionsCountVariance DECIMAL(19, 4)
,	BudgetEXTCount DECIMAL(18, 4)
,	EXTCount INT
,	EXTCountVariance DECIMAL(19, 4)
,	BudgetEXTSales DECIMAL(18, 4)
,	EXTSales DECIMAL(19, 4)
,	EXTSalesVariance DECIMAL(20, 4)
,	BudgetEXTConversionCount DECIMAL(18, 4)
,	EXTConversionsCount INT
,	EXTConversionsCountVariance DECIMAL(19, 4)
,	BudgetSurgeryCount DECIMAL(18, 4)
,	SurgeryCount INT
,	SurgeryCountVariance DECIMAL(19, 4)
,	BudgetSurgerySales DECIMAL(18, 4)
,	SurgerySales DECIMAL(18, 4)
,	SurgerySalesVariance DECIMAL(19, 4)
,	BudgetRestorInkCount DECIMAL(18, 4)
,	RestorInkCount INT
,	RestorInkCountVariance DECIMAL(19, 4)
,	BudgetRestorInkSales DECIMAL(18, 4)
,	RestorInkSales DECIMAL(18, 4)
,	RestorInkSalesVariance DECIMAL(19, 4)
,	BudgetApplicationsCount DECIMAL(18, 4)
,	ApplicationsCount INT
,	ApplicationsCountVariance DECIMAL(19, 4)
,	BudgetConversionsCount DECIMAL(18, 4)
,	ConversionsCount INT
,	ConversionsCountVariance DECIMAL(19, 4)
,	BudgetNetPCPSales DECIMAL(18, 4)
,	NetPCPSales DECIMAL(18, 4)
,	NetPCPSalesVariance DECIMAL(19, 4)
,	BudgetLaserSales DECIMAL(18, 4)
,	LaserSales DECIMAL(18, 4)
,	LaserSalesVariance DECIMAL(19, 4)
,	BudgetNonProgramSales DECIMAL(18, 4)
,	NonProgramSales DECIMAL(18, 4)
,	NonProgramSalesVariance DECIMAL(19, 4)
,	BudgetServiceSales DECIMAL(18, 4)
,	ServiceSales DECIMAL(18, 4)
,	ServiceSalesVariance DECIMAL(19, 4)
,	BudgetRetailSales DECIMAL(18, 4)
,	RetailSales DECIMAL(18, 4)
,	RetailSalesVariance DECIMAL(19, 4)
,	Receivables INT
,	ReceivablesClientCount INT
,	NBCancels INT
,	PCPCancels INT
,	TotalCancels INT
)

CREATE TABLE #DailyFlashVariance (
	ReportDate DATETIME
,	ReportPeriod NVARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	Metric NVARCHAR(50)
,	Actual DECIMAL(18,4)
,	Target DECIMAL(18,4)
,	Variance DECIMAL(18,4)
,	SortOrder INT
)


/********************************** Get Daily Flash Summary data *************************************/
INSERT	INTO #DailyFlashSummary
		SELECT	dfs.ReportDate
		,		dfs.DateID
		,		dfs.DateDesc
		,		dfs.DateDescFiscalYear
		,		dfs.StartDate
		,		dfs.EndDate
		,		dfs.SortOrder
		,		dfs.BudgetLeads
		,		dfs.Leads
		,		dfs.LeadsVariance
		,		dfs.BudgetAppointments
		,		dfs.Appointments
		,		dfs.AppointmentsVariance
		,		dfs.BudgetConsultations
		,		dfs.Consultations
		,		dfs.ConsultationsVariance
		,		dfs.InPersonConsultations
		,		dfs.VirtualConsultations
		,		dfs.BudgetGrossNB1Count
		,		dfs.GrossNB1Count
		,		dfs.GrossNB1CountVariance
		,		dfs.BudgetNetNB1Count
		,		dfs.NetNB1Count
		,		dfs.NetNB1CountVariance
		,		dfs.BudgetNetNB1Sales
		,		dfs.NetNB1Sales
		,		dfs.NetNB1SalesVariance
		,		dfs.BudgetNB1DollarPerSale
		,		dfs.NB1DollarPerSale
		,		dfs.NB1DollarPerSaleVariance
		,		dfs.BudgetXtrandsPlusCount
		,		dfs.XtrandsPlusCount
		,		dfs.XtrandsPlusCountVariance
		,		dfs.BudgetXtrandsPlusSales
		,		dfs.XtrandsPlusSales
		,		dfs.XtrandsPlusSalesVariance
		,		dfs.BudgetXtrandsPlusConversionsCount
		,		dfs.XtrandsPlusConversionsCount
		,		dfs.XtrandsPlusConversionsCountVariance
		,		dfs.BudgetXtrandsCount
		,		dfs.XtrandsCount
		,		dfs.XtrandsCountVariance
		,		dfs.BudgetXtrandsSales
		,		dfs.XtrandsSales
		,		dfs.XtrandsSalesVariance
		,		dfs.BudgetXtrandsConversionCount
		,		dfs.XtrandsConversionsCount
		,		dfs.XtrandsConversionsCountVariance
		,		dfs.BudgetEXTCount
		,		dfs.EXTCount
		,		dfs.EXTCountVariance
		,		dfs.BudgetEXTSales
		,		dfs.EXTSales
		,		dfs.EXTSalesVariance
		,		dfs.BudgetEXTConversionCount
		,		dfs.EXTConversionsCount
		,		dfs.EXTConversionsCountVariance
		,		dfs.BudgetSurgeryCount
		,		dfs.SurgeryCount
		,		dfs.SurgeryCountVariance
		,		dfs.BudgetSurgerySales
		,		dfs.SurgerySales
		,		dfs.SurgerySalesVariance
		,		dfs.BudgetRestorInkCount
		,		dfs.RestorInkCount
		,		dfs.RestorInkCountVariance
		,		dfs.BudgetRestorInkSales
		,		dfs.RestorInkSales
		,		dfs.RestorInkSalesVariance
		,		dfs.BudgetApplicationsCount
		,		dfs.ApplicationsCount
		,		dfs.ApplicationsCountVariance
		,		dfs.BudgetConversionsCount
		,		dfs.ConversionsCount
		,		dfs.ConversionsCountVariance
		,		dfs.BudgetNetPCPSales
		,		dfs.NetPCPSales
		,		dfs.NetPCPSalesVariance
		,		dfs.BudgetLaserSales
		,		dfs.LaserSales
		,		dfs.LaserSalesVariance
		,		dfs.BudgetNonProgramSales
		,		dfs.NonProgramSales
		,		dfs.NonProgramSalesVariance
		,		dfs.BudgetServiceSales
		,		dfs.ServiceSales
		,		dfs.ServiceSalesVariance
		,		dfs.BudgetRetailSales
		,		dfs.RetailSales
		,		dfs.RetailSalesVariance
		,		dfs.Receivables
		,		dfs.ReceivablesClientCount
		,		dfs.NBCancels
		,		dfs.PCPCancels
		,		dfs.TotalCancels
		FROM	datDailyFlashSummary dfs
		WHERE	dfs.DateDesc = 'Full Month'


UPDATE STATISTICS #DailyFlashSummary;


/********************************** Get Daily Flash Variance data *************************************/
INSERT	INTO #DailyFlashVariance
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Leads' AS 'Metric'
		,		dfs.Leads AS 'Actual'
		,		dfs.BudgetLeads AS 'Target'
		,		dfs.LeadsVariance AS 'Variance'
		,		1 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.LeadsVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Appointments' AS 'Metric'
		,		dfs.Appointments AS 'Actual'
		,		dfs.BudgetAppointments AS 'Target'
		,		dfs.AppointmentsVariance AS 'Variance'
		,		2 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.AppointmentsVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Consultations' AS 'Metric'
		,		dfs.Consultations AS 'Actual'
		,		dfs.BudgetConsultations AS 'Target'
		,		dfs.ConsultationsVariance AS 'Variance'
		,		3 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.ConsultationsVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Net NB #' AS 'Metric'
		,		dfs.NetNB1Count AS 'Actual'
		,		dfs.BudgetNetNB1Count AS 'Target'
		,		dfs.NetNB1CountVariance AS 'Variance'
		,		4 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.NetNB1CountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Net NB $' AS 'Metric'
		,		dfs.NetNB1Sales AS 'Actual'
		,		dfs.BudgetNetNB1Sales AS 'Target'
		,		dfs.NetNB1SalesVariance AS 'Variance'
		,		5 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.NetNB1SalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'NB $/Sale' AS 'Metric'
		,		dfs.NB1DollarPerSale AS 'Actual'
		,		dfs.BudgetNB1DollarPerSale AS 'Target'
		,		dfs.NB1DollarPerSaleVariance AS 'Variance'
		,		6 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.NB1DollarPerSaleVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Retail $' AS 'Metric'
		,		dfs.RetailSales AS 'Actual'
		,		dfs.BudgetRetailSales AS 'Target'
		,		dfs.RetailSalesVariance AS 'Variance'
		,		7 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.RetailSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Conversions #' AS 'Metric'
		,		dfs.ConversionsCount AS 'Actual'
		,		dfs.BudgetConversionsCount AS 'Target'
		,		dfs.ConversionsCountVariance AS 'Variance'
		,		8 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.ConversionsCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Net PCP $' AS 'Metric'
		,		dfs.NetPCPSales AS 'Actual'
		,		dfs.BudgetNetPCPSales AS 'Target'
		,		dfs.NetPCPSalesVariance AS 'Variance'
		,		9 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.NetPCPSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Net PCP Receivables $' AS 'Metric'
		,		dfs.Receivables AS 'Actual'
		,		0 AS 'Target'
		,		dfs.Receivables AS 'Variance'
		,		10 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.Receivables > 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Xtrands+ #' AS 'Metric'
		,		dfs.XtrandsPlusCount AS 'Actual'
		,		dfs.BudgetXtrandsPlusCount AS 'Target'
		,		dfs.XtrandsPlusCountVariance AS 'Variance'
		,		11 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.XtrandsPlusCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Xtrands+ $' AS 'Metric'
		,		dfs.XtrandsPlusSales AS 'Actual'
		,		dfs.BudgetXtrandsPlusSales AS 'Target'
		,		dfs.XtrandsPlusSalesVariance AS 'Variance'
		,		12 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.XtrandsPlusSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Xtrands+ Conversions #' AS 'Metric'
		,		dfs.XtrandsPlusConversionsCount AS 'Actual'
		,		dfs.BudgetXtrandsPlusConversionsCount AS 'Target'
		,		dfs.XtrandsPlusConversionsCountVariance AS 'Variance'
		,		13 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.XtrandsPlusConversionsCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Xtrands #' AS 'Metric'
		,		dfs.XtrandsCount AS 'Actual'
		,		dfs.BudgetXtrandsCount AS 'Target'
		,		dfs.XtrandsCountVariance AS 'Variance'
		,		14 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.XtrandsCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Xtrands $' AS 'Metric'
		,		dfs.XtrandsSales AS 'Actual'
		,		dfs.BudgetXtrandsSales AS 'Target'
		,		dfs.XtrandsSalesVariance AS 'Variance'
		,		15 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.XtrandsSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Xtrands Conversions #' AS 'Metric'
		,		dfs.XtrandsConversionsCount AS 'Actual'
		,		dfs.BudgetXtrandsConversionCount AS 'Target'
		,		dfs.XtrandsConversionsCountVariance AS 'Variance'
		,		16 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.BudgetXtrandsConversionCount < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'EXT #' AS 'Metric'
		,		dfs.EXTCount AS 'Actual'
		,		dfs.BudgetEXTCount AS 'Target'
		,		dfs.EXTCountVariance AS 'Variance'
		,		17 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.EXTCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'EXT $' AS 'Metric'
		,		dfs.EXTSales AS 'Actual'
		,		dfs.BudgetEXTSales AS 'Target'
		,		dfs.EXTSalesVariance AS 'Variance'
		,		18 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.EXTSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'EXT Conversions #' AS 'Metric'
		,		dfs.EXTConversionsCount AS 'Actual'
		,		dfs.BudgetEXTConversionCount AS 'Target'
		,		dfs.EXTConversionsCountVariance AS 'Variance'
		,		19 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.EXTConversionsCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Surgery #' AS 'Metric'
		,		dfs.SurgeryCount AS 'Actual'
		,		dfs.BudgetSurgeryCount AS 'Target'
		,		dfs.SurgeryCountVariance AS 'Variance'
		,		20 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.SurgeryCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Surgery $' AS 'Metric'
		,		dfs.SurgerySales AS 'Actual'
		,		dfs.BudgetSurgerySales AS 'Target'
		,		dfs.SurgerySalesVariance AS 'Variance'
		,		21 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.SurgerySalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'RestorInk #' AS 'Metric'
		,		dfs.RestorInkCount AS 'Actual'
		,		dfs.BudgetRestorInkCount AS 'Target'
		,		dfs.RestorInkCountVariance AS 'Variance'
		,		22 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.RestorInkCountVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'RestorInk $' AS 'Metric'
		,		dfs.RestorInkSales AS 'Actual'
		,		dfs.BudgetRestorInkSales AS 'Target'
		,		dfs.RestorInkSalesVariance AS 'Variance'
		,		23 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.RestorInkSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Laser $' AS 'Metric'
		,		dfs.LaserSales AS 'Actual'
		,		dfs.BudgetLaserSales AS 'Target'
		,		dfs.LaserSalesVariance AS 'Variance'
		,		24 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.LaserSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Non-Progam $' AS 'Metric'
		,		dfs.NonProgramSales AS 'Actual'
		,		dfs.BudgetNonProgramSales AS 'Target'
		,		dfs.NonProgramSalesVariance AS 'Variance'
		,		25 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.NonProgramSalesVariance < 0
		UNION
		SELECT	dfs.ReportDate
		,		dfs.DateDesc AS 'ReportPeriod'
		,		dfs.StartDate
		,		dfs.EndDate
		,		'Service $' AS 'Metric'
		,		dfs.ServiceSales AS 'Actual'
		,		dfs.BudgetServiceSales AS 'Target'
		,		dfs.ServiceSalesVariance AS 'Variance'
		,		26 AS 'SortOrder'
		FROM	#DailyFlashSummary dfs
		WHERE	dfs.ServiceSalesVariance < 0


/********************************** Save Final Data *************************************/
TRUNCATE TABLE datDailyFlashVariance


INSERT	INTO datDailyFlashVariance
		SELECT	dfv.ReportDate
		,		dfv.ReportPeriod
		,		dfv.StartDate
		,		dfv.EndDate
		,		dfv.Metric
		,		dfv.Actual
		,		dfv.Target
		,		dfv.Variance
		,		dfv.SortOrder
		FROM	#DailyFlashVariance dfv
		ORDER BY dfv.SortOrder

END
GO
