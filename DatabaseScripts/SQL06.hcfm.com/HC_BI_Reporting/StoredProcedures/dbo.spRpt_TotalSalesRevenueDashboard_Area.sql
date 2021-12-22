/***********************************************************************
PROCEDURE:				spRpt_TotalSalesRevenueDashboard_Area
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_TotalSalesRevenueDashboard_Area
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		11/08/2018
------------------------------------------------------------------------
NOTES:
Query for Totals at the top and in the charts
------------------------------------------------------------------------
CHANGE HISTORY:
03/11/2019 - RH - Added Non-Program to Recurring Revenue (per Melissa Oakes)
12/17/2019 - RH - TrackIT 2188 Added No Shows from Yesterday; Changed Total Revenue Budget to include Non-Pgm
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_TotalSalesRevenueDashboard_Area] '260'

EXEC [spRpt_TotalSalesRevenueDashboard_Area] '201, 203, 230, 232, 235, 237, 240, 258, 263, 267, 283, 219, 289, 202, 231, 256, 257, 299'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_TotalSalesRevenueDashboard_Area]
(
	@CenterNumber NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;

/*************************** Set variables to find Yesterdays dates *******************************************/


DECLARE @YesterdayStartDate DATETIME
DECLARE @YesterdayEndDate DATETIME
SET @YesterdayStartDate = CASE WHEN DATEPART(dw,GETUTCDATE()) = 3 THEN DATEADD(day,DATEDIFF(day,0,GETDATE()-3),0)	--If it is Tuesday then pull from either Sat at 12:00AM  --Tuesday = 3
							ELSE DATEADD(Day,DATEDIFF(day,0,GETDATE()-1),0) END										--Yesterday at 12:00AM
SET @YesterdayEndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()),0))) 								--Yesterday at 11:59PM

----For Testing on the weekend
--SET @YesterdayStartDate = DATEADD(day,DATEDIFF(day,0,GETDATE()-3),0)
--SET @YesterdayEndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()-2),0) ))



--PRINT '@YesterdayStartDate = ' + CAST(@YesterdayStartDate AS NVARCHAR(12))
--PRINT '@YesterdayEndDate = ' + CAST(@YesterdayEndDate AS NVARCHAR(12))

/***************************** Create temp tables *************************************************************/

CREATE TABLE #MonthToDate  (
	DateKey INT
,	FullDate DATETIME
,	MonthNumber INT
,	YearNumber	INT
,	FirstDateOfMonth DATETIME)


CREATE TABLE #CenterNumber (CenterNumber INT)


CREATE TABLE #Deferred (
	CenterNumber INT NOT NULL
,   DeferredRevenueType NVARCHAR(50) NULL
,   SortOrder INT NULL
,   Revenue DECIMAL(18, 2) NULL
)


CREATE TABLE #NB_DR(
	CenterNumber INT NOT NULL
,	NewBusinessType NVARCHAR(50)NULL
,	NB_NetRevenue DECIMAL(18, 2) NULL
)


CREATE TABLE #RB_DR(
	CenterNumber INT NOT NULL
,	TotalPCPAmt_Actual DECIMAL(18, 2) NULL
)


CREATE TABLE #Totals(
	CenterNumber INT
,	Section NVARCHAR(10)
,	FirstDateOfMonth DATE
,	MonthNumber INT
,	YearNumber INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterDescription NVARCHAR(50)
,	NB_NetRevenue DECIMAL(18,4)
,	NB_NetRevenue_Budget DECIMAL(18,4)
,	NB_NetSales INT
,	NB_NetSales_Budget INT
,	TotalPCPAmt_Actual DECIMAL(18,4)
,   TotalPCPAmt_Budget DECIMAL(18,4)
,	RetailAmt DECIMAL(18,4)
,   RetailAmt_Budget DECIMAL(18,4)
,	TotalCenterSales DECIMAL(18,4)
,   TotalRevenue_Budget DECIMAL(18,4)
,   ServiceAmt DECIMAL(18,4)
,	ServiceAmt_Budget DECIMAL(18,4)
,	LaserPrice DECIMAL(18,4)
,	ClientARBalance DECIMAL(18,4)
,	RemainingDays INT
)



CREATE TABLE #NB(
	CenterNumber INT
,	Section NVARCHAR(10)
,	ThisMembershipBeginDate DATE
,	ThisMonth DATE
,	AppointmentDate DATE
,	AppointmentStartTime  NVARCHAR(25)
,	CenterDescription NVARCHAR(60)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFirstName NVARCHAR(150)
,	ClientLastName NVARCHAR(150)
,	ClientEMailAddress NVARCHAR(150)
,	ClientPhone1 NVARCHAR(50)
,	ClientMembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipBeginDate DATE
,	ClientMembershipStatusDescription NVARCHAR(50)
,	HairSystemOrderStatusDescription NVARCHAR(50)
,	Active INT
,	ClientMembershipDuration INT
,	HairSystemReceivedDate DATETIME
,	ClientMembershipContractPrice DECIMAL(18,4)
,	ExtendedPrice DECIMAL(18,4)
,	ContractBalance DECIMAL(18,4)
)


CREATE TABLE #TotalPayments(
	ClientKey INT
,   ClientMembershipKey INT
,	ClientMembershipEndDate DATE
,	ClientMembershipContractPrice DECIMAL(18,4)
,	BusinessSegmentSSID INT
,   ExtendedPrice DECIMAL(18,4)
)



CREATE TABLE #SUM_TotalPayments(
	ClientKey INT
,   ClientMembershipContractPrice DECIMAL(18,4)
,	ExtendedPrice DECIMAL(18,4)
,	ContractBalance DECIMAL(18,4)
)



CREATE TABLE #RB(
	CenterNumber INT
,	Section NVARCHAR(10)
,	AppointmentDate DATE
,	AppointmentStartTime  NVARCHAR(25)
,	ClientIdentifier INT
,	ClientFirstName NVARCHAR(150)
,	ClientLastName NVARCHAR(150)
,	ClientEMailAddress NVARCHAR(150)
,	ClientPhone1 NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipBeginDate DATE
,	ClientMembershipStatusDescription NVARCHAR(50)
,	ExpectedConversionDate DATE
,	DoNotCallFlag INT
,	DoNotContactFlag INT
)


CREATE TABLE #Services(
	CenterNumber INT
,	Section NVARCHAR(10)
,	MonthNumber INT
,	YearNumber INT
,	AppointmentDate DATE
,	AppointmentStartTime  NVARCHAR(25)
,	AppointmentEndTime  NVARCHAR(25)
,	CenterDescription NVARCHAR(150)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFirstName NVARCHAR(150)
,	ClientLastName NVARCHAR(150)
,	ClientEMailAddress NVARCHAR(150)
,	ClientPhone1 NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipBeginDate DATE
,	ClientMembershipStatusDescription NVARCHAR(50)
)



CREATE TABLE #LaserCap
(	CenterNumber INT
,	Section NVARCHAR(10)
,	MonthNumber INT
,	YearNumber INT
,	AppointmentDate DATE
,	AppointmentStartTime NVARCHAR(25)
,	AppointmentEndTime NVARCHAR(25)
,	CenterDescription NVARCHAR(50)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFirstName NVARCHAR(150)
,	ClientLastName NVARCHAR(150)
,	ClientEMailAddress NVARCHAR(150)
,	ClientPhone1 NVARCHAR(50)
,	MembershipDescription  NVARCHAR(50)
,	ClientMembershipBeginDate DATE
,	ClientMembershipStatusDescription NVARCHAR(50)
)


CREATE TABLE #Appoint(
	CenterNumber INT
,	Section NVARCHAR(50)
,	FirstDateOfMonth DATE
,	MonthNumber INT
,	YearNumber INT
,	ThisMembershipBeginDate DATE
,   ThisMonth DATE
,	AppointmentDate DATE
,	AppointmentStartTime  NVARCHAR(25)
,	AppointmentEndTime  NVARCHAR(25)

,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterDescription NVARCHAR(50)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFirstName NVARCHAR(150)
,	ClientLastName NVARCHAR(150)
,	ClientEMailAddress NVARCHAR(150)
,	ClientPhone1 NVARCHAR(50)
,	ClientMembershipKey INT
,	MembershipDescription NVARCHAR(50)

,	ClientMembershipBeginDate DATE
,	ClientMembershipStatusDescription NVARCHAR(50)
,	ExpectedConversionDate DATE
,	DoNotCallFlag INT
,	DoNotContactFlag INT
,	NB_NetRevenue DECIMAL(18,4)
,	NB_NetRevenue_Budget DECIMAL(18,4)
,	NB_NetSales INT
,	NB_NetSales_Budget INT
,	TotalPCPAmt_Actual DECIMAL(18,4)

