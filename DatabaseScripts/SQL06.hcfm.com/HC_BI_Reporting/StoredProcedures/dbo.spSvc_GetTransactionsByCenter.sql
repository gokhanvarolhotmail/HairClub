/* CreateDate: 05/11/2020 17:09:07.163 , ModifyDate: 05/11/2020 17:41:46.897 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_GetCenterTransactions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/11/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetTransactionsByCenter 294
EXEC spSvc_GetTransactionsByCenter 296
***********************************************************************/
CREATE PROCEDURE spSvc_GetTransactionsByCenter
(
	@CenterNumber INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = '1/1/2014'
SET @EndDate = '5/10/2020'


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


/********************************** Get list of centers *************************************/
IF @CenterNumber BETWEEN 201 AND 296
	BEGIN
		INSERT  INTO #Center
				SELECT  dr.RegionSSID
				,		dr.RegionDescription
				,		cma.CenterManagementAreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		dct.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
							ON dct.CenterTypeKey = ctr.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion dr
							ON dr.RegionKey = ctr.RegionSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
							ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
				WHERE   ctr.CenterNumber = @CenterNumber
						AND ctr.Active = 'Y'
	END


IF @CenterNumber BETWEEN 745 AND 896
	BEGIN
		INSERT  INTO #Center
				SELECT  dr.RegionSSID
				,		dr.RegionDescription
				,		cma.CenterManagementAreaDescription
				,		ctr.CenterSSID
				,		ctr.CenterNumber
				,		ctr.CenterDescription
				,		dct.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
							ON dct.CenterTypeKey = ctr.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion dr
							ON dr.RegionKey = ctr.RegionKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
							ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
				WHERE   ctr.CenterNumber = @CenterNumber
						AND ctr.Active = 'Y'
	END


/********************************** Get sales data *************************************/
SELECT	c.AreaDescription AS 'Area'
,		c.CenterNumber
,		c.CenterDescription
,		so.InvoiceNumber
,		dd.FullDate AS 'OrderDate'
,		CASE WHEN CONVERT(NVARCHAR(18), clt.SFDC_Leadid) = '-2' THEN '' ELSE CONVERT(NVARCHAR(18), clt.SFDC_Leadid) END AS 'SFDC_LeadID'
,		clt.ClientIdentifier
,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullName AS 'ClientName'
,		CASE WHEN clt.GenderSSID = 2 THEN 'Female' ELSE 'Male' END AS 'Gender'
,		ISNULL(clt.ClientEthinicityDescription, '') AS 'Ethnicity'
,		ISNULL(clt.ClientOccupationDescription, '') AS 'Occupation'
,		ISNULL(clt.ClientMaritalStatusDescription, '') AS 'MaritalStatus'
,		m.MembershipDescription AS 'Membership'
,		cm.ClientMembershipBeginDate AS 'BeginDate'
,		cm.ClientMembershipEndDate AS 'EndDate'
,		cm.ClientMembershipStatusDescription AS 'MembershipStatus'
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription AS 'Description'
,		sot.SalesOrderTypeDescription AS 'SalesOrderType'
,		sc.SalesCodeDepartmentSSID AS 'Department'
,		fst.ExtendedPrice AS 'Price'
,		fst.Tax1 AS 'Tax'
,		fst.ExtendedPricePlusTax AS 'Total'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
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
WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
        AND so.IsVoidedFlag = 0

END
GO
