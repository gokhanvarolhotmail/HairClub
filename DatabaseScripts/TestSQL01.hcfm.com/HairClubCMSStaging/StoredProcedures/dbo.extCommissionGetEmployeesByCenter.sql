/* CreateDate: 02/18/2013 07:40:33.910 , ModifyDate: 04/08/2013 21:58:24.853 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[extCommissionGetEmployeesByCenter]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Get employees by center
==============================================================================
NOTES:
			* 02/19/2013 MVT - Updated to use synonyms
			* 04/04/2013 MLM - Added Unknown to the Results
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionGetEmployeesByCenter] 292
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionGetEmployeesByCenter] (
	@CenterSSID INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT EmployeeKey
	,	EmployeeFullName AS 'EmployeeName'
	,   EmployeeSSID as 'EmployeeGUID'
	FROM HC_BI_CMS_DDS_DimEmployee_TABLE
	WHERE (CenterSSID = @CenterSSID
		AND IsActiveFlag = 1) OR EmployeeKey = -1
	ORDER BY EmployeeFullName

END
GO