,	TotalPCPAmt_Budget DECIMAL(18,4)
,	RetailAmt DECIMAL(18,4)
,	RetailAmt_Budget DECIMAL(18,4)
,	TotalCenterSales DECIMAL(18,4)
,	TotalRevenue_Budget DECIMAL(18,4)
,	ServiceAmt DECIMAL(18,4)
,	ServiceAmt_Budget DECIMAL(18,4)
,	LaserPrice DECIMAL(18,4)
,	ClientARBalance DECIMAL(18,4)
,	RemainingDays INT

,	HairSystemOrderStatusDescription NVARCHAR(50)
,	Active INT
,	ClientMembershipDuration INT
,	HairSystemReceivedDate DATETIME
,	ClientMembershipContractPrice DECIMAL(18,4)
,	TotalPayments DECIMAL(18,4)
,	ContractBalance DECIMAL(18,4)

,	SalesCodeDescription NVARCHAR(150)
,	RevenueGroupDescription NVARCHAR(50)
,	EmployeeFullName1 NVARCHAR(250)
,	EmployeeFullName2 NVARCHAR(250)
)


/*********************** Find CenterNumbers using fnSplit *****************************************************/

INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')

/***************************** Find the Current Period *****************************************************************************/
DECLARE @Period DATETIME
SET @Period = DATETIMEFROMPARTS(YEAR(GETUTCDATE()), MONTH(GETUTCDATE()), 1, 0, 0, 0, 0)

/**************** Populate #MonthToDate ************************************************************************/

INSERT INTO #MonthToDate
SELECT	DD.DateKey
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	DD.FirstDateOfMonth
FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
WHERE DD.FullDate BETWEEN CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME) --First Day of this month
	AND DATEADD(DAY,-1,DATEADD(MONTH,2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))) + '23:59:000' --End of next month
GROUP BY DD.DateKey
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	DD.FirstDateOfMonth

/**************************** Find the # Remaining Days in the month ***************************************************************/
DECLARE @MonthWorkdays INT
DECLARE @CummWorkdays INT
DECLARE @RemainingDays INT

SET @MonthWorkdays = (SELECT [MonthWorkdaysTotal] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @Period)
	SET @CummWorkdays = (SELECT [CummWorkdays] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(VARCHAR, GETDATE(), 101))
SET @RemainingDays = @MonthWorkdays - @CummWorkdays




/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_Deferred_CenterNumber ON #Deferred ( CenterNumber )
CREATE NONCLUSTERED INDEX IDX_Deferred_DeferredRevenueType ON #Deferred ( DeferredRevenueType )

/********************************** Get Deferred Revenue Type Data *************************************/
INSERT INTO #Deferred (
		CenterNumber
,		DeferredRevenueType
,		SortOrder
,		Revenue
)
SELECT 	CN.CenterNumber
,		drt.TypeDescription
,		drt.SortOrder
,		0 AS Revenue
FROM   HC_DeferredRevenue_DAILY.dbo.DimDeferredRevenueType drt, #CenterNumber CN


/********************************** Get Revenue for the specific center & period **************************************************/
UPDATE d
SET d.Revenue = o_R.Revenue
FROM   #Deferred d
              OUTER APPLY ( SELECT ISNULL(ROUND(SUM(drd.Revenue), 2), 0) AS Revenue
                                         FROM   HC_DeferredRevenue_DAILY.dbo.vwDeferredRevenueDetails drd
                                         WHERE  drd.Center = d.CenterNumber
                                                       AND drd.DeferredRevenueType = d.DeferredRevenueType
                                                       AND drd.Period = @Period ) o_R
              INNER JOIN HC_DeferredRevenue_DAILY.dbo.vwDeferredRevenueDetails drd
                     ON drd.DeferredRevenueType = d.DeferredRevenueType
                     AND drd.Center = d.CenterNumber


/********************************** Find New Business Revenue as NB_NetRevenue *****************************************************/

INSERT INTO #NB_DR
SELECT x.CenterNumber,
       x.DeferredRevenueType AS NewBusinessType,
       SUM(ISNULL(x.Revenue,0)) AS NB_NetRevenue
FROM (	SELECT CenterNumber
		,   CASE WHEN drt.DeferredRevenueType LIKE 'New Business%' THEN 'New Business'
				 END AS DeferredRevenueType
		,       SUM(ISNULL(Revenue,0)) AS Revenue
		FROM #Deferred drt
		WHERE drt.DeferredRevenueType LIKE 'New Business%'
		GROUP BY CenterNumber
		,       DeferredRevenueType
		) x
GROUP BY x.CenterNumber,
       x.DeferredRevenueType


/********************************** Find Recurring Business Revenue & Non-Program as TotalPCPAmt_Actual *******************************************/
INSERT INTO #RB_DR
SELECT y.CenterNumber,
       SUM(ISNULL(y.Revenue,0)) AS TotalPCPAmt_Actual
FROM (	SELECT CenterNumber
		,   CASE WHEN drt.DeferredRevenueType LIKE 'Recurring Business%' THEN 'Recurring Business'
				WHEN  drt.DeferredRevenueType LIKE 'Non-Program%' THEN 'Non-Program'
				 END AS DeferredRevenueType
		,       SUM(ISNULL(Revenue,0)) AS Revenue
		FROM #Deferred drt
		WHERE (drt.DeferredRevenueType = 'Recurring Business' OR drt.DeferredRevenueType = 'Non-Program')
		GROUP BY CenterNumber
		,       DeferredRevenueType
		) y
GROUP BY y.CenterNumber


/************************* Find Budgets, Retail and Service Amounts *******************************************************************/
/**************************************************************************************************************************************/

;WITH MonthToDatePeriod AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FirstDateOfMonth = @Period
),
NewBBudget AS (
				SELECT 	NB.FirstDateOfMonth
				,	NB.YearNumber
				,	MTD.MonthNumber
				,	NB.CenterNumber
				,	NB.NetRevenue_Budget NB_NetRevenue_Budget
				,	NB.NetSales NB_NetSales
				,	NB.NetSales_Budget NB_NetSales_Budget
				FROM HC_BI_Datazen.dbo.dashNewBusiness NB
					INNER JOIN MonthToDatePeriod MTD
						ON NB.FirstDateOfMonth = MTD.FirstDateOfMonth
					INNER JOIN #CenterNumber CN
						ON NB.CenterNumber = CN.CenterNumber
				WHERE NB.FirstDateOfMonth = @Period

),
Laser AS (
				SELECT FST.CenterKey
				,	CTR.CenterNumber
				,	DD.FirstDateOfMonth
				,	SUM(ISNULL(FST.ExtendedPrice,0)) AS LaserPrice
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN MonthToDatePeriod DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
						ON FST.CenterKey = CTR.CenterKey
					INNER JOIN #CenterNumber CN
						ON CTR.CenterNumber = CN.CenterNumber
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
						ON FST.SalesCodeKey = DSC.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
						ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON FST.SalesOrderKey = SO.SalesOrderKey
				WHERE DSCD.SalesCodeDepartmentDescription = 'Laser Devices' --34
					AND DSCD.SalesCodeDivisionSSID = 30
					AND SO.IsVoidedFlag = 0
				GROUP BY FST.CenterKey
					 ,	CTR.CenterNumber
					 ,	DD.FirstDateOfMonth
),
RecurringBBudget AS ( SELECT  RB.FirstDateOfMonth
						,       RB.YearNumber
						,       MTD.MonthNumber
						,       RB.CenterNumber
						--,       RB.TotalPCPAmt_Budget
						,		RB.RetailAmt
						,       RB.RetailAmt_Budget
						,       RB.TotalRevenue_Budget
						,       RB.ServiceAmt
						,		RB.ServiceAmt_Budget
						,		L.LaserPrice
						FROM HC_BI_Datazen.dbo.dashRecurringBusiness RB
						INNER JOIN MonthToDatePeriod MTD
							ON RB.FirstDateOfMonth = MTD.FirstDateOfMonth
						LEFT JOIN Laser L
							ON L.CenterNumber = RB.CenterNumber
						INNER JOIN #CenterNumber CN
							ON RB.CenterNumber = CN.CenterNumber
						WHERE RB.FirstDateOfMonth = @Period

),
TotalPCPAmt_Budget AS (SELECT FA.PartitionDate
						,	CN.CenterNumber
						,	SUM(ISNULL(FA.Budget,0)) AS TotalPCPAmt_Budget
						FROM HC_Accounting.dbo.FactAccounting FA
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
							ON FA.CenterID = CTR.CenterNumber							---CenterID in FactAccounting is using CenterNumber
						INNER JOIN #CenterNumber CN
							ON CTR.CenterNumber = CN.CenterNumber
						WHERE FA.AccountID IN(3015, 10536)								---Include Non-Program with Recurring PCP Revenue
						AND FA.PartitionDate = @Period
						GROUP BY CN.CenterNumber
						,	FA.PartitionDate
),
AR AS ( SELECT  CTR.CenterNumber
				,	SUM(ISNULL(CLT.ClientARBalance,0)) AS ClientARBalance
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterSSID = CLT.CenterSSID
		INNER JOIN #CenterNumber CN
				ON CTR.CenterNumber = CN.CenterNumber
		GROUP BY CTR.CenterNumber
)

