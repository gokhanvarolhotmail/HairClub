/***********************************************************************
PROCEDURE:				sprpt_RetailFlashByProductType
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_CMS_DDS
RELATED APPLICATION:	Retail Flash - sub report
AUTHOR:					Mauricio Hurtado
IMPLEMENTOR:			Mauricio Hurtado
DATE IMPLEMENTED:		1/15/2020
LAST REVISION DATE:
------------------------------------------------------------------------

CHANGE HISTORY:


--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:

EXEC [sprpt_RetailFlashByProductType] 'C','1/1/2020','1/31/2020'

EXEC [sprpt_RetailFlashByProductType] 'F','1/1/2020','1/31/2020'

--***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_RetailFlashByProductType]
(
	@sType CHAR (1)
,	@CurrentPeriodStartDate DATETIME
,	@CurrentPeriodEndDate DATETIME
)

AS
BEGIN


DECLARE
	@StartDate DATETIME
,	@EndDate DATETIME


SET @StartDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, @CurrentPeriodStartDate), 0)
SET @EndDate = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @StartDate), 0)))


PRINT '@CurrentPeriodStartDate = ' + CAST(@CurrentPeriodStartDate AS NVARCHAR(12))
PRINT '@CurrentPeriodEndDate = ' + CAST(@CurrentPeriodEndDate AS NVARCHAR(12))
PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(12))
PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(12))


/********************************** Create temp table objects *************************************/

CREATE TABLE #Center (
       MainGroupID INT
,      MainGroup NVARCHAR(50)
,      AreaDescription NVARCHAR(100)
,      CenterNumber INT
,	   CenterKey INT
,      CenterDescriptionNumber NVARCHAR(103)
,      CenterTypeDescriptionShort NVARCHAR(2)
)


CREATE TABLE #SalesCode (
	SalesCodeID INT
,	SalesCodeDescription NVARCHAR(50)
,	SalesCodeDescriptionShort NVARCHAR(15)
,	BrandID INT
)


CREATE TABLE #YTDWigs(
	MainGroup NVARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
,	[Period] NVARCHAR(10)
,	YTDWigs DECIMAL(18,4)
)


CREATE TABLE #CurrentWigs(
	MainGroup NVARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
,	[Period] NVARCHAR(10)
,	CurrentWigs DECIMAL(18,4)
)


CREATE TABLE #YTD(
	MainGroup NVARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
,	[Period] NVARCHAR(10)
,	YTDMinerva DECIMAL(18,4)
,	YTDSPA DECIMAL(18,4)
,	YTDChristine DECIMAL(18,4)
,	YTDHalo DECIMAL(18,4)
,	YTDExtensions DECIMAL(18,4)
,	StartDate DATETIME
,	EndDate DATETIME
)


CREATE TABLE #Current(AreaDescription NVARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
,	[Period] NVARCHAR(12)
,	Minerva DECIMAL(18,4)
,	SPA DECIMAL(18,4)
,	Christine DECIMAL(18,4)
,	Halo DECIMAL(18,4)
,	Extensions DECIMAL(18,4)
, 	CurrentStartDate DATETIME
,   CurrentEndDate DATETIME
)


CREATE TABLE #Final(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
,	YTDMinerva DECIMAL(18,4)
,	YTDSPA DECIMAL(18,4)
,	YTDChristine DECIMAL(18,4)
,	YTDHalo DECIMAL(18,4)
,	YTDExtensions DECIMAL(18,4)
,	YTDWigs DECIMAL(18,4)
,	Minerva DECIMAL(18,4)
,	SPA DECIMAL(18,4)
,	Christine DECIMAL(18,4)
,	Halo DECIMAL(18,4)
,	Extensions DECIMAL(18,4)
,	Wigs DECIMAL(18,4)
)


