/* CreateDate: 11/18/2016 17:02:21.473 , ModifyDate: 12/15/2020 15:36:53.987 */
GO
/*******************************************************************************************************

PROCEDURE:				[spRpt_RetailFlashDepartmentDetail]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE:	HC_BI_CMS_DDS

RELATED APPLICATION:	Retail Flash - sub report for Totals - Area/ Region and Grand Total

AUTHOR:					Rachelen Hut

IMPLEMENTOR:			Rachelen Hut

DATE IMPLEMENTED:		11/18/2016

--------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
06/23/2017 - RH - (#140509) Removed DSC.SalesCodeDescriptionShort in ('HM3V5','EXTLH','HM3V5N','EXTLB') as these are already included
04/19/2018 - RH - (#145957) Changed the Center queries to join on CenterTypeKey
05/15/2018 - RH - (#149717) Changed query to find Laser Products based on the Department 3065, and added code to find 'Capillus'
08/01/2019 - RH - (#12346) Added WigsRevenue - remove tender type of InterCo to exclude employees
01/31/2020 - RH - (TrackIT 6360) Added Minerva, Halo, SPA, Extensions as separate units
12/15/2020 - AP -  (TFS 14732) Add skincare department
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:
[spRpt_RetailFlashDepartmentDetail]0, 101, '1/1/2020', '1/31/2020', 3064
[spRpt_RetailFlashDepartmentDetail]0, 101, '2/1/2020', '2/4/2020', 3070
[spRpt_RetailFlashDepartmentDetail]0, 102, '1/1/2020', '1/31/2020', 3010
*********************************************************************************************************/


CREATE PROCEDURE [dbo].[spRpt_RetailFlashDepartmentDetail] (
	@Filter INT
,	@MainGroupID INT
,	@begdt DATETIME
,	@enddt DATETIME
,	@Department INT

) AS
	SET NOCOUNT ON

BEGIN


/* These are just assignments within this stored procedure for the variable @Department, not necessarily actual departments
3010 - Adhesives/Adhesive Removers
3030 - Shampoos
3040 - Conditioners
3050 - Styling Aids
3070 - Kits
3080 - MISC minus Minerva, SPA, Christine, Halo and Extensions
3061 - EXT Products minus Laser products as EXT products
3062 - Laser Comb
3063 - Laser Helmet
3064 - Laser Band
3065 - Capillus
3081 = Minerva
3082 = SPA
3083 = Christine
3084 = Halo
3085 = Extensions
3045 = SkinCare
*/


CREATE TABLE #Centers(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterKey INT
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
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	SalesCodeDivisionSSID INT
,	SalesCodeDivisionDescription NVARCHAR(150)
,	SalesCodeDepartmentSSID INT
,	SalesCodeDepartmentDescription NVARCHAR(150)
,	Department NVARCHAR(150)
,	SalesCodeSSID INT
,	SalesCodeDescriptionShort  NVARCHAR(50)
,	SalesCodeDescription  NVARCHAR(50)
,	Code NVARCHAR(150)
,	BrandID INT
,	TenderTypeDescriptionShort NVARCHAR(50)
,	Quantity INT
,	Discount DECIMAL(18,4)
,	Price DECIMAL(18,4)
,	ExtendedPrice DECIMAL(18,4)
,	DiscountPercent DECIMAL(12,4)
,	TaxTotal DECIMAL(18,4)
,	Total DECIMAL(18,4)
)

CREATE TABLE #RetailSum(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	SalesCodeDivisionSSID INT
,	SalesCodeDivisionDescription NVARCHAR(150)
,	SalesCodeDepartmentSSID INT
,	SalesCodeDepartmentDescription NVARCHAR(150)
,	Department NVARCHAR(150)
,	SalesCodeSSID INT
,	SalesCodeDescriptionShort  NVARCHAR(50)
,	SalesCodeDescription  NVARCHAR(50)
,	Code NVARCHAR(150)
,	BrandID INT
,	TenderTypeDescriptionShort NVARCHAR(50)
,	Quantity INT
,	Discount DECIMAL(18,4)
,	Price DECIMAL(18,4)
,	ExtendedPrice DECIMAL(18,4)
,	DiscountPercent DECIMAL(12,4)
,	TaxTotal DECIMAL(18,4)
,	Total DECIMAL(18,4)
)

