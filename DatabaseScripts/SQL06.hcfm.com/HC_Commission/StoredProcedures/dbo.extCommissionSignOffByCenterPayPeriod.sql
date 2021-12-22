/* CreateDate: 09/18/2017 21:23:22.800 , ModifyDate: 06/01/2019 13:49:28.550 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionSignOffByCenterPayPeriod]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission signoff by center and pay period
==============================================================================
NOTES:	The regular commissions are pulled for the current pay period, but the commission corrections are for the previous pay period.
The Pay On Date for commission corrections is the Pay On Date listed in the table, SQL01.HairclubCMS.datCommissionCorrections.
==============================================================================
CHANGE HISTORY:

04/03/2013 - MB - Corrected report so that Conversion commissions now show up properly (#84754)
09/05/2014 - DL - Added the commission % column (#103632)
03/31/2015 - RH - Added the bottom statement for Last Pay Date in a UNION statement (#112423)
06/18/2015 - RH - Added CommissionCorrectionStatusDescription since Denied corrections were showing on the report (#115581)
12/20/2016 - RH - Set PayDate for corrections to the PayOnDate from datCommissionCorrections; Pull only Approved commission corrections (#132925)
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionSignOffByCenterPayPeriod] 1080, 560, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionSignOffByCenterPayPeriod]
(
    @CenterSSID INT,
    @PayPeriodID INT,
    @EmployeeKey INT
)
AS
BEGIN

SET NOCOUNT ON;


--Use @PayDate to set the PayDate for corrections to the PayDate of the selected pay period
DECLARE @PayDate DATETIME;


SET @PayDate = (SELECT PayDate FROM dbo.lkpPayPeriods WHERE PayPeriodKey = @PayPeriodID);


--Create temp tables
CREATE TABLE #EmployeeKeys (EmployeeKey INT);


IF @EmployeeKey = 0
BEGIN
	INSERT	INTO #EmployeeKeys (
		EmployeeKey
	)
	SELECT	EmployeeKey
	FROM	HC_BI_CMS_DDS.bi_cms_dds.DimEmployee
	WHERE	CenterSSID = @CenterSSID;
END;
ELSE
BEGIN
	INSERT	INTO #EmployeeKeys (
		EmployeeKey
	)
	VALUES	(
		@EmployeeKey
	);
END;


--Find Last Pay Period
DECLARE @LastPayPeriodID NVARCHAR(50);


SET @LastPayPeriodID = (@PayPeriodID - 1);


CREATE TABLE #signoff (
	StartDate DATETIME
,	EndDate DATETIME
,	PayPeriod NVARCHAR(104)
,	Center NVARCHAR(101)
,	EmployeeKey INT
,	EmployeeName NVARCHAR(104)
,	EmployeeInitials NVARCHAR(2)
,	CommissionTypeDescription NVARCHAR(104)
,	ClientIdentifier INT
,	Client NVARCHAR(104)
,	CommissionDate DATETIME
,	Commission MONEY
,	CommissionPct FLOAT
,	PayDate DATETIME
,	LastPay INT
,	NoLastPay INT
,	CommissionCorrectionStatusDescription NVARCHAR(25)
);


INSERT	INTO #signoff
		SELECT	PP.StartDate
		,		PP.EndDate
		,		CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriod'
		,		CTR.CenterDescription + ' (' + CONVERT(VARCHAR(3), CTR.CenterNumber) + ')' AS 'Center'
		,		ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) AS 'EmployeeKey'
		,		ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeName'
		,		DE.EmployeeInitials
		,		CT.Grouping AS 'CommissionTypeDescription'
		,		DC.ClientIdentifier AS 'ClientIdentifier'
		,		DC.ClientFullName AS 'Client'
		,		FCH.AdvancedCommissionDate AS 'CommissionDate'
		,		SUM(ISNULL(FCH.AdvancedCommission, 0)) AS 'Commission'
		,		FCH.PlanPercentage AS 'CommissionPct'
		,		NULL AS 'PayDate'
		,		NULL AS 'LastPay'
		,		NULL AS 'NoLastPay'
		,		NULL AS 'CommissionCorrectionStatusDescription'
		FROM	dbo.FactCommissionHeader FCH
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
					ON FCH.ClientKey = DC.ClientKey
				INNER JOIN DimCommissionType CT
					ON FCH.CommissionTypeID = CT.CommissionTypeID
				INNER JOIN lkpPayPeriods PP
					ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON FCH.CenterKey = CTR.CenterKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON FCH.EmployeeKey = DE.EmployeeKey
				LEFT OUTER JOIN FactCommissionOverride FCO
					ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
				INNER JOIN #EmployeeKeys E
					ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = E.EmployeeKey
		WHERE	FCH.AdvancedPayPeriodKey = @PayPeriodID
				--AND CTR.CenterSSID = @CenterSSID
				AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		GROUP BY PP.StartDate
		,		PP.EndDate
		,		CT.Grouping
		,		CTR.CenterNumber
		,		CTR.CenterDescription
		,		DC.ClientIdentifier
		,		ISNULL(DC.ClientNumber_Temp, DC.ClientIdentifier)
		,		DC.ClientFullName
		,		ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)
		,		ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)
		,		DE.EmployeeInitials
		,		FCH.AdvancedCommissionDate
		,		CT.CommissionTypeDescription
		,		FCH.PlanPercentage
		UNION
		SELECT	LPP2.StartDate
		,		LPP2.EndDate
		,		CONVERT(VARCHAR, LPP2.StartDate, 101) + ' - ' + CONVERT(VARCHAR, LPP2.EndDate, 101) AS 'PayPeriod'
		,		CTR.CenterDescription + ' (' + CAST(CTR.CenterNumber AS NVARCHAR(3)) + ')' AS 'Center'
		,		NULL AS 'EmployeeKey'
		,		E.EmployeeFullNameCalc AS 'EmployeeName'
		,		E.EmployeeInitials
		,		CPS.CommissionPlanSectionDescription AS 'CommissionTypeDescription'
		,		CLT.ClientIdentifier
		,		CLT.ClientFullNameCalc AS 'Client'
		,		CC2.TransactionDate AS 'CommissionDate'
		,		CC2.AmountToBePaid AS 'Commission'
		,		NULL AS 'CommissionPct'
		,		CC2.PayOnDate AS 'PayDate'
		,		NULL AS 'LastPay'
		,		NULL AS 'NoLastPay'
		,		CCS.CommissionCorrectionStatusDescription
		FROM	SQL01.HairClubCMS.dbo.datCommissionCorrection CC2
				INNER JOIN SQL01.HairClubCMS.dbo.cfgCenter CTR
					ON CC2.CenterID = CTR.CenterID
				INNER JOIN SQL01.HairClubCMS.dbo.datEmployee E
					ON CC2.EmployeeGUID = E.EmployeeGUID
				INNER JOIN SQL01.HairClubCMS.dbo.lkpCommissionPlan CP
					ON CC2.CommissionPlanID = CP.CommissionPlanID
				INNER JOIN SQL01.HairClubCMS.dbo.lkpCommissionPlanSection CPS
					ON CC2.CommissionPlanSectionID = CPS.CommissionPlanSectionID
				INNER JOIN SQL01.HairClubCMS.dbo.datClient CLT
					ON CC2.ClientGUID = CLT.ClientGUID
				INNER JOIN dbo.lkpPayPeriods LPP2
					ON CC2.PayPeriodKey = LPP2.PayPeriodKey
				INNER JOIN SQL01.HairClubCMS.dbo.lkpCommissionCorrectionStatus CCS
					ON CC2.CommissionCorrectionStatusID = CCS.CommissionCorrectionStatusID
		WHERE	CC2.PayPeriodKey = @LastPayPeriodID
				AND CC2.CenterID = @CenterSSID
				AND ( E.EmployeePayrollID IN ( SELECT EmployeePayrollID FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee WHERE	EmployeeKey = @EmployeeKey )
						OR	@EmployeeKey = 0 )
				AND CCS.CommissionCorrectionStatusDescription = 'Approved';


UPDATE	#signoff
SET LastPay = 1
WHERE	PayDate IS NOT NULL;


UPDATE	#signoff
SET NoLastPay = 1
WHERE	PayDate IS NULL;


SELECT	*
FROM	#signoff;

END;
GO
