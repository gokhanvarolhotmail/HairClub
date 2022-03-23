/* CreateDate: 07/01/2015 08:24:35.973 , ModifyDate: 09/04/2015 11:47:07.500 */
GO
/***********************************************************************
PROCEDURE:				spRpt_WomenMembershipsUpgradesDowngrades
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			New Women Memberships - Upgrades & Downgrades
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/1/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_WomenMembershipsUpgradesDowngrades 2, '6/1/2015', '6/30/2015'
EXEC spRpt_WomenMembershipsUpgradesDowngrades 8, '6/1/2015', '6/30/2015'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_WomenMembershipsUpgradesDowngrades]
(
	@CenterType INT,
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)


/********************************** Get list of centers *************************************/
IF @CenterType = 0 OR @CenterType = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


IF @CenterType = 0 OR @CenterType = 8
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


/********************************** Get sales data *************************************/
SELECT	C.MainGroupID AS 'RegionSSID'
,		C.MainGroup AS 'Region'
,		C.CenterSSID AS 'ClientCenterSSID'
,		C.CenterDescription AS 'ClientCenter'
,		C.CenterType
,		CTR.CenterSSID AS 'TransactionCenterSSID'
,		CTR.CenterDescriptionNumber AS 'TransactionCenter'
,		DSO.InvoiceNumber
,		DD.FullDate
,		CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
,		CASE CLT.GenderSSID
		WHEN 1 THEN 'Male'
		WHEN 2 THEN 'Female'
		ELSE 'Other'
		END AS 'Gender'
,		PrevDM.MembershipDescription AS 'ConvertedFrom'
,		DM.MembershipDescription AS 'ConvertedTo'
,		DSC.SalesCodeDescriptionShort AS 'SalesCode'
,		DSC.SalesCodeDescription AS 'Description'
,		Dept.SalesCodeDepartmentSSID AS 'Department'
,		Div.SalesCodeDivisionSSID AS 'Division'
,		FST.ExtendedPrice AS 'Price'
,		FST.Tax1 AS 'Tax'
,		FST.ExtendedPricePlusTax AS 'Total'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment Dept
			ON DSC.SalesCodeDepartmentKey = Dept.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision Div
			ON Dept.SalesCodeDivisionKey = Div.SalesCodeDivisionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType DSOT
			ON DSO.SalesOrderTypeKey = DSOT.SalesOrderTypeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PrevDCM
            ON DSOD.PreviousClientMembershipSSID = PrevDCM.ClientMembershipSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PrevDM
            ON PrevDCM.MembershipSSID = PrevDM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
            ON DC.ReportingCenterSSID = C.CenterSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
			ON FST.Employee1Key = PFR.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
			ON FST.Employee2Key = STY.EmployeeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND ( DSC.SalesCodeKey IN ( 636, 1757 ) AND DM.MembershipKey IN ( 114, 115, 116, 117, 118, 119, 120, 121 ) )
		OR ( DSC.SalesCodeKey IN ( 635 ) AND PrevDM.MembershipKey IN ( 114, 115, 116, 117, 118, 119, 120, 121 ) )
ORDER BY C.CenterType
,		C.MainGroup
,		C.CenterSSID
,		DSO.OrderDate

END
GO
