/* CreateDate: 02/16/2015 14:53:33.113 , ModifyDate: 03/31/2015 09:39:37.360 */
GO
/*
==============================================================================

PROCEDURE:				[rptCommissionCorrection]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

==============================================================================
DESCRIPTION:	Displays a list of all Commission corrections
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [rptCommissionCorrection] 292, 335, 1

EXEC [rptCommissionCorrection] 201, 452, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptCommissionCorrection] (
	@CenterSSID INT
,	@PayPeriodKey INT
,	@Status INT
)  AS

BEGIN
	SET NOCOUNT ON

	/*
		@Status is from the lkpCommissionCorrectionStatus table:

		CommissionCorrectionStatusID	CommissionCorrectionStatusDescription
			1								Pending
			2								Approved
			3								Denied



	--CREATE TABLE #Commission (
	--	CenterID INT
	--,	CenterDescriptionFullCalc VARCHAR(100)
	--,	EmployeeGUID UNIQUEIDENTIFIER
	--,	EmployeePositionID INT
	--,	EmployeeFullName VARCHAR(255)
	--,	PayPeriodKey INT
	--,	CommissionPlanID INT
	--,	CommissionPlanSectionID INT
	--,	ClientID INT
	--,	ClientFullName VARCHAR(100)
	--,	AmountToBePaid MONEY
	--,	CommissionCorrectionsStatusID INT
	--,	TransactionDate DATETIME
	--,	CreateDate DATETIME  --Status Change Date
	--,	CommissionAdjustmentReasonID INT
	--,	ReasonForCorrection NVARCHAR(200)
	--)

		*/



	SELECT CenterID
	,	CenterDescriptionFullCalc
	,	EmployeeGUID
	,	EmployeePositionID
	,	EmployeeFullName
	,	PayPeriodKey
	,	CommissionPlanID
	,	CommissionPlanSectionID
	,	ClientID
	,	ClientFullName
	,	AmountToBePaid
	,	CommissionCorrectionsStatusID
	,	TransactionDate
	,	CreateDate  --Status Change Date
	,	CommissionAdjustmentReasonID
	,	ReasonForCorrection
	INTO #Commission
	FROM datCommissionCorrection CC
	INNER JOIN lkpCommissionAdjustmentReason CAR
		ON CC.CommissionAdjustmentReasonID = CAR.CommissionAdjustmentReasonID
	INNER JOIN lkpCommissionCorrectionStatus CCS
		ON CC.CommissionCorrectionStatusID = CCS.CommissionCorrectionStatusID
	INNER JOIN lkpCommissionPlan CP
		ON CC.CommissionPlanID = CP.CommissionPlanID
	INNER JOIN lkpCommissionPlanSection CPS
		ON CC.CommissionPlanSectionID = CPS.CommissionPlanSectionID


	SELECT *
	FROM #Commission

END
GO
