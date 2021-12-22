/*
==============================================================================

PROCEDURE:				[extCommissionOverrideGetDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Get commission details for the override screen
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionOverrideGetDetails] 445806
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionOverrideGetDetails] (
	@CommissionHeaderKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT CTR.CenterDescriptionNumber
	,	CT.CommissionTypeDescription
	,	DC.ClientFullName
	,	ISNULL(FCH.AdvancedCommission, 0) AS 'Commission'
	,	FCH.AdvancedCommissionDate
	,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
	FROM HC_Commission.dbo.[FactCommissionHeader] FCH
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON FCH.EmployeeKey = DE.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON FCH.ClientKey = DC.ClientKey
		INNER JOIN HC_Commission.dbo.DimCommissionType CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN HC_Commission.dbo.FactCommissionOverride FCO
			ON FCH.CommissionOverrideKey = FCO.OverrideID
	WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey

END
