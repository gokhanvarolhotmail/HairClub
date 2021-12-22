/* CreateDate: 02/05/2013 13:44:34.793 , ModifyDate: 02/13/2013 16:32:31.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spApp_EarnedCommissionSummaryByEmployee]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by employee
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionEarnedSummaryByEmployee] 292, 339, 2
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionEarnedSummaryByEmployee] (
	@CenterSSID INT
,	@PayPeriodKey INT
,	@Filter INT
)  AS
BEGIN
	SET NOCOUNT ON

	/*
		@Filter
		1 = Potential
		2 = Advanced
	*/


	IF @Filter = 1 --Select all open potential commission
		BEGIN
			SELECT CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescription'
			,	NULL AS 'PayPeriodDates'
			,	NULL AS 'PayPeriodBatchKey'
			,	NULL AS 'PayPeriodBatchStatusDescription'
			,	NULL AS 'PayPeriodBatchStatusID'
			,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) AS 'EmployeeKey'
			,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
			,	CT.[Grouping] AS 'CommissionType'
			,	CONVERT(VARCHAR, ISNULL(DC.ClientNumber_Temp, DC.ClientIdentifier)) + ' - ' + DC.ClientFullName AS 'ClientFullName'
			,	ISNULL(FCH.CalculatedCommission, 0) AS 'Commission'
			,	FCH.CommissionHeaderKey
			FROM HC_Commission.dbo.[FactCommissionHeader] FCH
				INNER JOIN HC_Commission.dbo.DimCommissionType CT
					ON FCH.CommissionTypeID = CT.CommissionTypeID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON FCH.CenterKey = CTR.CenterKey
				LEFT OUTER JOIN HC_Commission.dbo.FactCommissionOverride FCO
					ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
				LEFT OUTER JOIN HC_Commission.dbo.FactCommissionBatch FCB
					ON FCH.BatchKey = FCB.BatchKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
					ON FCH.ClientKey = DC.ClientKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON FCH.EmployeeKey = DE.EmployeeKey
			WHERE FCH.CenterSSID = @CenterSSID
				AND FCH.IsClosed = 0
				AND FCH.AdvancedPayPeriodKey IS NULL
				AND FCH.RetractedPayPeriodKey IS NULL
				AND ISNULL(FCH.CalculatedCommission, 0) <> 0
		END
	ELSE IF @Filter = 2 --Select all advanced or retracted commission
		BEGIN
			SELECT CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescription'
			,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
			,	FCB.BatchKey AS 'PayPeriodBatchKey'
			,	ISNULL(LCBS.BatchStatusDescription, 'Pending Approval') AS 'PayPeriodBatchStatusDescription'
			,	ISNULL(LCBS.BatchStatusID, 5) AS 'PayPeriodBatchStatusID'
			,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) AS 'EmployeeKey'
			,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
			,	CT.[Grouping] AS 'CommissionType'
			,	CONVERT(VARCHAR, ISNULL(DC.ClientNumber_Temp, DC.ClientIdentifier)) + ' - ' + DC.ClientFullName AS 'ClientFullName'
			,	ISNULL(FCH.AdvancedCommission, 0) AS 'Commission'
			,	FCH.CommissionHeaderKey
			FROM HC_Commission.dbo.[FactCommissionHeader] FCH
				INNER JOIN HC_Commission.dbo.DimCommissionType CT
					ON FCH.CommissionTypeID = CT.CommissionTypeID
				INNER JOIN HC_Commission.dbo.lkpPayPeriods PP
					ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON FCH.CenterKey = CTR.CenterKey
				LEFT OUTER JOIN HC_Commission.dbo.FactCommissionOverride FCO
					ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
				LEFT OUTER JOIN HC_Commission.dbo.FactCommissionBatch FCB
					ON FCH.BatchKey = FCB.BatchKey
				LEFT OUTER JOIN HC_Commission.dbo.lkpCommissionBatchStatus LCBS
					ON FCB.BatchStatusID = LCBS.BatchStatusID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
					ON FCH.ClientKey = DC.ClientKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON FCH.EmployeeKey = DE.EmployeeKey
			WHERE FCH.CenterSSID = @CenterSSID
				AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
				AND ISNULL(FCH.AdvancedCommission, 0) <> 0

		END

END
GO
