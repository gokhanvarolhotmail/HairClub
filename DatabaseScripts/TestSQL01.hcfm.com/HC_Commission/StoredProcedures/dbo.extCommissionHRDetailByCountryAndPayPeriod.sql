/* CreateDate: 03/13/2013 11:52:37.803 , ModifyDate: 03/24/2020 17:03:44.343 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[extCommissionHRDetailByCountryAndPayPeriod]

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
EXEC [extCommissionHRDetailByCountryAndPayPeriod] 'US', 568
EXEC [extCommissionHRDetailByCountryAndPayPeriod] 'CA', 568
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionHRDetailByCountryAndPayPeriod] (
	@Country VARCHAR(3)
,	@PayPeriodKey INT
)  AS
BEGIN

SET NOCOUNT ON;

SELECT  CONVERT(VARCHAR(3), ctr.CenterNumber) + ' - ' + ctr.CenterDescription AS 'CenterDescription'
,       CONVERT(VARCHAR, pp.StartDate, 101) + ' - ' + CONVERT(VARCHAR, pp.EndDate, 101) AS 'PayPeriodDates'
,       ISNULL(fco.EmployeeFullName, fch.EmployeeFullName) AS 'EmployeeFullName'
,       dct.[Grouping] AS 'CommissionType'
,       clt.ClientFullName + ' (' + CONVERT(VARCHAR, clt.ClientIdentifier) + ')' AS 'ClientFullName'
,       fch.MembershipDescription AS 'Membership'
,       ISNULL(fch.AdvancedCommission, 0) AS 'Commission'
,       fch.AdvancedCommissionDate AS 'AdvancedCommissionDate'
	,	CASE
			WHEN FCH.CommissionTypeID IN ( 1, 2, 3, 4, 20, 28, 29, 30, 34, 40, 43, 44, 45, 46, 47, 53, 54, 74, 76, 77, 78, 79 ) THEN 'Total paid: $' + CONVERT(VARCHAR, CAST(x_P.TotalPaid AS MONEY), 1)
			WHEN FCH.CommissionTypeID IN ( 7, 8, 9, 10, 17, 18, 19, 21, 27, 31, 32, 36, 37, 38, 39, 41, 57 ) THEN ISNULL(x_M.MembershipChangeDetails, x_C.MembershipChangeDetails)
			ELSE ''
		END AS 'CommissionDetails'
,		fch.CommissionHeaderKey
FROM    FactCommissionHeader fch
        INNER JOIN HC_Commission.dbo.DimCommissionType dct
            ON dct.CommissionTypeID = fch.CommissionTypeID
        INNER JOIN HC_Commission.dbo.lkpPayPeriods pp
            ON pp.PayPeriodKey = fch.AdvancedPayPeriodKey
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
                                      OR ( sc.SalesCodeDescription LIKE '%Laser%' OR sc.SalesCodeDescription LIKE '%Capillus%' )
									  OR ( sc.SalesCodeDepartmentSSID = 5062 AND sc.SalesCodeDescriptionShort <> 'SVCSMP' )
									  OR ( sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) )
									  OR ( sc.SalesCodeDepartmentSSID = 7052 )
                                      OR sc.SalesCodeDepartmentSSID = 2025 )
                                AND fcd.IsValidTransaction = 1
                    ) x_P
WHERE   fch.AdvancedPayPeriodKey = @PayPeriodKey
		AND ctr.CountryRegionDescriptionShort = @Country
		AND ISNULL(fch.AdvancedCommission, 0) <> 0
        AND ISNULL(fco.EmployeeKey, fch.EmployeeKey) <> -1
ORDER BY ISNULL(fco.EmployeeFullName, fch.EmployeeFullName)
,		clt.ClientFullName

END
GO
