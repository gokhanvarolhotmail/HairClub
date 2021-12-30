/* CreateDate: 07/02/2017 11:18:45.880 , ModifyDate: 04/07/2020 10:53:07.157 */
GO
/***********************************************************************
PROCEDURE:				extCommissionHRAuditByCountryAndPayPeriod_OLD
PURPOSE:				Export pay period details for all US centers for Certipay
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

04/17/2013 - MB - Corrected query so that membership change details only shows the prior and current memberships.
				  It was showing an additional line with the same membership
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extCommissionHRAuditByCountryAndPayPeriod_OLD 'US', 582
EXEC extCommissionHRAuditByCountryAndPayPeriod_OLD 'CA', 582
***********************************************************************/
CREATE PROCEDURE [dbo].[extCommissionHRAuditByCountryAndPayPeriod_OLD]
(
	@Country VARCHAR(3),
	@PayPeriodKey INT
)
AS
BEGIN

SET NOCOUNT ON


DECLARE @Centers AS TABLE (
	CenterKey INT
,	ReportingCenterSSID INT
,	CenterDescription VARCHAR(50)
)


IF @Country = 'US'
   BEGIN
         INSERT INTO @Centers
                SELECT  CenterKey
                ,       ReportingCenterSSID
                ,       CenterDescription
                FROM    HC_BI_ENT_DDS_DimCenter_TABLE
                WHERE   ReportingCenterSSID LIKE '2%'
                        AND Active = 'Y'
                        AND CountryRegionDescriptionShort = 'US'
   END
ELSE
   IF @Country = 'CA'
      BEGIN
            INSERT  INTO @Centers
                    SELECT  CenterKey
                    ,       ReportingCenterSSID
                    ,       CenterDescription
                    FROM    HC_BI_ENT_DDS_DimCenter_TABLE
                    WHERE   ReportingCenterSSID LIKE '2%'
                            AND Active = 'Y'
                            AND CountryRegionDescriptionShort = 'CA'
      END