CREATE TABLE #FinalSum(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	SalesCodeDivisionSSID INT
,	SalesCodeDivisionDescription NVARCHAR(150)
,	SalesCodeDepartmentSSID INT
,	SalesCodeDepartmentDescription NVARCHAR(150)
,	Department NVARCHAR(150)
,	SalesCodeSSID INT
,	SalesCodeDescriptionShort  NVARCHAR(50)
,	SalesCodeDescription  NVARCHAR(50)
,	Code NVARCHAR(150)
,	BrandID INT
,	TenderTypeDescriptionShort NVARCHAR(50)
,	Quantity INT
,	Discount DECIMAL(18,4)
,	Price DECIMAL(18,4)
,	ExtendedPrice DECIMAL(18,4)
,	DiscountPercent DECIMAL(12,4)
,	TaxTotal DECIMAL(18,4)
,	Total DECIMAL(18,4)
)

/**************** Populate #Centers **********************************************/

IF @MainGroupID = 101  --All Corporate (Grand Total)
BEGIN
	INSERT  INTO #Centers
	SELECT  101 AS 'MainGroupID'
	,		'All Corporate' AS 'MainGroup'
	,		CenterKey
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
				ON DC.CenterTypeKey = DCT.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
                ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
	WHERE	DCT.CenterTypeDescriptionShort = 'C'
			AND DC.Active = 'Y'
END
ELSE
IF @MainGroupID = 102  --All Franchise (Grand Total)
BEGIN
	INSERT  INTO #Centers
	SELECT  102 AS 'MainGroupID'
	,		'All Franchise' AS 'MainGroup'
	,		CenterKey
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
				ON DC.CenterTypeKey = DCT.CenterTypeKey
	WHERE	DCT.CenterTypeDescriptionShort IN ('F','JV')
			AND DC.Active = 'Y'
END


/********************** For @Department 3061,3062,3063,3064,3065 *********************************
3061 - EXT Products minus Laser products as EXT products
3062 - Laser Comb
3063 - Laser Helmet
3064 - Laser Band
3065 - Capillus
*/
IF @Department IN(3061,3062,3063,3064,3065)
BEGIN
/******************* Find SalesCodeSSID's for Laser Products ***************************************/

INSERT INTO #LaserProducts
SELECT DSC.SalesCodeKey
,	DSC.SalesCodeSSID
,	DSC.SalesCodeDescription
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
inner join HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment  DSCD
	on DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
where DSCD.SalesCodeDivisionSSID = 30    --Products
and DSCD.SalesCodeDepartmentSSID = 3065

/************************ Main select statement ***************************************************/
INSERT INTO #RetailSum
SELECT 	q.MainGroupID
,	q.MainGroup
,	q.SalesCodeDivisionSSID
,	q.SalesCodeDivisionDescription
,	q.SalesCodeDepartmentSSID
,	q.SalesCodeDepartmentDescription
,	CAST(q.SalesCodeDepartmentSSID AS VARCHAR) + ' - ' + q.SalesCodeDepartmentDescription AS 'Department'
,	q.SalesCodeSSID
,	q.SalesCodeDescriptionShort
,	q.SalesCodeDescription
,	q.SalesCodeDescriptionShort + ' - ' + q.SalesCodeDescription AS 'Code'
,	0 AS BrandID
,	NULL AS TenderTypeDescriptionShort
,	SUM(q.Quantity) AS Quantity
,	SUM(q.Discount) AS 'Discount'
,	SUM(q.Price) AS 'Price'
,	SUM(q.ExtendedPrice) AS 'ExtendedPrice'
,	CASE WHEN SUM(q.Quantity)=0 THEN 0 ELSE dbo.DIVIDE_DECIMAL( (SUM(q.Discount)/SUM(q.Quantity)), SUM(q.ExtendedPrice)) END AS 'DiscountPercent'
,	SUM(TaxTotal) AS 'TaxTotal'
,	SUM(Total) AS 'Total'
FROM(
		SELECT #Centers.MainGroupID
		,	#Centers.MainGroup
		,	DSCDiv.SalesCodeDivisionSSID
		,	DSCDiv.SalesCodeDivisionDescription
		,	DSC.SalesCodeDepartmentSSID
		,	DSCD.SalesCodeDepartmentDescription
		,	DSC.SalesCodeSSID
		,	DSC.SalesCodeDescriptionShort
		,	DSC.SalesCodeDescription
		,	NULL AS BrandID
		,	NULL AS TenderTypeDescriptionShort
		,	ISNULL(FST.Quantity,0) AS 'Quantity'
		,	ISNULL(FST.Discount,0) AS 'Discount'
		,	CASE WHEN @Department = 3061 THEN ISNULL(FST.RetailAmt,0) ELSE ISNULL(FST.PCP_LaserAmt,0) END AS 'Price'
		,	CASE WHEN @Department = 3061 THEN ISNULL(FST.RetailAmt,0) ELSE ISNULL(FST.PCP_LaserAmt,0) END AS 'ExtendedPrice'
		,	ISNULL(FST.TotalTaxAmount,0) AS 'TaxTotal'
		,	CASE WHEN @Department = 3061 THEN (ISNULL(FST.RetailAmt,0) + ISNULL(FST.TotalTaxAmount,0)) ELSE (ISNULL(FST.PCP_LaserAmt,0) + ISNULL(FST.TotalTaxAmount,0)) END AS 'Total'
		FROM HC_BI_CMS_DDS.BI_CMS_DDS.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail DSOD
				ON FST.salesorderdetailkey = DSOD.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON FST.MembershipKey = M.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrder DSO
				ON FST.salesorderkey = DSO.SalesOrderKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = C.CenterKey
			INNER JOIN #Centers
				ON C.CenterKey = #Centers.CenterKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode DSC
				ON FST.SalesCodeKey = DSC.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
				ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision DSCDiv
				ON DSCD.SalesCodeDivisionKey = DSCDiv.SalesCodeDivisionKey
		WHERE 	DSCD.SalesCodeDivisionSSID = 30
			AND DD.FullDate BETWEEN @begdt AND @enddt
			AND DSO.IsVoidedFlag = 0
			AND M.MembershipDescription NOT LIKE 'Employee%'
			AND DSCD.SalesCodeDepartmentSSID <> 7052  --Remove wigs
	)q
