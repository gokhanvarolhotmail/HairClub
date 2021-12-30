/* CreateDate: 03/13/2013 16:27:22.550 , ModifyDate: 10/09/2020 16:30:52.923 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionHRAuditByCountryAndPayPeriod]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Export pay period details for all US centers for Certipay
==============================================================================
NOTES:	04/17/2013 - MB - Corrected query so that membership change details only
							shows the prior and current memberships.  It was showing
							an additional line with the same membership
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionHRAuditByCountryAndPayPeriod] 'US', 582
EXEC [extCommissionHRAuditByCountryAndPayPeriod] 'CA', 582
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionHRAuditByCountryAndPayPeriod] (
	@Country VARCHAR(3)
,	@PayPeriodKey INT
)  AS
BEGIN

SET NOCOUNT ON;


CREATE TABLE #Centers (
	CenterKey INT
,	ReportingCenterSSID INT
,	CenterDescription VARCHAR(50)
)


IF @Country = 'US'
BEGIN
	INSERT	INTO #Centers
	SELECT	CenterKey
	,		ReportingCenterSSID
	,		CenterDescription
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter
	WHERE	CountryRegionDescriptionShort = 'US'
			AND CenterSSID <> 100
			AND CenterTypeKey = 2
			AND Active = 'Y'
END
ELSE IF @Country = 'CA'
BEGIN
	INSERT	INTO #Centers
	SELECT	CenterKey
	,		ReportingCenterSSID
	,		CenterDescription
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter
	WHERE	CenterNumber LIKE '2%'
			AND Active = 'Y'
			AND CountryRegionDescriptionShort = 'CA'
END


SELECT  CONVERT(VARCHAR(3), ctr.CenterNumber) + ' - ' + ctr.CenterDescription AS 'CenterDescription'
,       CONVERT(VARCHAR, pp.StartDate, 101) + ' - ' + CONVERT(VARCHAR, pp.EndDate, 101) AS 'PayPeriodDates'
,       de.EmployeePayrollID AS 'EmployeeNumber'
,       ISNULL(fco.EmployeeFullName, fch.EmployeeFullName) AS 'EmployeeFullName'
,       dct.[Grouping] AS 'CommissionType'
,       clt.ClientFullName + ' (' + CONVERT(VARCHAR, clt.ClientIdentifier) + ')' AS 'ClientFullName'
,       fch.MembershipDescription AS 'Membership'
,       ISNULL(fch.AdvancedCommission, 0) AS 'Commission'
,       fch.AdvancedCommissionDate AS 'AdvancedCommissionDate'
,       ISNULL(x_P.TotalPaid, 0) AS 'TotalPaid'
,       ISNULL(ISNULL(x_M.MembershipChangeDetails, x_C.MembershipChangeDetails), '') AS 'MembershipChange'
FROM    FactCommissionHeader fch
        INNER JOIN HC_Commission.dbo.DimCommissionType dct
            ON dct.CommissionTypeID = fch.CommissionTypeID
        INNER JOIN HC_Commission.dbo.lkpPayPeriods pp
            ON pp.PayPeriodKey = fch.AdvancedPayPeriodKey
		INNER JOIN #Centers c
			ON c.CenterKey = fch.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
            ON ctr.CenterKey = fch.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
            ON clt.ClientKey = fch.ClientKey
        LEFT OUTER JOIN HC_Commission.dbo.FactCommissionOverride fco
            ON fco.CommissionHeaderKey = fch.CommissionHeaderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
            ON de.EmployeeKey = ISNULL(fco.EmployeeKey, fch.EmployeeKey)
        OUTER APPLY ( SELECT    m_p.MembershipDescription + ' to ' + m_c.MembershipDescription AS 'MembershipChangeDetails'
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
                                    ON so.SalesOrderKey = fst.SalesOrderKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
                                    ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm_c
                                    ON dcm_c.ClientMembershipKey = so.ClientMembershipKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m_c
                                    ON m_c.MembershipKey = dcm_c.MembershipKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm_p
                                    ON dcm_p.ClientMembershipSSID = sod.PreviousClientMembershipSSID
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m_p
                                    ON m_p.MembershipKey = dcm_p.MembershipKey
                      WHERE     fst.SalesOrderKey = fch.SalesOrderKey
                                AND fch.CommissionTypeID IN ( 7, 8, 9, 10, 17, 18, 19, 21, 27, 31, 32, 36, 37, 38, 39, 41, 57 )
                                AND dcm_p.ClientMembershipSSID <> dcm_c.ClientMembershipSSID
                                AND sod.IsVoidedFlag = 0
                    ) x_M
        OUTER APPLY ( SELECT    m_p.MembershipDescription + ' to ' + m_c.MembershipDescription AS 'MembershipChangeDetails'
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
                                    ON so.SalesOrderKey = fst.SalesOrderKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
                                    ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
								INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
									ON sc.SalesCodeKey = fst.SalesCodeKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm_c
                                    ON dcm_c.ClientMembershipKey = so.ClientMembershipKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m_c
                                    ON m_c.MembershipKey = dcm_c.MembershipKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm_p
                                    ON dcm_p.ClientMembershipSSID = sod.PreviousClientMembershipSSID
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m_p
                                    ON m_p.MembershipKey = dcm_p.MembershipKey
                      WHERE     fst.SalesOrderKey = fch.SalesOrderKey
								AND sc.SalesCodeDepartmentSSID = 1099
                                AND fch.CommissionTypeID IN ( 7, 8, 9, 10, 17, 18, 19, 21, 27, 31, 32, 36, 37, 38, 39, 43, 44, 45, 57 )
                                AND dcm_p.ClientMembershipSSID <> dcm_c.ClientMembershipSSID
                                AND sod.IsVoidedFlag = 0
                    ) x_C
        OUTER APPLY ( SELECT    SUM(fcd.ExtendedPrice) AS 'TotalPaid'
                      FROM      FactCommissionDetail fcd
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
                                    ON sc.SalesCodeKey = fcd.SalesCodeKey
                      WHERE     fcd.CommissionHeaderKey = fch.CommissionHeaderKey
                                AND fch.CommissionTypeID IN ( 1, 2, 3, 4, 20, 28, 29, 30, 34, 40, 43, 44, 45, 46, 47, 53, 54, 74, 75, 76, 77, 78, 79 )
                                AND ( ( sc.SalesCodeDepartmentSSID = 2020 AND sc.SalesCodeTypeSSID = 4 )
                                      OR ( sc.SalesCodeDepartmentSSID = 3065 )
									  OR ( sc.SalesCodeDepartmentSSID = 5062 AND sc.SalesCodeDescriptionShort <> 'SVCSMP' )
									  OR ( sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) )
									  OR ( sc.SalesCodeDepartmentSSID = 7052 )
                                      OR sc.SalesCodeDepartmentSSID = 2025 )
                                AND fcd.IsValidTransaction = 1
                    ) x_P
WHERE	fch.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(fch.AdvancedCommission, 0) <> 0
		AND ISNULL(fco.EmployeeKey, fch.EmployeeKey) <> -1
ORDER BY ISNULL(fco.EmployeeFullName, fch.EmployeeFullName)
,		clt.ClientFullName

END
GO
