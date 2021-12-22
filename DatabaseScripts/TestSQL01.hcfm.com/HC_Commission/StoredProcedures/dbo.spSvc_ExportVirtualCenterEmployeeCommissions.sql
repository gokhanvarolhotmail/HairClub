/* CreateDate: 10/12/2020 14:40:16.670 , ModifyDate: 10/12/2020 14:40:16.670 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_ExportVirtualCenterEmployeeCommissions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/12/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ExportVirtualCenterEmployeeCommissions
***********************************************************************/
CREATE PROCEDURE spSvc_ExportVirtualCenterEmployeeCommissions
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


/* Since this will be run on a Saturday, set the Current Date to the Friday to capture data for the last pay period */
SET @CurrentDate = DATEADD(DAY, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


/* Get Current Pay Period */
SELECT	@StartDate = pp.StartDate
,		@EndDate = pp.EndDate
FROM	HC_Commission.dbo.lkpPayPeriods pp
WHERE	CAST(@CurrentDate AS DATE) BETWEEN pp.StartDate AND pp.EndDate


/* Get Virtual Center Employees */
SELECT	e.EmployeeKey
,		e.EmployeeSSID
,		e.EmployeeFirstName
,		e.EmployeeLastName
INTO	#VirtualCenterEmployees
FROM	HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
WHERE	e.CenterSSID = 360
		AND e.IsActiveFlag = 1


/* Get Advanced Commissions For Virtual Center Employees In The Current Pay Period */
SELECT  ctr.CenterDescriptionNumber AS 'CenterDescription'
,       CONVERT(VARCHAR, pp.StartDate, 101) + ' - ' + CONVERT(VARCHAR, pp.EndDate, 101) AS 'PayPeriodDates'
,       ISNULL(de.EmployeePayrollID, '') AS 'EmployeeNumber'
,       REPLACE(ISNULL(fco.EmployeeFullName, fch.EmployeeFullName), ',', '') AS 'EmployeeFullName'
,       dct.[Grouping] AS 'CommissionType'
,		clt.ClientIdentifier
,       REPLACE(clt.ClientFullName, ',', '') + ' (' + CONVERT(VARCHAR, clt.ClientIdentifier) + ')' AS 'ClientFullName'
,       fch.MembershipDescription AS 'Membership'
,		fch.CalculatedCommission
,       fch.AdvancedCommission AS 'AdvancedCommission'
,       CAST(fch.AdvancedCommissionDate AS DATE) AS 'AdvancedCommissionDate'
,		fch.PlanPercentage
,       ISNULL(x_P.TotalPaid, 0) AS 'TotalPaid'
FROM    HC_Commission.dbo.FactCommissionHeader fch
        INNER JOIN HC_Commission.dbo.DimCommissionType dct
            ON dct.CommissionTypeID = fch.CommissionTypeID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
            ON ctr.CenterKey = fch.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
            ON clt.ClientKey = fch.ClientKey
        LEFT OUTER JOIN HC_Commission.dbo.lkpPayPeriods pp
            ON pp.PayPeriodKey = fch.AdvancedPayPeriodKey
        LEFT OUTER JOIN HC_Commission.dbo.FactCommissionOverride fco
            ON fco.CommissionHeaderKey = fch.CommissionHeaderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
            ON de.EmployeeKey = ISNULL(fco.EmployeeKey, fch.EmployeeKey)
		INNER JOIN #VirtualCenterEmployees vce
			ON vce.EmployeeKey = de.EmployeeKey
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
                      FROM      HC_Commission.dbo.FactCommissionDetail fcd
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
WHERE	ISNULL(fch.AdvancedCommission, 0) <> 0
		AND CAST(fch.AdvancedCommissionDate AS DATE) BETWEEN @StartDate AND @EndDate

END
GO
