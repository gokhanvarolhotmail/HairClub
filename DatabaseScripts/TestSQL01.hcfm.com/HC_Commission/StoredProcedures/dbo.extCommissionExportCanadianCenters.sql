/* CreateDate: 03/12/2013 10:51:30.067 , ModifyDate: 03/12/2013 16:34:17.417 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionExportCanadianCenters]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Export pay period details for all Canadian centers for Ceridian
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionExportCanadianCenters] 344
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionExportCanadianCenters] (
	@PayPeriodKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT '"0664"' AS 'EmployerNumber'
	,	'"COSTING"' AS 'ImportType'
	,	'"00000' + CONVERT(VARCHAR, DE.EmployeePayrollID) + '"' AS 'CertipayNumber'
	,	'"REG"' AS 'ChequeType'
	,	CASE WHEN FCH.CommissionTypeID IN (26) THEN '"33Y"'
			WHEN FCH.CommissionTypeID IN (25) THEN '"O41"'
			WHEN FCH.CommissionTypeID IN (2) THEN '"O18"'
			ELSE '"O20"'
		END AS 'Code'
	,	CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0)
			WHEN FCH.CommissionTypeID IN (25) THEN ISNULL(FCH.AdvancedCommission, 0)
			WHEN FCH.CommissionTypeID IN (2) THEN ISNULL(FCH.AdvancedCommission, 0)
			ELSE ISNULL(FCH.AdvancedCommission, 0)
		END)) AS 'Value'
	FROM [dbo].[FactCommissionHeader] FCH
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON FCH.ClientKey = DC.ClientKey
		INNER JOIN DimCommissionType CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = DE.EmployeeKey
	WHERE CTR.CountryRegionDescriptionShort = 'CA'
		AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
		and ctr.centerssid=264
	GROUP BY DE.EmployeePayrollID
	,	CASE WHEN FCH.CommissionTypeID IN (26) THEN '"33Y"'
			WHEN FCH.CommissionTypeID IN (25) THEN '"O41"'
			WHEN FCH.CommissionTypeID IN (2) THEN '"O18"'
			ELSE '"O20"'
		END
	ORDER BY DE.EmployeePayrollID
	,	CASE WHEN FCH.CommissionTypeID IN (26) THEN '"33Y"'
			WHEN FCH.CommissionTypeID IN (25) THEN '"O41"'
			WHEN FCH.CommissionTypeID IN (2) THEN '"O18"'
			ELSE '"O20"'
		END

END
GO
