/*
==============================================================================

PROCEDURE:				[extCommissionEarnedSummaryByEmployeeHR_OLD]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by employee
==============================================================================
NOTES:
		04/04/2013	MLM	   Show Unassigned Records in HR Screen
		09/03/2015  SAL	   Added the return of the Pay Period's End Date
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionEarnedSummaryByEmployeeHR_OLD] 'US', 431
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionEarnedSummaryByEmployeeHR_OLD] (
	@Country VARCHAR(3)
,	@PayPeriodKey INT
)
AS
BEGIN
	SET NOCOUNT ON


	declare @Centers as table (
		CenterKey INT
	,	ReportingCenterSSID INT
	,	CenterDescription VARCHAR(50)
	)


	IF @Country = 'ALL'
		BEGIN
			INSERT INTO @Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS_DimCenter_TABLE
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
		END
	ELSE IF @Country = 'US'
		BEGIN
			INSERT INTO @Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS_DimCenter_TABLE
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
				AND CountryRegionDescriptionShort = 'US'
		END
	ELSE IF @Country = 'CA'
		BEGIN
			INSERT INTO @Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS_DimCenter_TABLE
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
				AND CountryRegionDescriptionShort = 'CA'
		END


SELECT CTR.ReportingCenterSSID as 'CenterId'
,	CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescription'
,	CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
,	FCB.BatchKey AS 'PayPeriodBatchKey'
,	ISNULL(LCBS.BatchStatusDescription, 'Pending Approval') AS 'PayPeriodBatchStatusDescription'
,	ISNULL(LCBS.BatchStatusID, 5) AS 'PayPeriodBatchStatusID'
,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) AS 'EmployeeKey'
,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
,	CT.[Grouping] AS 'CommissionType'
,	CONVERT(VARCHAR, ISNULL(DC.ClientNumber_Temp, DC.ClientIdentifier)) + ' - ' + DC.ClientFullName AS 'ClientFullName'
,	CASE WHEN FCH.CommissionTypeID NOT IN (26) THEN ISNULL(FCH.CalculatedCommission, 0) ELSE 0 END AS 'Commission'
,	CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.CalculatedCommission, 0) ELSE 0 END AS 'Tip'
,	FCB.UpdatedBy AS 'BatchUpdateUser'
,	FCB.UpdateDate AS 'BatchUpdateDate'
,	FCH.CommissionHeaderKey
,	PP.EndDate AS 'PayPeriodEndDate'
FROM Commission_FactCommissionHeader_TABLE FCH
	INNER JOIN Commission_DimCommissionType_TABLE CT
		ON FCH.CommissionTypeID = CT.CommissionTypeID
	INNER JOIN Commission_lkpPayPeriods_TABLE PP
		ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
	INNER JOIN @Centers CTR
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
		ON FCH.EmployeeKey = DE.EmployeeKey
WHERE FCH.AdvancedPayPeriodKey = @PayPeriodKey
	AND ISNULL(FCH.AdvancedCommission, 0) <> 0
	--AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
ORDER BY CTR.ReportingCenterSSID
,	FCH.CommissionHeaderKey

END
