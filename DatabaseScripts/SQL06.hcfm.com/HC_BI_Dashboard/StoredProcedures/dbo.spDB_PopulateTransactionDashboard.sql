/* CreateDate: 07/17/2020 14:10:21.283 , ModifyDate: 09/03/2020 11:17:00.143 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spDB_PopulateTransactionDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/17/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateTransactionDashboard
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateTransactionDashboard]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Today DATETIME
,		@StartDate DATETIME
,		@EndDate DATETIME
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@PreviousYearStart DATETIME
,		@PreviousYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @Today = CAST(DATEADD(DAY, 0, CURRENT_TIMESTAMP) AS DATE)
SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today), 0))
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @Today)) +1, 0))
SET @CurrentYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)
SET @CurrentYearEnd = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)))
SET @PreviousYearEnd = DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0))
SET @PreviousYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @PreviousYearEnd), 0)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Date (
	DateKey INT
,	FullDate DATETIME
,	YearNumber INT
,	MonthNumber INT
,	MonthName CHAR(10)
,	DayOfMonth INT
,	FirstDateOfMonth DATETIME
)

CREATE TABLE #Center (
	Area VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
)

CREATE TABLE #Transaction (
	DateKey INT
,	CenterKey INT
,	SalesOrderTypeKey INT
,	SalesCodeKey INT
,	SalesCodeDepartmentKey INT
,	SalesCodeDivisionKey INT
,	ClientKey INT
,	ClientMembershipKey INT
,	ContractPrice MONEY
,	ContractPaidAmount MONEY
,	MembershipKey INT
,	Employee1Key INT
,	Employee2Key INT
,	Quantity INT
,	Price MONEY
,	Tax MONEY
,	Total MONEY
,	GrossNBCount INT
,	NetNBCount INT
,	NetNBRevenue MONEY
,	NetPCPRevenue MONEY
,	NetNonProgramRevenue MONEY
,	NetRetailRevenue MONEY
,	NetServiceRevenue MONEY
,	NetTotalRevenue MONEY
,	NetFirstServiceCount INT
,	NetApplicationCount INT
,	NetConversionCount INT
,	NetXPICount INT
,	NetXPIRevenue MONEY
,	NetXPI6Count INT
,	NetXPI6Revenue MONEY
,	NetEXTCount INT
,	NetEXTRevenue MONEY
,	NetPostEXTCount INT
,	NetPostEXTRevenue MONEY
,	NetXtrandsCount INT
,	NetXtrandsRevenue MONEY
,	NetSurgeryCount INT
,	NetSurgeryRevenue MONEY
,	NetPRPCount INT
,	NetPRPRevenue MONEY
,	NetRestorInkCount INT
,	NetRestorInkRevenue MONEY
,	NetLaserCount INT
,	NetLaserRevenue MONEY
,	NetNBLaserCount INT
,	NetNBLaserRevenue MONEY
,	NetPCPLaserCount INT
,	NetPCPLaserRevenue MONEY
)

CREATE TABLE #Client (
	ClientKey INT
)

CREATE TABLE #FirstServiceDate (
	ClientKey INT
,	DateKey INT
,	FirstServiceDate DATETIME

)


/********************************** Get Date data *************************************/
INSERT	INTO #Date
		SELECT	dd.DateKey
		,		dd.FullDate
		,		dd.YearNumber
		,		dd.MonthNumber
		,		dd.MonthName
		,		dd.DayOfMonth
		,		dd.FirstDateOfMonth
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate dd
		WHERE	dd.FullDate BETWEEN @PreviousYearStart AND @Today


CREATE NONCLUSTERED INDEX IDX_Date_DateKey ON #Date ( DateKey );
CREATE NONCLUSTERED INDEX IDX_Date_FullDate ON #Date ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Date_FirstDateOfMonth ON #Date ( FirstDateOfMonth );


UPDATE STATISTICS #Date;


SELECT	@MinDate = MIN(d.FullDate)
,		@MaxDate = MAX(d.FullDate)
FROM	#Date d


/********************************** Get Center data *************************************/
INSERT	INTO #Center
		SELECT	CASE WHEN ct.CenterTypeDescriptionShort IN ( 'JV', 'F' ) THEN r.RegionDescription ELSE ISNULL(cma.CenterManagementAreaDescription, 'Corporate') END AS 'Area'
		,		ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		CASE WHEN ct.CenterTypeDescription = 'Joint' THEN 'Joint Venture' ELSE ct.CenterTypeDescription END AS 'CenterType'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON r.RegionKey = ctr.RegionKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	ct.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
				AND ( ctr.CenterNumber IN ( 360, 199 ) OR ctr.Active = 'Y' )


CREATE NONCLUSTERED INDEX IDX_Center_CenterSSID ON #Center ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


