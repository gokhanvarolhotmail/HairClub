/* CreateDate: 01/07/2019 11:24:16.843 , ModifyDate: 01/07/2019 11:25:56.123 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_FactCommissionHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_Commission
IMPLEMENTOR:			DLeiba
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.vw_FactCommissionHeader WHERE AdvancedCommissionDate BETWEEN '12/1/2018' AND '12/31/2018'
***********************************************************************/
CREATE VIEW [dbo].vw_FactCommissionHeader
AS

SELECT  ctr.CenterKey
,		ctr.CenterSSID
,		ctr.CenterNumber
,		ctr.CenterDescription
,       lpp.StartDate AS 'PayPeriodStartDate'
,		lpp.EndDate	AS 'PayPeriodEndDate'
,		lpp.PayDate AS 'PayPeriodPayDate'
,		de.EmployeeKey
,		de.EmployeeSSID
,       de.EmployeePayrollID
,       de.EmployeeFullName
,       dct.[Grouping] AS 'CommissionType'
,		dct.[Role]
,		clt.ClientKey
,		clt.ClientSSID
,		clt.ClientIdentifier
,       clt.ClientFullName
,       fch.MembershipDescription AS 'Membership'
,       ISNULL(fch.AdvancedCommission, 0) AS 'AdvancedCommission'
,       CAST(fch.AdvancedCommissionDate AS DATE) AS 'AdvancedCommissionDate'
FROM    FactCommissionHeader fch
        INNER JOIN HC_Commission.dbo.DimCommissionType dct
            ON dct.CommissionTypeID = fch.CommissionTypeID
        INNER JOIN HC_Commission.dbo.lkpPayPeriods lpp
            ON lpp.PayPeriodKey = fch.AdvancedPayPeriodKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
            ON ctr.CenterKey = fch.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
            ON clt.ClientKey = fch.ClientKey
        LEFT OUTER JOIN HC_Commission.dbo.FactCommissionOverride fco
            ON fco.CommissionHeaderKey = fch.CommissionHeaderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
            ON de.EmployeeKey = ISNULL(fco.EmployeeKey, fch.EmployeeKey)
WHERE	de.EmployeeKey <> -1
GO
