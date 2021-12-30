/* CreateDate: 04/14/2021 11:29:31.777 , ModifyDate: 04/15/2021 15:52:44.957 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetAcquiredClientDataForPittsburgh
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/14/2021
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetAcquiredClientDataForPittsburgh
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetAcquiredClientDataForPittsburgh]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CenterID INT
DECLARE @CurrentDate DATETIME
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @CenterID = 216
SET @CurrentDate = CAST(CURRENT_TIMESTAMP AS DATE)
SET @StartDate = '11/1/2019'
SET @EndDate = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, @CurrentDate), 101))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	AreaDescription NVARCHAR(50)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(10)
)


/********************************** Get Center Data *************************************/
INSERT	INTO #Center
		SELECT	dr.RegionSSID
		,		dr.RegionDescription
		,		cma.CenterManagementAreaDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		dct.CenterTypeDescriptionShort
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion dr
					ON dr.RegionKey = ctr.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	ctr.CenterSSID = @CenterID
				AND ctr.Active = 'Y'


/********************************** Get Acquired Client Data *************************************/
SELECT	DISTINCT
		clt.ClientIdentifier
INTO	#Clients
FROM	HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientSSID = cm.ClientSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterSSID = clt.CenterSSID
WHERE	ctr.CenterNumber = @CenterID
		AND m.MembershipDescriptionShort IN ( 'ACQUIRED', 'ACQSOL' )
		AND cm.ClientMembershipBeginDate >= '10/1/2019'


/********************************** Get Sales Data *************************************/
SELECT	c.AreaDescription AS 'Area'
,		c.CenterNumber
,		c.CenterDescription
,		so.InvoiceNumber
,		dd.FullDate
,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullName AS 'ClientName'
,		m.MembershipDescription AS 'Membership'
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription AS 'Description'
,		sot.SalesOrderTypeDescription AS 'SalesOrderType'
,		dep.SalesCodeDepartmentSSID
,		dep.SalesCodeDepartmentDescription AS 'Department'
,		div.SalesCodeDivisionSSID
,		div.SalesCodeDivisionDescription AS 'Division'
,		fst.Quantity
,		fst.ExtendedPrice AS 'Price'
,		fst.Tax1 AS 'Tax'
,		fst.ExtendedPricePlusTax AS 'Total'
FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.DateKey = fst.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = fst.ClientKey
		INNER JOIN #Clients cl
			ON cl.ClientIdentifier = clt.ClientIdentifier
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
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType sot
			ON sot.SalesOrderTypeKey = so.SalesOrderTypeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON cm.ClientMembershipKey = so.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterKey = cm.CenterKey
		INNER JOIN #Center c
			ON c.CenterSSID = ctr.CenterSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee con
			ON con.EmployeeKey = fst.Employee1Key
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee sty
			ON sty.EmployeeKey = fst.Employee2Key
WHERE	dd.FullDate BETWEEN @StartDate AND @EndDate
		AND sc.SalesCodeDescriptionShort NOT IN ( 'UPDMBR', 'UPDCXL', 'PMTRCVD', 'AUTO CC PMT', 'CONTUPT', 'TIPS', 'POSTAGE' )
		AND sot.SalesOrderTypeDescriptionShort NOT IN ( 'MO' )
		AND fst.ExtendedPrice <> 0
		AND so.IsVoidedFlag = 0
ORDER BY so.OrderDate

END
GO
