/***********************************************************************
PROCEDURE:				spRpt_SurgeryClientOverview_CommissionDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_SurgeryClientOverview
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		12/05/2013
------------------------------------------------------------------------

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_SurgeryClientOverview_CommissionDetail '67439'  --Mark Wright

EXEC spRpt_SurgeryClientOverview_CommissionDetail '366417'  --Stacy Luu

EXEC spRpt_SurgeryClientOverview_CommissionDetail '416237'  --Fabian Rodriguez

EXEC spRpt_SurgeryClientOverview_CommissionDetail '20196'  --Steve Nicholson

EXEC spRpt_SurgeryClientOverview_CommissionDetail '368347'  --Cheryl Weber

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_SurgeryClientOverview_CommissionDetail]
(
	@ClientIdentifier INT
) AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;

	DECLARE @ClientKey INT
	SET @ClientKey = (SELECT ClientKey
						FROM [HC_BI_CMS_DDS].[bi_cms_dds].DimClient
						WHERE ClientIdentifier = @ClientIdentifier)

	PRINT @ClientKey

	SELECT
	FCD.CommissionHeaderKey
	,	@ClientIdentifier AS ClientIdentifier
	,	CEN.CenterDescriptionNumber
	,	FCH.CommissionTypeID
	,	CT.CommissionTypeDescription
	,	FCD.SalesOrderDate
	,	FCD.SalesOrderDetailKey
	,	CM.MembershipKey
	,	M.MembershipDescription
	,	FCD.Quantity
	,	FCD.ExtendedPrice
	,	FST.S_SurAmt
	,	FST.S_PostExtAmt
	,	E.EmployeeFullName
	,	CASE WHEN SC.SalesCodeDescription = 'Surgical Procedure-Room Reservation' THEN 'Surg-Room Reservation'
		WHEN SC.SalesCodeDescription = 'Surgical Procedure-Payment Adj' THEN 'Surg-Payment Adj'
		ELSE SC.SalesCodeDescription
		END AS SalesCodeDescription
	,	FCH.AdvancedCommission
	,	FCH.AdvancedCommissionDate
	,	FCH.AdvancedPayPeriodKey
	,	SO.ClientKey
	,	SO.ClientMembershipKey
	,	SO.OrderDate
	,	SO.InvoiceNumber

	FROM HC_Commission.dbo.FactCommissionDetail FCD
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON FCD.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON CM.MembershipKey = M.MembershipKey
	INNER JOIN HC_Commission.dbo.FactCommissionHeader FCH
		ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
	INNER JOIN HC_Commission.dbo.DimCommissionType CT
		ON FCH.CommissionTypeID = CT.CommissionTypeID
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].FactSalesTransaction FST
		ON FCD.SalesOrderDetailKey = FST.SalesOrderDetailKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee E
		ON FST.Employee1Key = E.EmployeeKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].DimCenter CEN
		ON FCH.CenterSSID = CEN.CenterSSID
	WHERE CM.ClientKey = @ClientKey
	AND M.BusinessSegmentDescription = 'Surgery'
	AND LEFT(OrderDateKey,4) >= YEAR(DATEADD(YEAR,-1,GETDATE()))  --For the past year
	AND FCD.ExtendedPrice <> '0.00'
	ORDER BY FCD.SalesOrderDate, FCD.CommissionHeaderKey

END
