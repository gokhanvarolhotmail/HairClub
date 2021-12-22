/* CreateDate: 03/13/2013 11:39:44.387 , ModifyDate: 09/23/2020 10:02:37.770 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionHRSummaryByCountryAndPayPeriod]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Export pay period details for all US centers for Certipay
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionHRSummaryByCountryAndPayPeriod] 'US', 562
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionHRSummaryByCountryAndPayPeriod] (
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


	IF @Country = 'US'
		BEGIN
			INSERT INTO #Centers
			SELECT CenterKey
			,	CenterNumber
			,	CenterDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CountryRegionDescriptionShort = 'US'
				AND Active = 'Y'
				AND ( CenterNumber LIKE '2%' OR CenterNumber = 396 OR CenterNumber = 360 )
		END
	ELSE IF @Country = 'CA'
		BEGIN
			INSERT INTO #Centers
			SELECT CenterKey
			,	CenterNumber
			,	CenterDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CountryRegionDescriptionShort = 'CA'
				AND Active = 'Y'
				AND CenterNumber LIKE '2%'
		END


	SELECT CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescription'
	,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
	,	DE.EmployeePayrollID AS 'CertipayNumber'
	,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeName'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID NOT IN (25, 26, 2) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'Commission'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'CashTips'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (25) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'NonCashTips'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (2) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'RetentionBonus'
	FROM FactCommissionHeader FCH
		INNER JOIN lkpPayPeriods PP
			ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
		INNER JOIN #Centers CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = DE.EmployeeKey
	WHERE FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
	GROUP BY CTR.ReportingCenterSSID
	,	CTR.CenterDescription
	,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101)
	,	DE.EmployeePayrollID
	,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)
	ORDER BY ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)

END
GO