GROUP BY MainGroupID
,	MainGroup
,	q.SalesCodeDivisionSSID
,	q.SalesCodeDivisionDescription
,	q.SalesCodeDepartmentSSID
,	q.SalesCodeDepartmentDescription
,	q.SalesCodeSSID
,	q.SalesCodeDescriptionShort
,	q.SalesCodeDescription

IF @Department = 3061														--EXT Products minus Laser
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3060)
	AND	SalesCodeSSID NOT IN (SELECT SalesCodeSSID FROM #LaserProducts)
END

ELSE IF @Department = 3062													--Laser Comb
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3065)
	AND	SalesCodeSSID IN (SELECT SalesCodeSSID FROM #LaserProducts)
	AND SalesCodeDescription LIKE '%LaserComb%'
END

ELSE IF @Department = 3063													--Laser Helmet
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3065)
	AND	SalesCodeSSID IN (SELECT SalesCodeSSID FROM #LaserProducts)
	AND SalesCodeDescription LIKE '%LaserHelmet%'
END

ELSE IF @Department = 3064													--Laser Band
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3065)
	AND	SalesCodeSSID IN (SELECT SalesCodeSSID FROM #LaserProducts)
	AND SalesCodeDescription LIKE '%LaserBand%'
END

ELSE IF @Department = 3065													--Capillus
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3065)
	AND	SalesCodeSSID IN (SELECT SalesCodeSSID FROM #LaserProducts)
	AND SalesCodeDescription LIKE '%Capillus%'
END

ELSE IF @Department = 3045													--SkinCare
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3045)
	AND	SalesCodeSSID IN (SELECT SalesCodeSSID FROM #LaserProducts)
	AND SalesCodeDescription LIKE '%SkinCare%'
END


SELECT * FROM #FinalSum

END
/***************************For Wigs *****************************************************************************/

ELSE IF @Department = 7052													--Wigs
BEGIN

/************ First find the wig sales not related to employee sales - join on Tender Type to remove Interco ******/

INSERT INTO #Wigs
SELECT 	q.MainGroupID
,	q.MainGroup
,	q.SalesCodeDivisionSSID
,	q.SalesCodeDivisionDescription
,	q.SalesCodeDepartmentSSID
,	q.SalesCodeDepartmentDescription
,	CAST(q.SalesCodeDepartmentSSID AS VARCHAR) + ' - ' + q.SalesCodeDepartmentDescription AS 'Department'
,	q.SalesCodeSSID
,	q.SalesCodeDescriptionShort
,	q.SalesCodeDescription
,	q.SalesCodeDescriptionShort + ' - ' + q.SalesCodeDescription AS 'Code'
,	0 AS BrandID
,	NULL AS TenderTypeDescriptionShort
,	SUM(q.Quantity) AS Quantity
,	SUM(q.Discount) AS 'Discount'
,	SUM(q.RetailAmt) AS 'Price'
,	SUM(q.RetailAmt) AS ExtendedPrice
,	CASE WHEN SUM(q.Quantity)=0 THEN 0 ELSE dbo.DIVIDE_DECIMAL( (SUM(q.Discount)/SUM(q.Quantity)), SUM(q.RetailAmt)) END AS 'DiscountPercent'
,	SUM(TaxTotal) AS 'TaxTotal'
,	SUM(Total) AS 'Total'
FROM(
		SELECT #Centers.MainGroupID
		,	#Centers.MainGroup
		,	DSCDiv.SalesCodeDivisionSSID
		,	DSCDiv.SalesCodeDivisionDescription
		,	DSC.SalesCodeDepartmentSSID
		,	DSCD.SalesCodeDepartmentDescription
		,	DSC.SalesCodeSSID
		,	DSC.SalesCodeDescriptionShort
		,	DSC.SalesCodeDescription
		,	NULL AS BrandID
		,	NULL AS TenderTypeDescriptionShort
		,	ISNULL(FST.Quantity,0) AS 'Quantity'
		,	ISNULL(FST.Discount,0) AS 'Discount'
		,	ISNULL(FST.RetailAmt,0) AS 'Price'
		,	ISNULL(FST.RetailAmt,0) AS 'RetailAmt'
		,	ISNULL(FST.TotalTaxAmount,0) AS 'TaxTotal'
		,	ISNULL(FST.ExtendedPricePlusTax,0) AS 'Total'
		FROM HC_BI_CMS_DDS.BI_CMS_DDS.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail DSOD
				ON FST.salesorderdetailkey = DSOD.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON FST.MembershipKey = M.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrder DSO
				ON FST.salesorderkey = DSO.SalesOrderKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = C.CenterKey
			INNER JOIN #Centers
				ON C.CenterKey = #Centers.CenterKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode DSC
				ON FST.SalesCodeKey = DSC.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
				ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision DSCDiv
				ON DSCD.SalesCodeDivisionKey = DSCDiv.SalesCodeDivisionKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender DSOT
				ON DSOT.SalesOrderKey = FST.SalesOrderKey
		WHERE DSCD.SalesCodeDepartmentSSID = 7052  --Wigs
			AND DD.FullDate BETWEEN @begdt AND @enddt
			AND DSO.IsVoidedFlag = 0
			AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
			AND M.MembershipDescription NOT LIKE 'Employee%'
	)q
GROUP BY 	q.MainGroupID
	,	q.MainGroup
    ,	q.SalesCodeDescriptionShort
	,	q.SalesCodeDescription
    ,	q.SalesCodeDivisionSSID
    ,	q.SalesCodeDivisionDescription
    ,	q.SalesCodeDepartmentSSID
    ,	q.SalesCodeDepartmentDescription
    ,	q.SalesCodeSSID





INSERT INTO #FinalSum
SELECT * FROM #Wigs


SELECT * FROM #FinalSum

END

ELSE
BEGIN

/***************************For all other departments *****************************************/

/********************************* Get Christine Sales Codes **********************************/
INSERT INTO #Christine
              SELECT sc.SalesCodeID
              ,             sc.SalesCodeDescription
              ,             sc.SalesCodeDescriptionShort
			  ,				sc.BrandID
              FROM   SQL05.HairClubCMS.dbo.cfgSalesCode sc
              WHERE  sc.BrandID = 20 -- Christine Headwear

/********************************** Get sales data *******************************************/

INSERT INTO #RetailSum
SELECT 	q.MainGroupID
,	q.MainGroup
,	q.SalesCodeDivisionSSID
,	q.SalesCodeDivisionDescription
,	q.SalesCodeDepartmentSSID
,	q.SalesCodeDepartmentDescription
,	CAST(q.SalesCodeDepartmentSSID AS VARCHAR) + ' - ' + q.SalesCodeDepartmentDescription AS 'Department'
,	q.SalesCodeSSID
,	q.SalesCodeDescriptionShort
,	q.SalesCodeDescription
,	q.SalesCodeDescriptionShort + ' - ' + q.SalesCodeDescription AS 'Code'
,	q.BrandID
,	NULL AS TenderTypeDescriptionShort
,	SUM(q.Quantity) AS Quantity
,	SUM(q.Discount) AS 'Discount'
,	SUM(q.RetailAmt) AS 'Price'
,	SUM(q.RetailAmt) AS ExtendedPrice
,	CASE WHEN SUM(q.Quantity)=0 THEN 0 ELSE dbo.DIVIDE_DECIMAL( (SUM(q.Discount)/SUM(q.Quantity)), SUM(q.RetailAmt)) END AS 'DiscountPercent'
,	SUM(TaxTotal) AS 'TaxTotal'
,	SUM(Total) AS 'Total'
FROM(
		SELECT #Centers.MainGroupID
		,	#Centers.MainGroup
		,	DSCDiv.SalesCodeDivisionSSID
		,	DSCDiv.SalesCodeDivisionDescription
		,	DSC.SalesCodeDepartmentSSID
		,	DSCD.SalesCodeDepartmentDescription
		,	DSC.SalesCodeSSID
		,	DSC.SalesCodeDescriptionShort
		,	DSC.SalesCodeDescription
		,	CASE WHEN CHR.BrandID = 20 THEN 20 ELSE 0 END AS BrandID
		,	NULL AS TenderTypeDescriptionShort
		,	ISNULL(FST.Quantity,0) AS 'Quantity'
		,	ISNULL(FST.Discount,0) AS 'Discount'
		,	ISNULL(FST.RetailAmt,0) AS 'Price'
		,	ISNULL(FST.RetailAmt,0) AS 'RetailAmt'
		,	ISNULL(FST.TotalTaxAmount,0) AS 'TaxTotal'
		,	ISNULL(FST.ExtendedPricePlusTax,0) AS 'Total'
		FROM HC_BI_CMS_DDS.BI_CMS_DDS.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail DSOD
				ON FST.salesorderdetailkey = DSOD.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON FST.MembershipKey = M.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrder DSO
				ON FST.salesorderkey = DSO.SalesOrderKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = C.CenterKey
			INNER JOIN #Centers
				ON C.CenterKey = #Centers.CenterKey
			INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode DSC
				ON FST.SalesCodeKey = DSC.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
				ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision DSCDiv
				ON DSCD.SalesCodeDivisionKey = DSCDiv.SalesCodeDivisionKey
			LEFT JOIN #Christine CHR
				ON CHR.SalesCodeDescriptionShort = DSOD.SalesCodeDescriptionShort
		WHERE 	DSCD.SalesCodeDivisionSSID = 30
			AND DD.FullDate BETWEEN @begdt AND @enddt
			AND DSO.IsVoidedFlag = 0
			AND M.MembershipDescription NOT LIKE 'Employee%'
	)q
GROUP BY q.MainGroupID
,	q.MainGroup
,	q.SalesCodeDivisionSSID
,	q.SalesCodeDivisionDescription
,	q.SalesCodeDepartmentSSID
,	q.SalesCodeDepartmentDescription
,	q.SalesCodeSSID
,	q.SalesCodeDescriptionShort
,	q.SalesCodeDescription
,	q.BrandID



/*********** Populate #FinalSum according to @Department **********************************/

IF @Department = 3010														--Adhesives
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3010,3020)
END