UPDATE STATISTICS #Center;


/********************************** Get Sales data *************************************/
INSERT	INTO #Transaction
		SELECT	d.DateKey
		,		c.CenterKey
		,		fst.SalesOrderTypeKey
		,		fst.SalesCodeKey
		,		dep.SalesCodeDepartmentKey
		,		dep.SalesCodeDivisionKey
		,		fst.ClientKey
		,		fst.ClientMembershipKey
		,		cm.ClientMembershipContractPrice AS 'ContractPrice'
		,		cm.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
		,		fst.MembershipKey
		,		fst.Employee1Key
		,		fst.Employee2Key
		,		fst.Quantity
		,		fst.ExtendedPrice AS 'Price'
		,		fst.Tax1 AS 'Tax'
		,		fst.ExtendedPricePlusTax AS 'Total'
		,		( ISNULL(fst.NB_GrossNB1Cnt, 0) + ISNULL(fst.NB_MDPCnt, 0) ) AS 'GrossNBCount'
		,		( ISNULL(fst.NB_TradCnt, 0) + ISNULL(fst.NB_GradCnt, 0) + ISNULL(fst.NB_ExtCnt, 0) + ISNULL(fst.S_PostExtCnt, 0) + ISNULL(fst.NB_XTRCnt, 0) + ISNULL(fst.S_SurCnt, 0) + ISNULL(fst.NB_MDPCnt, 0) + ISNULL(fst.S_PRPCnt, 0) ) AS 'NetNBCount'
		,       ( ISNULL(fst.NB_TradAmt, 0) + ISNULL(fst.NB_GradAmt, 0) + ISNULL(fst.NB_ExtAmt, 0) + ISNULL(fst.S_PostExtAmt, 0) + ISNULL(fst.NB_XTRAmt, 0) +  ISNULL(fst.S_SurAmt, 0) + ISNULL(fst.NB_MDPAmt, 0) + ISNULL(fst.NB_LaserAmt, 0) + ISNULL(fst.S_PRPAmt, 0) ) AS 'NetNBRevenue'
		,		ISNULL(fst.PCP_NB2Amt, 0) AS 'NetPCPRevenue'
		,		ISNULL(fst.PCPNonPgmAmt, 0) AS 'NetNonProgramRevenue'
		,		ISNULL(fst.RetailAmt, 0) AS 'NetRetailRevenue'
		,		ISNULL(fst.ServiceAmt, 0) AS 'NetServiceRevenue'
		,		ISNULL(fst.NetSalesAmt, 0) AS 'NetTotalRevenue'
		,		NULL AS 'NetFirstServiceCount'
		,		ISNULL(fst.NB_AppsCnt, 0) AS 'NetApplicationCount'
		,		( ISNULL(fst.NB_BIOConvCnt, 0) + ISNULL(fst.NB_EXTConvCnt, 0) + ISNULL(fst.NB_XTRConvCnt, 0) ) AS 'NetConversionCount'
		,       ISNULL(fst.NB_TradCnt, 0) AS 'NetXPICount'
		,       ISNULL(fst.NB_TradAmt, 0) AS 'NetXPIRevenue'
		,       ISNULL(fst.NB_GradCnt, 0) AS 'NetXPI6Count'
		,       ISNULL(fst.NB_GradAmt, 0) AS 'NetXPI6Revenue'
		,       ISNULL(fst.NB_ExtCnt, 0) AS 'NetEXTCount'
		,       ISNULL(fst.NB_ExtAmt, 0) AS 'NetEXTRevenue'
		,       ISNULL(fst.S_PostExtCnt, 0) AS 'NetPostEXTCount'
		,       ISNULL(fst.S_PostExtAmt, 0) AS 'NetPostEXTRevenue'
		,       ISNULL(fst.NB_XTRCnt, 0) AS 'NetXtrandsCount'
		,       ISNULL(fst.NB_XTRAmt, 0) AS 'NetXtrandsRevenue'
		,       ISNULL(fst.S_SurCnt, 0) AS 'NetSurgeryCount'
		,       ISNULL(fst.S_SurAmt, 0) AS 'NetSurgeryRevenue'
		,		ISNULL(fst.S_PRPCnt, 0) AS 'NetPRPCount'
		,		ISNULL(fst.S_PRPAmt, 0) AS 'NetPRPRevenue'
		,       ISNULL(fst.NB_MDPCnt, 0) AS 'NetRestorInkCount'
		,       ISNULL(fst.NB_MDPAmt, 0) AS 'NetRestorInkRevenue'
		,       ISNULL(fst.LaserCnt, 0) AS 'NetLaserCount'
		,       ISNULL(fst.LaserAmt, 0) AS 'NetLaserRevenue'
		,       ISNULL(fst.NB_LaserCnt, 0) AS 'NetNBLaserCount'
		,       ISNULL(fst.NB_LaserAmt, 0) AS 'NetNBLaserRevenue'
		,       ISNULL(fst.PCP_LaserCnt, 0) AS 'NetPCPLaserCount'
		,       ISNULL(fst.PCP_LaserAmt, 0) AS 'NetPCPLaserRevenue'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN #Date d
					ON d.FullDate = dd.FullDate
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment dep
					ON dep.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType sot
					ON sot.SalesOrderTypeKey = so.SalesOrderTypeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN #Center c
					ON c.CenterKey = cm.CenterKey
		WHERE	sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_Transaction_DateKey ON #Transaction ( DateKey );