/******************************** Final select for Totals *******************************************************/
INSERT INTO #Totals
SELECT    NBBUD.CenterNumber
,	   'Totals' AS Section
,		NBBUD.FirstDateOfMonth
,       NBBUD.MonthNumber
,       NBBUD.YearNumber
,		CMA.CenterManagementAreaDescription
,		CTR.CenterDescription
,		NB_DR.NB_NetRevenue
,		NBBUD.NB_NetRevenue_Budget
,		NBBUD.NB_NetSales
,		NBBUD.NB_NetSales_Budget
,		RB_DR.TotalPCPAmt_Actual
--,       RBBUD.TotalPCPAmt_Budget
,		PCPBud.TotalPCPAmt_Budget
,		RBBUD.RetailAmt     --Includes Laser currently
,       RBBUD.RetailAmt_Budget
,		(ISNULL(NB_DR.NB_NetRevenue,0) + ISNULL(RB_DR.TotalPCPAmt_Actual,0) + ISNULL(RBBUD.RetailAmt,0) + ISNULL(RBBUD.ServiceAmt,0)) TotalCenterSales
,       RBBUD.TotalRevenue_Budget
,       RBBUD.ServiceAmt
,		RBBUD.ServiceAmt_Budget
,		Laser.LaserPrice
,		AR.ClientARBalance
,		@RemainingDays AS  RemainingDays
FROM NewBBudget NBBUD
INNER JOIN MonthToDatePeriod MTD
	ON MTD.FirstDateOfMonth = NBBUD.FirstDateOfMonth
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterNumber = NBBUD.CenterNumber
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
LEFT JOIN Laser
	ON CTR.CenterNumber = Laser.CenterNumber
		AND MTD.FirstDateOfMonth = Laser.FirstDateOfMonth
LEFT JOIN RecurringBBudget RBBUD
	ON CTR.CenterNumber = RBBUD.CenterNumber
		AND MTD.FirstDateOfMonth = RBBUD.FirstDateOfMonth
LEFT JOIN #NB_DR NB_DR
	ON NB_DR.CenterNumber = CTR.CenterNumber
LEFT JOIN #RB_DR RB_DR
	ON RB_DR.CenterNumber = CTR.CenterNumber
LEFT JOIN AR AR
	ON AR.CenterNumber = CTR.CenterNumber
LEFT JOIN TotalPCPAmt_Budget PCPBud
	ON PCPBud.CenterNumber = RBBUD.CenterNumber
		AND MTD.FirstDateOfMonth = PCPBud.PartitionDate
GROUP BY NBBUD.CenterNumber
,		NBBUD.FirstDateOfMonth
,       NBBUD.MonthNumber
,       NBBUD.YearNumber
,		CMA.CenterManagementAreaDescription
,		CTR.CenterDescription
,		NB_DR.NB_NetRevenue
,		NBBUD.NB_NetRevenue_Budget
,		NBBUD.NB_NetSales
,		NBBUD.NB_NetSales_Budget
,		RB_DR.TotalPCPAmt_Actual
,       PCPBud.TotalPCPAmt_Budget
,		RBBUD.RetailAmt     --Includes Laser currently
,       RBBUD.RetailAmt_Budget
,		(ISNULL(NB_DR.NB_NetRevenue,0) + ISNULL(RB_DR.TotalPCPAmt_Actual,0) + ISNULL(RBBUD.RetailAmt,0) + ISNULL(RBBUD.ServiceAmt,0))
,       RBBUD.TotalRevenue_Budget
,       RBBUD.ServiceAmt
,		RBBUD.ServiceAmt_Budget
,		Laser.LaserPrice
,		AR.ClientARBalance

/************************************ NB ****************************************************************************/
/************** Find Dates ******************************************************************************************/

DECLARE @ThisMonth DATETIME
DECLARE @ThisMembershipBeginDate DATETIME
DECLARE @Month INT
DECLARE @Year INT

SET @Month = MONTH(GETUTCDATE())
SET @Year = YEAR(GETUTCDATE())

SET @ThisMonth = CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATE)
SET @ThisMembershipBeginDate = DATEADD(MM,-12,@ThisMonth)


/************** Find initial sales for the past 4 months **************************************************************/

SELECT @ThisMembershipBeginDate ThisMembershipBeginDate
,	@ThisMonth ThisMonth
,	CTR.CenterNumber
,	CTR.CenterDescription
,	CLT.ClientSSID
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.ClientARBalance
,	CLT.ClientEMailAddress
,	'(' + LEFT(CLT.ClientPhone1,3) + ') ' + SUBSTRING(CLT.ClientPhone1,4,3) + '-' + RIGHT(CLT.ClientPhone1,4) ClientPhone1
,	DM.MembershipDescription
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipStatusDescription
,	CASE WHEN DCM.ClientMembershipStatusDescription = 'Active' THEN 1 ELSE 0 END  Active
,	DATEDIFF(DAY,DCM.ClientMembershipBeginDate,GETDATE()) ClientMembershipDuration
,	Active_Memberships.ClientMembershipContractPrice
,	Active_Memberships.ClientMembershipKey
INTO #InitialSale
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = CLT.CenterSSID
INNER JOIN #CenterNumber CN
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID)  --No Surgery
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
	ON DM.MembershipSSID = DCM.MembershipSSID
OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipKey
							  ,         DCM.ClientMembershipContractPrice
							  ,		    DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipIdentifier
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
											ON CTR.CenterSSID = CLT.CenterSSID
										INNER JOIN #CenterNumber CN
											ON CTR.CenterNumber = CN.CenterNumber
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
											ON DM.MembershipKey = DCM.MembershipKey
							  WHERE     ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
										AND DCM.ClientMembershipStatusDescription = 'Active'
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) Active_Memberships
WHERE DCM.ClientMembershipBeginDate >= @ThisMembershipBeginDate
AND DM.RevenueGroupSSID = 1			--NB
AND DM.BusinessSegmentSSID = 1		--XTR+
AND DM.MembershipDescription <> 'New Client (ShowNoSale)'
AND CLT.DoNotCallFlag = 0
AND CLT.DoNotContactFlag = 0

/************** Find initial clients who have been applied (and remove these later) ************************************************/

SELECT INI.ThisMembershipBeginDate,
        INI.ThisMonth,
        INI.CenterNumber,
        INI.CenterDescription,
        INI.ClientSSID,
        INI.ClientKey,
        INI.ClientIdentifier,
        INI.ClientFirstName,
        INI.ClientLastName,
        INI.ClientARBalance,
		INI.ClientEMailAddress,
		INI.ClientPhone1,
        INI.MembershipDescription,
        INI.ClientMembershipBeginDate,
        INI.ClientMembershipStatusDescription,
        INI.Active,
        INI.ClientMembershipDuration,
		INI.ClientMembershipContractPrice,
		INI.ClientMembershipKey
INTO #Applied
FROM #InitialSale INI
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	ON FST.ClientKey = INI.ClientKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
INNER JOIN #CenterNumber CN
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
	ON DSC.SalesCodeKey = FST.SalesCodeKey
WHERE FST.SalesCodeKey IN(SELECT SalesCodeKey FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode WHERE SalesCodeDescriptionShort = 'NB1A')
AND INI.Active = 1
GROUP BY INI.ThisMembershipBeginDate,
         INI.ThisMonth,
         INI.CenterNumber,
         INI.CenterDescription,
         INI.ClientSSID,
         INI.ClientKey,
         INI.ClientIdentifier,
         INI.ClientFirstName,
         INI.ClientLastName,
         INI.ClientARBalance,
		 INI.ClientEMailAddress,
		INI.ClientPhone1,
         INI.MembershipDescription,
         INI.ClientMembershipBeginDate,
         INI.ClientMembershipStatusDescription,
         INI.Active,
         INI.ClientMembershipDuration,
		INI.ClientMembershipContractPrice,
		INI.ClientMembershipKey


