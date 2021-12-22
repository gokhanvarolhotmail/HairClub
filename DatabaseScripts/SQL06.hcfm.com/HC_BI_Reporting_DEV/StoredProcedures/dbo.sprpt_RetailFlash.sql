/***********************************************************************
PROCEDURE:				sprpt_RetailFlash	VERSION  1.0
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_CMS_DDS
RELATED APPLICATION:	Retail Flash - sub report
AUTHOR:					Kevin Murdoch
IMPLEMENTOR:			Kevin Murdoch
DATE IMPLEMENTED:		4/1/2012
LAST REVISION DATE:		10/21/2013
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
3/27/2012	KMurdoch	Initial Creation
8/31/2012   HDu	- WO# 79045 Found bug in usage of Sales Order Date, updated query to use the facttransaction datekey
9/25/2012	HDu - WO# 79679 Removed SalesCodes that are Membership Revenue from the Laser comb column.
11/30/2012  HDu - WO# 81576 Changed stylist lookup to a hybrid method of center/initial lookup from Reporting.Employee table and Employee2GUID from CMS
01/28/2013  KM/MB = WO# 83938 - Modified join to DimEmployee rather than Employee
10/21/2013 - RH - (#92910) Added additional RSM roll-up filters - see 1,2,3,4 below - By Region, NB1, MA, TM
10/21/2013 - RH - (#92910) Removed the following line from the procedure: SET @enddt = @enddt + ' 23:59:59'
10/25/2013 - RH - (#92910) Changed LEFT OUTER JOIN to INNER JOIN ON #Sales in the last statement and added WHERE emp.IsActiveFlag = 1
10/28/2013 - RH - For Franchise - Changed INNER JOIN ON DC.RegionSSID = DR.RegionKey to ON DC.RegionKey = DR.RegionKey
10/30/2013 - DL - (#93242) Removed LEFT OUTER JOIN to the employee table in the output query as well as the WHERE emp.IsActiveFlag = 1 clause.
				  The Recurring Flash retail amount column now matches the Total Retail column.
02/25/2015 - DL - (#111964) Removed EXT - LaserComb Payment & EXT - LaserHelmet Payment sales codes that appear to have been placed in the stored proc incorrectly.
11/23/2015 - RH - (#120713) Added LaserBand and LaserComb Ultima 12
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
11/19/2016 - RH - (#132270) Separate Shampoo and Conditioners
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description
06/23/2017 - RH - (#140509) Changed logic to find LaserHelmet, LaserComb and LaserBand; Changed logic to use DimCenterManagementArea for Areas
06/29/2017 - RH - (#140509) Added SalesOrderDetailKey to the detail section to ensure all was being counted
01/23/2018 - RH - (#145147) Added EmployeePayrollID
04/19/2018 - RH - (#149012) Adjust the Services to be one per client per day
05/15/2018 - RH - (#149717) Added Capillus, Total Laser, Retail without Laser
05/15/2018 - RH - (#12346)  Added WigsRevenue - TenderTypeDescriptionShort <> 'InterCo' to exclude employees
10/03/2019 - JL - (#13178)  Laser showing tripled on the Report. Revised query in #product, group by TenderTypeDescriptionShort will cause dup records - TrackIT#1394 TFS#13178
01/15/2020 - RH - (TrackIT 5248) Added Minerva, Spa, Halo, Extensions; and removed these amounts from MISC; moved Wigs to its separate temp table
02/05/2020 - RH - (TFS 13795) Removed WHERE Employee <> 'UNKNOWN' so the counts would match the department detail
12/10/2020 - AP - (TFS 14732) Add skincare department
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:

EXEC [sprpt_RetailFlash] 'C', '3/1/2021', '3/31/2021', 3
--***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_RetailFlash] (
	@sType CHAR(1)
,	@begdt SMALLDATETIME
,	@enddt SMALLDATETIME
,	@Filter INT
) AS

BEGIN


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort NVARCHAR(2)
)

CREATE TABLE #LaserProducts (
	SalesCodeKey INT
,	SalesCodeSSID INT
,	SalesCodeDescription NVARCHAR(50)
)


CREATE TABLE #Christine(
	 SalesCodeID INT
,    SalesCodeDescription NVARCHAR(100)
,    SalesCodeDescriptionShort NVARCHAR(50)
,	 BrandID INT
)


CREATE TABLE #Wigs(
	FullDate DATETIME
,	CenterNumber INT
,	Employee NVARCHAR(250)
,	MembershipDescriptionShort NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	SalesCodeDepartmentDescription NVARCHAR(50)
,	SalesCodeDescription NVARCHAR(60)
,	RetailQty INT
,	ExtendedPrice MONEY
,	SalesOrderDetailKey INT
,	ClientName NVARCHAR(450)
,	EmployeePayrollID NVARCHAR(50)
,	Position NVARCHAR(450)
)



CREATE TABLE #Services(
	CenterNumber INT NULL
,	CenterTypeDescriptionShort VARCHAR(10)
,	Fulldate DATETIME
,	ClientKey INT
,	SalesCodeSSID INT
,	SalesCodeDescription NVARCHAR(150)
,	SalesCodeTypeSSID INT
,	SalesCodeDepartmentSSID INT
,	SalesCodeDivisionSSID INT
,	EmployeeID UNIQUEIDENTIFIER NULL
,	Employee VARCHAR(255) NULL
,	EmployeePayrollID NVARCHAR(20)
,	ServicesCt INT NULL
)


CREATE TABLE #Products(
	CenterNumber INT NULL
,	CenterTypeDescriptionShort VARCHAR(10)
,	Fulldate DATETIME
,	SalesOrderDetailKey INT
,	Quantity INT
,	ExtendedPrice DECIMAL(18,4)
,	ClientKey INT
,	SalesCodeSSID INT
,	SalesCodeDescription NVARCHAR(150)
,	PriceDefault DECIMAL(18,4)
,	SalesCodeTypeSSID INT
,	SalesCodeDepartmentSSID INT
,	SalesCodeDivisionSSID INT
,	EmployeeID NVARCHAR(50) NULL
,	Employee VARCHAR(255) NULL
,	EmployeePayrollID NVARCHAR(20)
,	Adhesives DECIMAL(18,4) NULL
,	Shampoo DECIMAL(18,4) NULL
,   SkinCare DECIMAL(18,4) NULL
,	Conditioner DECIMAL(18,4) NULL
,	Styling DECIMAL(18,4) NULL
,	EXTProd DECIMAL(18,4) NULL
,	Kits DECIMAL(18,4) NULL
,	LaserComb DECIMAL(18,4) NULL
,	LaserBand DECIMAL(18,4) NULL
,	Laser DECIMAL(18,4) NULL
,	Capillus DECIMAL(18,4) NULL
,	Misc DECIMAL(18,4) NULL
,	Retail DECIMAL(18,4) NULL
,	RetailFree DECIMAL(18,4) NULL
,	Minerva DECIMAL(18,4) NULL
,	SPA DECIMAL(18,4) NULL
,	Christine DECIMAL(18,4) NULL
,	Halo DECIMAL(18,4) NULL
,	Extensions DECIMAL(18,4) NULL
--,	Wigs DECIMAL(18,4) NULL
)


CREATE TABLE #EmpID(
	EmployeeSSID NVARCHAR(50)
,	EmployeePayrollID NVARCHAR(50)
)


CREATE TABLE #ProdServ(
	[TYPE] NVARCHAR(2)
,	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber  VARCHAR(102)
,	Employee VARCHAR(255)
,	EmployeePayrollID NVARCHAR(20)
,	TotalRetail DECIMAL(18,4)
,	TotalServiceClients INT
 ,	RetailFree DECIMAL(18,4) NULL
,	Shampoo DECIMAL(18,4) NULL
,   SkinCare DECIMAL(18,4) NULL
,	Conditioner DECIMAL(18,4) NULL
,	Styling DECIMAL(18,4) NULL
,	Adhesives DECIMAL(18,4) NULL
,	EXTProd DECIMAL(18,4) NULL
,	LaserComb DECIMAL(18,4) NULL
,	LaserBand DECIMAL(18,4) NULL
,	Laser DECIMAL(18,4) NULL
,	Capillus DECIMAL(18,4) NULL
,	Kits DECIMAL(18,4) NULL
,	Miscellaneous DECIMAL(18,4) NULL
,	Minerva DECIMAL(18,4) NULL
,	SPA DECIMAL(18,4) NULL
,	Christine DECIMAL(18,4) NULL
,	Halo DECIMAL(18,4) NULL
,	Extensions DECIMAL(18,4) NULL
,	Wigs DECIMAL(18,4) NULL
)


/********************************** Get list of centers *************************************/


IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
	INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
			,	CMA.CenterManagementAreaDescription AS MainGroup
			,	DC.CenterKey
			,	DC.CenterNumber
			,	DC.CenterSSID
			,	DC.CenterDescriptionNumber
			,	CT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CMA.Active = 'Y'
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
				AND DC.CenterNumber = 237
END
IF @sType = 'C' AND @Filter = 3  -- By Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  DC.CenterSSID AS MainGroupID
			,		DC.CenterDescriptionNumber AS MainGroup
			,		DC.CenterKey
			,		DC.CenterNumber
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		CT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE	CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS MainGroupID
			,		DR.RegionDescription AS MainGroup
			,		DC.CenterKey
			,		DC.CenterNumber
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		CT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DR.RegionKey = DC.RegionKey
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
END


/******************* Find SalesCodeSSID's for Laser Products ***************************************/

INSERT INTO #LaserProducts
SELECT SalesCodeKey
,	SalesCodeSSID
,	SalesCodeDescription
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
inner join HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment  DSCD
	on DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
where DSCD.SalesCodeDivisionSSID = 30    --Products
and DSCD.SalesCodeDepartmentSSID = 3065


/********************************* Get Services - one per day per client ***************/

INSERT INTO #Services
SELECT q.CenterNumber,
       q.CenterTypeDescriptionShort,
       q.FullDate,
       q.ClientKey,
       q.SalesCodeSSID,
       q.SalesCodeDescription,
       q.SalesCodeTypeSSID,
       q.SalesCodeDepartmentSSID,
       q.ServicesCt,
       q.EmployeeID,
       q.Employee,
       q.EmployeePayrollID,
       q.FirstRank AS 'ServicesCt'
