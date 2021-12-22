/* CreateDate: 03/12/2013 14:05:59.123 , ModifyDate: 03/22/2013 13:20:33.393 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[extCommissionEarnedSummaryByCenterHR]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by center
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionEarnedSummaryByCenterHR] 'US', 345
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionEarnedSummaryByCenterHR] (
	@Country VARCHAR(3)
,	@PayPeriodKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #Centers (
		CenterKey INT
	,	ReportingCenterSSID INT
	,	CenterDescription VARCHAR(50)
	)


	IF @Country = 'ALL'
		BEGIN
			INSERT INTO #Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS_DimCenter_TABLE
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
		END
	ELSE IF @Country = 'US'
		BEGIN
			INSERT INTO #Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS_DimCenter_TABLE
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
				AND CountryRegionDescriptionShort = 'US'
		END
	ELSE IF @Country = 'CA'
		BEGIN
			INSERT INTO #Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS_DimCenter_TABLE
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
				AND CountryRegionDescriptionShort = 'CA'
		END


	SELECT CTR.ReportingCenterSSID AS 'CenterSSID'
	,	CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescription'
	,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
	,	MAX(ISNULL(FCB.BatchKey, 0)) AS 'PayPeriodBatchKey'
	,	MIN(ISNULL(LCBS.BatchStatusDescription, 'Pending Approval')) AS 'PayPeriodBatchStatusDescription'
	,	MIN(ISNULL(LCBS.BatchStatusID, 5)) AS 'PayPeriodBatchStatusID'
	,	SUM(CASE WHEN CT.[Role] = 'NB Consult' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'NBConsultantsCommission'
	,	SUM(CASE WHEN CT.[Role] = 'MA' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'MembershipAdvisonCommission'
	,	SUM(CASE WHEN CT.[Role] = 'Stylist' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'StylistCommission'
	,	SUM(CASE WHEN FCH.CommissionTypeID IN (25) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'NonCashTipsCommission'
	,	SUM(CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'CashTipsCommission'
	,	MAX(FCB.UpdatedBy) AS 'BatchUpdateUser'
	,	MAX(FCB.UpdateDate) AS 'BatchUpdateDate'
	FROM Commission_FactCommissionHeader_TABLE FCH
		INNER JOIN Commission_DimCommissionType_TABLE CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN Commission_lkpPayPeriods_TABLE PP
			ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
		INNER JOIN #Centers CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN Commission_FactCommissionOverride_TABLE FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		LEFT OUTER JOIN Commission_FactCommissionBatch_TABLE FCB
			ON FCH.BatchKey = FCB.BatchKey
		LEFT OUTER JOIN Commission_lkpCommissionBatchStatus_TABLE LCBS
			ON FCB.BatchStatusID = LCBS.BatchStatusID
	WHERE FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
	GROUP BY CTR.ReportingCenterSSID
	,	CTR.CenterDescription
	,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101)
	--,	FCB.BatchKey
	--,	ISNULL(LCBS.BatchStatusDescription, 'Pending Approval')
	--,	ISNULL(LCBS.BatchStatusID, 5)
	--,	FCB.UpdatedBy
	--,	FCB.UpdateDate

END
GO
