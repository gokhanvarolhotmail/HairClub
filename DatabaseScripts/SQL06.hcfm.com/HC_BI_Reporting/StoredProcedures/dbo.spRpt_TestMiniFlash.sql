/***********************************************************************
PROCEDURE:				spRpt_TestMiniFlash
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

EXEC spRpt_TestMiniFlash 'C'
EXEC spRpt_TestMiniFlash 'F'
***********************************************************************/
CREATE PROCEDURE [dbo].spRpt_TestMiniFlash
(
	@CenterType CHAR(1)
)
AS
BEGIN

SET NOCOUNT ON;
SET FMTONLY OFF;


DECLARE	@CurrentDate DATETIME
,		@YesterdayStart DATETIME
,		@YesterdayEnd DATETIME
,		@CurrentMonthStart DATETIME
,		@CurrentMonthEnd DATETIME
,		@NextMonthStart DATETIME
,		@NextMonthEnd DATETIME
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@CurrentFiscalYearStart DATETIME
,		@CurrentFiscalYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @CurrentDate = GETDATE()

SET @YesterdayStart = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, @CurrentDate), 101))
SET @YesterdayEnd = @YesterdayStart

SET @CurrentMonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@YesterdayStart)) + '/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
SET @CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))


SET @NextMonthStart = DATEADD(mm, 1, DATEADD(mm, DATEDIFF(mm, 0, @CurrentDate), 0))
SET @NextMonthEnd = DATEADD(dd, -1, DATEADD(mm, DATEDIFF(mm, 0, DATEADD(MM, 1, @CurrentDate)) + 1, 0))
SET @NextMonthEnd = @NextMonthEnd


SET @CurrentYearStart = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
SET @CurrentYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentYearStart))

SET @CurrentFiscalYearStart = (SELECT CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(FullDate))) FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @YesterdayStart, 101)))
SET @CurrentFiscalYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentFiscalYearStart))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Date (
	DateID INT
,	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	SortOrder INT
)

CREATE TABLE #Center (
	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
)

CREATE TABLE #Sales (
	FullDate DATETIME
,	NB1Applications INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales DECIMAL(18, 4)
,	NetGradCount INT
,	NetGradSales DECIMAL(18, 4)
,	NetGrad6Count INT
,	NetGrad6Sales DECIMAL(18, 4)
,	NetGrad12Count INT
,	NetGrad12Sales DECIMAL(18, 4)
,	NetGrad6EZPAYCount INT
,	NetGrad6EZPAYSales DECIMAL(18, 4)
,	NetEXTCount INT
,	NetEXTSales DECIMAL(18, 4)
,	NetEXTInitialCount INT
,	NetEXTInitialSales DECIMAL(18, 4)
,	NetXtrCount INT
,	NetXtrSales DECIMAL(18, 4)
,	SurgeryCount INT
,	SurgerySales DECIMAL(18, 4)
,	AdditionalSurgerySales INT
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18, 4)
,	NetMDPCount INT
,	NetMDPSales DECIMAL(18, 4)
,	NetLaserCount INT
,	NetLaserSales DECIMAL(18, 4)
,	PCPSales DECIMAL(18, 4)
,	NetPCPSales DECIMAL(18, 4)
,	NetNB2Sales DECIMAL(18, 4)
,	ServiceSales DECIMAL(18, 4)
,	RetailSales DECIMAL(18, 4)
,	BIOConversions INT
,	EXTConversions INT
,	XTRConversions INT
,	TotalConversions INT
,	PCPCancels INT
,	PCPDowngrades INT
,	PCPUpgrades INT
,	EXMEMSales DECIMAL(18, 4)
,	NetRetailLaserCount INT
,	NetRetailLaserSales DECIMAL(18, 4)
)

CREATE TABLE #Receivables (
	FullDate DATETIME
,	Receivables INT
)

CREATE TABLE #Lead (
	FullDate DATETIME
,	Leads INT
)

CREATE TABLE #Task (
	FullDate DATETIME
,	Id NVARCHAR(18)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	ExcludeFromConsults INT
,	ExcludeFromBeBacks INT
,	BeBacksToExclude INT
)

CREATE TABLE #Activity (
	FullDate DATETIME
,	Appointments INT
,	Consultations INT
,	BeBacks INT
,	BeBacksToExclude INT
,	Shows INT
,	Sales INT
)

CREATE TABLE #Final (
	DateID INT