IF @Department = 3030														--Shampoos
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3030)
END

IF @Department = 3045														--SkinCare
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3045)
END


IF @Department = 3040														--Conditioners
BEGIN
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3040)
END

IF @Department = 3050														--Styling Aids
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3050)


IF @Department = 3070														--Kits
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3070)

IF @Department = 3080														--MISC minus Minerva, SPA, Christine, Halo and Extensions
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDepartmentSSID in (3080)
AND SalesCodeDescriptionShort NOT IN ('480-115','480-116','HALO2LINES', 'HALO5LINES', 'HALO20','TAPEPACK')
AND SalesCodeSSID NOT IN(SELECT SalesCodeID FROM #Christine)



ELSE IF @Department = 7052													--Wigs
INSERT INTO #FinalSum
SELECT * FROM #Wigs


ELSE IF @Department = 3081													--Minerva
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDescriptionShort = '480-115'

ELSE IF @Department = 3082													--SPA
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDescriptionShort = '480-116'


ELSE IF @Department = 3083													--Christine
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE BrandID = 20



ELSE IF @Department = 3084													--Halo
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' )


ELSE IF @Department = 3085													--Extensions
INSERT INTO #FinalSum
SELECT * FROM #RetailSum
WHERE SalesCodeDescriptionShort = 'TAPEPACK'




SELECT * FROM #FinalSum

END

END
GO
