/***********************************************************************
PROCEDURE:				[rptFlashAccessories]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairclubCMS
RELATED REPORT:
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		10/15/2018
------------------------------------------------------------------------
NOTES:
@CenterType = 2 for Corporate, 8 for Franchise
This report is on SQL01 because we need Brand for Mizani and Matrix
------------------------------------------------------------------------
CHANGE HISTORY:
12/04/2018 - RH/MH - Added Christine Headwear
11/18/2019 - RH - Added Wigs and Blow Dryers; Changed the name from rptProductsMatrixMizani to rptFlashAccessories; removed Tender Type of InterCo and No Charge
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [rptFlashAccessories] 2, '11/1/2019', '11/15/2019'
***********************************************************************/
CREATE PROCEDURE [dbo].[rptFlashAccessories]
(
	@CenterType INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
)
AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;

       --DROP table #Centers
/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
       MainGroupID INT
,      MainGroup VARCHAR(50)
,		MainGroupSortOrder INT
,      CenterNumber INT
,      CenterDescription VARCHAR(255)
,      CenterType VARCHAR(50)
)


/********************************** Get list of centers *******************************************/
IF @CenterType = 0 OR @CenterType = 2
       BEGIN
              INSERT  INTO #Centers
                           SELECT  CMA.CenterManagementAreaID  MainGroupID
                           ,        CMA.CenterManagementAreaDescription MainGroup
						   ,		CMA.CenterManagementAreaSortOrder MainGroupSortOrder
                           ,        CTR.CenterNumber
                           ,        CTR.CenterDescriptionFullCalc
                           ,        CT.CenterTypeDescriptionShort
                           FROM    dbo.cfgCenter CTR WITH (NOLOCK)
                                         INNER JOIN dbo.lkpCenterType CT WITH (NOLOCK)
                                                ON CT.CenterTypeID = CTR.CenterTypeID
                                         INNER JOIN dbo.cfgCenterManagementArea CMA WITH (NOLOCK)
                                                ON CMA.CenterManagementAreaID = CTR.CenterManagementAreaID
                           WHERE   CT.CenterTypeDescriptionShort = 'C'
                                        AND CTR.IsActiveFlag = 1
       END


IF @CenterType = 8
       BEGIN
              INSERT  INTO #Centers
                           SELECT   LR.RegionID MainGroupID
                           ,        LR.RegionDescription MainGroup
						   ,		LR.RegionSortOrder MainGroupSortOrder
                           ,        CTR.CenterNumber
                           ,        CTR.CenterDescriptionFullCalc
                           ,        LCT.CenterTypeDescriptionShort
                           FROM    dbo.cfgCenter CTR WITH (NOLOCK)
                                         INNER JOIN dbo.lkpCenterType LCT WITH (NOLOCK)
                                                ON LCT.CenterTypeID = CTR.CenterTypeID
                                         INNER JOIN dbo.lkpRegion LR WITH (NOLOCK)
                                                ON LR.RegionID = CTR.RegionID
                           WHERE   LCT.CenterTypeDescriptionShort IN ( 'JV', 'F' )
                                         AND CTR.IsActiveFlag = 1
       END


/************************ Find Wig SalesCodes ****************************************************/

SELECT SalesCodeID, sc.SalesCodeDescription
INTO #WigSalesCodes
FROM cfgSalesCode sc  WITH(NOLOCK)
INNER JOIN dbo.lkpSalesCodeDepartment scd
	ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
WHERE scd.SalesCodeDepartmentDescription = 'Wigs'
AND sc.IsActiveFlag = 1