,	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	SortOrder INT
,	NB1Applications INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales DECIMAL(18, 4)
,	NetGradCount INT
,	NetGradSales DECIMAL(18, 4)
,	NetEXTCount INT
,	NetEXTSales DECIMAL(18, 4)
,	NetXtrCount INT
,	NetXtrSales DECIMAL(18, 4)
,	SurgeryCount INT
,	SurgerySales DECIMAL(18, 4)
,	AdditionalSurgerySales INT
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18, 4)
,	NetMDPCount INT
,	NetMDPSales DECIMAL(18, 4)
,	NetLaserCount INT
,	NetLaserSales DECIMAL(18, 4)
,	PCPSales DECIMAL(18, 4)
,	NetPCPSales DECIMAL(18, 4)
,	NetNB2Sales DECIMAL(18, 4)
,	ServiceSales DECIMAL(18, 4)
,	RetailSales DECIMAL(18, 4)
,	BIOConversions INT
,	EXTConversions INT
,	XTRConversions INT
,	TotalConversions INT
,	PCPCancels INT
,	PCPDowngrades INT
,	PCPUpgrades INT
,	EXMEMSales DECIMAL(18, 4)
,	Receivables INT
,	Leads INT
,	Appointments INT
,	Consultations INT
,	BeBacks INT
,	BeBacksToExclude INT
,	Shows INT
,	Sales INT
,	NetRetailLaserCount INT
,	NetRetailLaserSales DECIMAL(18, 4)
)


/********************************** Get Dates data *************************************/
INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (1, 'Day', 'Day', @YesterdayStart, @YesterdayEnd, 1)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (2, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentMonthStart, @YesterdayEnd, 2)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (3, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentFiscalYearStart, @YesterdayEnd, 3)


CREATE NONCLUSTERED INDEX IDX_Date_Dates ON #Date ( StartDate, EndDate );


SELECT	@MinDate = CAST(MIN(d.StartDate) AS DATE)
,		@MaxDate = CAST(MAX(d.EndDate) AS DATE)
FROM	#Date d


UPDATE	d
SET		d.DateDescFiscalYear = CASE WHEN d.DateID = 2 THEN DATENAME(MONTH, d.StartDate) ELSE 'FY' END + ' ' + CONVERT(VARCHAR, dd.FiscalYear)
FROM	#Date d
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.FullDate = d.StartDate
WHERE	d.DateID IN ( 2, 3 )


UPDATE STATISTICS #Date;


/********************************** Get Center data *************************************/
IF @CenterType = 'C'
BEGIN
	INSERT INTO #Center
			SELECT	ctr.CenterKey
			,		ctr.CenterSSID
			,		ctr.CenterNumber
			,		ctr.CenterDescription
			FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
						ON ct.CenterTypeSSID = ctr.CenterTypeSSID
			WHERE	ct.CenterTypeDescriptionShort = 'C'
					AND ( ctr.CenterNumber IN ( 360, 199 ) OR ctr.Active = 'Y' )
END


IF @CenterType = 'F'
BEGIN
	INSERT INTO #Center
			SELECT	ctr.CenterKey
			,		ctr.CenterSSID
			,		ctr.CenterNumber
			,		ctr.CenterDescription
			FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON ctr.CenterTypeSSID = CT.CenterTypeSSID
			WHERE	CT.CenterTypeDescriptionShort IN ( 'F', 'JV' )
					AND ctr.Active = 'Y'
END


CREATE NONCLUSTERED INDEX IDX_Center_CenterKey ON #Center ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