/********************************** Get Hair Order Information *************************************/

SELECT   ROW_NUMBER() OVER ( PARTITION BY hso.ClientKey ORDER BY hso.ClientKey, hso.HairSystemOrderDate ASC ) AS RowNumber
    ,        ce.CenterSSID
    ,        hso.ClientKey
	,		ISA.ClientIdentifier
    ,        hso.ClientHomeCenterKey
    ,        hso.HairSystemOrderDate
    ,        hso.HairSystemOrderNumber
    ,        hso.HairSystemAppliedDate
    ,        hso.HairSystemDueDate
    ,        hso.ClientMembershipKey
    ,        m.MembershipDescription
	,		hso.HairSystemOrderStatusKey
	,		HSOS.HairSystemOrderStatusDescription
	,        hso.HairSystemReceivedDate
	INTO #HairOrder_CTE
    FROM     HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder hso
            INNER JOIN #InitialSale ISA
                ON hso.ClientKey = ISA.ClientKey
            INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
                ON hso.CenterKey = ce.CenterKey
			INNER JOIN #CenterNumber CN
				ON ce.CenterNumber = CN.CenterNumber
            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                ON hso.ClientMembershipKey = cm.ClientMembershipKey
            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                ON cm.MembershipKey = m.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemOrderStatus HSOS
				ON HSOS.HairSystemOrderStatusKey = hso.HairSystemOrderStatusKey
			WHERE ISA.Active = 1


SELECT ho_cte.RowNumber
,      ho_cte.CenterSSID
,      ho_cte.ClientKey
,      ho_cte.ClientIdentifier
,      ho_cte.ClientHomeCenterKey
,      ho_cte.HairSystemOrderDate
,      ho_cte.HairSystemOrderNumber
,      ho_cte.HairSystemAppliedDate
,      ho_cte.HairSystemDueDate
,      ho_cte.ClientMembershipKey
,      ho_cte.MembershipDescription
,		ho_cte.HairSystemOrderStatusDescription
,      ho_cte.HairSystemReceivedDate
INTO   #HairOrder
FROM   #HairOrder_CTE ho_cte
WHERE  ho_cte.RowNumber = 1

/************** Find Hair Orders with a status of 'Received at Center','Priority Hair' **************************/


SELECT
	HO.HairSystemOrderStatusDescription
,	INI.ThisMembershipBeginDate
,	INI.ThisMonth
,	INI.CenterNumber
,	INI.CenterDescription
,	INI.ClientKey
,	INI.ClientIdentifier
,	INI.ClientFirstName
,	INI.ClientLastName
,	INI.ClientEMailAddress
,	INI.ClientPhone1
,	INI.MembershipDescription
,	INI.ClientMembershipBeginDate
,	INI.ClientMembershipStatusDescription
,	INI.Active
,	INI.ClientMembershipDuration
,	HO.HairSystemReceivedDate
,	INI.ClientMembershipContractPrice
,	INI.ClientMembershipKey
INTO #HairInCenter
FROM #HairOrder HO
INNER JOIN #InitialSale INI
	ON INI.ClientKey = HO.ClientKey
WHERE HO.HairSystemOrderStatusDescription IN('Received at Center','Priority Hair')
AND INI.Active = 1
AND INI.ClientKey NOT IN (SELECT ClientKey FROM #Applied)  --Find those who have not been applied
AND INI.ClientMembershipDuration <= 120						--Only those clients whose initial sale date is less than or equal to 120 days

/***************** Combine Hair Orders and Initial Sales for clients without appointments **********************/

SELECT  HC.HairSystemOrderStatusDescription
,	HC.ThisMembershipBeginDate
,	HC.ThisMonth
,	HC.CenterNumber
,	HC.CenterDescription
,	HC.ClientKey
,	HC.ClientIdentifier
,	HC.ClientFirstName
,	HC.ClientLastName
,	HC.ClientEMailAddress
,	HC.ClientPhone1
,	HC.MembershipDescription
,	HC.ClientMembershipBeginDate
,	HC.ClientMembershipStatusDescription
,	HC.Active
,	HC.ClientMembershipDuration
,	appt2.AppointmentDate
,	appt2.AppointmentStartTime
,	HC.HairSystemReceivedDate
,	HC.ClientMembershipContractPrice
,	NULL AS ExtendedPrice
,	NULL AS ContractBalance
,	HC.ClientMembershipKey
INTO #NB_Top5
FROM #HairInCenter  HC
OUTER APPLY(SELECT AppointmentDate
				,	AppointmentStartTime
				,	ROW_NUMBER()OVER(PARTITION BY ClientKey ORDER BY A.AppointmentDate) AS Ranking
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment A
			WHERE A.ClientKey = HC.ClientKey
				AND A.AppointmentDate > GETDATE()
			) appt2
WHERE (appt2.AppointmentDate IS NULL OR appt2.Ranking = 1)

/******Find the Total Payments ****************************************************************************/

INSERT INTO #TotalPayments
SELECT  FST.ClientKey
,       DCM.ClientMembershipKey
,		DCM.ClientMembershipEndDate
,		SA.ClientMembershipContractPrice
,		M.BusinessSegmentSSID
,       SUM(FST.ExtendedPrice *	FST.Quantity) AS ExtendedPrice
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #InitialSale SA
			ON FST.ClientKey = SA.ClientKey AND FST.ClientMembershipKey = SA.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
			ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
			ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M  WITH ( NOLOCK )
			ON M.MembershipKey = FST.MembershipKey
WHERE   FST.ClientKey IN(SELECT ClientKey FROM #InitialSale)
			AND (FST.NB_TradAmt <> 0
					OR FST.NB_GradAmt <> 0
					OR FST.NB_ExtAmt <> 0
					OR FST.NB_XTRAmt <> 0)
			AND DCM.ClientMembershipEndDate >= GETUTCDATE()
			AND DSC.SalesCodeDepartmentSSID IN ( 2020 )
			AND DSC.SalesCodeDescriptionShort NOT IN ( 'EXTPMTLC', 'EXTPMTLCP', 'EXTPMTLH', 'EXTPMTLB', 'EXTPMTLCN', 'EXTPMTCAP82', 'EXTPMTCAP202', 'EXTPMTCAP272', 'EXTCAP312', 'EXTPMTCAP312', 'EXTCAP202TI', 'EXTCAP272TI', 'EXTCAP312TI' ) -- Exclude Laser Comb, Laser Helmet, Laser Band or Capillus Payments
			AND DSOD.IsVoidedFlag = 0
			AND M.BusinessSegmentSSID IN(1,2,6)
GROUP BY FST.ClientKey
,       DCM.ClientMembershipKey
,		DCM.ClientMembershipEndDate
,		SA.ClientMembershipContractPrice
,		M.BusinessSegmentSSID


INSERT INTO #SUM_TotalPayments
SELECT ClientKey
,       SUM(ClientMembershipContractPrice)
,       SUM(TP.ExtendedPrice) AS ExtendedPrice
,		SUM(TP.ClientMembershipContractPrice) - SUM(TP.ExtendedPrice) AS ContractBalance
FROM #TotalPayments TP
GROUP BY ClientKey

UPDATE NB
SET NB.ExtendedPrice = STP.ExtendedPrice
FROM #NB_Top5 NB
INNER JOIN #SUM_TotalPayments STP
	ON STP.ClientKey = NB.ClientKey
WHERE NB.ExtendedPrice IS NULL

UPDATE NB
SET NB.ContractBalance = STP.ContractBalance
FROM #NB_Top5 NB
INNER JOIN #SUM_TotalPayments STP
	ON STP.ClientKey = NB.ClientKey
WHERE NB.ContractBalance IS NULL

/************************************************************/

IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
INSERT INTO #NB
SELECT CenterNumber
,	'NB' AS Section
,	ThisMembershipBeginDate
,	ThisMonth
,	AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CenterDescription
,	ClientKey
,	ClientIdentifier
,	ClientFirstName
,	ClientLastName
,	ClientEmailAddress
,	ClientPhone1
,	ClientMembershipKey
,	MembershipDescription
,	ClientMembershipBeginDate
,	ClientMembershipStatusDescription
,	HairSystemOrderStatusDescription
,	Active
,	ClientMembershipDuration
,	HairSystemReceivedDate
,	ClientMembershipContractPrice
,	ExtendedPrice
,	ContractBalance
FROM #NB_Top5
END
ELSE
BEGIN
INSERT INTO #NB
SELECT TOP 5 CenterNumber
,	'NB' AS Section
,	ThisMembershipBeginDate
,	ThisMonth
,	AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CenterDescription
,	ClientKey
,	ClientIdentifier
,	ClientFirstName
,	ClientLastName
,	ClientEmailAddress
,	ClientPhone1
,	ClientMembershipKey
,	MembershipDescription
,	ClientMembershipBeginDate
,	ClientMembershipStatusDescription
,	HairSystemOrderStatusDescription
,	Active
,	ClientMembershipDuration
,	HairSystemReceivedDate
,	ClientMembershipContractPrice
,	ExtendedPrice
,	ContractBalance
FROM #NB_Top5
ORDER BY ClientMembershipBeginDate DESC
END

/*********************************** Recurring Business RB ************************************************************************/
/*********** IF there is more than one CenterNumber then pull all records else top five *******************************************/

IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
INSERT INTO #RB
SELECT 	CTR.CenterNumber
,	'RB' AS Section
,	appt6.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt6.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CLT.ClientIdentifier
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.ClientEMailAddress
,	'(' + LEFT(CLT.ClientPhone1,3) + ') ' + SUBSTRING(CLT.ClientPhone1,4,3) + '-' + RIGHT(CLT.ClientPhone1,4) ClientPhone1
,	DM.MembershipDescription
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipStatusDescription
,	CLT.ExpectedConversionDate
,	CLT.DoNotCallFlag
,	CLT.DoNotContactFlag
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = CLT.CenterSSID
INNER JOIN #CenterNumber CN
	ON CN.CenterNumber = CTR.CenterNumber
INNER JOIN #MonthToDate MTD
	ON CLT.ExpectedConversionDate = MTD.FullDate
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID)  --No Surgery
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
	ON DM.MembershipSSID = DCM.MembershipSSID
OUTER APPLY(SELECT a2.AppointmentDate
				,	a2.AppointmentStartTime
				,	ROW_NUMBER()OVER(PARTITION BY ClientKey ORDER BY a2.AppointmentDate) AS Ranking
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment a2
			WHERE a2.ClientKey = CLT.ClientKey
				AND a2.AppointmentDate > GETDATE()
			) appt6
WHERE DCM.ClientMembershipStatusDescription = 'Active'
AND DM.RevenueGroupSSID = 1   --NB with an Expected Conversion Date this month
AND CLT.DoNotCallFlag = 0
AND CLT.DoNotContactFlag = 0
AND (appt6.AppointmentDate IS NULL OR appt6.Ranking = 1)
END
ELSE
BEGIN
INSERT INTO #RB
SELECT TOP 5
	CTR.CenterNumber
,	'RB' AS Section
,	appt6.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt6.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CLT.ClientIdentifier
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.ClientEMailAddress
,	'(' + LEFT(CLT.ClientPhone1,3) + ') ' + SUBSTRING(CLT.ClientPhone1,4,3) + '-' + RIGHT(CLT.ClientPhone1,4) ClientPhone1
,	DM.MembershipDescription
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipStatusDescription
,	CLT.ExpectedConversionDate
,	CLT.DoNotCallFlag
,	CLT.DoNotContactFlag
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = CLT.CenterSSID
INNER JOIN #CenterNumber CN
	ON CN.CenterNumber = CTR.CenterNumber
INNER JOIN #MonthToDate MTD
	ON CLT.ExpectedConversionDate = MTD.FullDate
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID)  --No Surgery
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
	ON DM.MembershipSSID = DCM.MembershipSSID
