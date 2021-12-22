/*
==============================================================================

PROCEDURE:				[extCommissionExportUSCenters]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Export pay period details for all US centers for Certipay
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionExportUSCenters] 344
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionExportUSCenters] (
	@PayPeriodKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT DE.EmployeePayrollID AS 'CertipayNumber'
	,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeName'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID NOT IN (25, 26, 2) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'Commission'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'CashTips'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (25) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'NonCashTips'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (2) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END)) AS 'RetentionBonus'
	FROM [dbo].[FactCommissionHeader] FCH
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON FCH.ClientKey = DC.ClientKey
		INNER JOIN DimCommissionType CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN lkpPayPeriods PP
			ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = DE.EmployeeKey
	WHERE CTR.CountryRegionDescriptionShort = 'US'
		AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
	GROUP BY DE.EmployeePayrollID
	,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)

END
