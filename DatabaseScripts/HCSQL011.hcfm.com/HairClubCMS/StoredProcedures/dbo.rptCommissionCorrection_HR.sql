/* CreateDate: 02/26/2015 11:20:19.620 , ModifyDate: 10/13/2015 13:54:27.683 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[rptCommissionCorrection_HR]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

IMPLEMENTATION DATE:	02/26/2015

==============================================================================
DESCRIPTION:	Displays a list of all Commission corrections for the HR version of the report
==============================================================================
NOTES:	Multiple centers and multiple pay periods may be selected
==============================================================================
CHANGE HISTORY:
03/09/2015	RH	Added CommissionCorrectionID
05/20/2015	RH	Replaced @StartDate and @EndDate with @PayOnDate; Added PayOnDate, StatusChangeDate
06/26/2015	RH	(WO#116131) Added logic to only include PayOnDate as a parameter when Status = 2 (Approved)
10/13/2015	RH	(WO#119292) Added Comments
==============================================================================
SAMPLE EXECUTION:

EXEC [rptCommissionCorrection_HR] '2015-05-29,2015-05-15', '201,211,280,281,292', '453,454,455', 3

EXEC [rptCommissionCorrection_HR] '1/1/1999', '1', '456,455,454', 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[rptCommissionCorrection_HR] (
@PayOnDate  NVARCHAR(MAX)
,	@CenterID NVARCHAR(MAX)
,	@PayPeriodKey NVARCHAR(MAX)
,	@Status INT
)  AS

BEGIN
SET NOCOUNT ON

/* Parameters:

	@CenterID	Description
		1		All
		May be one CenterID or a string of CenterID's

	@Status		Description
		0		All
		1		Pending
		2		Approved
		3		Denied
*/


--Create temp tables
CREATE TABLE #Centers (
			CenterID INT NOT NULL
		)

CREATE TABLE #PayPeriod (
			PayPeriodKey INT NOT NULL
		)

CREATE TABLE #PayOnDate (
			PayOnDate DATETIME NOT NULL
		)

--Find selected centers

IF @CenterID = '1' --All centers
BEGIN
	INSERT INTO #Centers (CenterID)
	SELECT CenterID FROM cfgCenter
	WHERE IsActiveFlag = 1
	AND CenterID LIKE '[278]%'
END
ELSE
BEGIN
	INSERT INTO #Centers (CenterID)
	SELECT item FROM fnSplit(@CenterID,',')
END


--Find PayPeriod's
INSERT INTO #PayPeriod(PayPeriodKey)
SELECT  item FROM fnSplit(@PayPeriodKey,',')


--Find PayOnDate's
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @BeginDate DATETIME

SET @StartDate = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
SET @EndDate = (SELECT MIN(PayDate) FROM [dbo].[Commission_lkpPayPeriods_TABLE] WHERE PayDate > GETUTCDATE())
SET @BeginDate = DATEADD(MONTH,-6,@StartDate)					--Six months ago

IF @PayOnDate = '1/1/1999' --All PayOnDate's from the drop-down list (which includes 6 months ago until one PayOnDate past today)
BEGIN
	INSERT INTO #PayOnDate
	SELECT PayDate AS 'PayOnDate'
	FROM [dbo].[Commission_lkpPayPeriods_TABLE]
	WHERE PayDate BETWEEN @BeginDate AND @EndDate
END
ELSE
BEGIN
	INSERT INTO #PayOnDate
	SELECT item FROM fnSplit(@PayOnDate,',')
END

--Select statement

SELECT CC.CenterID
,	CTR.CenterDescriptionFullCalc
,	CC.EmployeeGUID
,	CC.EmployeePositionID
,	EP.EmployeePositionDescription
,	E.EmployeeFullNameCalc
,	E.EmployeePayrollID
,	CC.PayPeriodKey
,	CC.CommissionCorrectionID
,	LPP.StartDate
,	LPP.EndDate
,	CC.CommissionPlanID
,	cp.CommissionPlanDescription
,	CC.CommissionPlanSectionID
,	CPS.CommissionPlanSectionDescription
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CC.AmountToBePaid
,	CC.CommissionCorrectionStatusID
,	CCS.CommissionCorrectionStatusDescription
,	CC.TransactionDate
,	CC.PayOnDate
,	CC.StatusChangeDate
,	CC.CommissionAdjustmentReasonID
,	CAR.CommissionAdjustmentReasonDescription
,	CC.ReasonForCorrection
,	CC.Comments
INTO #Commission
FROM datCommissionCorrection CC
INNER JOIN #Centers C
	ON CC.CenterID = C.CenterID
INNER JOIN cfgCenter CTR
	ON CC.CenterID = CTR.CenterID  --For CenterDescriptionFullCalc
INNER JOIN datEmployee E
	ON CC.EmployeeGUID = E.EmployeeGUID
INNER JOIN lkpEmployeePosition EP
	ON CC.EmployeePositionID = EP.EmployeePositionID
INNER JOIN lkpCommissionAdjustmentReason CAR
	ON CC.CommissionAdjustmentReasonID = CAR.CommissionAdjustmentReasonID
INNER JOIN lkpCommissionCorrectionStatus CCS
	ON CC.CommissionCorrectionStatusID = CCS.CommissionCorrectionStatusID
INNER JOIN lkpCommissionPlan CP
	ON CC.CommissionPlanID = CP.CommissionPlanID
INNER JOIN lkpCommissionPlanSection CPS
	ON CC.CommissionPlanSectionID = CPS.CommissionPlanSectionID
INNER JOIN dbo.datClient CLT
	ON CC.ClientGUID = CLT.ClientGUID
INNER JOIN #PayPeriod PP
	ON CC.PayPeriodKey = PP.PayPeriodKey
INNER JOIN Commission_lkpPayPeriods_TABLE LPP
	ON CC.PayPeriodKey = LPP.PayPeriodKey
LEFT JOIN #PayOnDate POD
	ON CC.PayOnDate = POD.PayOnDate
WHERE CC.PayPeriodKey IN(SELECT PayPeriodKey FROM #PayPeriod)
	--AND (CC.PayOnDate IN(SELECT PayOnDate FROM #PayOnDate) OR CC.PayOnDate IS NULL)


/*	@Status		Description
		0		All
		1		Pending
		2		Approved
		3		Denied
*/

IF @Status = 0 --ALL
BEGIN
	SELECT * FROM #Commission
END
ELSE
IF @Status IN (1,3)  --There will be no PayOnDate
BEGIN
	SELECT * FROM #Commission
	WHERE CommissionCorrectionStatusID = @Status
END
ELSE
IF @Status = 2  --Approved will have a PayOnDate
BEGIN
	SELECT * FROM #Commission
	WHERE CommissionCorrectionStatusID = @Status
	AND PayOnDate IN(SELECT PayOnDate FROM #PayOnDate)
END


END
GO