OUTER APPLY(SELECT a2.AppointmentDate
				,	a2.AppointmentStartTime
				,	ROW_NUMBER()OVER(PARTITION BY ClientKey ORDER BY a2.AppointmentDate) AS Ranking
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment a2
			WHERE a2.ClientKey = CLT.ClientKey
				AND a2.AppointmentDate > GETDATE()
			) appt6
WHERE DCM.ClientMembershipStatusDescription = 'Active'
AND DM.RevenueGroupSSID = 1   --NB with an Expected Conversion Date this month
AND CLT.DoNotCallFlag = 0
AND CLT.DoNotContactFlag = 0
AND (appt6.AppointmentDate IS NULL OR appt6.Ranking = 1)
ORDER BY DCM.ClientMembershipBeginDate DESC
END


/***************************** Find Services ****************************************************************************/
/****************** Find memberships ******************************************************************************************/

SELECT DC.CenterNumber
,	DC.CenterDescription
,	DCLT.ClientKey
,	DCLT.ClientIdentifier
,	DCLT.ClientFirstName
,	DCLT.ClientLastName
,	DCLT.ClientEMailAddress
,	'(' + LEFT(DCLT.ClientPhone1,3) + ') ' + SUBSTRING(DCLT.ClientPhone1,4,3) + '-' + RIGHT(DCLT.ClientPhone1,4) ClientPhone1
,	memb_status.MembershipDescription
,	memb_status.ClientMembershipBeginDate
,	memb_status.ClientMembershipStatusDescription
,	DCLT.ClientGenderDescription
INTO #Mem
FROM   HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON DCLT.CenterSSID = DC.CenterSSID
	INNER JOIN #CenterNumber CN
		ON DC.CenterNumber = CN.CenterNumber
	OUTER APPLY ( SELECT TOP 1
							DCM.ClientMembershipSSID
					,         DM.MembershipSSID
					,         DM.MembershipDescription
					,			DM.MembershipDescriptionShort
					,         DCM.ClientMembershipStatusDescription
					,         DCM.ClientMembershipBeginDate
					,         DCM.ClientMembershipEndDate
					FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
							ON CLT.CenterSSID = DC.CenterSSID
						INNER JOIN #CenterNumber CN
							ON DC.CenterNumber = CN.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
							ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
							ON DM.MembershipKey = DCM.MembershipKey
					WHERE DCLT.ClientKey = CLT.ClientKey
					ORDER BY  DCM.ClientMembershipEndDate DESC
				) memb_status
WHERE memb_status.ClientMembershipStatusDescription = 'Active'
	AND DCLT.ClientGenderDescription = 'Female'
	AND DCLT.DoNotCallFlag = 0
	AND DCLT.DoNotContactFlag = 0

/****************** Find Service appointments ******************************************************************************************/

SELECT appt3.CenterSSID
		,	MAX(appt3.AppointmentDate) AppointmentDate
		,	MAX(appt3.AppointmentStartTime) AppointmentStartTime
		,	MAX(appt3.AppointmentEndTime) AppointmentEndTime
		,	DD.FullDate
		,	DD.MonthNumber
		,	DD.YearNumber
		,	Mem.CenterNumber
		,	Mem.CenterDescription
		,	Mem.ClientKey
		,	Mem.ClientIdentifier
		,	Mem.ClientFirstName
		,	Mem.ClientLastName
		,	Mem.ClientEMailAddress
		,	Mem.ClientPhone1
		,	Mem.MembershipDescription
		,	Mem.ClientMembershipBeginDate
		,	Mem.ClientMembershipStatusDescription
		,	ROW_NUMBER()OVER(PARTITION BY Mem.ClientIdentifier ORDER BY DD.FullDate ASC)  Ranking
INTO #Appt
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment appt3
	INNER JOIN #MonthToDate DD
		ON appt3.AppointmentDate = DD.FullDate
	INNER JOIN #Mem Mem
		ON Mem.ClientKey = appt3.ClientKey
WHERE appt3.CheckOutTime IS NULL -- These appointments have not yet occurred
AND appt3.IsDeletedFlag = 0
AND appt3.AppointmentDate >= GETDATE()  -- They should not be before today
GROUP BY appt3.CenterSSID
,       DD.FullDate
,       DD.MonthNumber
,       DD.YearNumber
,       Mem.CenterNumber
,       Mem.CenterDescription
,       Mem.ClientKey
,       Mem.ClientIdentifier
,       Mem.ClientFirstName
,       Mem.ClientLastName
,		Mem.ClientEMailAddress
,		Mem.ClientPhone1
,       Mem.MembershipDescription
,       Mem.ClientMembershipBeginDate
,       Mem.ClientMembershipStatusDescription

/********************* Final select if multiple centers then select all, else select top 5 **************/

IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
INSERT INTO #Services
SELECT 	appt4.CenterNumber
,	'Services' AS Section
,	appt4.MonthNumber
,	appt4.YearNumber
,	appt4.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt4.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt4.AppointmentEndTime, 100), 7))  AppointmentEndTime
,	appt4.CenterDescription
,	appt4.ClientKey
,	appt4.ClientIdentifier
,	appt4.ClientFirstName
,	appt4.ClientLastName
,	appt4.ClientEMailAddress
,	appt4.ClientPhone1
,	appt4.MembershipDescription
,	appt4.ClientMembershipBeginDate
,	appt4.ClientMembershipStatusDescription
FROM #Appt appt4
WHERE appt4.Ranking = 1  --This will remove duplicate clients
ORDER BY appt4.AppointmentDate  --As the days continue, the Appointment Dates that are today or tomorrow will drop off and additional appointments will appear
	, appt4.AppointmentStartTime
END
ELSE
BEGIN
INSERT INTO #Services
SELECT TOP 5 appt4.CenterNumber
,	'Services' AS Section
,	appt4.MonthNumber
,	appt4.YearNumber
,	appt4.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt4.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt4.AppointmentEndTime, 100), 7))  AppointmentEndTime
,	appt4.CenterDescription
,	appt4.ClientKey
,	appt4.ClientIdentifier
,	appt4.ClientFirstName
,	appt4.ClientLastName
,	appt4.ClientEMailAddress
,	appt4.ClientPhone1
,	appt4.MembershipDescription
,	appt4.ClientMembershipBeginDate
,	appt4.ClientMembershipStatusDescription
FROM #Appt appt4
WHERE appt4.Ranking = 1  --This will remove duplicate clients
ORDER BY appt4.AppointmentDate  --As the days continue, the Appointment Dates that are today or tomorrow will drop off and additional appointments will appear
	, appt4.AppointmentStartTime
END

/****************************** Lasers and Capillus *************************************************/
/************************** Find EXT memberships ****************************************************/

SELECT DC.CenterNumber
,	DC.CenterDescription
,	DCLT.ClientKey
,	DCLT.ClientIdentifier
,	DCLT.ClientFirstName
,	DCLT.ClientLastName
,	DCLT.ClientEMailAddress
,	'(' + LEFT(DCLT.ClientPhone1,3) + ') ' + SUBSTRING(DCLT.ClientPhone1,4,3) + '-' + RIGHT(DCLT.ClientPhone1,4) ClientPhone1
,	memb_status.MembershipDescription
,	memb_status.ClientMembershipBeginDate
,	memb_status.ClientMembershipStatusDescription
INTO #EXTMem
FROM   HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON DCLT.CenterSSID = DC.CenterSSID
	INNER JOIN #CenterNumber CN
		ON DC.CenterNumber = CN.CenterNumber
	OUTER APPLY ( SELECT TOP 1
						DCM.ClientMembershipSSID
					,   DM.MembershipSSID
					,   DM.MembershipDescription
					,	DM.MembershipDescriptionShort
					,	DCM.ClientMembershipStatusDescription
					,	DCM.ClientMembershipBeginDate
					,	DCM.ClientMembershipEndDate
					FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
							ON CLT.CenterSSID = CTR.CenterSSID
						INNER JOIN #CenterNumber CN
							ON CTR.CenterNumber = CN.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
							ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
							ON DM.MembershipKey = DCM.MembershipKey
					WHERE DCLT.ClientKey = CLT.ClientKey
							AND DM.RevenueGroupDescription = 'Recurring Business'
							AND DM.BusinessSegmentDescription = 'Extreme Therapy'
					ORDER BY  DCM.ClientMembershipEndDate DESC
				) memb_status
WHERE memb_status.ClientMembershipStatusDescription = 'Active'
	AND DCLT.ClientPhone1 IS NOT NULL
	AND DCLT.DoNotCallFlag = 0
	AND DCLT.DoNotContactFlag = 0


/************************** Find Laser sales codes ****************************************************/

SELECT DSC.SalesCodeKey
,	DSC.SalesCodeSSID
,	DSC.SalesCodeDescription
INTO #Laser
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment  DSCD
	on DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE DSCD.SalesCodeDepartmentDescription = 'Laser Devices' --34  Changed this to remove hard-coded sales codes
AND DSCD.SalesCodeDivisionSSID = 30

/************************** Find Laser sales codes and clients ****************************************************/

SELECT FST.ClientKey
, FST.SalesOrderKey
, FST.SalesCodeKey
, DSC.SalesCodeDepartmentSSID
INTO #LaserClients
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN #EXTMem EXTMem
	ON EXTMem.ClientKey = FST.ClientKey
INNER JOIN #Laser Laser
	ON Laser.SalesCodeKey = FST.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
	ON DSC.SalesCodeKey = FST.SalesCodeKey


/************************** Find Laser Appointments ****************************************************/

SELECT appt7.CenterSSID
		,	MAX(appt7.AppointmentDate) AppointmentDate
		,	MAX(appt7.AppointmentStartTime) AppointmentStartTime
		,	MAX(appt7.AppointmentEndTime) AppointmentEndTime
		,	DD.FullDate
		,	DD.MonthNumber
		,	DD.YearNumber
		,	EXTMem.CenterNumber
		,	EXTMem.CenterDescription
		,	EXTMem.ClientKey
		,	EXTMem.ClientIdentifier
		,	EXTMem.ClientFirstName
		,	EXTMem.ClientLastName
		,	EXTMem.ClientEMailAddress
		,	EXTMem.ClientPhone1
		,	EXTMem.MembershipDescription
		,	EXTMem.ClientMembershipBeginDate
		,	EXTMem.ClientMembershipStatusDescription
		,	ROW_NUMBER()OVER(PARTITION BY EXTMem.ClientIdentifier ORDER BY DD.FullDate ASC)  Ranking
INTO #LaserAppt
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment appt7
	INNER JOIN #MonthToDate DD
		ON appt7.AppointmentDate = DD.FullDate
	INNER JOIN #EXTMem EXTMem
		ON EXTMem.ClientKey = appt7.ClientKey
WHERE appt7.CheckOutTime IS NULL -- These appointments have not yet occurred
AND appt7.IsDeletedFlag = 0
AND appt7.AppointmentDate >= GETDATE()  -- They should not be before today
GROUP BY appt7.CenterSSID
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	EXTMem.CenterNumber
,	EXTMem.CenterDescription
,	EXTMem.ClientKey
,	EXTMem.ClientIdentifier
,	EXTMem.ClientFirstName
,	EXTMem.ClientLastName
,	EXTMem.ClientEMailAddress
,	EXTMem.ClientPhone1
,	EXTMem.MembershipDescription
,	EXTMem.ClientMembershipBeginDate
,	EXTMem.ClientMembershipStatusDescription


/*********** IF there is nore than one CenterNumber then pull all records else top five *******************************************/

IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
INSERT INTO #LaserCap
SELECT LA.CenterNumber
,	'Laser' AS Section
,	LA.MonthNumber
,	LA.YearNumber
,	LA.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), LA.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), LA.AppointmentEndTime, 100), 7)) AppointmentEndTime
,	LA.CenterDescription
,	LA.ClientKey
,	LA.ClientIdentifier
,	LA.ClientFirstName
,	LA.ClientLastName
,	LA.ClientEMailAddress
,	LA.ClientPhone1
,	LA.MembershipDescription
,	LA.ClientMembershipBeginDate
,	LA.ClientMembershipStatusDescription
FROM #LaserAppt LA
WHERE LA.Ranking = 1  --This will remove duplicate clients
AND LA.ClientKey NOT IN (SELECT ClientKey FROM #LaserClients)
AND LA.ClientPhone1 <> '() -'
END
ELSE
BEGIN
INSERT INTO #LaserCap
SELECT TOP 5 	LA.CenterNumber
,	'Laser' AS Section
,	LA.MonthNumber
,	LA.YearNumber
,	LA.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), LA.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), LA.AppointmentEndTime, 100), 7))  AppointmentEndTime
,	LA.CenterDescription
,	LA.ClientKey
,	LA.ClientIdentifier
,	LA.ClientFirstName
,	LA.ClientLastName
,	LA.ClientEMailAddress
,	LA.ClientPhone1
,	LA.MembershipDescription
,	LA.ClientMembershipBeginDate
,	LA.ClientMembershipStatusDescription
FROM #LaserAppt  LA
WHERE LA.Ranking = 1  --This will remove duplicate clients
AND LA.ClientKey NOT IN (SELECT ClientKey FROM #LaserClients)
AND LA.ClientPhone1 <> '() -'
ORDER BY LA.AppointmentDate  --As the days continue, the Appointment Dates that are today or tomorrow will drop off and additional appointments will appear
END

/**************** Find yesterday no-show appointments ***********************************************************/


CREATE TABLE #NoShowYesterday(
		AppointmentKey INT
	,   CenterNumber INT
	,	CenterDescription NVARCHAR(60)
	,	Section NVARCHAR(50)
	,	ClientKey INT
	,	ClientFirstName NVARCHAR(50)
	,	ClientLastName NVARCHAR(50)
	,   ClientIdentifier INT
	,	MembershipDescription NVARCHAR(60)
	,	RevenueGroupDescription NVARCHAR(60)
	,	AppointmentDate DATETIME
	,	AppointmentStartTime NVARCHAR(25)
	,	AppointmentEndTime NVARCHAR(25)
	,	SalesCodeDescription NVARCHAR(60)
	,	EmployeeFullName1   NVARCHAR(150)
	,	EmployeeFullName2   NVARCHAR(150)
	)


