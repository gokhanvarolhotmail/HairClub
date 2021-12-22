/* CreateDate: 09/06/2018 16:24:08.720 , ModifyDate: 02/21/2020 16:39:40.757 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_BosleyMiniFlash
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/6/2018
DESCRIPTION:			9/6/2018
------------------------------------------------------------------------
NOTES:

09/14/2018 - RH - (Case 389) Changed to WHERE SourceName LIKE 'BOS%REF%' AND RIGHT(SourceName,1) <> '-'
09/21/2018 - DL - Source Code query still had WHERE SourceName LIKE 'BOSREF%'. Changed it to match comment above 'BOS%REF%'
09/27/2018 - DL - Added AND ds.SourceSSID <> 'BOSOHREF'
07/25/2018 - DL - Changed BOS to HC Leads removing BOSNCREF from Omaha, Portland and Annapolis
01/13/2020 - JL - Remove Bosley Consult from leads, appointments & consultation count TrackIT 5322
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_BosleyMiniFlash 'C'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_BosleyMiniFlash]
(
	@CenterType CHAR(1)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


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
SET @YesterdayEnd = @YesterdayStart + ' 23:59:59'

SET @CurrentMonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@YesterdayStart)) + '/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
SET @CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))


SET @NextMonthStart = DATEADD(mm, 1, DATEADD(mm, DATEDIFF(mm, 0, @CurrentDate), 0))
SET @NextMonthEnd = DATEADD(dd, -1, DATEADD(mm, DATEDIFF(mm, 0, DATEADD(MM, 1, @CurrentDate)) + 1, 0))
SET @NextMonthEnd = @NextMonthEnd + ' 23:59:59'


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
,	CenterNumber INT
)

CREATE TABLE #SourceCode (
	SourceKey INT
,	SourceSSID NVARCHAR(20)
,	SourceName NVARCHAR(50)
,   OwnerType NVARCHAR(50)
)

CREATE TABLE #Surgery (
	FullDate DATETIME
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
)

CREATE TABLE #SurgeryHC (
	FullDate DATETIME
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
)

CREATE TABLE #SurgeryScheduled (
	SiebelID NVARCHAR(50)
,	ProcedureDate DATETIME
)

CREATE TABLE #SurgeryPerformed (
	FullDate DATETIME
,	SurgeryPerformedCount INT
,	SurgeryPerformedSales MONEY
)


CREATE TABLE #SurgeryPerformedHC (
	FullDate DATETIME
,	SurgeryPerformedHCCount INT
,	SurgeryPerformedHCSales MONEY
)

CREATE TABLE #NonSurgery (
	FullDate DATETIME
,	NetTradCount INT
,	NetTradSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetXtrandCount INT
,	NetXtrandSales MONEY
,	NetCount INT
,	NetSales MONEY
)

CREATE TABLE #NonSurgeryHC (
	FullDate DATETIME
,	NetTradCount INT
,	NetTradSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetXtrandCount INT
,	NetXtrandSales MONEY
,	NetCount INT
,	NetSales MONEY
)

CREATE TABLE #Activity (
	FullDate DATETIME
,	BeBacks INT
,	Consultations INT
,	Appointments INT
,	Shows INT
,	Sales INT
,	NoShows INT
,	NoSales INT
,	BeBacksHC INT
,	ConsultationsHC INT
,	AppointmentsHC INT
,	ShowsHC INT
,	SalesHC INT
,	NoShowsHC INT
,	NoSalesHC INT
)

CREATE TABLE #BOStoHCLead (
	FullDate DATETIME
,	Leads INT
,	Appointments INT
,	Shows INT
,	Sales INT
,	NoShows INT
,	NoSales INT
)

CREATE TABLE #BOStoHCLeadHC (
	FullDate DATETIME
,	Leads INT
,	Appointments INT
,	Shows INT
,	Sales INT
,	NoShows INT
,	NoSales INT
)

CREATE TABLE #BreakOut (
	FullDate DATETIME
,	Leads INT
,	Appointments INT
,	Shows INT
,	Sales INT
,	NoShows INT
,	NoSales INT
)

CREATE TABLE #HCtoBOSLead (
	FullDate DATETIME
,	Leads INT
)

CREATE TABLE #LeadNoAppointment (
	FullDate DATETIME
,	LeadsNoAppointment INT
,	LeadsNoAppointmentHC INT
)

CREATE TABLE #Final (
	DateID INT
,	DateDesc VARCHAR(50)
,	DateDescFiscalYear VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	SortOrder INT
,	SurgeryCount INT
,	SurgerySales MONEY
,	SurgeryAvg INT
,	SurgeryPerformedCount INT
,	SurgeryPerformedSales MONEY
,	SurgeryPerformedAvg INT
,	PostEXTCount INT
,	PostEXTSales MONEY
,	PostEXTAvg INT
,	PostEXTPct FLOAT
,	NetCount INT
,	NetSales MONEY
,	HCtoBOSLeads INT
,	BOStoHCLeads INT
,	Appointments INT
,	Shows INT
,	ReferralsWithNoAppointments INT
,	BOStoHCLeadsHC INT
,	AppointmentsHC INT
,	ShowsHC INT
,	ReferralsWithNoAppointmentsHC INT
,	NetCountHC INT
,	NetSalesHC MONEY
,	SurgeryCountHC INT
,	SurgerySalesHC MONEY
,	SurgeryAvgHC INT
,	SurgeryPerformedHCCount INT
,	SurgeryPerformedHCSales MONEY
,	SurgeryPerformedHCAvg INT
)


/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_Date_Dates ON #Date ( StartDate, EndDate )
CREATE NONCLUSTERED INDEX IDX_Center_CenterKey ON #Center ( CenterKey )
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber )
CREATE NONCLUSTERED INDEX IDX_SourceCode_SourceKey ON #SourceCode ( SourceKey )
CREATE NONCLUSTERED INDEX IDX_Surgery_FullDate ON #Surgery ( FullDate )
CREATE NONCLUSTERED INDEX IDX_SurgeryPerformed_FullDate ON #SurgeryPerformed ( FullDate )
CREATE NONCLUSTERED INDEX IDX_NonSurgery_FullDate ON #NonSurgery ( FullDate )
CREATE NONCLUSTERED INDEX IDX_NonSurgery_FullDate ON #NonSurgeryHC ( FullDate )
CREATE NONCLUSTERED INDEX IDX_Activity_FullDate ON #Activity ( FullDate )
CREATE NONCLUSTERED INDEX IDX_BOStoHCLead_FullDate ON #BOStoHCLead ( FullDate )
CREATE NONCLUSTERED INDEX IDX_BOStoHCLead_FullDate ON #BOStoHCLeadHC ( FullDate )
CREATE NONCLUSTERED INDEX IDX_HCtoBOSLead_FullDate ON #HCtoBOSLead ( FullDate )
CREATE NONCLUSTERED INDEX IDX_LeadNoAppointment_FullDate ON #LeadNoAppointment ( FullDate )
CREATE NONCLUSTERED INDEX IDX_Final_DateID ON #Final ( DateID )


/********************************** Get Dates data *************************************/
INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (1, 'Day', 'Day', @YesterdayStart, @YesterdayEnd, 1)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (2, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentMonthStart, @YesterdayEnd, 2)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (4, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentFiscalYearStart, @YesterdayEnd, 5)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (5, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))), DATEADD(YEAR, -1, @CurrentMonthStart), DATEADD(YEAR, -1, @YesterdayEnd), 3)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (6, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))), DATEADD(YEAR, -1, @CurrentFiscalYearStart), DATEADD(YEAR, -1, @YesterdayEnd), 6)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (7, 'MTD', 'Difference', @CurrentMonthStart, @YesterdayEnd, 4)

