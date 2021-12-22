/* CreateDate: 02/18/2013 07:32:17.363 , ModifyDate: 03/04/2013 22:17:55.963 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionDetailsByClient]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission details by client
==============================================================================
NOTES:
		* 02/19/2013 MVT - Updated to use synonyms
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionDetailsByClient] 7252
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
	FROM Commission_FactCommissionHeader_TABLE FCH
		INNER JOIN Commission_FactCommissionDetail_TABLE FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		INNER JOIN HC_BI_CMS_DDS_DimEmployee_TABLE DE
			ON FCH.EmployeeKey = DE.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS_DimClient_TABLE DC
			ON FCH.ClientKey = DC.ClientKey
		INNER JOIN HC_BI_ENT_DDS_DimCenter_TABLE CTR
			ON FCH.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_CMS_DDS_DimSalesCode_TABLE SC
			ON FCD.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS_DimSalesOrderDetail_TABLE SOD
			ON FCD.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey
		AND FCD.IsValidTransaction = 1
	ORDER BY FCD.SalesOrderDetailKey

END
GO
