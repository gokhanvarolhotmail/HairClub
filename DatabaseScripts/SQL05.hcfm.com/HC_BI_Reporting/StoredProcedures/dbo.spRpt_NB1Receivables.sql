/* CreateDate: 05/28/2014 15:56:13.803 , ModifyDate: 07/30/2020 10:48:09.960 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_NB1Receivables]
VERSION:				v1.2
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_Reporting
RELATED APPLICATION:  	NB1 Receivables Report
AUTHOR: 				Dominic Leiba
IMPLEMENTOR: 			Dominic Leiba
DATE IMPLEMENTED: 		12/27/2006
LAST REVISION DATE: 	05/27/2014
--------------------------------------------------------------------------------------------------------
NOTES:
	09/30/2010	 MB 	Added code for inclusion of Franchise centers (W0# 55578)
	09/29/2011	 MB 	Added code to retrieve first payments after sale (WO# 67097)
	11/11/2011	 HDu	WO# 67413b Change to report on string lists of Centers and optional Minimum value filter
	12/05/2011	 HDu	WO# 69597 Removed Canceled Aggreements from the Receivables.
	12/16/2011	 HDu	WO# 70006 remove the NB1A condition for finding initial application date
	01/06/2014	 RH		Rewrote procedure to use the new tables on SQL06.
	02/04/2014	 DL		Rewrote procedure to use temp tables for appts, apps, convs, pmts & cancels (#98511)
	05/27/2014	 RH		Changed report to pull by Type 'C' or 'F', then by Region or by Centers.
	09/22/2016	 RH		Added requirements to limit the results (#127214)
	01/11/2018	 RH		Changed @Region to @Filter to be consistent with other reports; Removed Region for Corporate and added CenterManagementArea
-------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_NB1Receivables] '1/1/2019', '5/21/2019', 'C', 2, 50

EXEC [spRpt_NB1Receivables] '1/1/2018', '1/31/2018', 'C', 3, 50

EXEC [spRpt_NB1Receivables] '1/1/2018', '1/31/2018', 'F', 1, 50

**********************************************************************************************************/

CREATE PROCEDURE [dbo].[spRpt_NB1Receivables](
	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@sType CHAR(1)	--'C' for Corporate; 'F' for Franchise
	,	@Filter INT		-- 1 for Region; 2 by Area; 3 by Center
	,	@Minimum MONEY = NULL
)
AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;



/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription NVARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterManagementAreaSortOrder INT
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(103)
,	CenterType NVARCHAR(50)
)

CREATE TABLE #Display(
	RegionSSID INT
,	RegionDescription NVARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterManagementAreaSortOrder INT
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(103)
,	ClientKey INT
,   ClientName NVARCHAR(104)
,   OriginalMembership NVARCHAR(50)
,   CurrentMembership NVARCHAR(50)
,   ContractAmount MONEY
,   PaymentsToDate MONEY
,	FirstPayment MONEY
,   ContractBalance MONEY
,   SalesDate DATETIME
,	ConversionDate DATETIME
,	LastPaymentDate DATETIME
,	InitialApplicationDate DATETIME
,	LastAppointmentDate DATETIME
,	CancelDate DATETIME
,   ARBalance MONEY
,	ClientMembershipStatusDescription NVARCHAR(50)
)



/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 2    --By Areas
BEGIN
	INSERT  INTO #Centers
			SELECT  NULL AS 'RegionSSID'
			,		NULL AS 'RegionDescription'
			,		CMA.CenterManagementAreaSSID
			,		CMA.CenterManagementAreaDescription
			,		CMA.CenterManagementAreaSortOrder
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE   DCT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END
ELSE
IF @sType = 'C' AND @Filter = 3			--By Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  NULL AS RegionSSID
			,		NULL AS RegionDescription
			,		NULL AS CenterManagementAreaSSID
			,		NULL AS CenterManagementAreaDescription
			,		NULL AS CenterManagementAreaSortOrder
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
			WHERE   DCT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END

ELSE
IF @sType = 'F' AND @Filter = 1			--By Region
BEGIN
INSERT  INTO #Centers
			SELECT  DR.RegionSSID
			,		DR.RegionDescription
			,		NULL AS CenterManagementAreaSSID
			,		NULL AS CenterManagementAreaDescription
			,		NULL AS CenterManagementAreaSortOrder
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
			WHERE    DCT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
