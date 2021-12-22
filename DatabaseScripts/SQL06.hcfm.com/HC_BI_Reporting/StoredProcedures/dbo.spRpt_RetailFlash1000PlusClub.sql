/* CreateDate: 08/02/2016 11:27:33.183 , ModifyDate: 01/23/2020 16:22:16.933 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_RetailFlash1000PlusClub
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
03/31/2017 - RH - (#137635) Only Salon Managers, Stylist Supervisors, and Stylists should show on this report.
08/25/2017 - RH - (#142424) Added an index to #Sales; Moved the PIVOT to the report
11/20/2017 - RH - (#145957) Changed logic for Area Managers
01/23/2018 - RH - (#145147) Added Employee Payroll ID
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:

EXEC [spRpt_RetailFlash1000PlusClub] 'C', 2
EXEC [spRpt_RetailFlash1000PlusClub] 'C', 3

EXEC [spRpt_RetailFlash1000PlusClub] 'F', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_RetailFlash1000PlusClub] (
	@sType CHAR(1)
,	@Filter INT
) AS

BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

DECLARE @Year INT
SET @Year = YEAR(GETDATE())
--SET @Year = 2017
PRINT @Year



/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
)

CREATE TABLE #Dates(
MonthNumber INT
,	YearNumber INT)

CREATE TABLE #Employees(
	CenterSSID INT
,	EmployeeSSID NVARCHAR(36)
,	EmployeeFullName NVARCHAR(150)
,	EmployeePayrollID NVARCHAR(20)
,	IsActiveFlag INT
,	Position NVARCHAR(150)
,	FirstRank INT
)

CREATE TABLE #Sales(MonthNumber INT
,	YearNumber INT
,	CenterSSID INT NULL
,	CenterType VARCHAR(50)
,	EmployeeID VARCHAR(50)
,	Retail MONEY NULL
,	EmployeeFullName VARCHAR(255) NULL
,	EmployeePayrollID NVARCHAR(20)
)

--Create an index on the temp table that will be dropped at the end of the sp
CREATE NONCLUSTERED INDEX [IX_tmpSales_CenterSSID_Retail_Included]
ON [dbo].[#Sales] ([CenterSSID],[Retail])
INCLUDE ([MonthNumber],[YearNumber],[CenterType],[EmployeeFullName])

/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
	INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
			,	CMA.CenterManagementAreaDescription AS MainGroup
			,	CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
			,	DC.CenterSSID
			,	DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CMA.Active = 'Y'
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
END
IF @sType = 'C' AND @Filter = 3  -- By Corporate Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  DC.CenterSSID AS MainGroupID
			,		DC.CenterDescriptionNumber AS MainGroup
			,		DC.CenterSSID AS 'MainGroupSortOrder'
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS MainGroupID
			,		DR.RegionDescription AS MainGroup
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
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
,	E.EmployeePayrollID
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
					AND EP.EmployeePositionDescription IN('Stylist', 'Stylist Supervisor', 'Franchise Stylist Supervisor')
				ORDER BY EP.EmployeePositionDescription
				FOR XML PATH('') ) AS P (Position)
WHERE P.Position IS NOT NULL


/********************************** Get sales data *************************************/

INSERT INTO #Sales
SELECT 	#Dates.MonthNumber
,	#Dates.YearNumber
,	CTR.CenterSSID
,	DCT.CenterTypeDescriptionShort AS 'CenterType'
,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2SSID
		WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1SSID END AS 'EmployeeID'
,	SUM(CASE WHEN scd.SalesCodeDivisionSSID = 30 THEN FST.ExtendedPrice ELSE 0 END) AS 'Retail'
,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2FullName
		WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1FullName
		ELSE
		'UNKNOWN'
		END AS 'EmployeeFullName'
,	EMP.EmployeePayrollID
FROM hc_bi_cms_dds.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON DD.DateKey = FST.OrderDateKey
	INNER JOIN #Dates
		ON DD.YearNumber = #Dates.YearNumber AND DD.MonthNumber = #Dates.MonthNumber
	INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.salesorderdetailkey = SOD.SalesOrderDetailKey
	INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrder SO
		on FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN #Employees EMP
		ON 	(EMP.EmployeeSSID = SOD.Employee1SSID OR EMP.EmployeeSSID = SOD.Employee2SSID)
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		on FST.CenterKey = CTR.CenterKey
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

WHERE SCD.SalesCodeDivisionSSID = 30
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
       , CTR.CenterSSID
       , DCT.CenterTypeDescriptionShort
	   , EMP.EmployeePayrollID

/************** Find the Thousands *********************************************/

SELECT S.MonthNumber
,	S.YearNumber
,	S.CenterType
,	C.MainGroupID
,	C.MainGroup
,	C.MainGroupSortOrder
,	C.CenterSSID
,	C.CenterDescription
,	S.EmployeeFullName
,	S.EmployeeID
,	S.EmployeePayrollID
,	S.Retail
,	LEFT(S.Retail,1) AS 'Thousand'
INTO #Thousand
FROM #Centers C
    INNER JOIN #Sales S
		ON C.CenterSSID = S.CenterSSID
WHERE Retail >= '1000.00'


SELECT	MainGroupID
     ,	MainGroup
     ,	MainGroupSortOrder
     ,	CenterSSID
     ,	CenterDescription
     ,	EmployeeFullName
	 ,  EmployeeID
	 ,  EmployeePayrollID
	 ,	MonthNumber
     ,  Thousand
FROM #Thousand

DROP INDEX #Sales.[IX_tmpSales_CenterSSID_Retail_Included]

END
GO
