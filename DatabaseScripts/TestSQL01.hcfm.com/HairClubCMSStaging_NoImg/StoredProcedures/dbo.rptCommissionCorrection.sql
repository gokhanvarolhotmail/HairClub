/* CreateDate: 02/17/2015 09:45:51.433 , ModifyDate: 05/27/2015 13:35:48.590 */
GO
/*
==============================================================================

PROCEDURE:				[rptCommissionCorrection]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

IMPLEMENTATION DATE:	02/26/2015

==============================================================================
DESCRIPTION:	Displays a list of all Commission corrections for the Center version of the report
==============================================================================
NOTES:	Multiple centers and multiple pay periods may be selected
==============================================================================
CHANGE HISTORY:
03/09/2015	RH	Added CommissionCorrectionID
05/26/2015	RH	Added StatusChangeDate
==============================================================================
SAMPLE EXECUTION:

EXEC rptCommissionCorrection '201', '454', 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[rptCommissionCorrection] (
	@CenterID NVARCHAR(MAX)
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


	--Create temp/ variable tables
	DECLARE @Centers TABLE
			(
				CenterID INT NOT NULL
			)


	CREATE TABLE #PayPeriod
			(
				PayPeriodKey INT NOT NULL
			)

	--Find selected centers

	IF @CenterID = '1' --All centers
	BEGIN
		INSERT INTO @Centers (CenterID)
		SELECT CenterID FROM cfgCenter
		WHERE IsActiveFlag = 1
		AND CenterID LIKE '[278]%'
	END
	ELSE
	BEGIN
		INSERT INTO @Centers (CenterID)
		SELECT item FROM fnSplit(@CenterID,',')
	END

	INSERT INTO #PayPeriod(PayPeriodKey)
	SELECT  item FROM fnSplit(@PayPeriodKey,',')


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
	,	CC.StatusChangeDate
	,	CC.PayOnDate
	,	CC.CommissionAdjustmentReasonID
	,	CAR.CommissionAdjustmentReasonDescription
	,	CC.ReasonForCorrection
	INTO #Commission
	FROM datCommissionCorrection CC
	INNER JOIN @Centers C
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
	WHERE CC.PayPeriodKey IN(SELECT CC.PayPeriodKey FROM #PayPeriod)



	IF @Status = 0 --ALL
	BEGIN
		SELECT * FROM #Commission
	END
	ELSE
	BEGIN
		SELECT * FROM #Commission
		WHERE CommissionCorrectionStatusID = @Status
	END

END
GO
