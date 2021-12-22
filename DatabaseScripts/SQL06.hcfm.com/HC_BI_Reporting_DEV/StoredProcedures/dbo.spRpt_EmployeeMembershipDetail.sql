/* CreateDate: 03/20/2020 16:37:21.983 , ModifyDate: 03/23/2020 14:30:18.690 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_EmployeeMembershipDetail]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_BI_Reporting]

IMPLEMENTOR: 			Rachelen Hut

==============================================================================
DESCRIPTION:	This procedure is for reporting employees with memberships
==============================================================================
CHANGE HISTORY:

==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_EmployeeMembershipDetail] 201,'2/01/2020','2/29/2020'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_EmployeeMembershipDetail] (
	@CenterNumber INT
,	@begdt DATETIME
,	@enddt DATETIME
) AS
BEGIN
SET NOCOUNT ON

/************************** Find employee memberships **********************************/

SELECT CLT.ClientIdentifier
,	CLT.ClientSSID
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
,	CTR.CenterDescriptionNumber
,	E.EmployeeKey
INTO #Employee
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
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON E.EmployeeFullName = CLT.ClientFullName
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = E.CenterSSID
WHERE CTR.CenterNumber = @CenterNumber
AND CM.MembershipSSID IN(50,51,78,282,290)
AND E.IsActiveFlag = 1
AND CM.ClientMembershipEndDate >= @enddt


/****************************** GET RETAIL and SERVICES DATA **************************************/
IF OBJECT_ID('tempdb..#RetailService') IS NOT NULL
BEGIN
	DROP TABLE #RetailService
END

SELECT DIV.SalesCodeDivisionSSID
,	DIV.SalesCodeDivisionDescription
,	C.CenterNumber
,	#Employee.ClientIdentifier
,	#Employee.ClientMembershipKey
,	#Employee.ClientFullName
,	DD.FullDate AS RetailServiceDate
,	FST.SalesOrderKey
,	SC.SalesCodeSSID
,	SC.SalesCodeDescription
,	SC.SalesCodeDescriptionShort
,	SO.InvoiceNumber
,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailAmt'
,	SUM(ISNULL(FST.ServiceAmt,0)) AS 'ServiceAmt'
INTO #RetailService
FROM    #Employee
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	ON FST.ClientMembershipKey = #Employee.ClientMembershipKey
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
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
    ON FST.SalesCodeKey = SC.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DEP
	ON DEP.SalesCodeDepartmentKey = SC.SalesCodeDepartmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision DIV
	ON DEP.SalesCodeDivisionKey = DIV.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
    ON CM.MembershipSSID = M.MembershipSSID
WHERE  DIV.SalesCodeDivisionSSID IN(30,50)
AND DD.FullDate BETWEEN @begdt AND @enddt
GROUP BY DIV.SalesCodeDivisionSSID
,	DIV.SalesCodeDivisionDescription
,	C.CenterNumber
,   ClientIdentifier
,   #Employee.ClientMembershipKey
,   ClientFullName
,	DD.FullDate
,	SO.InvoiceNumber
,   FST.SalesOrderKey
,   SC.SalesCodeSSID
,   SC.SalesCodeDescription
,   SC.SalesCodeDescriptionShort


/****************************** GET FINAL DATA SET ***********************************/

SELECT  E.CenterDescriptionNumber
,	ISNULL(RS.SalesCodeDivisionSSID,0) AS SalesCodeDivisionSSID
,	ISNULL(RS.SalesCodeDivisionDescription,'None') AS SalesCodeDivisionDescription
,	RS.RetailServiceDate
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
,	RS.InvoiceNumber
,	RS.SalesOrderKey
,	RS.SalesCodeSSID
,	RS.SalesCodeDescription
,	RS.SalesCodeDescriptionShort
,	ISNULL(RS.ServiceAmt, RS.RetailAmt) AS 'RetailServiceAmt'

FROM    #Employee E
LEFT OUTER JOIN #RetailService RS
	ON E.ClientIdentifier = RS.ClientIdentifier
GROUP BY ISNULL(RS.ServiceAmt, RS.RetailAmt)
,   ISNULL(RS.SalesCodeDivisionSSID,0)
,   ISNULL(RS.SalesCodeDivisionDescription,'None')
,	E.CenterDescriptionNumber
,   RS.RetailServiceDate
,   E.ClientIdentifier
,   E.ClientKey
,   E.ClientMembershipKey
,   E.ClientFullName
,   E.MembershipSSID
,   E.MembershipDescription
,   E.ClientMembershipBeginDate
,   E.ClientMembershipEndDate
,   E.RevenueGroupDescription
,   E.BusinessSegmentDescription
,   E.EmployeeKey
,	RS.InvoiceNumber
,	RS.SalesOrderKey
,	RS.SalesCodeSSID
,	RS.SalesCodeDescription
,	RS.SalesCodeDescriptionShort


END
GO
