/*
==============================================================================

PROCEDURE:				spRpt_LaborEfficiencyRetailDetails

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		06/17/13

==============================================================================
DESCRIPTION:	Labor Efficiency Retail Details

06/18/2014 - RH - (#103343) Added AND E.IsActiveFlag = 1 to the employee selection statement.
06/19/2014 - RH - Decided to comment out this line NOT to remove inactive employees from historical data.
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_LaborEfficiencyRetailDetails 14174, 294, '6/01/2014'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_LaborEfficiencyRetailDetails] (
	@StylistID VARCHAR(20)
,	@CenterNum INT
,	@PeriodEndDate DATETIME
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


	--Get retail information per employee
	SELECT C.CenterSSID as 'Center'
	,	E.EmployeeInitials AS 'Performer2'
	,	E.EmployeePayrollNumber AS 'StylistID'
	,	E.EmployeeLastName AS 'Last_Name'
	,	E.EmployeeFirstName AS 'First_Name'
	,	CLT.ClientIdentifier AS 'Client_No'
	,	CLT.ClientLastName
	,	CLT.ClientFirstName
	,	SUM(FST.ExtendedPrice) AS 'TotalRetail'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #Distinct D
			ON FST.SalesOrderDetailKey = D.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = R.RegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
		LEFT OUTER JOIN lkpStylistPoints SP
			ON FST.MembershipKey = SP.MembershipKey
	WHERE E.EmployeeKey = @StylistID
		--AND E.IsActiveFlag = 1
	GROUP BY C.CenterSSID
	,	E.EmployeeInitials
	,	E.EmployeePayrollNumber
	,	E.EmployeeLastName
	,	E.EmployeeFirstName
	,	CLT.ClientIdentifier
	,	CLT.ClientLastName
	,	CLT.ClientFirstName
END