FROM

	(SELECT #Centers.CenterNumber
	,	#Centers.CenterTypeDescriptionShort
	,	DD.Fulldate
	,	FST.ClientKey
	,	DSC.SalesCodeSSID
	,	DSC.SalesCodeDescription
	,	DSC.SalesCodeTypeSSID
	,	DSCD.SalesCodeDepartmentSSID
	,	CASE WHEN DSCD.SalesCodeDepartmentSSID between 5010 and 5040 THEN 1 ELSE 0 END AS 'ServicesCt'
	,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
			WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID
			END AS 'EmployeeID'
	,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
			WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
				ELSE 'UNKNOWN'
			END AS 'Employee'
	,	NULL AS 'EmployeePayrollID'
	,	ROW_NUMBER() OVER(PARTITION BY FST.ClientKey,DD.FullDate ORDER BY DSC.SalesCodeDescription DESC) AS 'FirstRank'  --One service per day per client
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Centers
			ON FST.CenterKey = #Centers.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
	WHERE 	DSCD.SalesCodeDivisionSSID = 50
		AND DD.FullDate BETWEEN @begdt AND @enddt
		AND SO.IsVoidedFlag = 0
		AND DSCD.SalesCodeDepartmentSSID between 5010 and 5040  --This is for services
		AND M.MembershipDescription NOT LIKE 'Employee%'
	)q
WHERE FirstRank = 1

/********************************* Get Christine Sales Codes **********************************/

INSERT INTO #Christine
              SELECT sc.SalesCodeID
              ,             sc.SalesCodeDescription
              ,             sc.SalesCodeDescriptionShort
			  ,				sc.BrandID
              FROM   SQL05.HairClubCMS.dbo.cfgSalesCode sc
              WHERE  sc.BrandID = 20 -- Christine Headwear

/************ First find the wig sales not related to employee sales - join on Tender Type to remove Interco ******/

