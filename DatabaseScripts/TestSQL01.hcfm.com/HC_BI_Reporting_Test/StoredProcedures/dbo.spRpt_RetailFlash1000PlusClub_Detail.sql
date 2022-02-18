/* CreateDate: 08/01/2019 11:16:12.650 , ModifyDate: 01/23/2020 16:21:47.373 */
GO
/***********************************************************************
PROCEDURE:				spRpt_RetailFlash1000PlusClub_Detail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_CMS_DDS
RELATED APPLICATION:	Retail Flash - Top Stylists who sell $1,000 +
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		7/26/2016
LAST REVISION DATE:		7/26/2016
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Corporate Regions, 2 is Area Managers, 3 is By Corporate Centers, 4 is by Franchise Regions
This report defaults to this year and shows all months.
------------------------------------------------------------------------
CHANGE HISTORY:
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description
04/03/2017 - RH - (#137635) Show only Managers, Stylists and Stylist Supervisors
08/01/2019 - RH - (#12346) Changed logic for finding centers using CenterTypeDescriptionShort
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:

EXEC [spRpt_RetailFlash1000PlusClub_Detail] 2,1
EXEC [spRpt_RetailFlash1000PlusClub_Detail] 3,6

EXEC [spRpt_RetailFlash1000PlusClub_Detail] 4,6
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_RetailFlash1000PlusClub_Detail] (
	@Filter INT
	,	@Month INT
) AS

BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

DECLARE @Year INT
SET @Year = YEAR(GETDATE())
PRINT @Year



/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	EmployeeKey INT
,	EmployeeFullName VARCHAR(102)
)

CREATE TABLE #Dates(
MonthNumber INT
,	YearNumber INT)

CREATE TABLE #Employees(
	CenterSSID INT
,	EmployeeSSID NVARCHAR(36)
,	EmployeeFullName NVARCHAR(150)
,	IsActiveFlag INT
,	Position NVARCHAR(150)
,	FirstRank INT
)

CREATE TABLE #Sales(MonthNumber INT
,	YearNumber INT
,	CenterSSID INT NULL
,	CenterType VARCHAR(50)
,	EmployeeID UNIQUEIDENTIFIER NULL
,	Retail MONEY NULL
,	EmployeeFullName VARCHAR(255) NULL
)

/********************************** Get list of centers *************************************/

IF @Filter = 2  --By Area Managers
BEGIN
	INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
			,	CMA.CenterManagementAreaDescription AS MainGroup
			,	CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
			,	DC.CenterSSID
			,	DC.CenterDescriptionNumber
			,	E.EmployeeKey
			,	E.EmployeeFullName
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
						ON CMA.OperationsManagerSSID = E.EmployeeSSID
			WHERE	CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END
IF @Filter = 3  -- By Corporate Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  DC.CenterNumber AS MainGroupID
			,		DC.CenterDescriptionNumber AS MainGroup
			,		DC.CenterNumber AS 'MainGroupSortOrder'
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		NULL AS EmployeeKey
			,		NULL AS EmployeeFullName
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END


IF @Filter = 4  --Always By Regions for Franchises
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS MainGroupID
			,		DR.RegionDescription AS MainGroup
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		NULL AS EmployeeKey
			,		NULL AS EmployeeFullName
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort IN ('F','JV')
					AND DC.Active = 'Y'
END

/********************************* Set up the #Dates table *****************************/

INSERT INTO #Dates VALUES (1,@Year)
INSERT INTO #Dates VALUES (2,@Year)
INSERT INTO #Dates VALUES (3,@Year)
INSERT INTO #Dates VALUES (4,@Year)
INSERT INTO #Dates VALUES (5,@Year)
INSERT INTO #Dates VALUES (6,@Year)
INSERT INTO #Dates VALUES (7,@Year)
INSERT INTO #Dates VALUES (8,@Year)
INSERT INTO #Dates VALUES (9,@Year)
INSERT INTO #Dates VALUES (10,@Year)
INSERT INTO #Dates VALUES (11,@Year)
INSERT INTO #Dates VALUES (12,@Year)

/****************** Find active employees per center **********************************/

INSERT INTO #Employees
SELECT E.CenterSSID
,	E.EmployeeSSID
,	E.EmployeeFullName
,	E.IsActiveFlag AS 'E_IsActiveFlag'
,	STUFF(P.Position, 1, 1, '') AS 'Position'
,	ROW_NUMBER() OVER(PARTITION BY E.EmployeeSSID ORDER BY E.EmployeeSSID) AS FirstRank
FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
INNER JOIN #Centers CTR
	ON E.CenterSSID = CTR.CenterSSID