CREATE TABLE #rankMissed (
		AppointmentKey INT
	,	EmployeeFullName NVARCHAR(150)
	,	RANKING INT)

INSERT INTO #NoShowYesterday
SELECT 	appt8.AppointmentKey
	,	CTR.CenterNumber
	,	CTR.CenterDescription
	,	'NoShowYesterday' AS Section
	,	appt8.ClientKey
	,	cl.ClientFirstName
	,   cl.ClientLastName
	,   cl.ClientIdentifier
	,	m.MembershipDescription
	,	m.RevenueGroupDescription
	,	appt8.AppointmentDate
	,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt8.AppointmentStartTime, 100), 7)) AS AppointmentStartTime
	,	LTRIM(RIGHT(CONVERT(VARCHAR(25), appt8.AppointmentEndTime, 100), 7)) AS AppointmentEndTime
	,	scd.SalesCodeDescription
	,	NULL AS EmployeeFullName1
	,	NULL AS EmployeeFullName2
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment appt8
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON CTR.CenterKey = appt8.CenterKey
	INNER JOIN #CenterNumber CN
		ON CTR.CenterNumber = CN.CenterNumber
	INNER JOIN #MonthToDate DD
		ON appt8.AppointmentDate = DD.FullDate
	CROSS APPLY
		(SELECT TOP(1) SalesCodeDescription
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON ad.SalesCodeKey = sc.SalesCodeKey
			WHERE appt8.AppointmentKey = ad.AppointmentKey
			) scd
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
		ON appt8.ClientKey = cl.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm   -- pull the client membership from the appointment to match the Appointment2.rdl
		ON appt8.ClientMembershipKey = cm.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
		ON m.MembershipKey = cm.MembershipKey
WHERE appt8.AppointmentDate >= @YesterdayStartDate
	AND appt8.AppointmentDate <= @YesterdayEndDate
	AND ISNULL(appt8.IsDeletedFlag, 0) = 0
	AND appt8.ClientKey <> -1
	AND appt8.CheckInTime IS NULL


/************Use ranking to partition employees *****************************************/