/********************************** Get list of centers *******************************************/
IF @sType = 'C'
       BEGIN
              INSERT  INTO #Center
                           SELECT  cma.CenterManagementAreaSSID AS 'MainGroupID'
                           ,             cma.CenterManagementAreaDescription AS 'MainGroup'
                           ,             ISNULL(cma.CenterManagementAreaDescription, '') AS 'AreaDescription'
                           ,             ctr.CenterNumber
						   ,			 ctr.CenterKey
                           ,             ctr.CenterDescriptionNumber
                           ,             ct.CenterTypeDescriptionShort
                           FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
                                         INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
                                                ON ct.CenterTypeKey = ctr.CenterTypeKey
                                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
                                                ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
                           WHERE   ct.CenterTypeDescriptionShort = 'C'
                                         AND ctr.Active = 'Y'
       END


IF @sType = 'F'
       BEGIN
              INSERT  INTO #Center
                           SELECT  r.RegionSSID AS 'MainGroupID'
                           ,             r.RegionDescription  AS 'MainGroup'
                           ,             '' AS 'AreaDescription'
                           ,             ctr.CenterNumber
						   ,			 ctr.CenterKey
                           ,             ctr.CenterDescriptionNumber
                           ,             ct.CenterTypeDescriptionShort
                           FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
                                         INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
                                                ON ct.CenterTypeKey = ctr.CenterTypeKey
                                         INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
                                                ON r.RegionKey = ctr.RegionKey
                           WHERE   ct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
                                         AND ctr.Active = 'Y'
       END


CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );



UPDATE STATISTICS #Center;


-- Get Sales Codes
INSERT INTO #SalesCode
              SELECT sc.SalesCodeID
              ,             sc.SalesCodeDescription
              ,             sc.SalesCodeDescriptionShort
			  ,				sc.BrandID
              FROM   SQL05.HairClubCMS.dbo.cfgSalesCode sc
              WHERE  ( sc.SalesCodeDescriptionShort IN ( '480-115', '480-116', 'HALO2LINES', 'HALO5LINES', 'HALO20', 'TAPEPACK' ) -- Minerva, SPA Devices, Halo, Extensions
                                  OR sc.BrandID = 20 -- Christine Headwear
                     )


/************ First find the wig sales not related to employee sales - join on Tender Type to remove Interco ******/

INSERT INTO #YTDWigs
SELECT c.MainGroup
,     c.CenterNumber
,     c.CenterDescriptionNumber
,     c.CenterTypeDescriptionShort
,     'YTD' AS 'Period'
,	  SUM(ISNULL(FST.ExtendedPrice,0)) AS 'YTDWigs'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON DD.DateKey = FST.OrderDateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
		ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
		ON FST.salesorderkey = so.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
		ON FST.ClientKey = cl.ClientKey
	INNER JOIN #Center c
		ON FST.CenterKey = c.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
		ON FST.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
		ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership clm
		ON FST.ClientMembershipKey = clm.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mem
		ON clm.MembershipKey = mem.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender DSOT
		ON	FST.SalesOrderKey = DSOT.SalesOrderKey
WHERE scd.SalesCodeDepartmentSSID = 7052  --Wigs
	AND DD.FullDate BETWEEN @StartDate AND @EndDate
	AND so.IsVoidedFlag = 0
	AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
	AND mem.MembershipDescription NOT LIKE 'Employee%'
GROUP BY c.MainGroup
,     c.CenterNumber
,     c.CenterDescriptionNumber
,     c.CenterTypeDescriptionShort



INSERT INTO #CurrentWigs
SELECT 	c.MainGroup
,     c.CenterNumber
,     c.CenterDescriptionNumber
,     c.CenterTypeDescriptionShort
,     'Current' AS 'Period'
,	  SUM(ISNULL(FST.ExtendedPrice,0)) AS 'CurrentWigs'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON DD.DateKey = FST.OrderDateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
		ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
		ON FST.salesorderkey = so.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
		ON FST.clientkey = cl.ClientKey
	INNER JOIN #Center c
		ON FST.CenterKey = c.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
		ON FST.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
		ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership clm
		ON FST.ClientMembershipKey = clm.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mem
		ON clm.MembershipKey = mem.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender DSOT
		ON	FST.SalesOrderKey = DSOT.SalesOrderKey