CREATE NONCLUSTERED INDEX IDX_Transaction_ClientKey ON #Transaction ( ClientKey );


UPDATE STATISTICS #Transaction;


/********************************** Get Distinct Client Data *************************************/
INSERT	INTO #Client
		SELECT	DISTINCT
				t.ClientKey
		FROM	#Transaction t


CREATE NONCLUSTERED INDEX IDX_Client_ClientKey ON #Client ( ClientKey );


UPDATE STATISTICS #Client;


/********************************** Get First Service Data *************************************/
INSERT	INTO #FirstServiceDate
		SELECT	c.ClientKey
		,		MIN(dd.DateKey) AS 'DateKey'
		,		MIN(dd.FullDate) AS 'FirstServiceDate'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN #Client c
					ON c.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
		WHERE   sc.SalesCodeDescriptionShort IN ( 'NB1A', 'EXTSVC', 'WEXTSVC', 'XTRNEWSRV', 'SURPOST', 'SMPBACK', 'SMPTOUCH', 'SMPFULL', 'SMPBACKTOP', 'SMPDONOR', 'SMPFRTPK', 'SMPFRT', 'SMPFRTTOP', 'SMPFULLMAX', 'SMPCROWN', 'SVCSMP', 'SMPTEMPORAL' )
				AND so.IsVoidedFlag = 0
		GROUP BY c.ClientKey


CREATE NONCLUSTERED INDEX IDX_FirstServiceDate_DateKey ON #FirstServiceDate ( DateKey );
CREATE NONCLUSTERED INDEX IDX_FirstServiceDate_ClientKey ON #FirstServiceDate ( ClientKey );


UPDATE STATISTICS #FirstServiceDate;


/********************************** Update First Service Count Data *************************************/
UPDATE	t
SET		t.NetFirstServiceCount = 1
FROM	#Transaction t
		INNER JOIN #FirstServiceDate fsd
			ON fsd.ClientKey = t.ClientKey
				AND fsd.DateKey = t.DateKey


/********************************** Insert Sales data *************************************/
TRUNCATE TABLE dbTransaction


INSERT	INTO dbTransaction
		SELECT	t.DateKey
		,		t.CenterKey
		,		t.SalesOrderTypeKey
		,		t.SalesCodeKey
		,		t.SalesCodeDepartmentKey
		,		t.SalesCodeDivisionKey
		,		t.ClientMembershipKey
		,		t.ContractPrice
		,		t.ContractPaidAmount
		,		t.MembershipKey
		,		t.Employee1Key
		,		t.Employee2Key
		,		t.Quantity
		,		t.Price
		,		t.Tax
		,		t.Total
		,		t.GrossNBCount
		,		t.NetNBCount
		,		t.NetNBRevenue
		,		t.NetPCPRevenue
		,		t.NetNonProgramRevenue
		,		t.NetRetailRevenue
		,		t.NetServiceRevenue
		,		t.NetTotalRevenue
		,		ISNULL(t.NetFirstServiceCount, 0) AS 'NetFirstServiceCount'
		,		t.NetApplicationCount
		,		t.NetConversionCount
		,		t.NetXPICount
		,		t.NetXPIRevenue
		,		t.NetXPI6Count
		,		t.NetXPI6Revenue
		,		t.NetEXTCount
		,		t.NetEXTRevenue
		,		t.NetPostEXTCount
		,		t.NetPostEXTRevenue
		,		t.NetXtrandsCount
		,		t.NetXtrandsRevenue
		,		t.NetSurgeryCount
		,		t.NetSurgeryRevenue
		,		t.NetPRPCount
		,		t.NetPRPRevenue
		,		t.NetRestorInkCount
		,		t.NetRestorInkRevenue
		,		t.NetLaserCount
		,		t.NetLaserRevenue
		,		t.NetNBLaserCount
		,		t.NetNBLaserRevenue
		,		t.NetPCPLaserCount
		,		t.NetPCPLaserRevenue
		FROM	#Transaction t

END
GO