/********************************** Display Results ***********************************************/
SELECT  C.MainGroupID
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( '450-132', '450-133', '450-134', '450-135', '450-136', '450-137', '450-138' ) THEN 'Mizani'
			WHEN sc.SalesCodeID IN(SELECT SalesCodeID FROM #WigSalesCodes)THEN 'Wigs'
			ELSE lb.BrandDescription
			END AS 'Brand'
,		C.MainGroup
,		C.MainGroupSortOrder
,		ctr.CenterNumber
,		ctr.CenterDescription
,		so.InvoiceNumber
,		cl.ClientIdentifier
,		cl.ClientFullNameAlt2Calc  + ' (' +  CONVERT(VARCHAR, cl.ClientIdentifier) + ')' AS 'ClientName'
,		m.MembershipDescription AS 'Membership'
,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
,		so.OrderDate
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription AS 'Description'
,		scd.SalesCodeDepartmentID
,		scd.SalesCodeDepartmentDescription AS 'Department'
,		sod.ExtendedPriceCalc AS 'Price'
,		sod.TotalTaxCalc AS 'Tax'
,		sod.PriceTaxCalc AS 'Total'
,		ISNULL(con.EmployeeFullNameCalc, '') AS 'Consultant'
,		ISNULL(con.EmployeePayrollID, '') AS 'ConsultantPayrollID'
,		ISNULL(sty.EmployeeFullNameCalc, '') AS 'Stylist'
,		ISNULL(sty.EmployeePayrollID, '') AS 'StylistPayrollID'
FROM    dbo.datSalesOrderDetail sod WITH(NOLOCK)
        INNER JOIN datSalesOrder so WITH(NOLOCK)
            ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN dbo.datSalesOrderTender SOT WITH(NOLOCK)
			ON SOT.SalesOrderGUID = so.SalesOrderGUID
        INNER JOIN cfgSalesCode sc  WITH(NOLOCK)
            ON sc.SalesCodeID = sod.SalesCodeID
        INNER JOIN lkpBrand lb  WITH(NOLOCK)
                ON lb.BrandID = sc.BrandID
        INNER JOIN lkpSalesCodeDepartment scd   WITH(NOLOCK)
            ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
        INNER JOIN lkpSalesCodeDivision scdv  WITH(NOLOCK)
            ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
        INNER JOIN cfgCenter ctr  WITH(NOLOCK)
            ON ctr.CenterID = so.CenterID
		INNER JOIN #Centers C
            ON C.CenterNumber = ctr.CenterNumber
        INNER JOIN datClient cl  WITH(NOLOCK)
            ON cl.ClientGUID = so.ClientGUID
        INNER JOIN datClientMembership cm   WITH(NOLOCK)
            ON cm.ClientMembershipGUID = so.ClientMembershipGUID
        INNER JOIN lkpClientMembershipStatus cms
                ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
        INNER JOIN cfgMembership m   WITH(NOLOCK)
            ON m.MembershipID = cm.MembershipID
        LEFT OUTER JOIN datEmployee csh   WITH(NOLOCK)
            ON csh.EmployeeGUID = so.EmployeeGUID
        LEFT OUTER JOIN datEmployee con   WITH(NOLOCK)
            ON con.EmployeeGUID = sod.Employee1GUID
        LEFT OUTER JOIN datEmployee sty   WITH(NOLOCK)
            ON sty.EmployeeGUID = sod.Employee2GUID
WHERE   so.OrderDate BETWEEN @StartDate AND @EndDate
              AND scdv.SalesCodeDivisionID = 30 --Products
              AND ( lb.BrandID IN ( 19, 34, 35, 20 ) -- 'Matrix', 'Mizani', 'Christine Headwear'
                           OR sc.SalesCodeDescriptionShort IN ( '450-132', '450-133', '450-134', '450-135', '450-136', '450-137', '450-138', '480-115' )  --Added Blow Dryer '480-115'
						   OR sc.SalesCodeID IN(SELECT SalesCodeID FROM #WigSalesCodes )
					)
        AND so.IsVoidedFlag = 0
		AND sc.IsActiveFlag = 1
		AND scd.IsActiveFlag = 1
		AND scdv.IsActiveFlag = 1
		AND sot.TenderTypeID NOT IN(5,7,8)  --InterCo, InterCoBOS, NC - No Charge

ORDER BY C.MainGroupSortOrder
,	lb.BrandDescription  --ORDER BY is here to speed up the SSRS report


END
