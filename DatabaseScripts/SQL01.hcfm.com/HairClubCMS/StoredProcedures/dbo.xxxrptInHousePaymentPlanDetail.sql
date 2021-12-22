/*
539155 - Cancelled client in 213
==============================================================================
PROCEDURE:				[rptInHousePaymentPlanDetail]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
AUTHOR: 				Rachelen Hut
DATE IMPLEMENTED: 		10/03/2016
==============================================================================
DESCRIPTION:	@Status = 1 for Active, 2 for Cancelled, 3 for Paid and 4 for New Business clients
				@Filter = 1 for By Regions, 2 By Area Managers, 3 By Centers
==============================================================================
CHANGE HISTORY:
11/07/2016 - RH - Removed duplicates using ROW_NUMBER() OVER PARTITION BY
11/11/2016 - RH - Added @Status
01/10/2017 - RH - Added @Filter for Area Managers logic; Replaced EmployeeKey with CenterManagementAreaID, EmployeeFullNameCalc with CenterManagementAreaDescription (#132688)
==============================================================================
SAMPLE EXECUTION:
EXEC [rptInHousePaymentPlanDetail] 'C','10/1/2016','11/30/2016', 3, 1, 1
EXEC [rptInHousePaymentPlanDetail] 'C','10/1/2016','10/30/2016', 9, 4, 2
EXEC [rptInHousePaymentPlanDetail] 'C','10/1/2016','10/30/2016', 213, 4, 3
==============================================================================
*/
CREATE PROCEDURE [dbo].[xxxrptInHousePaymentPlanDetail](
	@Type NVARCHAR(1)
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@MainGroupID INT
,	@Status INT
,	@Filter INT
)

AS
BEGIN

SET NOCOUNT ON


CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
,	CenterManagementAreaID INT
,	CenterManagementAreaDescription NVARCHAR(102)
)


CREATE TABLE #Main(
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,   PaymentPlanID INT
,	ClientGUID UNIQUEIDENTIFIER
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,   CenterDescriptionFullCalc NVARCHAR(104)
,   RegionID INT
,   RegionDescription NVARCHAR(50)
,   CenterManagementAreaID INT
,   CenterManagementAreaDescription NVARCHAR(104)
,   ClientIdentifier INT
,   FirstName NVARCHAR(50)
,   LastName NVARCHAR(50)
,   PaymentPlanStatusID INT
,   PaymentPlanStatusDescription NVARCHAR(50)
,   ContractAmount MONEY
,   DownpaymentAmount MONEY
,   TotalNumberOfPayments INT
,   RemainingNumberOfPayments INT
,   StartDate DATETIME
,   SatisfactionDate DATETIME
,   CancelDate DATETIME
,   RemainingBalance MONEY
,   ARBalance MONEY
,   RegionSortOrder INT
,   AreaManagerSortOrder INT
,   MonthlyFee MONEY
,	FirstService DATETIME
,	InitialApp DATETIME
,   Ranking INT
)

/********************************** Get list of centers *************************************/


IF @MainGroupID IS NULL AND @Type = 'C'
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		,		NULL AS CenterManagementAreaID
		,		NULL AS CenterManagementAreaDescription
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CONVERT(VARCHAR, C.CenterID) LIKE '[2]%'
				AND C.IsActiveFlag = 1
END
ELSE
IF @MainGroupID IS NULL AND @Type = 'F'
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		,		NULL AS CenterManagementAreaID
		,		NULL AS CenterManagementAreaDescription
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CONVERT(VARCHAR, C.CenterID) LIKE '[78]%'
				AND C.IsActiveFlag = 1
END
ELSE
IF @Filter = 1								--By Region
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		,		NULL AS CenterManagementAreaID
		,		NULL AS CenterManagementAreaDescription
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CONVERT(VARCHAR, C.CenterID) LIKE '[278]%'
				AND C.IsActiveFlag = 1
				AND C.RegionID = @MainGroupID
END
ELSE
IF  @Filter = 2								--By Area Managers
BEGIN
INSERT  INTO #Centers
		SELECT  AM.CenterManagementAreaID AS 'MainGroupID'
		,		AM.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		AM.CenterID
		,		AM.CenterDescription
		,		AM.CenterDescriptionFullCalc
		,		CASE WHEN AM.CenterTypeID = 1 THEN 'C' ELSE 'F' END AS 'CenterTypeDescription'
		,		AM.CenterManagementAreaID
		,		AM.CenterManagementAreaDescription
		FROM    vw_AreaManager AM
		WHERE   AM.IsActiveFlag = 1
		AND AM.CenterManagementAreaID = @MainGroupID
END
ELSE
IF @Filter = 3								-- A center has been selected
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		,		NULL AS CenterManagementAreaID
		,		NULL AS CenterManagementAreaDescription
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CONVERT(VARCHAR, C.CenterID) = @MainGroupID
				AND C.IsActiveFlag = 1
END


/********************** Main select *************************************/