/********************************** Get Sales data *************************************/
INSERT  INTO #Sales
		SELECT	dd.FullDate
		,		SUM(ISNULL(fst.NB_AppsCnt, 0)) AS 'NB1Applications'
		,		( SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) + SUM(ISNULL(fst.NB_ExtCnt, 0)) + SUM(ISNULL(fst.S_PostExtCnt, 0)) + SUM(ISNULL(fst.NB_XTRCnt, 0)) + SUM(ISNULL(fst.S_SurCnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt, 0)) ) AS 'NetNB1Count'
		,		( SUM(ISNULL(fst.NB_TradAmt, 0)) + SUM(ISNULL(fst.NB_GradAmt, 0)) + SUM(ISNULL(fst.NB_ExtAmt, 0)) + SUM(ISNULL(fst.S_PostExtAmt, 0)) + SUM(ISNULL(fst.NB_XTRAmt, 0)) + SUM(ISNULL(fst.NB_MDPAmt, 0)) + SUM(ISNULL(fst.NB_LaserAmt, 0)) + SUM(ISNULL(fst.S_SurAmt, 0)) + SUM(ISNULL(fst.S_PRPAmt, 0))) AS 'NetNB1Sales'
		,		SUM(ISNULL(fst.NB_TradCnt, 0)) AS 'NetTradCount'
		,		SUM(ISNULL(fst.NB_TradAmt, 0)) AS 'NetTradSales'
		,		SUM(ISNULL(fst.NB_GradCnt, 0)) AS 'NetGradCount'
		,		SUM(ISNULL(fst.NB_GradAmt, 0)) AS 'NetGradSales'
		,		SUM(CASE WHEN m.MembershipDescriptionShort NOT IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12', 'GRDSVEZ' ) THEN ISNULL(FST.NB_GradCnt, 0) ELSE 0 END) AS 'NetGrad6Count'
		,		SUM(CASE WHEN m.MembershipDescriptionShort NOT IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12', 'GRDSVEZ' ) THEN ISNULL(FST.NB_GradAmt, 0) ELSE 0 END) AS 'NetGrad6Sales'
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12' ) THEN ISNULL(FST.NB_GradCnt, 0) ELSE 0 END) AS 'NetGrad12Count'
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'GRAD12', 'GRADSOL12', 'GRDSV12', 'GRDSVSOL12' ) THEN ISNULL(FST.NB_GradAmt, 0) ELSE 0 END) AS 'NetGrad12Sales'
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'GRDSVEZ' ) THEN ISNULL(FST.NB_GradCnt, 0) ELSE 0 END) AS 'NetGrad6EZPAYCount'  --Xtrands+ Initial 6 EZPAY
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'GRDSVEZ' ) THEN ISNULL(FST.NB_GradAmt, 0) ELSE 0 END) AS 'NetGrad6EZPAYSales'
		,		SUM(CASE WHEN m.MembershipDescriptionShort NOT IN ( 'EXTINITIAL' ) THEN ISNULL(fst.NB_ExtCnt, 0) ELSE 0 END) AS 'NetEXTCount'
		,		SUM(CASE WHEN m.MembershipDescriptionShort NOT IN ( 'EXTINITIAL' ) THEN ISNULL(fst.NB_ExtAmt, 0) ELSE 0 END) AS 'NetEXTSales'
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'EXTINITIAL' ) THEN ISNULL(fst.NB_ExtCnt, 0) ELSE 0 END) AS 'NetEXTInitialCount'
		,		SUM(CASE WHEN m.MembershipDescriptionShort IN ( 'EXTINITIAL' ) THEN ISNULL(fst.NB_ExtAmt, 0) ELSE 0 END) AS 'NetEXTInitialSales'
		,		SUM(ISNULL(fst.NB_XTRCnt, 0)) AS 'NetXtrCount'
		,		SUM(ISNULL(fst.NB_XTRAmt, 0)) AS 'NetXtrSales'
		,		SUM(ISNULL(fst.S_SurCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt, 0)) AS 'SurgeryCount'
		,		SUM(ISNULL(fst.S_SurAmt, 0)) + SUM(ISNULL(fst.S_PRPAmt, 0))AS 'SurgerySales'
		,		SUM(ISNULL(fst.SA_NetSalesCnt, 0)) AS 'AdditionalSurgerySales'
		,		SUM(ISNULL(fst.S_PostExtCnt, 0)) AS 'PostEXTCount'
		,		SUM(ISNULL(fst.S_PostExtAmt, 0)) AS 'PostEXTSales'
		,		SUM(ISNULL(fst.NB_MDPCnt, 0)) AS 'NetMDPCount'
		,		SUM(ISNULL(fst.NB_MDPAmt, 0)) AS 'NetMDPSales'
		,		SUM(ISNULL(fst.nb_LaserCnt, 0)) AS 'NetLaserCount'
		,		SUM(ISNULL(fst.nb_LaserAmt, 0)) AS 'NetLaserSales'
		,		SUM(ISNULL(fst.PCP_PCPAmt, 0)) AS 'PCPSales'
		,		SUM(ISNULL(fst.PCP_NB2Amt, 0)) AS 'NetPCPSales'
		,		SUM(ISNULL(fst.PCP_NB2Amt, 0)) - SUM(ISNULL(fst.PCP_PCPAmt, 0)) AS 'NetNB2Sales'
		,		SUM(ISNULL(fst.ServiceAmt, 0)) AS 'ServiceSales'
		,       SUM(CASE WHEN scd.SalesCodeDivisionSSID IN ( 30, 50 )AND sc.SalesCodeDepartmentSSID <> 3065 THEN ISNULL(fst.RetailAmt, 0) ELSE 0 END) AS 'RetailSales'
		,		SUM(ISNULL(fst.NB_BIOConvCnt, 0)) AS 'BIOConversions'
		,		SUM(ISNULL(fst.NB_ExtConvCnt, 0)) AS 'EXTConversions'
		,		SUM(ISNULL(fst.NB_XTRConvCnt, 0)) AS 'XTRConversions'
		,		SUM(ISNULL(fst.NB_BIOConvCnt, 0)) + SUM(ISNULL(fst.NB_ExtConvCnt, 0)) + SUM(ISNULL(fst.NB_XTRConvCnt, 0)) AS 'TotalConversions'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1099 AND m.RevenueGroupDescriptionShort = 'PCP' THEN 1 ELSE 0 END) AS 'PCPCancels'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1080 THEN 1 ELSE 0 END) AS 'PCPDowngrades'
		,		SUM(CASE WHEN sc.SalesCodeDepartmentSSID = 1070 THEN 1 ELSE 0 END) AS 'PCPUpgrades'
		,		SUM(fst.PCP_ExtMemAmt) AS 'EXMEMSales'
		,		SUM(ISNULL(fst.pcp_LaserCnt, 0)) AS 'NetRetailLaserCount'
		,		SUM(ISNULL(fst.pcp_LaserAmt, 0)) AS 'NetRetailLaserSales'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
					ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = cm.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = cm.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fst.ClientKey
		WHERE	dd.FullDate BETWEEN @MinDate AND @MaxDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND so.IsVoidedFlag = 0
		GROUP BY dd.FullDate