SELECT  CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescription'
,       CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
,       DE.EmployeePayrollID AS 'EmployeeNumber'
,       ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
,		FCH.CommissionTypeID
,       CT.[Grouping] AS 'CommissionType'
,       DC.ClientFullName + ' (' + CONVERT(VARCHAR, DC.ClientIdentifier) + ')' AS 'ClientFullName'
,       FCH.MembershipDescription AS 'Membership'
,       ISNULL(FCH.AdvancedCommission, 0) AS 'Commission'
,       FCH.AdvancedCommissionDate AS 'AdvancedCommissionDate'
,       ISNULL(Payments.TotalPaid, 0) AS 'TotalPaid'
,       ISNULL(ISNULL(MembershipChange.MembershipChangeDetails, Cancel.MembershipChangeDetails), '') AS 'MembershipChange'
FROM    Commission_FactCommissionHeader_TABLE FCH
        INNER JOIN Commission_DimCommissionType_TABLE CT
            ON FCH.CommissionTypeID = CT.CommissionTypeID
        INNER JOIN Commission_lkpPayPeriods_TABLE PP
            ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
        INNER JOIN @Centers CTR
            ON FCH.CenterKey = CTR.CenterKey
        LEFT OUTER JOIN Commission_FactCommissionOverride_TABLE FCO
            ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
        INNER JOIN HC_BI_CMS_DDS_DimClient_TABLE DC
            ON FCH.ClientKey = DC.ClientKey
        INNER JOIN HC_BI_CMS_DDS_DimEmployee_TABLE DE
            ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = DE.EmployeeKey
        LEFT OUTER JOIN ( SELECT    FCH.CommissionHeaderKey
                          ,         M_Previous.MembershipDescription + ' to ' + M_Current.MembershipDescription AS 'MembershipChangeDetails'
                          FROM      HC_BI_CMS_DDS_DimSalesOrder_TABLE SO
                                    INNER JOIN HC_BI_CMS_DDS_DimClientMembership_TABLE CM_Current
                                        ON SO.ClientMembershipKey = CM_Current.ClientMembershipKey
                                    INNER JOIN HC_BI_CMS_DDS_DimMembership_TABLE M_Current
                                        ON CM_Current.MembershipKey = M_Current.MembershipKey
                                    INNER JOIN HC_BI_CMS_DDS_DimSalesOrderDetail_TABLE SOD
                                        ON SO.SalesOrderKey = SOD.SalesOrderKey
                                    INNER JOIN HC_BI_CMS_DDS_DimClientMembership_TABLE CM_Previous
                                        ON SOD.PreviousClientMembershipSSID = CM_Previous.ClientMembershipSSID
                                    INNER JOIN HC_BI_CMS_DDS_DimMembership_TABLE M_Previous
                                        ON CM_Previous.MembershipKey = M_Previous.MembershipKey
                                    INNER JOIN Commission_FactCommissionHeader_TABLE FCH
                                        ON SO.SalesOrderKey = FCH.SalesOrderKey
                                           AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
                                           AND ISNULL(FCH.AdvancedCommission, 0) <> 0
                                           AND FCH.CommissionTypeID IN ( 7, 8, 9, 10, 17, 18, 19, 21, 27, 31, 32, 36, 37, 38, 39, 41, 57 )
                          WHERE     CM_Previous.ClientMembershipSSID <> CM_Current.ClientMembershipSSID
                        ) MembershipChange
            ON FCH.CommissionHeaderKey = MembershipChange.CommissionHeaderKey
        LEFT OUTER JOIN ( SELECT    FCH.CommissionHeaderKey
                          ,         SUM(FCD.ExtendedPrice) AS 'TotalPaid'
                          FROM      Commission_FactCommissionHeader_TABLE FCH
                                    INNER JOIN Commission_FactCommissionDetail_TABLE FCD
                                        ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
                                    INNER JOIN HC_BI_CMS_DDS_DimSalesCode_TABLE SC
                                        ON FCD.SalesCodeKey = SC.SalesCodeKey
                          WHERE     FCH.AdvancedPayPeriodKey = @PayPeriodKey
                                    AND ISNULL(FCH.AdvancedCommission, 0) <> 0
                                    AND fch.CommissionTypeID IN ( 1, 2, 3, 4, 20, 28, 29, 30, 34, 40, 43, 44, 45, 46, 47, 53, 54, 74, 75, 76, 77, 78, 79 )
                                    AND FCD.IsValidTransaction = 1
									AND ( ( sc.SalesCodeDepartmentSSID = 2020 AND sc.SalesCodeTypeSSID = 4 )
											OR ( sc.SalesCodeDescription LIKE '%Laser%' OR sc.SalesCodeDescription LIKE '%Capillus%' )
											OR ( sc.SalesCodeDepartmentSSID = 5062 AND sc.SalesCodeDescriptionShort <> 'SVCSMP' )
											OR ( sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) )
											OR ( sc.SalesCodeDepartmentSSID = 7052 )
											OR sc.SalesCodeDepartmentSSID = 2025 )
                          GROUP BY  FCH.CommissionHeaderKey
                        ) Payments
            ON FCH.CommissionHeaderKey = Payments.CommissionHeaderKey
        LEFT OUTER JOIN ( SELECT    FCH.CommissionHeaderKey
                          ,         'Cancel from ' + M_Current.MembershipDescription AS 'MembershipChangeDetails'
                          FROM      HC_BI_CMS_DDS_DimSalesOrder_TABLE SO
                                    INNER JOIN HC_BI_CMS_DDS_DimClientMembership_TABLE CM_Current
                                        ON SO.ClientMembershipKey = CM_Current.ClientMembershipKey
                                    INNER JOIN HC_BI_CMS_DDS_DimMembership_TABLE M_Current
                                        ON CM_Current.MembershipKey = M_Current.MembershipKey
                                    INNER JOIN HC_BI_CMS_DDS_DimSalesOrderDetail_TABLE SOD
                                        ON SO.SalesOrderKey = SOD.SalesOrderKey
                                    INNER JOIN HC_BI_CMS_DDS_DimClientMembership_TABLE CM_Previous
                                        ON SOD.PreviousClientMembershipSSID = CM_Previous.ClientMembershipSSID
                                    INNER JOIN HC_BI_CMS_DDS_DimMembership_TABLE M_Previous
                                        ON CM_Previous.MembershipKey = M_Previous.MembershipKey
                                    INNER JOIN Commission_FactCommissionHeader_TABLE FCH
                                        ON SOD.SalesOrderDetailKey = FCH.SalesOrderKey
                                           AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
                                           AND ISNULL(FCH.AdvancedCommission, 0) <> 0
                                           AND FCH.CommissionTypeID IN ( 7, 8, 9, 10, 17, 18, 19, 21, 27, 31, 32, 36, 37, 38, 39, 43, 44, 45, 57 )
                          WHERE     CM_Previous.ClientMembershipSSID <> CM_Current.ClientMembershipSSID
                        ) Cancel
            ON FCH.CommissionHeaderKey = Cancel.CommissionHeaderKey
WHERE   FCH.AdvancedPayPeriodKey = @PayPeriodKey
        AND ISNULL(FCH.AdvancedCommission, 0) <> 0
        AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
ORDER BY ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)
,       DC.ClientFullName

END
GO