INSERT INTO #Main
SELECT q.MainGroupID
     , q.MainGroupDescription
     , q.PaymentPlanID
     , q.ClientGUID
     , q.ClientMembershipGUID
     , q.CenterID
     , q.CenterDescription
     , q.CenterDescriptionFullCalc
     , q.RegionID
     , q.RegionDescription
     , q.CenterManagementAreaID
     , q.CenterManagementAreaDescription
     , q.ClientIdentifier
     , q.FirstName
     , q.LastName
     , q.PaymentPlanStatusID
     , q.PaymentPlanStatusDescription
     , q.ContractAmount
     , q.DownpaymentAmount
     , q.TotalNumberOfPayments
     , q.RemainingNumberOfPayments
     , q.StartDate
     , q.SatisfactionDate
     , q.CancelDate
     , q.RemainingBalance
     , q.ARBalance
     , q.RegionSortOrder
     , q.AreaManagerSortOrder
     , q.MonthlyFee
	 , q.FirstService
	 , q.InitialApp
     , q.Ranking
FROM (
SELECT  C.MainGroupID
,	C.MainGroupDescription
,	PP.PaymentPlanID
,	PP.ClientGUID
,	PP.ClientMembershipGUID
,	CLT.CenterID
,	C.CenterDescription
,	C.CenterDescriptionFullCalc
,	R.RegionID
,	R.RegionDescription
,	C.CenterManagementAreaID
,	C.CenterManagementAreaDescription
,	CLT.ClientIdentifier
,	CLT.FirstName
,	CLT.LastName
,	PP.PaymentPlanStatusID
,	PPS.PaymentPlanStatusDescription
,	PP.ContractAmount
,	PP.DownpaymentAmount
,	PP.TotalNumberOfPayments
,	PP.RemainingNumberOfPayments
,	PP.StartDate
,	PP.SatisfactionDate
,	PP.CancelDate
,	PP.RemainingBalance
,	CLT.ARBalance
,	R.RegionSortOrder
,	CMA.CenterManagementAreaSortOrder AS 'AreaManagerSortOrder'
,	CM.MonthlyFee
,	firstserv.OrderDate AS 'FirstService'
,	initapp.OrderDate AS 'InitialApp'
,	ROW_NUMBER() OVER (PARTITION BY CLT.ClientIdentifier ORDER BY PP.RemainingNumberOfPayments ASC) AS 'Ranking'
FROM dbo.datPaymentPlan PP
	INNER JOIN dbo.datClient CLT
		ON PP.ClientGUID = CLT.ClientGUID
	INNER JOIN dbo.cfgCenter CTR
		ON CLT.CenterID = CTR.CenterID
	INNER JOIN #Centers C
		ON CTR.CenterID = C.CenterID
	INNER JOIN lkpRegion R
		ON CTR.RegionID = R.RegionID
	INNER JOIN dbo.cfgCenterManagementArea CMA
		ON CTR.CenterManagementAreaID = CMA.CenterManagementAreaID
	LEFT JOIN dbo.datPaymentPlanJournal PPJ
		ON PP.PaymentPlanID = PPJ.PaymentPlanID
	INNER JOIN lkpPaymentPlanStatus PPS
		ON PP.PaymentPlanStatusID = PPS.PaymentPlanStatusID
	INNER JOIN dbo.datClientMembership CM
		ON PP.ClientMembershipGUID = CM.ClientMembershipGUID
	LEFT OUTER JOIN (
				-- Get First Service Date
				SELECT  ClientGUID
					,	OrderDate
					,	sod.SalesCodeID
					,   ROW_NUMBER() OVER ( PARTITION BY ClientGUID ORDER BY OrderDate ) AS 'FirstServRank'
				FROM dbo.datSalesOrder so
				INNER JOIN dbo.datSalesOrderDetail sod
					ON sod.SalesOrderGUID = so.SalesOrderGUID
				INNER JOIN dbo.cfgSalesCode SC
					ON sod.SalesCodeID = SC.SalesCodeID
				WHERE (sod.SalesCodeID = 773  --Xtrands Service (New)
				OR SC.SalesCodeDepartmentID IN(5035,5036)) --EXT Service
				AND so.IsVoidedFlag = 0
			) firstserv
		ON PP.ClientGUID = firstserv.ClientGUID
			AND firstserv.FirstServRank = 1
	LEFT OUTER JOIN (
				-- Get Initial Application/ New Style Date
				SELECT  ClientGUID
					,	OrderDate
					,	sod.SalesCodeID
					,   ROW_NUMBER() OVER ( PARTITION BY ClientGUID ORDER BY OrderDate ) AS 'InitAppRank'
				FROM dbo.datSalesOrder so
				INNER JOIN dbo.datSalesOrderDetail sod
					ON sod.SalesOrderGUID = so.SalesOrderGUID
				WHERE sod.SalesCodeID = 648  --Initial New Style
				AND so.IsVoidedFlag = 0
			) initapp
		ON PP.ClientGUID = initapp.ClientGUID
			AND initapp.InitAppRank = 1
		)q
WHERE Ranking = 1
ORDER BY q.RegionSortOrder
	,	q.AreaManagerSortOrder

/******** Pull by Status or New Business ***********************************/

IF @Status = 1				--Active
BEGIN
	SELECT * FROM #Main WHERE PaymentPlanStatusDescription = 'Active'
END
ELSE IF @Status = 2			--Cancelled
BEGIN
SELECT * FROM #Main WHERE PaymentPlanStatusDescription = 'Cancelled'
END
ELSE IF @Status = 3			--Paid
BEGIN
SELECT * FROM #Main WHERE PaymentPlanStatusDescription = 'Paid'
END
ELSE IF @Status = 4			--NB
BEGIN
SELECT * FROM #Main WHERE StartDate BETWEEN @StartDate AND @EndDate
END


END