CROSS APPLY (SELECT ', ' + EP.EmployeePositionDescription
				FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP
					ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
				WHERE E.EmployeeSSID = EPJ.EmployeeGUID
					AND E.IsActiveFlag = 1
					AND EP.EmployeePositionDescription IN('Stylist', 'Stylist Supervisor', 'Franchise Stylist Supervisor','Manager', 'Franchise Manager')
				ORDER BY EP.EmployeePositionDescription
				FOR XML PATH('') ) AS P (Position)
WHERE P.Position IS NOT NULL


/********************************** Get sales data *************************************/

INSERT INTO #Sales
SELECT 	#Dates.MonthNumber
,	#Dates.YearNumber
,	CTR.ReportingCenterSSID
,	DCT.CenterTypeDescriptionShort AS 'CenterType'
,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2SSID
		WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1SSID END AS 'EmployeeID'
,	SUM(CASE WHEN scd.SalesCodeDivisionSSID = 30 THEN FST.ExtendedPrice ELSE 0 END) AS 'Retail'
,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2FullName
		WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1FullName
		ELSE
		'UNKNOWN'
		END AS 'EmployeeFullName'
FROM hc_bi_cms_dds.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON DD.DateKey = FST.OrderDateKey
	INNER JOIN #Dates
		ON DD.YearNumber = #Dates.YearNumber AND DD.MonthNumber = #Dates.MonthNumber
	INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.salesorderdetailkey = SOD.SalesOrderDetailKey
	INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrder SO
		ON FST.salesorderkey = SO.SalesOrderKey
	INNER JOIN #Employees EMP
		ON 	(EMP.EmployeeSSID = SOD.Employee1SSID OR EMP.EmployeeSSID = SOD.Employee2SSID)
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FST.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
		ON CTR.CenterTypeKey = DCT.CenterTypeKey
	INNER JOIN #Centers
        ON CTR.ReportingCenterSSID = #Centers.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
		ON CTR.RegionKey = R.RegionKey
	INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment SCD
		ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey

WHERE
	(SCD.SalesCodeDivisionSSID in (30,50) or SC.SalesCodeDescriptionShort in ('HM3V5','EXTLH','HM3V5N','EXTLB'))
	AND SO.IsVoidedFlag = 0
GROUP BY CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002'
       THEN sod.Employee2SSID
       WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002'
       THEN sod.Employee1SSID
       END
       , CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002'
       THEN sod.Employee2FullName
       WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002'
       THEN sod.Employee1FullName
       ELSE 'UNKNOWN'
       END
       , #Dates.MonthNumber
       , #Dates.YearNumber
       , CTR.ReportingCenterSSID
       , DCT.CenterTypeDescriptionShort

/***************************Pre-Pivot for Result Dataset ******************************************************/

SELECT S.MonthNumber
,	S.YearNumber
,	S.CenterType
,	C.MainGroupID
,	C.MainGroup
,	C.MainGroupSortOrder
,	C.CenterSSID
,	C.CenterDescription
,	S.EmployeeFullName
,	SUM(ISNULL(S.Retail,0)) AS 'TotalRetail'
,	CASE WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '1000.00' AND '1999.99' THEN 1
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '2000.00' AND '2999.99' THEN 2
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '3000.00' AND '3999.99' THEN 3
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '4000.00' AND '4999.99' THEN 4
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '5000.00' AND '5999.99' THEN 5
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '6000.00' AND '6999.99' THEN 6
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '7000.00' AND '7999.99' THEN 7
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '8000.00' AND '8999.99' THEN 8
		WHEN SUM(ISNULL(S.Retail,0)) BETWEEN '9000.00' AND '9999.99' THEN 9
		ELSE 10 END AS 'Thousands'
FROM #Centers C
    INNER JOIN #Sales S
		ON C.CenterSSID = S.CenterSSID
WHERE Retail >= '1000.00'
AND S.MonthNumber = @Month
GROUP BY S.MonthNumber
,	S.YearNumber
,	S.CenterType
,	C.MainGroupID
,	C.MainGroup
,	C.MainGroupSortOrder
,	C.CenterSSID
,	C.CenterDescription
,	S.EmployeeFullName




END
GO
