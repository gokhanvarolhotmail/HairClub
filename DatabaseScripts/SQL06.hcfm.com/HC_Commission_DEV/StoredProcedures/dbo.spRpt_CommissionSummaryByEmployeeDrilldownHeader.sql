/* CreateDate: 11/14/2012 09:22:15.887 , ModifyDate: 02/12/2013 16:44:17.430 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_CommissionSummaryByEmployeeDrilldownHeader]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by employee
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_CommissionSummaryByEmployeeDrilldownHeader] 4660, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_CommissionSummaryByEmployeeDrilldownHeader] (
	@CommissionHeaderKey INT
,	@Filter INT
)  AS
BEGIN
	SET NOCOUNT ON

	/*
		@Filter
		1 = Potential
		2 = Advanced
	*/

	CREATE TABLE #CommissionHeader (
		CommissionHeaderKey INT
	,	CenterDescriptionNumber VARCHAR(100)
	,	CommissionTypeDescription VARCHAR(100)
	,	ClientFullName VARCHAR(100)
	,	Commission MONEY
	,	CommissionDate DATETIME
	,	EmployeeFullName VARCHAR(100)
	,	CommissionTypeID INT
	,	PlanPercentage NUMERIC(3,2)
	,	MembershipChangeDetails VARCHAR(100)
	)

	IF @Filter = 1 --Select all open potential commission
		BEGIN
			INSERT INTO #CommissionHeader
			SELECT FCH.CommissionHeaderKey
			,	CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescriptionNumber'
			,	CT.CommissionTypeDescription
			,	DC.ClientFullName
			,	ISNULL(FCH.CalculatedCommission, 0) AS 'Commission'
			,	FCH.AdvancedCommissionDate
			,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
			,	FCH.CommissionTypeID
			,	ISNULL(FCH.PlanPercentage, 0.0) AS 'PlanPercentage'
			,	[dbo].[fxCommissionMembershipChangeDetails](FCH.SalesOrderKey) AS 'MembershipChangeDetails'
			FROM [FactCommissionHeader] FCH
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON FCH.EmployeeKey = DE.EmployeeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
					ON FCH.ClientKey = DC.ClientKey
				INNER JOIN DimCommissionType CT
					ON FCH.CommissionTypeID = CT.CommissionTypeID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON FCH.CenterKey = CTR.CenterKey
				LEFT OUTER JOIN FactCommissionOverride FCO
					ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
			WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey

		END
	ELSE
		BEGIN
			INSERT INTO #CommissionHeader
			SELECT FCH.CommissionHeaderKey
			,	CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescriptionNumber'
			,	CT.CommissionTypeDescription
			,	DC.ClientFullName
			,	ISNULL(FCH.AdvancedCommission, 0) AS 'Commission'
			,	FCH.AdvancedCommissionDate
			,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName'
			,	FCH.CommissionTypeID
			,	ISNULL(FCH.PlanPercentage, 0.0) AS 'PlanPercentage'
			,	[dbo].[fxCommissionMembershipChangeDetails](FCH.SalesOrderKey) AS 'MembershipChangeDetails'
			FROM [FactCommissionHeader] FCH
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON FCH.EmployeeKey = DE.EmployeeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
					ON FCH.ClientKey = DC.ClientKey
				INNER JOIN DimCommissionType CT
					ON FCH.CommissionTypeID = CT.CommissionTypeID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON FCH.CenterKey = CTR.CenterKey
				LEFT OUTER JOIN FactCommissionOverride FCO
					ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
			WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey
		END


	SELECT *
	FROM #CommissionHeader
END
GO
