/* CreateDate: 07/02/2013 12:06:55.370 , ModifyDate: 07/18/2014 14:46:21.357 */
GO
/*
==============================================================================

PROCEDURE:				spRpt_LaborEfficiencySPSDetails

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		06/17/13

==============================================================================
DESCRIPTION:	Labor Efficiency Retail Details
==============================================================================
CHANGE HISTORY:
06/18/2014 - RH - (#103343) Added AND E.IsActiveFlag = 1 to the employee selection statement.
06/19/2014 - RH - Decided to comment out this line NOT to remove inactive employees from historical data.
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_LaborEfficiencySPSDetails 12765, 210, '6/21/13', 223
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_LaborEfficiencySPSDetails] (
	@StylistID VARCHAR(20)
,	@CenterNum INT
,	@PeriodEndDate DATETIME
,	@SixWeeksBackHrs INT
)AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME

	SELECT @EndDate = DATEADD(mi, -1, DATEADD(dd, 1, @PeriodEndDate))
	,	@StartDate = DATEADD(dd, -41, @PeriodEndDate)


	--Get distinct clients for time period
	SELECT FST.ClientMembershipKey
	,	MAX(FST.SalesOrderDetailKey) AS 'SalesOrderDetailKey'
	INTO #Distinct
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
	WHERE SC.SalesCodeTypeSSID=1
		AND DD.FullDate BETWEEN @StartDate and @EndDate
		AND M.MembershipSSID NOT IN (30, 31)
	GROUP BY FST.ClientMembershipKey


	SELECT CLT.CenterSSID AS 'Center'
	,	CLT.ClientIdentifier AS 'Client_No'
	,	CLT.ClientFirstName
	,	CLT.ClientLastName
	,	M.MembershipDescription AS 'Member1'
	,	'' AS 'Member2'
	,	E.EmployeeInitials AS 'Performer2'
	,	E.EmployeePayrollID AS 'CertipayEmployeeNumber'
	,	E.EmployeeFirstName AS 'First_Name'
	,	E.EmployeeLastName AS 'Last_Name'
	,	SP.Points
	,	CASE WHEN SOD.TransactionNumber_Temp=-1 THEN SOD.SalesOrderDetailKey ELSE SOD.TransactionNumber_Temp END AS 'LastTransaction'
	,	SO.CenterSSID
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #Distinct D
			ON FST.SalesOrderDetailKey = D.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON FST.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CM.ClientKey = CLT.ClientKey
		INNER JOIN lkpStylistPoints SP
			ON FST.MembershipKey = SP.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
	WHERE E.EmployeeKey = @StylistID
		--AND E.IsActiveFlag = 1
	ORDER BY CLT.ClientFullName

END
GO
