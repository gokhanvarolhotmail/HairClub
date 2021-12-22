/* CreateDate: 03/04/2013 22:33:52.330 , ModifyDate: 09/10/2014 07:57:07.293 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[extCommissionEarnedSummaryByEmployee]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by employee
==============================================================================
NOTES:
	MLM	02/27/13	Added Tip to results
	MB 03/04/12 - Modified "Tips" column so it only includes Cash Tips
	SAL 09/05/14 - Add EmployeeSSID to results

==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionEarnedSummaryByEmployee] 292, 344, 2
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
			,	CASE WHEN FCH.CommissionTypeID NOT IN (26) THEN ISNULL(FCH.CalculatedCommission, 0) ELSE 0 END AS 'Commission'
			,	CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.CalculatedCommission, 0) ELSE 0 END AS 'Tip'
			,	FCH.CommissionHeaderKey
			,	DE.EmployeeSSID
			FROM Commission_FactCommissionHeader_TABLE FCH
				INNER JOIN Commission_DimCommissionType_TABLE CT
					ON FCH.CommissionTypeID = CT.CommissionTypeID
				INNER JOIN HC_BI_ENT_DDS_DimCenter_TABLE CTR
					ON FCH.CenterKey = CTR.CenterKey
				LEFT OUTER JOIN Commission_FactCommissionOverride_TABLE FCO
					ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
				LEFT OUTER JOIN Commission_FactCommissionBatch_TABLE FCB
					ON FCH.BatchKey = FCB.BatchKey
				LEFT OUTER JOIN HC_BI_CMS_DDS_DimClient_TABLE DC
					ON FCH.ClientKey = DC.ClientKey
				LEFT OUTER JOIN HC_BI_CMS_DDS_DimEmployee_TABLE DE
					ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = DE.EmployeeKey
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
			,	CASE WHEN FCH.CommissionTypeID NOT IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END AS 'Commission'
			,	CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END AS 'Tip'
			,	FCH.CommissionHeaderKey
			,	DE.EmployeeSSID
			FROM Commission_FactCommissionHeader_TABLE FCH
				INNER JOIN Commission_DimCommissionType_TABLE CT
					ON FCH.CommissionTypeID = CT.CommissionTypeID
				INNER JOIN Commission_lkpPayPeriods_TABLE PP
					ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
				INNER JOIN HC_BI_ENT_DDS_DimCenter_TABLE CTR
					ON FCH.CenterKey = CTR.CenterKey
				LEFT OUTER JOIN Commission_FactCommissionOverride_TABLE FCO
					ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
				LEFT OUTER JOIN Commission_FactCommissionBatch_TABLE FCB
					ON FCH.BatchKey = FCB.BatchKey
				LEFT OUTER JOIN Commission_lkpCommissionBatchStatus_TABLE LCBS
					ON FCB.BatchStatusID = LCBS.BatchStatusID
				LEFT OUTER JOIN HC_BI_CMS_DDS_DimClient_TABLE DC
					ON FCH.ClientKey = DC.ClientKey
				LEFT OUTER JOIN HC_BI_CMS_DDS_DimEmployee_TABLE DE
					ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = DE.EmployeeKey
			WHERE FCH.CenterSSID = @CenterSSID
				AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
				AND ISNULL(FCH.AdvancedCommission, 0) <> 0

		END

END
GO
