/* CreateDate: 03/04/2013 22:33:52.903 , ModifyDate: 03/04/2013 22:33:52.903 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[extCommissionDetailByHeaderKey]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Mike Maass

==============================================================================
DESCRIPTION:	Commission Detail by CommissionHeaderKey
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionDetailByHeaderKey] 6584
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionDetailByHeaderKey] (
	@CommissionHeaderKey INT
)  AS
BEGIN
		SET NOCOUNT ON

		SELECT SO.InvoiceNumber
			,   SC.SalesCodeDescription AS 'SalesCodeDescription'
			,	FCD.MembershipDescription
			,	FCD.ExtendedPrice AS 'PaymentAmount'
			,	FCD.SalesOrderDate AS 'SalesOrderDate'
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
			INNER JOIN HC_BI_CMS_DDS_DimSalesOrder_TABLE SO
				ON SOD.SalesOrderKey = SO.SalesOrderKey
		WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey
			AND FCD.IsValidTransaction = 1
		ORDER BY FCD.SalesOrderDetailKey

END
GO
