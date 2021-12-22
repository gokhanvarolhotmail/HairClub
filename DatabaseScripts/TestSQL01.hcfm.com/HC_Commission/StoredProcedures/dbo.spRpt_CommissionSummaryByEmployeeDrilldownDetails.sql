/* CreateDate: 11/14/2012 09:22:02.747 , ModifyDate: 02/12/2013 16:44:48.960 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spRpt_CommissionSummaryByEmployeeDrilldownDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by employee
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_CommissionSummaryByEmployeeDrilldownDetails] 6032
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_CommissionSummaryByEmployeeDrilldownDetails] (
	@CommissionHeaderKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT FCH.CommissionHeaderKey
	,	FCD.MembershipDescription
	,	SC.SalesCodeDescription AS 'SalesCodeDescriptionShort'
	,	FCD.ExtendedPrice
	,	FCD.SalesOrderDate
	,	ISNULL(FCH.AdvancedCommission, 0) AS 'Commission'
	,	FCD.IsValidTransaction
	,	FCD.SalesOrderDetailKey
	,	FCH.SalesOrderKey
	,	SO.InvoiceNumber
	FROM [FactCommissionHeader] FCH
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON FCH.EmployeeKey = DE.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON FCH.ClientKey = DC.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FCH.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FCD.SalesCodeKey = SC.SalesCodeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FCH.SalesOrderKey = SO.SalesOrderKey
	WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey
		AND FCD.IsValidTransaction = 1
	ORDER BY FCD.SalesOrderDetailKey

END
GO