END
ELSE
IF @sType = 'F' AND @Filter = 3			--By Center
BEGIN
	INSERT  INTO #Centers
			SELECT  NULL AS RegionSSID
			,		NULL AS RegionDescription
			,		NULL AS CenterManagementAreaSSID
			,		NULL AS CenterManagementAreaDescription
			,		NULL AS CenterManagementAreaSortOrder
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
			WHERE   DCT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'

END

/********************************** Get sales data *************************************/

SELECT	C.RegionSSID
,		C.RegionDescription
,		C.CenterManagementAreaSSID
,		C.CenterManagementAreaDescription
,		C.CenterManagementAreaSortOrder
,		C.CenterSSID
,		C.CenterDescriptionNumber
,		C.CenterType
,		DD.FullDate AS 'SalesDate'
,		CLT.ClientKey
,		CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
,		DCM.ClientMembershipKey
,		DCM.ClientMembershipContractPrice As 'ContractAmount'
,		DCM.ClientMembershipContractPaidAmount As  'PaymentsToDate'
,		( DCM.ClientMembershipContractPrice - DCM.ClientMembershipContractPaidAmount ) AS 'ContractBalance'
,		DM.MembershipKey
,		DM.MembershipDescription AS 'MembershipSold'
,		[dbo].[GetCurrentClientMembershipKey](CLT.ClientKey) AS 'CurrentClientMembershipKey'
--,		ISNULL(DCMA.AccumMoney, 0) AS 'ARBalance'
,		CLT.ClientARBalance AS 'ARBalance'
INTO	#Clients
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment Dept
			ON DSC.SalesCodeDepartmentKey = Dept.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
			ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
			ON DC.ReportingCenterSSID = C.CenterSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum DCMA
			ON DCM.ClientMembershipKey = DCMA.ClientMembershipKey
				AND DCMA.AccumulatorSSID = 3
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeSSID IN ( 347, 761 )
		AND DM.MembershipDescriptionShort NOT IN ( '1STSURG', 'ADDSURG', 'POSTEXT' )
		AND ( DCM.ClientMembershipContractPrice > 0
				OR CLT.ClientARBalance > 0 )
		AND DCM.ClientMembershipContractPaidAmount >= @Minimum
--ORDER BY DD.FullDate
--,		DSO.InvoiceNumber


/***************************** Find Guarantees and remove them *******************************/

