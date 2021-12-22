/*
==============================================================================

PROCEDURE:				[spApp_CommissionDetailsByClient]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission details by client
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spApp_CommissionDetailsByClient] 7252
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionDetailsByClient] (
	@CommissionHeaderKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT CASE WHEN FCH.SalesOrderKey = SOD.SalesOrderKey THEN 'Header' ELSE 'Detail' END AS 'RecordType'
	,	SC.SalesCodeDescription AS 'SalesCodeDescription'
	,	FCD.MembershipDescription
	,	FCD.ExtendedPrice AS 'Amount'
	,	FCD.SalesOrderDate AS 'SalesOrderDate'
	,	ISNULL(FCH.AdvancedCommission, 0) AS 'Commission'
	FROM HC_Commission.dbo.[FactCommissionHeader] FCH
		INNER JOIN HC_Commission.dbo.FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON FCH.EmployeeKey = DE.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON FCH.ClientKey = DC.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FCH.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FCD.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FCD.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey
		AND FCD.IsValidTransaction = 1
	ORDER BY FCD.SalesOrderDetailKey

END