INSERT INTO #rankMissed
SELECT ap.AppointmentKey
	,  e.EmployeeFullName
	,	ROW_NUMBER() OVER(PARTITION BY ap.AppointmentKey ORDER BY e.EmployeeFullName DESC) AS RANKING
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].FactAppointmentEmployee fae
		ON ap.AppointmentKey = fae.AppointmentKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee e
		ON fae.EmployeeKey = e.EmployeeKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePositionJoin epj
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionSSID
WHERE ap.AppointmentDate >= @YesterdayStartDate
AND ap.AppointmentDate <= @YesterdayEndDate
AND ap.AppointmentKey IN (SELECT AppointmentKey FROM #NoShowYesterday)
AND e.IsActiveFlag = 1



UPDATE p
SET p.EmployeeFullName1 = RM.EmployeeFullName
FROM #NoShowYesterday p
INNER JOIN #rankMissed RM ON p.AppointmentKey = RM.AppointmentKey
WHERE RM.RANKING = 1
AND p.EmployeeFullName1 IS NULL

UPDATE p
SET p.EmployeeFullName2 = RM.EmployeeFullName
FROM #NoShowYesterday p
INNER JOIN #rankMissed RM
	ON p.AppointmentKey = RM.AppointmentKey
WHERE RM.RANKING = 2
AND p.EmployeeFullName2 IS NULL


/*************** Final select ************************************************************************************/
--Combine the sections into one table

INSERT INTO #Appoint
SELECT  CenterNumber
,		Section
,		FirstDateOfMonth
,       MonthNumber
,       YearNumber
,       NULL AS ThisMembershipBeginDate
,       NULL AS ThisMonth
,		NULL AS AppointmentDate
,       NULL AS AppointmentStartTime
,       NULL AS AppointmentEndTime
,       NULL AS CenterManagementAreaSSID
,       CenterManagementAreaDescription
,       CenterDescription
,       NULL AS ClientKey
,       NULL AS ClientIdentifier
,       NULL AS ClientFirstName
,       NULL AS ClientLastName
,       NULL AS ClientEMailAddress
,       NULL AS ClientPhone1
,       NULL AS ClientMembershipKey
,       NULL AS MembershipDescription
,       NULL AS ClientMembershipBeginDate
,       NULL AS ClientMembershipStatusDescription
,       NULL AS ExpectedConversionDate
,       NULL AS DoNotCallFlag
,       NULL AS DoNotContactFlag
,		NB_NetRevenue
,       NB_NetRevenue_Budget
,       NB_NetSales
,       NB_NetSales_Budget
,       TotalPCPAmt_Actual
,       TotalPCPAmt_Budget
,       RetailAmt
,       RetailAmt_Budget
,		TotalCenterSales
,       TotalRevenue_Budget
,       ServiceAmt
,       ServiceAmt_Budget
,       LaserPrice
,       ClientARBalance
,       RemainingDays
,       NULL AS HairSystemOrderStatusDescription
,       NULL AS Active
,       NULL AS ClientMembershipDuration
,       NULL AS HairSystemReceivedDate
,		NULL AS ClientMembershipContractPrice
,		NULL AS TotalPayments
,		NULL AS ContractBalance
,		NULL AS SalesCodeDescription
,		NULL AS RevenueGroupDescription
,		NULL AS EmployeeFullName1
,		NULL AS EmployeeFullName2
FROM #Totals
UNION ALL
SELECT  CenterNumber
,		Section
,		NULL AS FirstDateOfMonth
,       NULL AS MonthNumber
,       NULL AS YearNumber
,       ThisMembershipBeginDate
,       ThisMonth
,		AppointmentDate
,       CONVERT(VARCHAR,AppointmentStartTime,108) AS AppointmentStartTime
,       NULL AS AppointmentEndTime
,       NULL AS CenterManagementAreaSSID
,       NULL AS CenterManagementAreaDescription
,       CenterDescription
,       ClientKey
,       ClientIdentifier
,       ClientFirstName
,       ClientLastName
,       ClientEMailAddress
,       ClientPhone1
,       ClientMembershipKey
,       MembershipDescription
,       ClientMembershipBeginDate
,       ClientMembershipStatusDescription
,       NULL AS ExpectedConversionDate
,       NULL AS DoNotCallFlag
,       NULL AS DoNotContactFlag
,		NULL AS NB_NetRevenue
,       NULL AS NB_NetRevenue_Budget
,       NULL AS NB_NetSales
,       NULL AS NB_NetSales_Budget
,       NULL AS TotalPCPAmt_Actual
,       NULL AS TotalPCPAmt_Budget
,       NULL AS RetailAmt
,       NULL AS RetailAmt_Budget
,		NULL AS TotalCenterSales
,       NULL AS TotalRevenue_Budget
,       NULL AS ServiceAmt
,       NULL AS ServiceAmt_Budget
,       NULL AS LaserPrice
,       NULL AS ClientARBalance
,       NULL AS RemainingDays
,       HairSystemOrderStatusDescription
,       Active
,       ClientMembershipDuration
,       HairSystemReceivedDate
,		ClientMembershipContractPrice
,		ExtendedPrice AS TotalPayments
,       ContractBalance
,		NULL AS SalesCodeDescription
,		NULL AS RevenueGroupDescription
,		NULL AS EmployeeFullName1
,		NULL AS EmployeeFullName2
FROM #NB
UNION ALL
SELECT  CenterNumber
,		Section
,		NULL AS FirstDateOfMonth
,		NULL AS MonthNumber
,       NULL AS YearNumber
,       NULL AS ThisMembershipBeginDate
,       NULL AS ThisMonth
,		AppointmentDate
,       CONVERT(VARCHAR,AppointmentStartTime,108) AS AppointmentStartTime
,       NULL AS AppointmentEndTime
,       NULL AS CenterManagementAreaSSID
,       NULL AS CenterManagementAreaDescription
,       NULL AS CenterDescription
,       NULL AS ClientKey
,       ClientIdentifier
,       ClientFirstName
,       ClientLastName
,       ClientEMailAddress
,       ClientPhone1
,       NULL AS ClientMembershipKey
,       MembershipDescription
,       ClientMembershipBeginDate
,       ClientMembershipStatusDescription
,       ExpectedConversionDate
,       DoNotCallFlag
,       DoNotContactFlag
,		NULL AS NB_NetRevenue
,       NULL AS NB_NetRevenue_Budget
,       NULL AS NB_NetSales
,       NULL AS NB_NetSales_Budget
,       NULL AS TotalPCPAmt_Actual
,       NULL AS TotalPCPAmt_Budget
,       NULL AS RetailAmt
,       NULL AS RetailAmt_Budget
,		NULL AS TotalCenterSales
,       NULL AS TotalRevenue_Budget
,       NULL AS ServiceAmt
,       NULL AS ServiceAmt_Budget
,       NULL AS LaserPrice
,       NULL AS ClientARBalance
,       NULL AS RemainingDays
,       NULL AS HairSystemOrderStatusDescription
,       NULL AS Active
,       NULL AS ClientMembershipDuration
,       NULL AS HairSystemReceivedDate
,		NULL AS ClientMembershipContractPrice
,		NULL AS TotalPayments
,       NULL AS ContractBalance
,		NULL AS SalesCodeDescription
,		NULL AS RevenueGroupDescription
,		NULL AS EmployeeFullName1
,		NULL AS EmployeeFullName2
FROM #RB
UNION ALL
SELECT  CenterNumber
,		Section
,		NULL AS FirstDateOfMonth
,		MonthNumber
,       YearNumber
,       NULL AS ThisMembershipBeginDate
,       NULL AS ThisMonth
,		AppointmentDate
,       CONVERT(VARCHAR,AppointmentStartTime,108) AS AppointmentStartTime
,       CONVERT(VARCHAR,AppointmentEndTime,108) AS AppointmentEndTime
,       NULL AS CenterManagementAreaSSID
,       NULL AS CenterManagementAreaDescription
,       CenterDescription
,       ClientKey
,       ClientIdentifier
,       ClientFirstName
,       ClientLastName
,       ClientEMailAddress
,       ClientPhone1
,       NULL AS ClientMembershipKey
,       MembershipDescription
,       ClientMembershipBeginDate
,       ClientMembershipStatusDescription
,       NULL AS ExpectedConversionDate
,       NULL AS DoNotCallFlag
,       NULL AS DoNotContactFlag
,		NULL AS NB_NetRevenue
,       NULL AS NB_NetRevenue_Budget
,       NULL AS NB_NetSales
,       NULL AS NB_NetSales_Budget
,       NULL AS TotalPCPAmt_Actual
,       NULL AS TotalPCPAmt_Budget
,       NULL AS RetailAmt
,       NULL AS RetailAmt_Budget
,		NULL AS TotalCenterSales
,       NULL AS TotalRevenue_Budget
,       NULL AS ServiceAmt
,       NULL AS ServiceAmt_Budget
,       NULL AS LaserPrice
,       NULL AS ClientARBalance
,       NULL AS RemainingDays
,       NULL AS HairSystemOrderStatusDescription
,       NULL AS Active
,       NULL AS ClientMembershipDuration
,       NULL AS HairSystemReceivedDate
,		NULL AS ClientMembershipContractPrice
,		NULL AS TotalPayments
,       NULL AS ContractBalance
,		NULL AS SalesCodeDescription
,		NULL AS RevenueGroupDescription
,		NULL AS EmployeeFullName1
,		NULL AS EmployeeFullName2
FROM #Services
UNION ALL
SELECT  CenterNumber
,		Section
,		NULL AS FirstDateOfMonth
,		MonthNumber
,       YearNumber
,       NULL AS ThisMembershipBeginDate
,       NULL AS ThisMonth
,		AppointmentDate
,       CONVERT(VARCHAR,AppointmentStartTime,108) AS AppointmentStartTime
,       CONVERT(VARCHAR,AppointmentEndTime,108) AS AppointmentEndTime
,       NULL AS CenterManagementAreaSSID
,       NULL AS CenterManagementAreaDescription
,       CenterDescription
,       ClientKey
,       ClientIdentifier
,       ClientFirstName
,       ClientLastName
,       ClientEMailAddress
,       ClientPhone1
,       NULL AS ClientMembershipKey
,       MembershipDescription
,       ClientMembershipBeginDate
,       ClientMembershipStatusDescription
,       NULL AS ExpectedConversionDate
,       NULL AS DoNotCallFlag
,       NULL AS DoNotContactFlag
,		NULL AS NB_NetRevenue
,       NULL AS NB_NetRevenue_Budget
,       NULL AS NB_NetSales
,       NULL AS NB_NetSales_Budget
,		NULL AS TotalPCPAmt_Actual
,       NULL AS TotalPCPAmt_Budget
,       NULL AS RetailAmt
,       NULL AS RetailAmt_Budget
,		NULL AS TotalCenterSales
,       NULL AS TotalRevenue_Budget
,       NULL AS ServiceAmt
,       NULL AS ServiceAmt_Budget
,       NULL AS LaserPrice
,       NULL AS ClientARBalance
,       NULL AS RemainingDays
,       NULL AS HairSystemOrderStatusDescription
,       NULL AS Active
,       NULL AS ClientMembershipDuration
,       NULL AS HairSystemReceivedDate
,		NULL AS ClientMembershipContractPrice
,		NULL AS TotalPayments
,       NULL AS ContractBalance
,		NULL AS SalesCodeDescription
,		NULL AS RevenueGroupDescription
,		NULL AS EmployeeFullName1
,		NULL AS EmployeeFullName2
FROM #LaserCap
UNION ALL
SELECT  CenterNumber
,		'NoShowYesterday' AS Section
,		NULL AS FirstDateOfMonth
,		NULL AS MonthNumber
,       NULL AS YearNumber
,       NULL AS ThisMembershipBeginDate
,       NULL AS ThisMonth
,		AppointmentDate
,       CONVERT(VARCHAR,AppointmentStartTime,108) AS AppointmentStartTime
,       CONVERT(VARCHAR,AppointmentEndTime,108) AS AppointmentEndTime
,       NULL AS CenterManagementAreaSSID
,       NULL AS CenterManagementAreaDescription
,       CenterDescription
,       ClientKey
,       ClientIdentifier
,       ClientFirstName
,       ClientLastName
,       NULL AS ClientEMailAddress
,       NULL AS ClientPhone1
,       NULL AS ClientMembershipKey
,       MembershipDescription
,       NULL AS ClientMembershipBeginDate
,       NULL AS ClientMembershipStatusDescription
,       NULL AS ExpectedConversionDate
,       NULL AS DoNotCallFlag
,       NULL AS DoNotContactFlag
,		NULL AS NB_NetRevenue
,       NULL AS NB_NetRevenue_Budget
,       NULL AS NB_NetSales
,       NULL AS NB_NetSales_Budget
,		NULL AS TotalPCPAmt_Actual
,       NULL AS TotalPCPAmt_Budget
,       NULL AS RetailAmt
,       NULL AS RetailAmt_Budget
,		NULL AS TotalCenterSales
,       NULL AS TotalRevenue_Budget
,       NULL AS ServiceAmt
,       NULL AS ServiceAmt_Budget
,       NULL AS LaserPrice
,       NULL AS ClientARBalance
,       NULL AS RemainingDays
,       NULL AS HairSystemOrderStatusDescription
,       NULL AS Active
,       NULL AS ClientMembershipDuration
,       NULL AS HairSystemReceivedDate
,		NULL AS ClientMembershipContractPrice
,		NULL AS TotalPayments
,       NULL AS ContractBalance
,		SalesCodeDescription
,		RevenueGroupDescription
,		EmployeeFullName1
,		EmployeeFullName2
FROM #NoShowYesterday
WHERE MembershipDescription NOT IN('Cancel','Retail')
	AND MembershipDescription NOT LIKE '%Employee%'
	AND MembershipDescription NOT LIKE '%Bosley%'


SELECT * FROM #Appoint
ORDER BY Section DESC  --This order places Total at the top

END
