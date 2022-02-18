/* CreateDate: 04/20/2015 15:00:58.603 , ModifyDate: 08/20/2018 14:55:45.620 */
GO
/***********************************************************************
PROCEDURE:				spRpt_SalesAnalysis
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/20/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_SalesAnalysis 2, 100, '7/18/2018', '8/18/2018', '7/20/2017', '8/20/2017'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SalesAnalysis]
(
	@CenterType INT
,	@CenterSSID INT = NULL
,	@CurrentStartDate DATETIME
,	@CurrentEndDate DATETIME
,	@PriorStartDate DATETIME
,	@PriorEndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @ReportHeading VARCHAR(103)


/*

@CenterType

- Specific Center = 1
- All Corporate = 2
- All Franchise = 8

*/


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Departments (
	Department INT
,	DepartmentDescription VARCHAR(50)
,	SalesCodeSSID INT
,	SalesCode VARCHAR(15)
,	SalesCodeDescription VARCHAR(50)
)


/********************************** Get list of centers *************************************/
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


IF @CenterType = 1
	BEGIN
		DELETE FROM #Centers WHERE #Centers.CenterSSID <> @CenterSSID
		SET @ReportHeading = (SELECT C.CenterDescription FROM #Centers C)
	END


IF @CenterType = 2
	BEGIN
		DELETE FROM #Centers WHERE #Centers.CenterType <> 'C'
		SET @ReportHeading = 'Corporate Centers'
	END


IF @CenterType = 8
	BEGIN
		DELETE FROM #Centers WHERE #Centers.CenterType NOT IN ( 'F', 'JV' )
		SET @ReportHeading = 'Franchise Centers'
	END



/********************************** Get sales data *************************************/

-- Current Period
SELECT	DSC.SalesCodeSSID
,		DSC.SalesCodeDescriptionShort AS 'SalesCode'
,		DSC.SalesCodeDescription AS 'SalesCodeDescription'
,		Dept.SalesCodeDepartmentSSID AS 'Department'
,		Dept.SalesCodeDepartmentDescription AS 'DepartmentDescription'
,		SUM(FST.ExtendedPrice) AS 'Price'
,		SUM(FST.Quantity) AS 'Quantity'
INTO	#Current
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
		INNER JOIN #Centers C
            ON CTR.ReportingCenterSSID = C.CenterSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment Dept
			ON DSC.SalesCodeDepartmentKey = Dept.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision Div
			ON Dept.SalesCodeDivisionKey = Div.SalesCodeDivisionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @CurrentStartDate AND @CurrentEndDate
		AND Div.SalesCodeDivisionSSID = 30
GROUP BY DSC.SalesCodeSSID
,		DSC.SalesCodeDescriptionShort
,		DSC.SalesCodeDescription
,		Dept.SalesCodeDepartmentSSID
,		Dept.SalesCodeDepartmentDescription
ORDER BY Dept.SalesCodeDepartmentSSID
,		DSC.SalesCodeDescriptionShort


-- Prior Period
SELECT	DSC.SalesCodeSSID
,		DSC.SalesCodeDescriptionShort AS 'SalesCode'
,		DSC.SalesCodeDescription AS 'SalesCodeDescription'
,		Dept.SalesCodeDepartmentSSID AS 'Department'
,		Dept.SalesCodeDepartmentDescription AS 'DepartmentDescription'
,		SUM(FST.ExtendedPrice) AS 'Price'
,		SUM(FST.Quantity) AS 'Quantity'
INTO	#Prior
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
		INNER JOIN #Centers C
            ON CTR.ReportingCenterSSID = C.CenterSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment Dept
			ON DSC.SalesCodeDepartmentKey = Dept.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision Div
			ON Dept.SalesCodeDivisionKey = Div.SalesCodeDivisionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @PriorStartDate AND @PriorEndDate
		AND Div.SalesCodeDivisionSSID = 30
GROUP BY DSC.SalesCodeSSID
,		DSC.SalesCodeDescriptionShort
,		DSC.SalesCodeDescription
,		Dept.SalesCodeDepartmentSSID
,		Dept.SalesCodeDepartmentDescription
ORDER BY Dept.SalesCodeDepartmentSSID
,		DSC.SalesCodeDescriptionShort


-- Get Distinct Departments & Sales Codes (necessary because some sales could have existed in the Current year that were not in the Prior year and vice-versa)
INSERT	INTO #Departments
		SELECT  DISTINCT
				C.Department
		,		C.DepartmentDescription
		,		C.SalesCodeSSID
		,		C.SalesCode
		,		C.SalesCodeDescription
		FROM    #Current C
		UNION
		SELECT  DISTINCT
				P.Department
		,		P.DepartmentDescription
		,		P.SalesCodeSSID
		,		P.SalesCode
		,		P.SalesCodeDescription
		FROM    #Prior P
		ORDER BY [Department]
		,		[SalesCode]


/********************************** Display Final Results *************************************/
SELECT  @ReportHeading AS 'ReportHeader'
,		D.Department
,       D.DepartmentDescription
,       D.SalesCode
,       D.SalesCodeDescription
,		(SELECT DSC.PriceDefault FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WHERE DSC.SalesCodeSSID = D.SalesCodeSSID) AS 'SalesCodePrice'
,		@CurrentStartDate AS 'Current_StartDate'
,		@CurrentEndDate AS 'Current_EndDate'
,		ISNULL((SELECT C.Price FROM #Current C WHERE C.Department = D.Department AND C.SalesCode = D.SalesCode), 0) AS 'Current_Price'
,		ISNULL((SELECT C.Quantity FROM #Current C WHERE C.Department = D.Department AND C.SalesCode = D.SalesCode), 0) AS 'Current_Quantity'
,		@PriorStartDate AS 'Prior_StartDate'
,		@PriorEndDate AS 'Prior_EndDate'
,		ISNULL((SELECT P.Price FROM #Prior P WHERE P.Department = D.Department AND P.SalesCode = D.SalesCode), 0) AS 'Prior_Price'
,		ISNULL((SELECT P.Quantity FROM #Prior P WHERE P.Department = D.Department AND P.SalesCode = D.SalesCode), 0) AS 'Prior_Quantity'
FROM    #Departments D
ORDER BY D.Department
,       D.SalesCode

END
GO