INSERT INTO #Wigs
SELECT
		DD.FullDate
	,	c.CenterNumber
	,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2FullName
		WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1FullName
		ELSE
		'UNKNOWN'
		END AS 'Employee'
	,	mem.MembershipDescriptionShort
	,	mem.MembershipDescription
	,	scd.SalesCodeDepartmentDescription
	,	sc.SalesCodeDescription
	,	CASE WHEN ( scd.SalesCodeDepartmentSSID = 7052
			--AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
			) THEN FST.quantity ELSE 0 END as 'RetailQty'
	,	CASE WHEN (scd.SalesCodeDivisionSSID = 30 AND scd.SalesCodeDepartmentSSID = 7052
			--AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
			) THEN FST.RetailAmt
			ELSE 0 END AS 'ExtendedPrice'
	,	FST.SalesOrderDetailKey
	,	cl.ClientFullName + ' (' + cast(cl.ClientIdentifier as varchar(10)) + ')' as 'ClientName'
	,	emp.EmployeePayrollID
	,	STUFF(P.Position, 1, 1, '') AS 'Position'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON DD.DateKey = FST.OrderDateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
		ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
		ON FST.salesorderkey = so.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
		ON FST.clientkey = cl.ClientKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
		ON FST.CenterKey = c.CenterKey
	INNER JOIN #Centers CTR
		ON CTR.CenterKey = c.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
		ON FST.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
		ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership clm
		ON FST.ClientMembershipKey = clm.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mem
		ON clm.MembershipKey = mem.MembershipKey
	--INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender DSOT
	--	ON	FST.SalesOrderKey = DSOT.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EMP
		ON (CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2SSID
		WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1SSID END) = emp.EmployeeSSID
	CROSS APPLY (SELECT ', ' + EP.EmployeePositionDescription
				FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP
					ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
				WHERE EMP.EmployeeSSID = EPJ.EmployeeGUID
					AND EMP.IsActiveFlag = 1
				ORDER BY EP.EmployeePositionDescription
				FOR XML PATH('') ) AS P (Position)
WHERE scd.SalesCodeDepartmentSSID = 7052  --Wigs
	AND DD.FullDate BETWEEN @begdt AND @enddt
	AND so.IsVoidedFlag = 0
	--AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
	AND mem.MembershipDescription NOT LIKE 'Employee%'

SELECT * FROM #Wigs w WHERE w.ClientName = 'Brady, Rennie (411863)'
/********************************** Get sales data *************************************/

INSERT INTO #Products
SELECT 	#Centers.CenterNumber
,	#Centers.CenterTypeDescriptionShort
,	DD.Fulldate
,	FST.SalesOrderDetailKey
,	FST.Quantity
,	FST.ExtendedPrice
,	FST.ClientKey
,	DSC.SalesCodeSSID
,	DSC.SalesCodeDescription
,	DSC.PriceDefault
,	DSC.SalesCodeTypeSSID
,	DSCD.SalesCodeDepartmentSSID
,	DSCD.SalesCodeDivisionSSID
,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
		WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID END AS 'EmployeeID'
,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
		WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
		ELSE
		'UNKNOWN'
		END AS 'Employee'
