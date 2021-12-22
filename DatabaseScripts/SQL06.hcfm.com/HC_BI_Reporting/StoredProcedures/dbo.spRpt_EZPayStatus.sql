/* CreateDate: 09/24/2019 11:16:25.240 , ModifyDate: 11/05/2019 08:53:00.317 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_EZPayStatus
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					James Lee
IMPLEMENTOR:			James Lee
DATE IMPLEMENTED:		9/12/2019
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_EZPayStatus
***********************************************************************/
CREATE PROCEDURE spRpt_EZPayStatus
AS

BEGIN

SET NOCOUNT ON;
SET FMTONLY OFF;


CREATE TABLE #Center (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
,   Sort INT
)


INSERT  INTO #Center
		SELECT	cma.CenterManagementAreaSSID AS 'MainGroupID'
		,		cma.CenterManagementAreaDescription AS 'MainGroup'
		,		cma.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		ctr.CenterNumber
		,		ctr.CenterSSID
		,		ctr.CenterDescription
		,		ctr.CenterDescriptionNumber
		,		1 AS 'SortOrder'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	ct.CenterTypeDescriptionShort IN ( 'C', 'HW' )
				AND ctr.Active = 'Y'
				AND cma.Active = 'Y'


INSERT  INTO #Center
		SELECT  r.RegionSSID AS 'MainGroupID'
		,		r.RegionDescription AS 'MainGroup'
		,		r.RegionSortOrder AS 'MainGroupSortOrder'
		,		ctr.CenterNumber
		,		ctr.CenterSSID
		,		ctr.CenterDescription
		,		ctr.CenterDescriptionNumber
		,       2 AS 'SortOrder'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON r.RegionSSID = ctr.RegionSSID
		WHERE	ct.CenterTypeDescriptionShort IN('F','JV')
				AND ctr.Active = 'Y'

SELECT	c.MainGroupID
,		c.MainGroup
,		c.MainGroupSortOrder
,		c.CenterDescriptionNumber AS 'CenterDescription'
,		clt.ClientFullName
,		MAX(cm.ClientMembershipBeginDate) AS 'ClientMembershipBeginDate'
,		MAX(cm.ClientMembershipContractPrice) AS 'ClientMembershipContractPrice'
,		MAX(cm.ClientMembershipContractPaidAmount) AS 'ClientMembershipContractPaidAmount'
,		MAX(sod.Discount) AS 'Discount'
,		MAX(e.EmployeeFullName) AS 'Employee'
,		MAX(cm.ClientMembershipMonthlyFee) AS 'Monthly Fee'
,		MAX(CASE WHEN ce.ClientEFTGUID IS NULL THEN 'NO EFT PROFILE' ELSE 'Good' END) AS 'EFT Status'
,		MAX(CASE WHEN sc.SalesCodeDepartmentSSID = 5010 THEN 'Applied' ELSE '' END) AS 'AppliedStatus'
,       MAX(so.InvoiceNumber) AS 'InvoiceNumber'
,		c.Sort
FROM	HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
			ON so.ClientMembershipSSID = cm.ClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
			ON sod.SalesOrderSSID = so.SalesOrderSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON sc.SalesCodeSSID = sod.SalesCodeSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterSSID = so.CenterSSID
		INNER JOIN #Center c
			ON c.CenterSSID = ctr.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
			ON ctr.CenterManagementAreaSSID = cma.CenterManagementAreaSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientSSID = cm.ClientSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
			ON e.EmployeeSSID = sod.Employee1SSID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datClientEFT ce
			ON ce.ClientMembershipGUID = cm.ClientMembershipSSID
WHERE	cm.MembershipSSID = 285
		AND ( sc.SalesCodeDepartmentSSID = 1010 OR sc.SalesCodeDepartmentSSID = 5010 )
		AND so.IsVoidedFlag = 0
GROUP BY c.MainGroupID
,		c.MainGroup
,		c.MainGroupSortOrder
,		c.CenterDescriptionNumber
,		clt.ClientFullName
,		c.Sort


END
GO
