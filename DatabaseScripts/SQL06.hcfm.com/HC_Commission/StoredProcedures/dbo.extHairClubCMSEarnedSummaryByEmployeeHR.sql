/* CreateDate: 07/02/2017 15:52:53.760 , ModifyDate: 04/20/2021 12:14:25.110 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSEarnedSummaryByEmployeeHR
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/2/2017
DESCRIPTION:			7/2/2017
------------------------------------------------------------------------
NOTES:

	09/13/2017	SAL	Updated to return CenterDescriptionNumber As 'CenterDescription'
						This is the center's full calc description
    04/20/2021	AP Change ReportingCenterSSID for CenterSSID TFS14871

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSEarnedSummaryByEmployeeHR 'ALL', 512
EXEC extHairClubCMSEarnedSummaryByEmployeeHR 'US', 520
EXEC extHairClubCMSEarnedSummaryByEmployeeHR 'CA', 510
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSEarnedSummaryByEmployeeHR]
(
	@Country VARCHAR(3)
,	@PayPeriodKey INT
)
AS
BEGIN

SELECT	CTR.CenterSSID as 'CenterId'
,		CTR.CenterDescriptionNumber AS 'CenterDescription'
,		CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
,		FCB.BatchKey AS 'PayPeriodBatchKey'
,		ISNULL(LCBS.BatchStatusDescription, 'Pending Approval') AS 'PayPeriodBatchStatusDescription'
,		ISNULL(LCBS.BatchStatusID, 5) AS 'PayPeriodBatchStatusID'
,		ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) AS 'EmployeeKey'
,		ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
,		CT.[Grouping] AS 'CommissionType'
,		CONVERT(VARCHAR, ISNULL(DC.ClientNumber_Temp, DC.ClientIdentifier)) + ' - ' + DC.ClientFullName AS 'ClientFullName'
,		CASE WHEN FCH.CommissionTypeID NOT IN (26) THEN ISNULL(FCH.CalculatedCommission, 0) ELSE 0 END AS 'Commission'
,		CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.CalculatedCommission, 0) ELSE 0 END AS 'Tip'
,		FCB.UpdatedBy AS 'BatchUpdateUser'
,		FCB.UpdateDate AS 'BatchUpdateDate'
,		FCH.CommissionHeaderKey
,		PP.EndDate AS 'PayPeriodEndDate'
FROM	FactCommissionHeader FCH
		INNER JOIN DimCommissionType CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN lkpPayPeriods PP
			ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		LEFT OUTER JOIN FactCommissionBatch FCB
			ON FCH.BatchKey = FCB.BatchKey
		LEFT OUTER JOIN lkpCommissionBatchStatus LCBS
			ON FCB.BatchStatusID = LCBS.BatchStatusID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON FCH.ClientKey = DC.ClientKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
			ON FCH.EmployeeKey = DE.EmployeeKey
WHERE	FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		AND CTR.CountryRegionDescriptionShort LIKE CASE WHEN @Country = 'ALL' THEN '%' ELSE @Country + '%' END
ORDER BY CTR.ReportingCenterSSID
,		FCH.CommissionHeaderKey
OPTION (RECOMPILE)

END
GO