,	NULL AS 'EmployeePayrollID'
,	CASE WHEN DSCD.SalesCodeDepartmentSSID in (3010,3020) THEN FST.RetailAmt ELSE 0 END AS 'Adhesives'
,	CASE WHEN DSCD.SalesCodeDepartmentSSID in (3030) THEN FST.RetailAmt ELSE 0 END AS 'Shampoo'
,	CASE WHEN DSCD.SalesCodeDepartmentSSID in (3045) THEN FST.RetailAmt ELSE 0 END AS 'SkinCare'
,	CASE WHEN DSCD.SalesCodeDepartmentSSID in (3040) THEN FST.RetailAmt ELSE 0 END AS 'Conditioner'
,	CASE WHEN DSCD.SalesCodeDepartmentSSID in (3050) THEN FST.RetailAmt ELSE 0 END AS 'Styling'
,	CASE WHEN (DSCD.SalesCodeDepartmentSSID in (3060) AND DSC.SalesCodeSSID NOT IN (SELECT SalesCodeSSID FROM #LaserProducts)) THEN FST.RetailAmt ELSE 0 END AS 'EXT Products'
,	CASE WHEN DSCD.SalesCodeDepartmentSSID in (3070) THEN FST.RetailAmt ELSE 0 END AS 'Kits'
,	CASE WHEN (DSC.SalesCodeDescription LIKE '%LaserComb%') THEN FST.PCP_LaserAmt ELSE 0 END AS 'LaserComb'

--,	CASE WHEN (DSC.SalesCodeDescription LIKE '%LaserHelmet%') THEN FST.PCP_LaserAmt ELSE 0 END AS 'LaserHelmet'	-- Remove LaserHelmet, merge with LaserBand
--,	CASE WHEN (DSC.SalesCodeDescription LIKE '%LaserBand%') THEN FST.PCP_LaserAmt ELSE 0 END AS 'LaserBand'
,	CASE WHEN (DSC.SalesCodeDescription LIKE '%LaserHelmet%' OR DSC.SalesCodeDescription LIKE '%LaserBand%') THEN FST.PCP_LaserAmt ELSE 0 END AS 'LaserBand'

,	CASE WHEN (DSC.SalesCodeDescription LIKE '%Capillus%') THEN FST.PCP_LaserAmt ELSE 0 END AS 'Capillus'				--Report only PCP Laser amounts
,	CASE WHEN (DSCD.SalesCodeDepartmentSSID = 3065) THEN FST.PCP_LaserAmt ELSE 0 END AS 'Laser'
,	SUM(CASE WHEN (DSCD.SalesCodeDepartmentSSID in (3080)
		AND DSC.SalesCodeDescriptionShort NOT IN('480-115','480-116', 'HALO2LINES', 'HALO5LINES', 'HALO20','TAPEPACK')  --Remove Minerva, SPA, Halo, and Extensions from MISC
			--AND DSC.SalesCodeDescriptionShort NOT IN(SELECT SalesCodeDescriptionShort FROM #Christine)				--Remove Christine later in the proc
			)
		THEN FST.RetailAmt ELSE 0 END) AS 'Misc'
,	FST.RetailAmt AS 'Retail'
,	CASE WHEN (FST.ExtendedPrice= 0 AND DSCD.SalesCodeDivisionSSID = 30
		AND DSCD.SalesCodeDepartmentSSID NOT IN (3060) ) THEN FST.Quantity*DSC.PriceDefault ELSE 0 END AS 'RetailFree'
,	SUM(CASE WHEN DSC.SalesCodeDescriptionShort = '480-115' THEN fst.RetailAmt ELSE 0 END) AS 'Minerva'
,	SUM(CASE WHEN DSC.SalesCodeDescriptionShort = '480-116' THEN fst.RetailAmt ELSE 0 END) AS 'SPA'
,	SUM(CASE WHEN CHR.BrandID = 20 THEN ISNULL(fst.RetailAmt,0) ELSE 0 END) AS 'Christine'
,	SUM(CASE WHEN DSC.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) THEN fst.RetailAmt ELSE 0 END) AS 'Halo'
,	SUM(CASE WHEN DSC.SalesCodeDescriptionShort = 'TAPEPACK' THEN fst.RetailAmt ELSE 0 END) AS 'Extensions'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
    INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
        ON FST.OrderDateKey = DD.DateKey
	INNER JOIN #Centers
		ON FST.CenterKey = #Centers.CenterKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
        ON FST.SalesCodeKey = DSC.SalesCodeKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
        ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON FST.MembershipKey = M.MembershipKey
	LEFT JOIN #Christine CHR
		ON CHR.SalesCodeDescriptionShort = SOD.SalesCodeDescriptionShort
WHERE 	DSCD.SalesCodeDivisionSSID = 30
	AND DD.FullDate BETWEEN @begdt AND @enddt
	AND SO.IsVoidedFlag = 0
	AND M.MembershipDescription NOT LIKE 'Employee%'
	AND DSCD.SalesCodeDepartmentSSID <> 7052  --Remove wigs
GROUP BY #Centers.CenterNumber
,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2SSID
			WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1SSID END
,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2FullName
			WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1FullName
			ELSE
			'UNKNOWN'
			END
,	#Centers.CenterTypeDescriptionShort
,	DD.Fulldate
,	FST.SalesOrderDetailKey
,	FST.Quantity
,	FST.PCP_LaserAmt
,	FST.RetailAmt
,	FST.ExtendedPrice
,	FST.ClientKey
,	DSC.SalesCodeSSID
,	DSC.SalesCodeDescription
,	DSC.PriceDefault
,	DSC.SalesCodeTypeSSID
,	DSCD.SalesCodeDepartmentSSID
,	DSCD.SalesCodeDivisionSSID


/**************** Find EmployeePayroll ID's **************************************************************/

INSERT INTO #EmpID
SELECT EMP.EmployeeSSID, EMP.EmployeePayrollID
FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EMP
WHERE EmployeeSSID IN(SELECT EmployeeID FROM #Products)
UNION
SELECT EMP.EmployeeSSID, EMP.EmployeePayrollID
FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EMP
WHERE EmployeeSSID IN(SELECT EmployeeID FROM #Services)

UPDATE #Services
SET #Services.EmployeePayrollID = CASE WHEN #EmpID.EmployeePayrollID = '' THEN '0' ELSE ISNULL(#EmpID.EmployeePayrollID,'0')  END
FROM #Services
LEFT JOIN #EmpID
	ON #EmpID.EmployeeSSID = #Services.EmployeeID


UPDATE #Products
SET #Products.EmployeePayrollID = CASE WHEN #EmpID.EmployeePayrollID = '' THEN '0' ELSE ISNULL(#EmpID.EmployeePayrollID,'0')  END
FROM #Products
LEFT JOIN #EmpID
	ON #EmpID.EmployeeSSID = #Products.EmployeeID


/***************************Final statement for Result Dataset ******************************************************/

-- UNION ALL statement
INSERT INTO #ProdServ
SELECT
	C.CenterTypeDescriptionShort AS 'TYPE'
,	C.MainGroupID
,	C.MainGroup
,	C.CenterNumber
,	C.CenterDescriptionNumber
,	PS.Employee
,	PS.EmployeePayrollID
,	SUM(ISNULL(PS.Retail,0))  AS 'TotalRetail'
,	NULL AS 'TotalServiceClients'
,	SUM(ISNULL(PS.RetailFree,0)) AS 'RetailFree'
,	SUM(ISNULL(PS.Shampoo, 0)) AS 'Shampoo'
,	SUM(ISNULL(PS.SkinCare, 0)) AS 'SkinCare'
,	SUM(ISNULL(PS.Conditioner, 0)) AS 'Conditioner'
,	SUM(ISNULL(PS.Styling, 0)) AS 'Styling'
,	SUM(ISNULL(PS.Adhesives, 0)) AS 'Adhesives'
,	SUM(ISNULL(PS.EXTProd, 0)) AS 'EXTProd'
,	SUM(ISNULL(PS.LaserComb, 0)) AS 'LaserComb'
,	SUM(ISNULL(PS.LaserBand, 0)) AS 'LaserBand'
,	SUM(ISNULL(PS.Capillus, 0)) AS 'Capillus'
,	SUM(ISNULL(PS.Laser, 0)) AS 'Laser'
,	SUM(ISNULL(PS.Kits, 0)) AS 'Kits'
,	SUM(ISNULL(PS.Misc,0)) AS 'Miscellaneous'
,	SUM(ISNULL(PS.Minerva,0)) AS 'Minerva'
,	SUM(ISNULL(PS.SPA,0)) AS 'SPA'
,	SUM(ISNULL(PS.Christine,0)) AS 'Christine'
,	SUM(ISNULL(PS.Halo,0)) AS 'Halo'
,	SUM(ISNULL(PS.Extensions,0)) AS 'Extensions'
,	NULL AS 'Wigs'
FROM #Products PS
    INNER JOIN #Centers	C
		ON PS.CenterNumber = C.CenterNumber
--WHERE PS.Employee <> 'UNKNOWN'
GROUP BY C.CenterTypeDescriptionShort
,	C.MainGroupID
,	C.MainGroup
,	C.CenterNumber
,	C.CenterDescriptionNumber
,	PS.Employee
,	PS.EmployeePayrollID
UNION ALL
SELECT
	C.CenterTypeDescriptionShort AS 'TYPE'
,	C.MainGroupID
,	C.MainGroup
,	C.CenterNumber
,	C.CenterDescriptionNumber
,	S.Employee
,	S.EmployeePayrollID
,	NULL AS 'TotalRetail'
,	SUM(ISNULL(S.ServicesCt,0)) AS 'TotalServiceClients'
,	NULL AS 'RetailFree'
,	NULL AS 'Shampoo'
,   NULL AS 'SkinCare'
,	NULL AS 'Conditioner'
,	NULL AS 'Styling'
,	NULL AS 'Adhesives'
,	NULL AS 'EXTProd'
,	NULL AS 'LaserComb'
,	NULL AS 'LaserBand'
,	NULL AS 'Capillus'
,	NULL AS 'Laser'
,	NULL AS 'Kits'
,	NULL AS 'Miscellaneous'
,	NULL AS 'Minerva'
,	NULL AS 'SPA'
,	NULL AS 'Christine'
,	NULL AS 'Halo'
,	NULL AS 'Extensions'
,	NULL AS 'Wigs'
FROM #Services S
    INNER JOIN #Centers	C
		ON S.CenterNumber = C.CenterNumber
--WHERE S.Employee <> 'UNKNOWN'
GROUP BY C.CenterTypeDescriptionShort
,	C.MainGroupID
,	C.MainGroup
,	C.CenterNumber
,	C.CenterDescriptionNumber
,	S.Employee
,	S.EmployeePayrollID
UNION ALL
SELECT
	C.CenterTypeDescriptionShort AS 'TYPE'
,	C.MainGroupID
,	C.MainGroup
,	C.CenterNumber
,	C.CenterDescriptionNumber
,	#Wigs.Employee
,	#Wigs.EmployeePayrollID
,	NULL AS 'TotalRetail'
,	NULL AS 'TotalServiceClients'
,	NULL AS 'RetailFree'
,	NULL AS 'Shampoo'
,   NULL AS 'SkinCare'
,	NULL AS 'Conditioner'
,	NULL AS 'Styling'
,	NULL AS 'Adhesives'
,	NULL AS 'EXTProd'
,	NULL AS 'LaserComb'
,	NULL AS 'LaserBand'
,	NULL AS 'Capillus'
,	NULL AS 'Laser'
,	NULL AS 'Kits'
,	NULL AS 'Miscellaneous'
,	NULL AS 'Minerva'
,	NULL AS 'SPA'
,	NULL AS 'Christine'
,	NULL AS 'Halo'
,	NULL AS 'Extensions'
,	SUM(ISNULL(#Wigs.ExtendedPrice,0))  AS 'Wigs'
FROM #Wigs
    INNER JOIN #Centers	C
		ON #Wigs.CenterNumber = C.CenterNumber
--WHERE #Wigs.Employee <> 'UNKNOWN'
GROUP BY C.CenterTypeDescriptionShort
,	C.MainGroupID
,	C.MainGroup
,	C.CenterNumber
,	C.CenterDescriptionNumber
,	#Wigs.Employee
,	#Wigs.EmployeePayrollID


/********************* Combine the NULL's to one SUM ***********************/

SELECT [TYPE]
,	MainGroupID
,	MainGroup
,	CenterNumber
,	CenterDescriptionNumber
,	Employee
,	EmployeePayrollID
,	( SUM(ISNULL(TotalRetail,0))
	+	SUM(ISNULL(Wigs,0))
	+	SUM(ISNULL(Laser,0)) )
	AS 'TotalRetail'
,	SUM(ISNULL(TotalServiceClients,0)) AS 'TotalServiceClients'
,	SUM(ISNULL(RetailFree,0)) AS 'RetailFree'
,	SUM(ISNULL(Shampoo,0)) AS 'Shampoo'
,	SUM(ISNULL(SkinCare,0)) AS 'SkinCare'
,	SUM(ISNULL(Conditioner,0)) AS 'Conditioner'
,	SUM(ISNULL(Styling,0)) AS 'Styling'
,	SUM(ISNULL(Adhesives,0)) AS 'Adhesives'
,	SUM(ISNULL(EXTProd,0)) AS 'EXTProd'
,	SUM(ISNULL(LaserComb,0)) AS 'LaserComb'
,	SUM(ISNULL(LaserBand,0)) AS 'LaserBand'
,	SUM(ISNULL(Capillus,0)) AS 'Capillus'
,	SUM(ISNULL(Laser,0)) AS 'Laser'
,	SUM(ISNULL(Kits,0)) AS 'Kits'
,	SUM(ISNULL(Miscellaneous,0)) - SUM(ISNULL(Christine,0)) AS 'Miscellaneous' --Remove Christine here
,	SUM(ISNULL(Minerva,0)) AS 'Minerva'
,	SUM(ISNULL(SPA,0)) AS 'SPA'
,	SUM(ISNULL(Christine,0)) AS 'Christine'
,	SUM(ISNULL(Halo,0)) AS 'Halo'
,	SUM(ISNULL(Extensions,0)) AS 'Extensions'
,	SUM(ISNULL(Wigs,0)) AS 'Wigs'
,	SUM(ISNULL(Laser,0)) AS 'TotalLaser'
,	(  SUM(ISNULL(TotalRetail,0))+ SUM(ISNULL(Wigs,0)) ) AS 'RetailMinusLaser'
FROM #ProdServ
GROUP BY [TYPE]
       , MainGroupID
       , MainGroup
       , CenterNumber
       , CenterDescriptionNumber
       , Employee
       , EmployeePayrollID

END