CREATE NONCLUSTERED INDEX IDX_Sales_FullDate ON #Sales ( FullDate );


UPDATE STATISTICS #Sales;


/********************************** Get Receivables data *************************************/
INSERT	INTO #Receivables
		SELECT	dd.FullDate
		,		SUM(ISNULL(fr.Balance, 0)) AS 'Receivables'
		FROM	HC_Accounting.dbo.FactReceivables fr
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fr.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fr.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
		WHERE	dd.FullDate = DATEADD(DAY, -1, @MaxDate)
				AND fr.Balance >= 0
		GROUP BY dd.FullDate


CREATE NONCLUSTERED INDEX IDX_Receivables_FullDate ON #Receivables ( FullDate );


UPDATE STATISTICS #Receivables;


/********************************** Get Lead data *************************************/
INSERT	INTO #Lead
		SELECT	CAST(l.ReportCreateDate__c AS DATE) AS 'FullDate'
		,		COUNT(l.Id) AS 'Leads'
		FROM	HC_BI_SFDC.dbo.Lead l
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(ISNULL(l.CenterNumber__c, l.CenterID__c), 100)
				OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
		WHERE	l.Status IN ( 'Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
				AND CAST(l.ReportCreateDate__c AS DATE) BETWEEN @MinDate AND @MaxDate
				AND ISNULL(l.IsDeleted, 0) = 0
				AND ISNULL(fil.IsInvalidLead, 0) = 0
		GROUP BY CAST(l.ReportCreateDate__c AS DATE)


CREATE NONCLUSTERED INDEX IDX_Lead_FullDate ON #Lead ( FullDate );

UPDATE STATISTICS #Lead;


/********************************** Get Task data *************************************/
INSERT	INTO #Task
		SELECT	CAST(t.ActivityDate AS DATE) AS 'FullDate'
		,		t.Id
		,		ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c), 100)
		,		c.CenterDescription
		,		t.Action__c
		,		t.Result__c
		,		t.SourceCode__c
		,		CASE WHEN (
							(
								t.Action__c = 'Be Back'
								OR	t.SourceCode__c IN ( 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSNCREF'
														, '4Q2016LWEXLD', 'REFEROTHER', 'IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF'
														, 'IPREFCLRERECA12476DP', 'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
														)
							)
							AND t.ActivityDate < '12/1/2020'
						) THEN 1
					ELSE 0
				END AS 'ExcludeFromConsults'
		,		CASE WHEN t.SourceCode__c IN ( 'CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSBIODMREF'
											, '4Q2016LWEXLD', 'REFEROTHER'
											) AND t.ActivityDate < '12/1/2020' THEN 1
					ELSE 0
				END AS 'ExcludeFromBeBacks'
		,		CASE WHEN ( t.Action__c = 'Be Back' AND t.ActivityDate < '12/1/2020' ) THEN 1
					ELSE 0
				END AS 'BeBacksToExclude'
		FROM	HC_BI_SFDC.dbo.Task t
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(ISNULL(t.CenterNumber__c, t.CenterID__c), 100)
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = t.WhoId
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a
					ON a.PersonContactId = t.WhoId
		WHERE	LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
				AND CAST(t.ActivityDate AS DATE) BETWEEN @MinDate AND @MaxDate
				AND ISNULL(t.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Task_FullDate ON #Task ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Task_Id ON #Task ( Id );
CREATE NONCLUSTERED INDEX IDX_Task_CenterNumber ON #Task ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Task_Action__c ON #Task ( Action__c );
CREATE NONCLUSTERED INDEX IDX_Task_Result__c ON #Task ( Result__c );
CREATE NONCLUSTERED INDEX IDX_Task_SourceCode ON #Task ( SourceCode );


UPDATE STATISTICS #Task;


/********************************** Get Activity data *************************************/
INSERT	INTO #Activity
		SELECT	t.FullDate
		,		SUM(CASE WHEN t.Action__c IN ( 'Appointment', 'In House', 'Recovery' ) AND ISNULL(t.Result__c, '') NOT IN ( 'Void', 'Cancel', 'Reschedule', 'Center Exception' ) THEN 1 ELSE 0 END) AS 'Appointments'
		,		SUM(CASE WHEN ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1 ELSE 0 END) AS 'Consultations'
		,		SUM(CASE WHEN t.Action__c IN ( 'Be Back' ) AND ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromBeBacks, 0) = 0 THEN 1 ELSE 0 END) AS 'BeBacks'
		,		SUM(CASE WHEN ISNULL(t.BeBacksToExclude, 0) = 1 THEN 1 ELSE 0 END) AS 'BeBacksToExclude'
		,		SUM(CASE WHEN ISNULL(t.Result__c, '') IN ( 'Show No Sale', 'Show Sale' ) THEN 1 ELSE 0 END) AS 'Shows'
		,		SUM(CASE WHEN ISNULL(t.Result__c, '') = 'Show Sale' THEN 1 ELSE 0 END) AS 'Sales'
		FROM	#Task t
		GROUP BY t.FullDate


