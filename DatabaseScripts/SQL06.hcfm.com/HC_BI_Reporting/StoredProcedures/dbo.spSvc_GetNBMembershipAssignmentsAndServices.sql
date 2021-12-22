/* CreateDate: 03/26/2021 10:13:50.197 , ModifyDate: 12/06/2021 12:36:13.977 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_GetNBMembershipAssignmentsAndServices
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/26/2021
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetNBMembershipAssignmentsAndServices
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetNBMembershipAssignmentsAndServices]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CenterType INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @CenterType = 2
SET @StartDate = '1/1/2020'
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, CURRENT_TIMESTAMP)) +1, 0))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	Area NVARCHAR(100)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
)


/********************************** Get list of centers *************************************/
INSERT INTO #Center
		SELECT	cma.CenterManagementAreaDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
				--INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion dr
				--	ON dr.RegionKey = ctr.RegionSSID --> Code was comment due to is not being use and also relation table is not being set up correctly
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	dct.CenterTypeDescriptionShort IN ( 'C' )
				AND ctr.Active = 'Y'
		ORDER BY CenterSSID asc


/********************************** Get Client Data *************************************/
SELECT	c.Area AS 'Area'
,		c.CenterNumber
,		c.CenterDescription AS 'CenterName'
,		so.InvoiceNumber
,		dd.FullDate AS 'SaleDate'
,		clt.ClientIdentifier
,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullName AS 'ClientName'
,		cm.ClientMembershipKey
,		m.MembershipDescription AS 'Membership'
,		CAST(cm.ClientMembershipBeginDate AS DATE) AS 'BeginDate'
,		CAST(cm.ClientMembershipEndDate AS DATE) AS 'EndDate'
,		cm.ClientMembershipStatusDescription AS 'MembershipStatus'
,		cm.ClientMembershipContractPrice AS 'ContractPrice'
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription AS 'Description'
,		sc.SalesCodeDepartmentSSID AS 'Department'
,		fst.ExtendedPrice AS 'Price'
,		fst.Tax1 AS 'Tax'
,		fst.ExtendedPricePlusTax AS 'Total'
INTO	#Client
FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.DateKey = fst.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = fst.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON sc.SalesCodeKey = fst.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
			ON so.SalesOrderKey = fst.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
			ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON cm.ClientMembershipKey = so.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterKey = cm.CenterKey
		INNER JOIN #Center c
			ON c.CenterSSID = ctr.CenterSSID
WHERE	dd.FullDate BETWEEN @StartDate AND @EndDate
		AND ( fst.NB_TradCnt >= 1
				OR fst.NB_GradCnt >= 1
				OR fst.NB_ExtCnt >= 1
				OR fst.NB_XTRCnt >= 1
				OR fst.NB_MDPCnt >= 1
				OR fst.S_SurCnt >= 1
				OR fst.S_PRPCnt >= 1
				)
		AND m.RevenueGroupDescriptionShort = 'NB' /* New Business */
		AND m.MembershipDescriptionShort NOT IN ( 'SHOWNOSALE', 'SNSSURGOFF', 'SNSSURGHW', 'RETAIL', '1STSURG', 'POSTEXT', 'MDP', 'HT', 'LASER82', 'NL1Strip'
												, 'NL3Artas', 'NL3Strip'
												)
		AND so.IsVoidedFlag = 0


/********************************** Get First Service Data *************************************/
SELECT	ROW_NUMBER() OVER (PARTITION BY clt.ClientIdentifier ORDER BY so.OrderDate) AS 'RowID'
,		so.InvoiceNumber
,		so.OrderDate AS 'ServiceDate'
,		clt.ClientIdentifier
,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullName AS 'ClientName'
,		m.MembershipDescription AS 'Membership'
,		cm.ClientMembershipBeginDate AS 'BeginDate'
,		cm.ClientMembershipEndDate AS 'EndDate'
,		cm.ClientMembershipContractPrice AS 'ContractPrice'
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription AS 'Description'
,		sc.SalesCodeDepartmentSSID AS 'Department'
,		fst.ExtendedPrice AS 'Price'
,		fst.Tax1 AS 'Tax'
,		fst.ExtendedPricePlusTax AS 'Total'
INTO	#FirstService
FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.DateKey = fst.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = fst.ClientKey
		INNER JOIN #Client c
			ON c.ClientIdentifier = clt.ClientIdentifier
			AND c.ClientMembershipKey = fst.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON sc.SalesCodeKey = fst.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment dep
			ON dep.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision div
			ON div.SalesCodeDivisionKey = dep.SalesCodeDivisionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
			ON so.SalesOrderKey = fst.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
			ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON cm.ClientMembershipKey = so.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterKey = cm.CenterKey
WHERE	dd.FullDate BETWEEN @StartDate AND @EndDate
		AND div.SalesCodeDivisionSSID = 50
		AND sc.SalesCodeDescriptionShort IN ( 'XTRNEWSRV', 'EXTSVC', 'WEXTSVC', 'NB1A' )


/********************************** Combine & Return Data *************************************/
SELECT	c.Area
,		c.CenterNumber
,		c.CenterName
,		c.InvoiceNumber
,		c.SaleDate
,		c.ClientIdentifier
,		REPLACE(c.ClientName, ',', '') AS 'ClientName'
,		c.Membership
,		c.BeginDate
,		c.EndDate
,		c.MembershipStatus
,		c.ContractPrice
,		fs.ServiceDate AS 'FirstServiceDate'
FROM	#Client c
		LEFT OUTER JOIN #FirstService fs
			ON fs.ClientIdentifier = c.ClientIdentifier
			AND fs.RowID = 1

END
GO
