/*
==============================================================================

PROCEDURE:				[spApp_GetEmployeesByCenter]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Get employees by center
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spApp_GetEmployeesByCenter] 292
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionGetEmployeesByCenter] (
	@CenterSSID INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT EmployeeKey
	,	EmployeeFullName AS 'EmployeeName'
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee
	WHERE CenterSSID = @CenterSSID
		AND IsActiveFlag = 1
	ORDER BY EmployeeFullName

END