INSERT INTO #Date(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
VALUES (8, 'YTD', 'Difference', @CurrentFiscalYearStart, @YesterdayEnd, 7)


SELECT	@MinDate = MIN(d.StartDate)
,		@MaxDate = MAX(d.EndDate)
FROM	#Date d

UPDATE	d
SET		d.DateDescFiscalYear = CASE WHEN d.DateID IN (2, 5) THEN DATENAME(MONTH, d.StartDate) ELSE 'FY' END + ' ' + CONVERT(VARCHAR, dd.FiscalYear)
FROM	#Date d
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.FullDate = d.StartDate
WHERE	d.DateID IN ( 2, 4, 5, 6 )


UPDATE	d
SET		d.DateDescFiscalYear = 'var +(-)'
FROM	#Date d
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.FullDate = d.StartDate
WHERE	d.DateID IN ( 7, 8 )


/********************************** Get Center data *************************************/
INSERT	INTO #Center
		SELECT  ctr.CenterKey
		,		ctr.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
		WHERE   ctr.CenterNumber LIKE CASE WHEN @CenterType = 'C' THEN '[2]%' ELSE '[78]%' END
				AND ctr.Active = 'Y'


/********************************** Get Bosley Referral Source Code data *************************************/
INSERT  INTO #SourceCode
        SELECT  ds.SourceKey AS 'SourceKey'
        ,       ds.SourceSSID AS 'SourceSSID'
        ,       ds.SourceName
		,       ds.OwnerType
        FROM    HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds
		WHERE	( ds.SourceSSID LIKE 'BOS%REF%' AND ds.SourceSSID <> 'BOSOHREF' )
				AND RIGHT(SourceName,1) <> '-'


/********************************** Get Surgery Sales data *************************************/
INSERT  INTO #Surgery
		SELECT	dd.FullDate
		,		SUM(ISNULL(fst.S_SurCnt, 0) + ISNULL(fst.SA_NetSalesCnt, 0)) AS 'SurgeryCount'
		,       SUM(ISNULL(fst.S_SurAmt, 0) + ISNULL(fst.SA_NetSalesAmt, 0)) AS 'SurgerySales'
		,       SUM(ISNULL(fst.S_PostExtCnt, 0)) AS 'PostEXTCount'
		,       SUM(ISNULL(fst.S_PostExtAmt, 0)) AS 'PostEXTSales'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst WITH ( NOLOCK )
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd WITH ( NOLOCK )
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt WITH ( NOLOCK )
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc WITH ( NOLOCK )
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so WITH ( NOLOCK )
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod WITH ( NOLOCK )
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm WITH ( NOLOCK )
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH ( NOLOCK )
					ON ctr.CenterKey = dcm.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				LEFT OUTER JOIN #SourceCode s
					ON s.SourceKey = fst.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND sod.IsVoidedFlag = 0
				AND (s.SourceSSID IS NULL OR s.OwnerType <> 'Bosley Consult')
		GROUP BY dd.FullDate