CREATE NONCLUSTERED INDEX IDX_Activity_FullDate ON #Activity ( FullDate );


/********************************** Get Totals *************************************/
INSERT	INTO #Final
		SELECT  d.DateID
		,       d.DateDesc
		,       d.DateDescFiscalYear
		,       d.StartDate
		,       d.EndDate
		,       d.SortOrder
		,		(SELECT ISNULL(SUM(NB1Applications), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NB1Applications'
		,		(SELECT ISNULL(SUM(NetNB1Count), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNB1Count'
		,		(SELECT ISNULL(SUM(NetNB1Sales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNB1Sales'
		,		(SELECT ISNULL(SUM(NetTradCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetTradCount'
		,		(SELECT ISNULL(SUM(NetTradSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetTradSales'
		,		(SELECT ISNULL(SUM(NetGradCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetGradCount'
		,		(SELECT ISNULL(SUM(NetGradSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetGradSales'
		,		(SELECT ISNULL(SUM(NetEXTCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetEXTCount'
		,		(SELECT ISNULL(SUM(NetEXTSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetEXTSales'
		,		(SELECT ISNULL(SUM(NetXtrCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetXtrCount'
		,		(SELECT ISNULL(SUM(NetXtrSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetXtrSales'
		,		(SELECT ISNULL(SUM(SurgeryCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryCount'
		,		(SELECT ISNULL(SUM(SurgerySales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgerySales'
		,		(SELECT ISNULL(SUM(AdditionalSurgerySales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'AdditionalSurgerySales'
		,		(SELECT ISNULL(SUM(PostEXTCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PostEXTCount'
		,		(SELECT ISNULL(SUM(PostEXTSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PostEXTSales'
		,		(SELECT ISNULL(SUM(NetMDPCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetMDPCount'
		,		(SELECT ISNULL(SUM(NetMDPSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetMDPSales'
		,		(SELECT ISNULL(SUM(NetLaserCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetLaserCount'
		,		(SELECT ISNULL(SUM(NetLaserSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetLaserSales'
		,		(SELECT ISNULL(SUM(PCPSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PCPSales'
		,		(SELECT ISNULL(SUM(NetPCPSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetPCPSales'
		,		(SELECT ISNULL(SUM(NetNB2Sales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetNB2Sales'
		,		(SELECT ISNULL(SUM(ServiceSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'ServiceSales'
		,		(SELECT ISNULL(SUM(RetailSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'RetailSales'
		,		(SELECT ISNULL(SUM(BIOConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BIOConversions'
		,		(SELECT ISNULL(SUM(EXTConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'EXTConversions'
		,		(SELECT ISNULL(SUM(XTRConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'XTRConversions'
		,		(SELECT ISNULL(SUM(TotalConversions), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'TotalConversions'
		,		(SELECT ISNULL(SUM(PCPCancels), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PCPCancels'
		,		(SELECT ISNULL(SUM(PCPDowngrades), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PCPDowngrades'
		,		(SELECT ISNULL(SUM(PCPUpgrades), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PCPUpgrades'
		,		(SELECT ISNULL(SUM(EXMEMSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'EXMEMSales'
		,		(SELECT ISNULL(SUM(Receivables), 0) FROM #Receivables r WHERE r.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Receivables'
		,		(SELECT ISNULL(SUM(Leads), 0) FROM #Lead l WHERE l.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Leads'
		,		(SELECT ISNULL(SUM(Appointments), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Appointments'
		,		(SELECT ISNULL(SUM(Consultations), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Consultations'
		,		(SELECT ISNULL(SUM(BeBacks), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BeBacks'
		,		(SELECT ISNULL(SUM(a.BeBacksToExclude), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BeBacksToExclude'
		,		(SELECT ISNULL(SUM(Shows), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Shows'
		,		(SELECT ISNULL(SUM(Sales), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Sales'
		,		(SELECT ISNULL(SUM(NetRetailLaserCount), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetRetailLaserCount'
		,		(SELECT ISNULL(SUM(NetRetailLaserSales), 0) FROM #Sales s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetRetailLaserSales'
		FROM    #Date d


UPDATE STATISTICS #Final;


/********************************** Return Final Data *************************************/
SELECT	f.DateID
,		f.DateDesc
,		f.DateDescFiscalYear
,		f.StartDate
,		f.EndDate
,		f.SortOrder
,		f.NB1Applications AS 'Applications'
,		f.NetNB1Count AS 'NetNB1Sales'
,		f.NetNB1Sales AS 'NetNB1Revenue'
,		f.NetTradCount AS 'TraditionalSales'
,		f.NetTradSales AS 'TraditionalRevenue'
,		f.NetGradCount AS 'GradualSales'
,		f.NetGradSales AS 'GradualRevenue'
,		f.NetEXTCount AS 'EXTSales'
,		f.NetEXTSales AS 'EXTRevenue'
,		f.NetXtrCount AS 'XtrandsSales'
,		f.NetXtrSales AS 'XtrandsRevenue'
,		f.SurgeryCount AS 'SurgerySales'
,		f.SurgerySales AS 'SurgeryRevenue'
,		f.AdditionalSurgerySales AS 'AddtlSurgery'
,		f.PostEXTCount AS 'PostEXTSales'
,		f.PostEXTSales AS 'PostEXTRevenue'
,		f.NetMDPCount AS 'MDPCount'
,		f.NetMDPSales AS 'MDPAmount'
,		f.NetLaserCount AS 'LaserCount'
,		f.NetLaserSales AS 'LaserAmount'
,		f.PCPSales AS 'PCPRevenue'
,		f.NetPCPSales AS 'PCPTotalRevenue'
,		f.NetNB2Sales AS 'NB2Revenue'
,		f.ServiceSales AS 'ServiceRevenue'
,		f.RetailSales AS 'RetailRevenue'
,		f.BIOConversions AS 'BIOConversion'
,		f.EXTConversions AS 'EXTConversion'
,		f.XTRConversions AS 'XTRConversion'
,		f.TotalConversions AS 'TotalConversion'
,		f.PCPCancels
,		f.PCPDowngrades
,		f.PCPUpgrades
,		f.EXMEMSales AS 'EXEMEMRevenue'
,		f.Receivables
,		f.Leads
,		f.Appointments
,		f.Consultations
,		f.BeBacks
,		f.BeBacksToExclude
,		f.Shows
,		f.Sales
,		f.NetRetailLaserCount AS 'RetailLaserCount'
,		f.NetRetailLaserSales AS 'RetailLaserAmount'
FROM	#Final f
ORDER BY f.SortOrder

END
