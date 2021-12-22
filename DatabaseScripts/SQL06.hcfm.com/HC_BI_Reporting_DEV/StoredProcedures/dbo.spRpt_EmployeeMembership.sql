/* CreateDate: 03/20/2020 12:48:53.143 , ModifyDate: 03/20/2020 14:53:06.283 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_EmployeeMembership]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_BI_Reporting]

IMPLEMENTOR: 			Rachelen Hut

==============================================================================
DESCRIPTION:	This procedure is the for reporting employees with memberships
==============================================================================
CHANGE HISTORY:

==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_EmployeeMembership] 'C','2/01/2020','2/29/2020', 2
EXEC [spRpt_EmployeeMembership] 'C','2/01/2020','2/29/2020', 3

EXEC [spRpt_EmployeeMembership] 'F','2/01/2020','2/29/2020', 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_EmployeeMembership] (
	@sType CHAR(1)
,	@begdt DATETIME
,	@enddt DATETIME
,	@Filter INT
) AS
BEGIN
SET NOCOUNT ON

/*
	@Filter
	-------
	1 = By Region for Franchise
	2 = By Area Manager
	3 = By Center
*/

/************ Create temp tables ***************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescription NVARCHAR(20)
)


/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
		,		CMA.CenterManagementAreaDescription AS MainGroup
		,		CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
		,		DC.CenterNumber
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		CT.CenterTypeDescription
		FROM		HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE		CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.Active = 'Y'
END
IF @sType = 'C' AND @Filter = 3  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterNumber AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterNumber AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		CT.CenterTypeDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.Active = 'Y'

END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterNumber
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		CASE WHEN CT.CenterTypeDescription = 'Joint' THEN 'Franchise' ELSE 'Franchise' END AS 'CenterTypeDescription'
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
END




/************************** Find employee memberships **********************************/

SELECT CLT.ClientIdentifier
,	CLT.ClientKey
,	CM.ClientMembershipKey
,	CLT.ClientFullName
,	CM.MembershipSSID
,	M.MembershipDescription
,	CM.ClientMembershipBeginDate
,	CM.ClientMembershipEndDate
,	M.RevenueGroupDescription
,	M.BusinessSegmentDescription
,	E.CenterSSID
,	#Centers.CenterDescriptionNumber
,	E.EmployeeKey
INTO #Employees
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
	ON (CM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
		OR CM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
		OR CM.ClientMembershipSSID = CLT.CurrentMDPClientMembershipSSID
		OR CM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
		OR CM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
		)
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipSSID = CM.MembershipSSID
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON E.EmployeeFullName = CLT.ClientFullName
INNER JOIN #Centers
	ON #Centers.CenterSSID = E.CenterSSID
WHERE CM.MembershipSSID IN(50,51,78,282,290)
AND E.IsActiveFlag = 1
AND CM.ClientMembershipEndDate >= @enddt


/********************************** Get Service Amount *************************************/

SELECT  #Centers.CenterNumber
,	#Centers.CenterTypeDescription
,	ClientIdentifier
,	#Employees.ClientMembershipKey
,	ClientFullName
,	DD.FullDate
,	SUM(ISNULL(FST.ServiceAmt, 0)) AS 'ServiceAmt'
INTO #Services
FROM    #Employees
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	ON FST.ClientMembershipKey = #Employees.ClientMembershipKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
    ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
	ON FST.SalesOrderKey = SO.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
	ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
	ON SO.ClientMembershipKey = CM.ClientMembershipKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	ON CM.CenterKey = C.CenterKey       --KEEP HomeCenter Based
INNER JOIN #Centers
    ON C.CenterSSID = #Centers.CenterSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
    ON FST.SalesCodeKey = SC.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
    ON CM.MembershipSSID = M.MembershipSSID
WHERE   DD.FullDate BETWEEN @begdt AND @enddt
		AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
        AND SOD.IsVoidedFlag = 0
GROUP BY #Centers.CenterNumber
,   CenterTypeDescription
,	ClientIdentifier
,	#Employees.ClientMembershipKey
,	ClientFullName
,	DD.FullDate


/****************************** GET RETAIL DATA **************************************/

SELECT  #Centers.CenterNumber
,	ClientIdentifier
,	#Employees.ClientMembershipKey
,	ClientFullName
,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailAmt'
INTO #RetailSales
from #Employees
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	ON FST.ClientMembershipKey = #Employees.ClientMembershipKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = FST.OrderDateKey
INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
	ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
	ON FST.CenterKey = c.CenterKey
INNER JOIN #Centers
    ON c.CenterSSID = #Centers.CenterSSID
INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
	ON FST.SalesCodeKey = sc.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
WHERE   d.FullDate BETWEEN @begdt AND @enddt
		AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
GROUP BY #Centers.CenterNumber
,    ClientIdentifier
,    #Employees.ClientMembershipKey
,    ClientFullName


/****************************** GET FINAL DATA SET ***********************************/

SELECT  CTR.CenterTypeDescription
,	CTR.MainGroupID
,	CTR.MainGroup
,	CTR.MainGroupSortOrder
,	CTR.CenterNumber
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,	E.ClientIdentifier
,	E.ClientKey
,	E.ClientMembershipKey
,	E.ClientFullName
,	E.MembershipSSID
,	E.MembershipDescription
,	E.ClientMembershipBeginDate
,	E.ClientMembershipEndDate
,	E.RevenueGroupDescription
,	E.BusinessSegmentDescription
,	E.EmployeeKey
,	ISNULL(S.ServiceAmt, 0) AS 'ServiceAmt'
,	ISNULL(RS.RetailAmt, 0) AS 'RetailAmt'
FROM    #Employees E
INNER JOIN #Centers CTR
	ON E.CenterSSID = CTR.CenterSSID
LEFT OUTER JOIN #Services S
	ON E.ClientIdentifier = S.ClientIdentifier
LEFT OUTER JOIN #RetailSales RS
	ON E.ClientIdentifier = RS.ClientIdentifier
GROUP BY ISNULL(S.ServiceAmt, 0)
,	ISNULL(RS.RetailAmt, 0)
,	CTR.CenterTypeDescription
,	CTR.MainGroupID
,	CTR.MainGroup
,	CTR.MainGroupSortOrder
,	CTR.CenterNumber
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,	E.ClientIdentifier
,	E.ClientKey
,	E.ClientMembershipKey
,	E.ClientFullName
,	E.MembershipSSID
,	E.MembershipDescription
,	E.ClientMembershipBeginDate
,	E.ClientMembershipEndDate
,	E.RevenueGroupDescription
,	E.BusinessSegmentDescription
,	E.EmployeeKey


END
GO
