/*
==============================================================================

PROCEDURE:				[spApp_EarnedCommissionSummaryByCenter]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by center
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spApp_EarnedCommissionSummaryByCenter] 292, 339
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionEarnedSummaryByCenter] (
	@CenterSSID INT
,	@PayPeriodKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescription'
	,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
	,	FCB.BatchKey AS 'PayPeriodBatchKey'
	,	ISNULL(LCBS.BatchStatusDescription, 'Pending Approval') AS 'PayPeriodBatchStatusDescription'
	,	ISNULL(LCBS.BatchStatusID, 5) AS 'PayPeriodBatchStatusID'
	,	SUM(CASE WHEN CT.[Role] = 'NB Consult' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'NBConsultantsCommission'
	,	SUM(CASE WHEN CT.[Role] = 'MA' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'MembershipAdvisonCommission'
	,	SUM(CASE WHEN CT.[Role] = 'Stylist' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'StylistCommission'
	,	SUM(CASE WHEN FCH.CommissionTypeID IN (25) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'NonCashTipsCommission'
	,	SUM(CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'CashTipsCommission'
	FROM HC_Commission.dbo.[FactCommissionHeader] FCH
		INNER JOIN HC_Commission.dbo.DimCommissionType CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN HC_Commission.dbo.lkpPayPeriods PP
			ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN HC_Commission.dbo.FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		LEFT OUTER JOIN HC_Commission.dbo.FactCommissionBatch FCB
			ON FCH.BatchKey = FCB.BatchKey
		LEFT OUTER JOIN HC_Commission.dbo.lkpCommissionBatchStatus LCBS
			ON FCB.BatchStatusID = LCBS.BatchStatusID
	WHERE FCH.CenterSSID = @CenterSSID
		AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
	GROUP BY CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription
	,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101)
	,	FCB.BatchKey
	,	ISNULL(LCBS.BatchStatusDescription, 'Pending Approval')
	,	ISNULL(LCBS.BatchStatusID, 5)

END