WHERE scd.SalesCodeDepartmentSSID = 7052  --Wigs
	AND DD.FullDate BETWEEN @CurrentPeriodStartDate AND @CurrentPeriodEndDate
	AND so.IsVoidedFlag = 0
	AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
	AND mem.MembershipDescription NOT LIKE 'Employee%'
GROUP BY c.MainGroup
,     c.CenterNumber
,     c.CenterDescriptionNumber
,     c.CenterTypeDescriptionShort


/************ Get Data for YTD other than Wigs *****************************************************************************************************/

INSERT INTO #YTD
SELECT c.MainGroup
,     c.CenterNumber
,     c.CenterDescriptionNumber
,     c.CenterTypeDescriptionShort
,     'YTD' AS 'Period'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort = '480-115' THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'YTDMinerva'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort = '480-116' THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'YTDSPA'
,     SUM(CASE WHEN s.BrandID = 20 THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'YTDChristine'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'YTDHalo'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort = 'TAPEPACK' THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'YTDExtensions'
,	  @StartDate AS StartDate
,	  @EndDate AS EndDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
            ON dd.DateKey = fst.OrderDateKey
        INNER JOIN #Center c
            ON fst.CenterKey = c.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
            ON fst.SalesCodeKey = sc.SalesCodeKey
        INNER JOIN #SalesCode s
                ON s.SalesCodeDescriptionShort = sc.SalesCodeDescriptionShort
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
            ON fst.SalesOrderKey = so.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
        AND so.IsVoidedFlag = 0
		AND M.MembershipDescription NOT LIKE 'Employee%'
GROUP BY c.MainGroup
,             c.CenterNumber
,             c.CenterDescriptionNumber
,             c.CenterTypeDescriptionShort



-- Find Current month

INSERT INTO #Current
SELECT c.AreaDescription
,     c.CenterNumber
,     c.CenterDescriptionNumber
,     c.CenterTypeDescriptionShort
,     'CurrentMonth' AS 'Period'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort = '480-115' THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'Minerva'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort = '480-116' THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'SPA'
,     SUM(CASE WHEN s.BrandID = 20 THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'Christine'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'Halo'
,     SUM(CASE WHEN sc.SalesCodeDescriptionShort = 'TAPEPACK' THEN ISNULL(fst.ExtendedPrice,0) ELSE 0 END) AS 'Extensions'
,	  @CurrentPeriodStartDate AS CurrentStartDate
,	  @CurrentPeriodEndDate AS CurrentEndDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
            ON dd.DateKey = fst.OrderDateKey
        INNER JOIN #Center c
            ON fst.CenterKey = c.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
            ON sc.SalesCodeKey = fst.SalesCodeKey
        INNER JOIN #SalesCode s
                ON s.SalesCodeDescriptionShort = sc.SalesCodeDescriptionShort
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
            ON so.SalesOrderKey = fst.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
WHERE   dd.FullDate BETWEEN @CurrentPeriodStartDate AND @CurrentPeriodEndDate
        AND so.IsVoidedFlag = 0
		AND M.MembershipDescription NOT LIKE 'Employee%'
GROUP BY c.AreaDescription
,             c.CenterNumber
,             c.CenterDescriptionNumber
,             c.CenterTypeDescriptionShort


/************* Final select - combine tables ***************************************/

INSERT INTO #Final
SELECT C.MainGroupID
,       C.MainGroup
,       C.CenterNumber
,       C.CenterDescriptionNumber
,       C.CenterTypeDescriptionShort
,       SUM(#YTD.YTDMinerva) AS YTDMinerva
,       SUM(#YTD.YTDSPA) AS YTDSPA
,       SUM(#YTD.YTDChristine) AS YTDChristine
,       SUM(#YTD.YTDHalo) AS YTDHalo
,       SUM(#YTD.YTDExtensions) AS YTDExtensions
,       SUM(YTDW.YTDWigs) AS YTDWigs
,       NULL AS Minerva
,       NULL AS SPA
,       NULL AS Christine
,       NULL AS Halo
,       NULL AS Extensions
,       SUM(CW.CurrentWigs) AS Wigs
FROM #Center C
LEFT JOIN #YTDWigs YTDW
	ON YTDW.CenterNumber = C.CenterNumber
LEFT JOIN #CurrentWigs CW
	ON CW.CenterNumber = C.CenterNumber
LEFT JOIN #YTD
	ON #YTD.CenterNumber = C.CenterNumber
GROUP BY C.MainGroupID
,       C.MainGroup
,       C.CenterNumber
,       C.CenterDescriptionNumber
,       C.CenterTypeDescriptionShort


/******************* Update values for Minerva, SPA, Halo, Extensions *************/

UPDATE F
SET F.Minerva = ISNULL(CURR.Minerva,0)
FROM #Final F
INNER JOIN #Current CURR
	ON F.CenterNumber = CURR.CenterNumber
WHERE (F.Minerva IS NULL OR F.Minerva = 0)

UPDATE F
SET F.SPA = ISNULL(CURR.SPA,0)
FROM #Final F
INNER JOIN #Current CURR
	ON F.CenterNumber = CURR.CenterNumber
WHERE (F.SPA IS NULL OR F.SPA = 0)

UPDATE F
SET F.Christine = ISNULL(CURR.Christine,0)
FROM #Final F
INNER JOIN #Current CURR
	ON F.CenterNumber = CURR.CenterNumber
WHERE (F.Christine IS NULL OR F.Christine = 0)

UPDATE F
SET F.Halo = ISNULL(CURR.Halo,0)
FROM #Final F
INNER JOIN #Current CURR
	ON F.CenterNumber = CURR.CenterNumber
WHERE (F.Halo IS NULL OR F.Halo = 0)

UPDATE F
SET F.Extensions = ISNULL(CURR.Extensions,0)
FROM #Final F
INNER JOIN #Current CURR
	ON F.CenterNumber = CURR.CenterNumber
WHERE (F.Extensions IS NULL OR F.Extensions = 0)


/************** Set NULLs to zero **********************************/

UPDATE #Final
SET YTDMinerva = '0.00'
WHERE YTDMinerva IS NULL

UPDATE #Final
SET YTDSPA = '0.00'
WHERE YTDSPA IS NULL

UPDATE #Final
SET YTDChristine = '0.00'
WHERE YTDChristine IS NULL

UPDATE #Final
SET YTDHalo = '0.00'
WHERE YTDHalo IS NULL

UPDATE #Final
SET YTDExtensions = '0.00'
WHERE YTDExtensions IS NULL

UPDATE #Final
SET YTDWigs = '0.00'
WHERE YTDWigs IS NULL


UPDATE #Final
SET Minerva = '0.00'
WHERE Minerva IS NULL

UPDATE #Final
SET SPA = '0.00'
WHERE SPA IS NULL

UPDATE #Final
SET Christine = '0.00'
WHERE Christine IS NULL

UPDATE #Final
SET Halo = '0.00'
WHERE Halo IS NULL

UPDATE #Final
SET Extensions = '0.00'
WHERE Extensions IS NULL

UPDATE #Final
SET Wigs = '0.00'
WHERE Wigs IS NULL




SELECT  MainGroupID
,        MainGroup
,        CenterNumber
,        CenterDescriptionNumber
,        CenterTypeDescriptionShort
,        YTDMinerva
,        YTDSPA
,        YTDChristine
,        YTDHalo
,        YTDExtensions
,        YTDWigs
,        Minerva
,        SPA
,        Christine
,        Halo
,        Extensions
,        Wigs
FROM #Final


END
