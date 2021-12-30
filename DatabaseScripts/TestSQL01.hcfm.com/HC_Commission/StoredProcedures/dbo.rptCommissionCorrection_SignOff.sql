/* CreateDate: 03/31/2015 12:11:43.033 , ModifyDate: 03/31/2015 12:47:37.973 */
GO
/*
==============================================================================

PROCEDURE:				[rptCommissionCorrection_SignOff]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_Commission

IMPLEMENTOR: 			Rachelen Hut

IMPLEMENTATION DATE:	03/31/2015

==============================================================================
DESCRIPTION:	Displays a list of all Commission corrections for the Previous
	PayPeriod for the Employee Sign-Off Form  (WO#112423)
==============================================================================
NOTES:
==============================================================================
CHANGE HISTORY:

==============================================================================
SAMPLE EXECUTION:

EXEC [rptCommissionCorrection_SignOff] 250, 452, 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[rptCommissionCorrection_SignOff] (
	@CenterSSID NVARCHAR(50)
,	@PayPeriodID NVARCHAR(50)
,	@EmployeeKey NVARCHAR(50)
)  AS

BEGIN
	SET NOCOUNT ON

	--DECLARE @LastPayPeriodID INT
	--SET @LastPayPeriodID = (@PayPeriodID - 1)
	--PRINT @LastPayPeriodID

	CREATE TABLE #signoff(CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(104)
	,	EmployeeFullNameCalc NVARCHAR(104)
	,	EmployeePayrollID INT
	,	EmployeeInitials NVARCHAR(2)
	,	PayPeriodKey NVARCHAR(12)
	,	CommissionCorrectionID INT
	,	CommissionPlanID INT
	,	CommissionPlanSectionDescription  NVARCHAR(104)
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(104)
	,	AmountToBePaid MONEY
	,	TransactionDate DATETIME
	,	StartDate DATETIME
	,	EndDate DATETIME
	,	PayDate DATETIME)

	DECLARE @LastPayPeriodID NVARCHAR(50)
		SET @LastPayPeriodID = (@PayPeriodID - 1)
		PRINT @LastPayPeriodID


				SELECT CC.CenterID
				,	CTR.CenterDescriptionFullCalc
				,	E.EmployeeFullNameCalc
				,	E.EmployeePayrollID
				,	E.EmployeeInitials
				,	CC.PayPeriodKey
				,	CC.CommissionCorrectionID
				,	CC.CommissionPlanID
				,	CPS.CommissionPlanSectionDescription
				,	CLT.ClientIdentifier
				,	CLT.ClientFullNameCalc
				,	CC.AmountToBePaid
				,	CC.TransactionDate
				,	LPP.StartDate
				,	LPP.EndDate
				,	LPP.PayDate
				FROM SQL01.HairClubCMS.dbo.datCommissionCorrection CC
				INNER JOIN SQL01.HairClubCMS.dbo.cfgCenter CTR
					ON CC.CenterID = CTR.CenterID  --For CenterDescriptionFullCalc
				INNER JOIN SQL01.HairClubCMS.dbo.datEmployee E
					ON CC.EmployeeGUID = E.EmployeeGUID
				INNER JOIN SQL01.HairClubCMS.dbo.lkpCommissionPlan CP
					ON CC.CommissionPlanID = CP.CommissionPlanID
				INNER JOIN SQL01.HairClubCMS.dbo.lkpCommissionPlanSection CPS
					ON CC.CommissionPlanSectionID = CPS.CommissionPlanSectionID
				INNER JOIN SQL01.HairClubCMS.dbo.datClient CLT
					ON CC.ClientGUID = CLT.ClientGUID
				INNER JOIN dbo.lkpPayPeriods LPP
					ON CC.PayPeriodKey =LPP.PayPeriodKey
				WHERE CC.PayPeriodKey = @LastPayPeriodID
					AND CC.CenterID = @CenterSSID
					AND (E.EmployeePayrollID IN (SELECT EmployeePayrollID FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee WHERE EmployeeKey =  @EmployeeKey) OR  @EmployeeKey = 0)


END
GO