INSERT  INTO #SurgeryHC
		SELECT	dd.FullDate
		,		SUM(ISNULL(fst.S_SurCnt, 0) + ISNULL(fst.SA_NetSalesCnt, 0)) AS 'SurgeryCount'
		,       SUM(ISNULL(fst.S_SurAmt, 0) + ISNULL(fst.SA_NetSalesAmt, 0)) AS 'SurgerySales'
		,       SUM(ISNULL(fst.S_PostExtCnt, 0)) AS 'PostEXTCount'
		,       SUM(ISNULL(fst.S_PostExtAmt, 0)) AS 'PostEXTSales'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst WITH ( NOLOCK )
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd WITH ( NOLOCK )
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt WITH ( NOLOCK )
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc WITH ( NOLOCK )
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so WITH ( NOLOCK )
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod WITH ( NOLOCK )
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm WITH ( NOLOCK )
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH ( NOLOCK )
					ON ctr.CenterKey = dcm.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN #SourceCode s
					ON s.SourceKey = fst.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND sod.IsVoidedFlag = 0
				AND s.OwnerType = 'Bosley Consult'
		GROUP BY dd.FullDate


/********************************** Get Surgery Schedule data *************************************/
INSERT	INTO #SurgeryScheduled
		SELECT	dirl.SiebelID
		,		MAX(ISNULL(o_Pu.ProcedureDate, CAST(dirl.ProcedureDate AS DATE))) -- If the procedure was rescheduled, use the new ProcedureDate
		FROM    SQL05.HairClubCMS.dbo.datIncomingRequestLog dirl WITH (NOLOCK)
				OUTER APPLY (
					SELECT	TOP 1
							CAST(irl.ProcedureDate AS DATE) AS 'ProcedureDate'
					FROM    SQL05.HairClubCMS.dbo.datIncomingRequestLog irl WITH (NOLOCK)
					WHERE   irl.SiebelID = dirl.SiebelID
							AND irl.ProcessName = 'ProcedureUpdate'
							AND irl.ProcedureStatus = 'Rescheduled'
							AND irl.CreateDate >= dirl.CreateDate  -- Check if we received a ProcedureUpdate with an updated ProcedureDate after the TreatmentPlan
					ORDER BY irl.CreateDate DESC
				) o_Pu
				OUTER APPLY (
					SELECT	TOP 1
							irl.SiebelID
					FROM    SQL05.HairClubCMS.dbo.datIncomingRequestLog irl WITH (NOLOCK)
					WHERE   irl.SiebelID = dirl.SiebelID
							AND irl.ProcessName = 'ProcedureUpdate'
							AND irl.ProcedureStatus = 'Cancelled'
							AND irl.CreateDate >= dirl.CreateDate -- Check if we received a ProcedureUpdate with a Cancellation after the TreatmentPlan
					ORDER BY irl.CreateDate DESC
				) o_C
		WHERE   dirl.ProcedureDate BETWEEN DATEADD(dd, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AND DATEADD(dd, -1, DATEADD(mm, DATEDIFF(mm, 0, DATEADD(MM, 1, GETDATE())) + 1, 0)) + ' 23:59:59'
				AND dirl.ProcessName = 'TreatmentPlan'
				AND dirl.ProcedureStatus IN ( 'Scheduled', 'Done' ) -- Check for TreatmentPlans during the specified time period
				AND o_C.SiebelID IS NULL -- Procedure has not been cancelled
		GROUP BY dirl.SiebelID


DECLARE @SurgeriesScheduledThisMonth INT
,		@SurgeriesScheduledNextMonth INT


SELECT	@SurgeriesScheduledThisMonth = SUM(CASE WHEN ss.ProcedureDate BETWEEN @CurrentMonthStart AND @CurrentMonthEnd THEN 1 ELSE 0 END)
,		@SurgeriesScheduledNextMonth = SUM(CASE WHEN ss.ProcedureDate BETWEEN @NextMonthStart AND @NextMonthEnd THEN 1 ELSE 0 END)
FROM	#SurgeryScheduled ss


/********************************** Get Surgery Performed data *************************************/
INSERT	INTO #SurgeryPerformed
		SELECT	CAST(irl.ProcedureDate AS DATE) AS 'FullDate'
		,		COUNT(DISTINCT irl.ConectID) AS 'SurgeryPerformedCount'
		,		SUM(irl.ProcedureAmount) AS 'SurgeryPerformedSales'
		FROM    SQL05.HairClubCMS.dbo.datIncomingRequestLog irl WITH (NOLOCK)
				   INNER JOIN  [HC_BI_CMS_DDS].bi_cms_dds.DimClient clt
				      ON clt.ClientIdentifier = irl.ConectID
				LEFT OUTER JOIN HC_BI_SFDC.dbo.lead l ON l.id = clt.SFDC_Leadid
                LEFT OUTER JOIN #SourceCode sc ON sc.SourceSSID = l.Source_Code_Legacy__c
		WHERE   irl.ProcedureDate BETWEEN @MinDate AND @MaxDate + ' 23:59:59'
				AND irl.ProcessName = 'ProcedureDone'
				AND irl.ProcedureStatus = 'Done'
				AND (sc.SourceSSID IS NULL OR sc.OwnerType <> 'Bosley Consult')
		GROUP BY CAST(irl.ProcedureDate AS DATE)


INSERT	INTO #SurgeryPerformedHC
		SELECT	CAST(irl.ProcedureDate AS DATE) AS 'FullDate'
		,		COUNT(DISTINCT irl.ConectID) AS 'SurgeryPerformedHCCount'
		,		SUM(irl.ProcedureAmount) AS 'SurgeryPerformedHCSales'
		FROM    SQL05.HairClubCMS.dbo.datIncomingRequestLog irl WITH (NOLOCK)
				   INNER JOIN  [HC_BI_CMS_DDS].bi_cms_dds.DimClient clt
				      ON clt.ClientIdentifier = irl.ConectID
				LEFT OUTER JOIN HC_BI_SFDC.dbo.lead l ON l.id = clt.SFDC_Leadid
                INNER JOIN #SourceCode sc ON sc.SourceSSID = l.Source_Code_Legacy__c
		WHERE   irl.ProcedureDate BETWEEN @MinDate AND @MaxDate + ' 23:59:59'
				AND irl.ProcessName = 'ProcedureDone'
				AND irl.ProcedureStatus = 'Done'
				AND sc.OwnerType = 'Bosley Consult'
		GROUP BY CAST(irl.ProcedureDate AS DATE)


/********************************** Get Non-Surgery Sales data *************************************/
INSERT  INTO #NonSurgery
		SELECT	dd.FullDate
		,		SUM(ISNULL(fst.NB_TradCnt, 0)) AS 'NetTradCount'
		,       SUM(ISNULL(fst.NB_TradAmt, 0)) AS 'NetTradSales'
		,       SUM(ISNULL(fst.NB_GradCnt, 0)) AS 'NetGradCount'
		,       SUM(ISNULL(fst.NB_GradAmt, 0)) AS 'NetGradSales'
		,       SUM(ISNULL(fst.NB_ExtCnt, 0)) AS 'NetEXTCount'
		,       SUM(ISNULL(fst.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,       SUM(ISNULL(fst.NB_XTRCnt, 0)) AS 'NetXtrandCount'
		,       SUM(ISNULL(fst.NB_XTRAmt, 0)) AS 'NetXtrandSales'
		,       SUM(ISNULL(fst.NB_TradCnt, 0) + ISNULL(fst.NB_GradCnt, 0) + ISNULL(fst.NB_ExtCnt, 0) + ISNULL(fst.NB_XTRCnt, 0) + ISNULL(fst.NB_MDPCnt, 0)) AS 'NetCount'
		,       SUM(ISNULL(fst.NB_TradAmt, 0) + ISNULL(fst.NB_GradAmt, 0) + ISNULL(fst.NB_ExtAmt, 0) + ISNULL(fst.NB_XTRAmt, 0) + ISNULL(fst.NB_MDPAmt, 0)) AS 'NetSales'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst WITH ( NOLOCK )
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd WITH ( NOLOCK )
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt WITH ( NOLOCK )
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc WITH ( NOLOCK )
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so WITH ( NOLOCK )
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod WITH ( NOLOCK )
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm WITH ( NOLOCK )
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH ( NOLOCK )
					ON ctr.CenterKey = dcm.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN #SourceCode s
					ON s.SourceKey = fst.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND sod.IsVoidedFlag = 0
				AND s.OwnerType <> 'Bosley Consult'

		GROUP BY dd.FullDate


INSERT  INTO #NonSurgeryHC
		SELECT	dd.FullDate
		,		SUM(ISNULL(fst.NB_TradCnt, 0)) AS 'NetTradCount'
		,       SUM(ISNULL(fst.NB_TradAmt, 0)) AS 'NetTradSales'
		,       SUM(ISNULL(fst.NB_GradCnt, 0)) AS 'NetGradCount'
		,       SUM(ISNULL(fst.NB_GradAmt, 0)) AS 'NetGradSales'
		,       SUM(ISNULL(fst.NB_ExtCnt, 0)) AS 'NetEXTCount'
		,       SUM(ISNULL(fst.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,       SUM(ISNULL(fst.NB_XTRCnt, 0)) AS 'NetXtrandCount'
		,       SUM(ISNULL(fst.NB_XTRAmt, 0)) AS 'NetXtrandSales'
		,       SUM(ISNULL(fst.NB_TradCnt, 0) + ISNULL(fst.NB_GradCnt, 0) + ISNULL(fst.NB_ExtCnt, 0) + ISNULL(fst.NB_XTRCnt, 0) + ISNULL(fst.NB_MDPCnt, 0)) AS 'NetCount'
		,       SUM(ISNULL(fst.NB_TradAmt, 0) + ISNULL(fst.NB_GradAmt, 0) + ISNULL(fst.NB_ExtAmt, 0) + ISNULL(fst.NB_XTRAmt, 0) + ISNULL(fst.NB_MDPAmt, 0)) AS 'NetSales'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst WITH ( NOLOCK )
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd WITH ( NOLOCK )
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt WITH ( NOLOCK )
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc WITH ( NOLOCK )
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so WITH ( NOLOCK )
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod WITH ( NOLOCK )
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm WITH ( NOLOCK )
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH ( NOLOCK )
					ON ctr.CenterKey = dcm.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
				INNER JOIN #SourceCode s
					ON s.SourceKey = fst.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND sod.IsVoidedFlag = 0
				AND s.OwnerType = 'Bosley Consult'
		GROUP BY dd.FullDate


/********************************** Get BOSREF Activity data *************************************/
INSERT  INTO #Activity
		SELECT  dd.FullDate
		,       SUM(CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN ISNULL(far.BeBack, 0) ELSE 0 END) AS 'BeBacks'
		,       SUM(CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN ISNULL(far.Consultation, 0) ELSE 0 END) AS 'Consultations'
		,       SUM(CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN ISNULL(far.Appointments, 0) ELSE 0 END) AS 'Appointments'
		,       SUM(CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN ISNULL(far.Show, 0) ELSE 0 END) AS 'Shows'
		,       SUM(CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN ISNULL(far.Sale, 0) ELSE 0 END) AS 'Sales'
		,		SUM(CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN ISNULL(far.NoShow, 0) ELSE 0 END) AS 'NoShows'
		,		SUM(CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN ISNULL(far.NoSale, 0) ELSE 0 END) AS 'NoSales'
		,       SUM(CASE WHEN sc.OwnerType = 'Bosley Consult' THEN ISNULL(far.BeBack, 0) ELSE 0 END) AS 'BeBacksHC'
		,       SUM(CASE WHEN sc.OwnerType = 'Bosley Consult' THEN ISNULL(far.Consultation, 0) ELSE 0 END) AS 'ConsultationsHC'
		,       SUM(CASE WHEN sc.OwnerType = 'Bosley Consult' THEN ISNULL(far.Appointments, 0) ELSE 0 END) AS 'AppointmentsHC'
		,       SUM(CASE WHEN sc.OwnerType = 'Bosley Consult' THEN ISNULL(far.Show, 0) ELSE 0 END) AS 'ShowsHC'
		,       SUM(CASE WHEN sc.OwnerType = 'Bosley Consult' THEN ISNULL(far.Sale, 0) ELSE 0 END) AS 'SalesHC'
		,		SUM(CASE WHEN sc.OwnerType = 'Bosley Consult' THEN ISNULL(far.NoShow, 0) ELSE 0 END) AS 'NoShowsHC'
		,		SUM(CASE WHEN sc.OwnerType = 'Bosley Consult' THEN ISNULL(far.NoSale, 0) ELSE 0 END) AS 'NoSalesHC'
		FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults far
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = far.ActivityDueDateKey
				INNER JOIN #Center c
					ON c.CenterKey = far.CenterKey
				INNER JOIN #SourceCode sc
					ON sc.SourceKey = far.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
		GROUP BY c.CenterNumber
		,       dd.FullDate


/********************************** Get BOSREF Lead data - BOS to HC *************************************/
INSERT  INTO #BOStoHCLead
		SELECT  dd.FullDate
		,       SUM(CASE WHEN (c.CenterNumber IN(287,289,234) AND sc.SourceSSID = 'BOSNCREF') THEN 0 ELSE ISNULL(fl.Leads, 0) END) AS 'Leads'
		,       SUM(ISNULL(fl.Appointments, 0)) AS 'Appointments'
		,       SUM(ISNULL(fl.Shows, 0)) AS 'Shows'
		,       SUM(ISNULL(fl.Sales, 0)) AS 'Sales'
		,		SUM(ISNULL(fl.NoShows, 0)) AS 'NoShows'
		,		SUM(ISNULL(fl.NoSales, 0)) AS 'NoSales'
		FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fl.LeadCreationDateKey
				INNER JOIN #Center c
					ON c.CenterKey = fl.CenterKey
				INNER JOIN #SourceCode sc
					ON sc.SourceKey = fl.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
		        AND sc.OwnerType <> 'Bosley Consult'
		GROUP BY dd.FullDate


INSERT  INTO #BOStoHCLeadHC
		SELECT  dd.FullDate
		,       SUM(CASE WHEN (c.CenterNumber IN(287,289,234) AND sc.SourceSSID = 'BOSNCREF') THEN 0 ELSE ISNULL(fl.Leads, 0) END) AS 'Leads'
		,       SUM(ISNULL(fl.Appointments, 0)) AS 'Appointments'
		,       SUM(ISNULL(fl.Shows, 0)) AS 'Shows'
		,       SUM(ISNULL(fl.Sales, 0)) AS 'Sales'
		,		SUM(ISNULL(fl.NoShows, 0)) AS 'NoShows'
		,		SUM(ISNULL(fl.NoSales, 0)) AS 'NoSales'
		FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fl.LeadCreationDateKey
				INNER JOIN #Center c
					ON c.CenterKey = fl.CenterKey
				INNER JOIN #SourceCode sc
					ON sc.SourceKey = fl.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
		        AND sc.OwnerType = 'Bosley Consult'
		GROUP BY dd.FullDate


/********************************** Get BOSREF Lead data - HC to BOS *************************************/
INSERT  INTO #HCtoBOSLead
		SELECT	dd.FullDate
		,		COUNT(DISTINCT clt.ClientKey) AS 'HCtoBOSLeads'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst WITH ( NOLOCK )
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd WITH ( NOLOCK )
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt WITH ( NOLOCK )
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc WITH ( NOLOCK )
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so WITH ( NOLOCK )
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod WITH ( NOLOCK )
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm WITH ( NOLOCK )
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m WITH ( NOLOCK )
					ON m.MembershipKey = dcm.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH ( NOLOCK )
					ON ctr.CenterKey = dcm.CenterKey
				INNER JOIN #Center c
					ON c.CenterNumber = ctr.CenterNumber
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
				AND m.MembershipDescriptionShort = 'SNSSURGOFF'
				AND sc.SalesCodeDescriptionShort = 'INITASG'
				AND ISNULL(clt.BosleySiebelID, '') <> ''
				AND sod.IsVoidedFlag = 0
		GROUP BY dd.FullDate
		ORDER BY dd.FullDate


/********************************** Get BOSREF Leads with no appointment data *************************************/
INSERT	INTO #LeadNoAppointment
		SELECT  dd.FullDate
		,       COUNT(DISTINCT CASE WHEN sc.OwnerType <> 'Bosley Consult' THEN fl.ContactKey ELSE 0 END) AS 'LeadsNoAppointment'
		,       COUNT(DISTINCT CASE WHEN sc.OwnerType = 'Bosley Consult' THEN fl.ContactKey ELSE 0 END) AS 'LeadsNoAppointmentHC'

		FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fl.LeadCreationDateKey
				INNER JOIN #Center c
					ON c.CenterKey = fl.CenterKey
				INNER JOIN #SourceCode sc
					ON sc.SourceKey = fl.SourceKey
		WHERE   dd.FullDate BETWEEN @MinDate AND @MaxDate
				AND ( fl.Appointments = 0
					  AND fl.Shows = 0
					  AND fl.NoShows = 0
					  AND fl.Sales = 0
					  AND fl.NoSales = 0 )
		GROUP BY dd.FullDate


/********************************** Get Totals *************************************/
INSERT	INTO #Final
		SELECT  d.DateID
		,       d.DateDesc
		,       d.DateDescFiscalYear
		,       d.StartDate
		,       d.EndDate
		,       d.SortOrder
		,		(SELECT ISNULL(SUM(s.SurgeryCount), 0) FROM #Surgery s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryCount'
		,		(SELECT ISNULL(SUM(s.SurgerySales), 0) FROM #Surgery s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgerySales'
		,		0 AS 'SurgeryAvg'
		,		(SELECT ISNULL(SUM(sp.SurgeryPerformedCount), 0) FROM #SurgeryPerformed sp WHERE sp.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryPerformedCount'
		,		(SELECT ISNULL(SUM(sp.SurgeryPerformedSales), 0) FROM #SurgeryPerformed sp WHERE sp.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryPerformedSales'
		,		0 AS 'SurgeryPerformedAvg'
		,		(SELECT ISNULL(SUM(s.PostEXTCount), 0) FROM #Surgery s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PostEXTCount'
		,		(SELECT ISNULL(SUM(s.PostEXTSales), 0) FROM #Surgery s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'PostEXTSales'
		,		0 AS 'PostEXTAvg'
		,		0 AS 'PostEXTPct'
		,		(SELECT ISNULL(SUM(ns.NetCount), 0) FROM #NonSurgery ns WHERE ns.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetCount'
		,		(SELECT ISNULL(SUM(ns.NetSales), 0) FROM #NonSurgery ns WHERE ns.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetSales'
		,		(SELECT ISNULL(SUM(l.Leads), 0) FROM #HCtoBOSLead l WHERE l.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'HCtoBOSLeads'
		,		(SELECT ISNULL(SUM(l.Leads), 0) FROM #BOStoHCLead l WHERE l.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BOStoHCLeads'
		,		(SELECT ISNULL(SUM(a.Appointments), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Appointments'
		,		(SELECT ISNULL(SUM(a.Shows), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'Shows'
		,		(SELECT ISNULL(SUM(lna.LeadsNoAppointment), 0) FROM #LeadNoAppointment lna WHERE lna.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'ReferralsWithNoAppointments'
		,		(SELECT ISNULL(SUM(l.Leads), 0) FROM #BOStoHCLeadHC l WHERE l.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'BOStoHCLeadsHC'
		,		(SELECT ISNULL(SUM(a.AppointmentsHC), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'AppointmentsHC'
		,		(SELECT ISNULL(SUM(a.ShowsHC), 0) FROM #Activity a WHERE a.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'ShowsHC'
		,		(SELECT ISNULL(SUM(lna.LeadsNoAppointmentHC), 0) FROM #LeadNoAppointment lna WHERE lna.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'ReferralsWithNoAppointmentsHC'
		,		(SELECT ISNULL(SUM(ns.NetCount), 0) FROM #NonSurgeryHC ns WHERE ns.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetCountHC'
		,		(SELECT ISNULL(SUM(ns.NetSales), 0) FROM #NonSurgeryHC ns WHERE ns.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'NetSalesHC'
		,		(SELECT ISNULL(SUM(s.SurgeryCount), 0) FROM #SurgeryHC s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryCountHC'
		,		(SELECT ISNULL(SUM(s.SurgerySales), 0) FROM #SurgeryHC s WHERE s.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgerySalesHC'
		,		0 AS 'SurgeryAvgHC'
		,		(SELECT ISNULL(SUM(sp.SurgeryPerformedHCCount), 0) FROM #SurgeryPerformedHC sp WHERE sp.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryPerformedHCCount'
		,		(SELECT ISNULL(SUM(sp.SurgeryPerformedHCSales), 0) FROM #SurgeryPerformedHC sp WHERE sp.FullDate BETWEEN d.StartDate AND d.EndDate) AS 'SurgeryPerformedHCSales'
		,		0 AS 'SurgeryPerformedHCAvg'
		FROM    #Date d


/**********************************Include Surgery in Net Count/sales for Bosley Consultation Done at HC *************************************/
UPDATE  f
SET     NetCountHC = NetCountHC + SurgeryCountHC
,       f.NetSalesHC = NetSalesHC + SurgerySalesHC
FROM    #Final f

/********************************** Calculate Averages, Percentages and Variances & Update Data *************************************/
UPDATE  f
SET     f.SurgeryAvg = dbo.DIVIDE_NOROUND(f.SurgerySales, f.SurgeryCount)
,       f.SurgeryAvgHC = dbo.DIVIDE_NOROUND(f.SurgerySalesHC, f.SurgeryCountHC)
,		f.SurgeryPerformedAvg = dbo.DIVIDE_NOROUND(f.SurgeryPerformedSales, f.SurgeryPerformedCount)
,       f.PostEXTAvg = dbo.DIVIDE_NOROUND(f.PostEXTSales, f.PostEXTCount)
,       f.PostEXTPct = dbo.DIVIDE_NOROUND(f.PostEXTCount, f.SurgeryCount)

,		f.SurgeryPerformedHCAvg = dbo.DIVIDE_NOROUND(f.SurgeryPerformedHCSales, f.SurgeryPerformedHCCount)
FROM    #Final f
WHERE   f.DateID NOT IN ( 7, 8 )


UPDATE  f
SET     f.SurgerySales = c.SurgerySales - p.SurgerySales
,       f.SurgerySalesHC = c.SurgerySalesHC - p.SurgerySalesHC
,       f.SurgeryPerformedSales = c.SurgeryPerformedSales - p.SurgeryPerformedSales
,       f.SurgeryPerformedHCSales = c.SurgeryPerformedHCSales - p.SurgeryPerformedHCSales
,       f.PostEXTSales = c.PostEXTSales - p.PostEXTSales
,       f.SurgeryCount = c.SurgeryCount - p.SurgeryCount
,       f.SurgeryCountHC = c.SurgeryCountHC - p.SurgeryCountHC
,       f.SurgeryPerformedCount = c.SurgeryPerformedCount - p.SurgeryPerformedCount
,       f.SurgeryPerformedHCCount = c.SurgeryPerformedHCCount - p.SurgeryPerformedHCCount
,       f.SurgeryAvg = c.SurgeryAvg - p.SurgeryAvg
,       f.SurgeryAvgHC = c.SurgeryAvgHC - p.SurgeryAvgHC
,       f.SurgeryPerformedAvg = c.SurgeryPerformedAvg - p.SurgeryPerformedAvg
,       f.SurgeryPerformedHCAvg = c.SurgeryPerformedHCAvg - p.SurgeryPerformedHCAvg
,       f.NetCount = c.NetCount - p.NetCount
,       f.PostEXTCount = c.PostEXTCount - p.PostEXTCount
,       f.PostEXTAvg = c.PostEXTAvg - p.PostEXTAvg
,       f.PostEXTPct = c.PostEXTPct - p.PostEXTPct
,       f.Appointments = c.Appointments - p.Appointments
,       f.Shows = c.Shows - p.Shows
,       f.HCtoBOSLeads = c.HCtoBOSLeads - p.HCtoBOSLeads
,       f.BOStoHCLeads = c.BOStoHCLeads - p.BOStoHCLeads
,       f.NetSales = c.NetSales - p.NetSales
,       f.ReferralsWithNoAppointments = c.ReferralsWithNoAppointments - p.ReferralsWithNoAppointments
,       f.AppointmentsHC = c.AppointmentsHC - p.AppointmentsHC
,       f.ShowsHC = c.ShowsHC - p.ShowsHC
,       f.BOStoHCLeadsHC = c.BOStoHCLeadsHC - p.BOStoHCLeadsHC
,       f.ReferralsWithNoAppointmentsHC = c.ReferralsWithNoAppointmentsHC - p.ReferralsWithNoAppointmentsHC
,       f.NetCountHC = c.NetCountHC - p.NetCountHC
,       f.NetSalesHC = c.NetSalesHC - p.NetSalesHC
FROM    #Final f
        INNER JOIN #Final c
            ON f.DateDesc = c.DateDesc
               AND c.DateID = 2
        INNER JOIN #Final p
            ON f.DateDesc = p.DateDesc
               AND p.DateID = 5
WHERE   f.DateID = 7


UPDATE  f
SET     f.SurgerySales = c.SurgerySales - p.SurgerySales
,       f.SurgerySalesHC = c.SurgerySalesHC - p.SurgerySalesHC
,       f.SurgeryPerformedSales = c.SurgeryPerformedSales - p.SurgeryPerformedSales
,       f.SurgeryPerformedHCSales = c.SurgeryPerformedHCSales - p.SurgeryPerformedHCSales
,       f.PostEXTSales = c.PostEXTSales - p.PostEXTSales
,       f.SurgeryCount = c.SurgeryCount - p.SurgeryCount
,       f.SurgeryCountHC = c.SurgeryCountHC - p.SurgeryCountHC
,       f.SurgeryPerformedCount = c.SurgeryPerformedCount - p.SurgeryPerformedCount
,       f.SurgeryPerformedHCCount = c.SurgeryPerformedHCCount - p.SurgeryPerformedHCCount
,       f.SurgeryAvg = c.SurgeryAvg - p.SurgeryAvg
,       f.SurgeryAvgHC = c.SurgeryAvgHC - p.SurgeryAvgHC
,       f.SurgeryPerformedAvg = c.SurgeryPerformedAvg - p.SurgeryPerformedAvg
,       f.SurgeryPerformedHCAvg = c.SurgeryPerformedHCAvg - p.SurgeryPerformedHCAvg
,       f.NetCount = c.NetCount - p.NetCount
,       f.PostEXTCount = c.PostEXTCount - p.PostEXTCount
,       f.PostEXTAvg = c.PostEXTAvg - p.PostEXTAvg
,       f.PostEXTPct = c.PostEXTPct - p.PostEXTPct
,       f.Appointments = c.Appointments - p.Appointments
,       f.Shows = c.Shows - p.Shows
,       f.HCtoBOSLeads = c.HCtoBOSLeads - p.HCtoBOSLeads
,       f.BOStoHCLeads = c.BOStoHCLeads - p.BOStoHCLeads
,       f.NetSales = c.NetSales - p.NetSales
,       f.ReferralsWithNoAppointments = c.ReferralsWithNoAppointments - p.ReferralsWithNoAppointments
,       f.AppointmentsHC = c.AppointmentsHC - p.AppointmentsHC
,       f.ShowsHC = c.ShowsHC - p.ShowsHC
,       f.BOStoHCLeadsHC = c.BOStoHCLeadsHC - p.BOStoHCLeadsHC
,       f.ReferralsWithNoAppointmentsHC = c.ReferralsWithNoAppointmentsHC - p.ReferralsWithNoAppointmentsHC
,       f.NetCountHC = c.NetCountHC - p.NetCountHC
,       f.NetSalesHC = c.NetSalesHC - p.NetSalesHC
FROM    #Final f
        INNER JOIN #Final c
            ON f.DateDesc = c.DateDesc
               AND c.DateID = 4
        INNER JOIN #Final p
            ON f.DateDesc = p.DateDesc
               AND p.DateID = 6
WHERE   f.DateID = 8


/********************************** Return Final Data *************************************/
SELECT  f.DateID
,		f.DateDesc
,		f.DateDescFiscalYear
,		f.SortOrder
,		f.StartDate
,		f.EndDate
,		f.HCtoBOSLeads
,		f.BOStoHCLeads
,		f.Appointments
,		f.Shows
,		f.ReferralsWithNoAppointments
,		f.NetCount
,		f.NetSales
,		f.SurgeryCount
,		f.SurgerySales
,		f.SurgeryAvg
,		f.SurgeryPerformedCount
,		f.SurgeryPerformedSales
,		f.SurgeryPerformedAvg
,		f.PostEXTCount
,		f.PostEXTSales
,		f.PostEXTAvg
,		f.PostEXTPct
,		@SurgeriesScheduledThisMonth AS 'SurgeriesScheduledThisMonth'
,		@SurgeriesScheduledNextMonth AS 'SurgeriesScheduledNextMonth'
,		f.BOStoHCLeadsHC
,		f.AppointmentsHC
,		f.ShowsHC
,		f.ReferralsWithNoAppointmentsHC
,		f.NetCountHC
,		f.NetSalesHC
,		f.SurgeryPerformedHCCount
,		f.SurgeryPerformedHCSales
,		f.SurgeryPerformedHCAvg
,	    f.SurgeryCountHC
,	    f.SurgerySalesHC
,		f.SurgeryAvgHC
FROM    #Final f
ORDER BY f.SortOrder

END
GO