SELECT DISTINCT CLT.ClientKey
INTO #Guarantees
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
WHERE CLT.ClientKey IN (SELECT ClientKey FROM #Clients)
	AND DSO.IsGuaranteeFlag = 1


/********************************** Get Appointment Data *************************************/

SELECT  DA.ClientKey
,		DA.ClientMembershipKey
,       MAX(AppointmentDate) AS 'LastAppointmentDate'
INTO    #Appointments
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
		INNER JOIN #Clients C
			ON DA.ClientKey = C.ClientKey
				AND DA.ClientMembershipKey = C.ClientMembershipKey
WHERE   DA.AppointmentDate < GETDATE()
GROUP BY DA.ClientKey
,		DA.ClientMembershipKey

/********************************** Get Application Data *************************************/

SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		MIN(DD.FullDate) AS 'InitialApplicationDate'
INTO	#Applications
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DSC.SalesCodeSSID IN ( 647, 648 )
GROUP BY FST.ClientKey
,		FST.ClientMembershipKey


/********************************** Get Conversion Data *************************************/

SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		MIN(DD.FullDate) AS 'ConversionDate'
INTO	#Conversions
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSCD.SalesCodeDepartmentSSID IN ( 1075 )
GROUP BY FST.ClientKey
,		FST.ClientMembershipKey


/********************************** Get Last Payment Date *************************************/

SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		MAX(DD.FullDate) AS 'LastPaymentDate'
,		SUM(FST.ExtendedPrice) AS 'TotalPayments'
INTO	#Payments
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSCD.SalesCodeDepartmentSSID IN ( 2020 )
GROUP BY FST.ClientKey
,		FST.ClientMembershipKey

/********************************** Get Initial Payment *************************************/

SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		FST.ExtendedPrice AS 'InitialPayment'
,		ROW_NUMBER() OVER(PARTITION BY FST.ClientKey ORDER BY DD.FullDate ASC) AS 'PaymentID'
INTO	#InitialPayment
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSCD.SalesCodeDepartmentSSID IN ( 2020 )


/********************************** Get Cancel Data *************************************/

SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		MAX(DD.FullDate) AS 'CancelDate'
INTO	#Cancels
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSCD.SalesCodeDepartmentSSID IN ( 1099 )
GROUP BY FST.ClientKey
,		FST.ClientMembershipKey


/********* Display Results of those clients with either a Contract Balance or an AR Balance ***************/

INSERT INTO #Display
SELECT  C.RegionSSID
,		C.RegionDescription
,		C.CenterManagementAreaSSID
,		C.CenterManagementAreaDescription
,		C.CenterManagementAreaSortOrder
,		C.CenterSSID
,		C.CenterDescriptionNumber
,		C.ClientKey
,       C.ClientName
,       C.MembershipSold AS 'OriginalMembership'
,       DM.MembershipDescription AS 'CurrentMembership'
,       C.ContractAmount
,       C.PaymentsToDate
,		IP.InitialPayment AS 'FirstPayment'
,       C.ContractBalance
,       C.SalesDate
,		Conv.ConversionDate
,		P.LastPaymentDate
,		Apps.InitialApplicationDate
,		Appt.LastAppointmentDate
,		Cxls.CancelDate
,       C.ARBalance
,		DCM.ClientMembershipStatusDescription
FROM    #Clients C
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON C.CurrentClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipSSID = DM.MembershipSSID
		LEFT OUTER JOIN #Appointments Appt
			ON C.ClientKey = Appt.ClientKey
				AND C.ClientMembershipKey = Appt.ClientMembershipKey
		LEFT OUTER JOIN #Applications Apps
			ON C.ClientKey = Apps.ClientKey
				AND C.ClientMembershipKey = Apps.ClientMembershipKey
		LEFT OUTER JOIN #Conversions Conv
			ON C.ClientKey = Conv.ClientKey
				AND C.ClientMembershipKey = Conv.ClientMembershipKey
		LEFT OUTER JOIN #Payments P
			ON C.ClientKey = P.ClientKey
				AND C.ClientMembershipKey = P.ClientMembershipKey
		LEFT OUTER JOIN #InitialPayment IP
			ON C.ClientKey = IP.ClientKey
				AND C.ClientMembershipKey = IP.ClientMembershipKey
				AND IP.PaymentID = 1
		LEFT OUTER JOIN #Cancels Cxls
			ON C.ClientKey = Cxls.ClientKey
				AND C.ClientMembershipKey = Cxls.ClientMembershipKey
WHERE (ContractBalance <> '0.00' OR ARBalance <> '0.00')
	AND DM.MembershipDescriptionShort NOT IN ( '1STSURG', 'ADDSURG', 'POSTEXT', 'SHOWSALE' , 'SHOWNOSALE', 'SNSSURGOFF' )
	AND DM.RevenueGroupDescriptionShort <> 'PCP'


/*******************Remove Cancels that do not have an AR Balance ****************************************/

DELETE FROM #Display
WHERE (ClientMembershipStatusDescription = 'Cancel'
AND ARBalance = '0.00' )


/******************* Select all except GUARANTEEs ********************************************************/
SELECT CenterSSID
     , CenterDescriptionNumber
	 , RegionSSID
     , RegionDescription
     , CenterManagementAreaSSID
     , CenterManagementAreaDescription
     , CenterManagementAreaSortOrder
     , ClientKey
     , ClientName
     , OriginalMembership
     , CurrentMembership
     , ContractAmount
     , PaymentsToDate
     , FirstPayment
     , ContractBalance
     , SalesDate
     , ConversionDate
     , LastPaymentDate
     , InitialApplicationDate
     , LastAppointmentDate
     , CancelDate
     , ARBalance
     , ClientMembershipStatusDescription
FROM #Display
WHERE ConversionDate IS NULL
	AND ClientKey NOT IN (SELECT ClientKey FROM #Guarantees)


END
GO
