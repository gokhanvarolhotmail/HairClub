/* CreateDate: 10/24/2013 14:02:41.907 , ModifyDate: 01/23/2020 16:22:50.583 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				sprpt_RetailFlashDetail	VERSION  1.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE:	HC_BI_CMS_DDS

RELATED APPLICATION:	Retail Flash - sub report

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/1/2012

LAST REVISION DATE:		4/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
03/27/2012 - KM - Initial Creation
10/23/2013 - RH - Added ISNULL(<>,'Unknown') to the Employee and Position fields
10/24/2013 - RH - Removed SET @enddt = @enddt + ' 23:59'- now using the dimDate table; Changed joins on HC_BI_Reporting.dbo.Employee
				  and HC_BI_Reporting.dbo.cmspositions to joins on HC_BI_CMS_DDS.bi_cms_dds.DimEmployee,
				  HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin and HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition
10/30/2013 - RH - Removed JOIN on HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin and HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition
				  since this was removing employees that were not in these tables; and the field, position, was not being used in the report.
				  (i.e. Shalon Tucker's employeeGUID was not in the HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin table)
09/23/2014 - DL - Changed ClientNumber_Temp to ClientIdentifier as it was causing some ClientNames to not be displayed on the report (#106753)
02/25/2015 - DL - (#111963) Removed EXT - LaserComb Payment & EXT - LaserHelmet Payment sales codes that appear to have been placed in the stored proc incorrectly.
07/17/2015 - RH - (#116911) Changed to only pull SalesCodeDivisionSSID = 30 since this is Retail and includes Lazer Comb and Lazer Helmet
					Added scd.SalesCodeDivisionSSID IN(30,50)
11/23/2015 - RH - (#120713) Added LaserBand and LaserComb Ultima 12; Changed ExtendedPrice for Retail where SalesCodeDivisionSSID = 30
06/29/2017 - RH - (#140623) Replaced so.TicketNumber_Temp with t.SalesOrderDetailKey
01/23/2018 - RH - (#145147) Added EmployeePayrollID and EmployeePositionDescription IN('Stylist', 'Stylist Supervisor', 'Franchise Stylist Supervisor')
04/19/2018 - RH - (#149012) Adjust the Services to be one per client per day
05/15/2018 - RH - (#149717) Added 3065 - Laser devices to removal from RetailFree
08/01/2019 - RH - (#12346) Added WigsRevenue - remove tender type of InterCo to exclude employees
01/17/2020 - RH - Pulled Wigs Revenue into a separate query since joining on tender type was causing dupes; also remove position limitation on employee

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
sprpt_RetailFlashDetail '241', '1/1/2020', '1/31/2020'
***********************************************************************/



CREATE   PROCEDURE [dbo].[sprpt_RetailFlashDetail] (
	@center Int
,	@begdt smalldatetime
,	@enddt SMALLDATETIME
) AS
	SET NOCOUNT ON

BEGIN


/**************** Create temp table **********************************************/


CREATE TABLE #Combined(
	FullDate DATETIME
,	CenterSSID INT
,	Employee NVARCHAR(300)
,	MembershipDescriptionShort NVARCHAR(50)
,	MembershipDescription NVARCHAR(150)
,	SalesCodeDepartmentDescription NVARCHAR(60)
,	SalesCodeDescription NVARCHAR(60)
,	RetailQty INT
,	ServiceQty INT
,	ExtendedPrice DECIMAL(18,4)
,	SalesOrderDetailKey INT
,	ClientName NVARCHAR(300)
,	RetailFree DECIMAL(18,4)
,	EmployeePayrollID NVARCHAR(50)
,	Position NVARCHAR(150)
)


CREATE TABLE #Wigs(
	FullDate DATETIME
,	CenterSSID INT
,	Employee NVARCHAR(300)
,	MembershipDescriptionShort NVARCHAR(50)
,	MembershipDescription NVARCHAR(150)
,	SalesCodeDepartmentDescription NVARCHAR(60)
,	SalesCodeDescription NVARCHAR(60)
,	RetailQty INT
,	ExtendedPrice DECIMAL(18,4)
,	SalesOrderDetailKey INT
,	ClientName NVARCHAR(300)
,	EmployeePayrollID NVARCHAR(50)
,	Position NVARCHAR(150)
)


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
	,	CASE WHEN ( scd.SalesCodeDepartmentSSID = 7052 AND DSOT.TenderTypeDescriptionShort <> 'InterCo') THEN FST.quantity ELSE 0 END as 'RetailQty'
	,	CASE WHEN (scd.SalesCodeDivisionSSID = 30 AND scd.SalesCodeDepartmentSSID = 7052 AND DSOT.TenderTypeDescriptionShort <> 'InterCo') THEN FST.RetailAmt
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
	AND c.CenterNumber = @center
	AND so.IsVoidedFlag = 0
	AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
	AND mem.MembershipDescription NOT LIKE 'Employee%'



/******* Use a UNION ALL to combine products and services, since services are one per day per client ********/

INSERT INTO #Combined
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
	,	CASE WHEN (scd.SalesCodeDepartmentSSID BETWEEN 3010 AND 3080 AND scd.SalesCodeDepartmentSSID <> 7052) THEN FST.quantity ELSE 0 END as 'RetailQty'
	,	NULL AS 'ServiceQty'
	,	CASE WHEN (scd.SalesCodeDivisionSSID = 30
					AND scd.SalesCodeDepartmentSSID BETWEEN 3010 AND 3080
						AND scd.SalesCodeDepartmentSSID <> 7052 ) THEN FST.ExtendedPrice
			ELSE 0 END AS 'ExtendedPrice'
	,	FST.SalesOrderDetailKey
	,	cl.ClientFullName + ' (' + cast(cl.ClientIdentifier as varchar(10)) + ')' as 'ClientName'
	,	CASE WHEN FST.ExtendedPrice= 0
			AND scd.SalesCodeDivisionSSID = 30
			AND scd.SalesCodeDepartmentSSID not in (3060,3065) THEN FST.Quantity*sc.PriceDefault ELSE 0 END AS 'RetailFree'	 --Added 3065
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
					--AND EP.EmployeePositionDescription IN('Stylist', 'Stylist Supervisor', 'Franchise Stylist Supervisor')
				ORDER BY EP.EmployeePositionDescription
				FOR XML PATH('') ) AS P (Position)
WHERE scd.SalesCodeDivisionSSID = 30   --Products
	AND DD.FullDate BETWEEN @begdt AND @enddt
	AND c.CenterNumber = @center
	AND so.IsVoidedFlag = 0
	--AND DSOT.TenderTypeDescriptionShort <> 'InterCo'
	AND MembershipDescription NOT LIKE 'Employee%'


UNION ALL

SELECT q.FullDate
     , q.CenterNumber AS 'CenterSSID'
     , q.Employee
     , q.MembershipDescriptionShort
     , q.MembershipDescription
     , q.SalesCodeDepartmentDescription
     , q.SalesCodeDescription
     , q.RetailQty
     , q.ServiceQty
     , q.ExtendedPrice
     , q.SalesOrderDetailKey
     , q.ClientName
     , q.RetailFree
     , q.EmployeePayrollID
     , q.Position
FROM
	(SELECT
			DD.FullDate, c.CenterNumber
		,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2FullName
			WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1FullName
			ELSE
			'UNKNOWN'
			END AS 'Employee'
		,	mem.MembershipDescriptionShort
		,	mem.MembershipDescription
		,	scd.SalesCodeDepartmentDescription
		,	sc.SalesCodeDescription
		,	NULL AS 'RetailQty'
		,	CASE WHEN scd.SalesCodeDepartmentSSID BETWEEN 5010 AND 5040 THEN 1 ELSE 0 END AS 'ServiceQty'
		,	CASE WHEN scd.SalesCodeDivisionSSID = 30 THEN FST.ExtendedPrice ELSE 0 END AS 'ExtendedPrice'
		,	FST.SalesOrderDetailKey
		,	cl.ClientFullName + ' (' + cast(cl.ClientIdentifier as varchar(10)) + ')' as 'ClientName'
		,	NULL AS 'RetailFree'
		,	emp.EmployeePayrollID
		,	STUFF(P.Position, 1, 1, '') AS 'Position'
		,	ROW_NUMBER() OVER(PARTITION BY FST.ClientKey,DD.FullDate ORDER BY sc.SalesCodeDescription DESC) AS 'FirstRank'  --One service per day per client
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
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON FST.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership clm
			ON FST.ClientMembershipKey = clm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mem
			ON clm.MembershipKey = mem.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EMP
			ON (CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2SSID
			WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1SSID END) = emp.EmployeeSSID
		CROSS APPLY (SELECT ', ' + EP.EmployeePositionDescription
					FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP
						ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
					WHERE EMP.EmployeeSSID = EPJ.EmployeeGUID
						AND EMP.IsActiveFlag = 1
						--AND EP.EmployeePositionDescription IN('Stylist', 'Stylist Supervisor', 'Franchise Stylist Supervisor')
					ORDER BY EP.EmployeePositionDescription
					FOR XML PATH('') ) AS P (Position)
	WHERE scd.SalesCodeDivisionSSID = 50  --Services
		AND DD.FullDate BETWEEN @begdt AND @enddt
		AND c.CenterNumber = @center
		AND so.IsVoidedFlag = 0
		AND scd.SalesCodeDepartmentSSID between 5010 and 5040)q
WHERE FirstRank = 1
AND MembershipDescription NOT LIKE 'Employee%'
UNION ALL
SELECT FullDate
,       CenterSSID
,       Employee
,       MembershipDescriptionShort
,       MembershipDescription
,       SalesCodeDepartmentDescription
,       SalesCodeDescription
,       RetailQty
,	    NULL AS ServiceQty
,       ExtendedPrice
,       SalesOrderDetailKey
,       ClientName
,	    NULL AS RetailFree
,       EmployeePayrollID
,       Position
FROM #Wigs


SELECT FullDate
,	CenterSSID
,	Employee
,	MembershipDescriptionShort
,	MembershipDescription
,	SalesCodeDepartmentDescription
,	SalesCodeDescription
,	SalesOrderDetailKey
,	ClientName
,	EmployeePayrollID
,	Position
,	SUM(ISNULL(RetailQty,0)) AS 'RetailQty'
,	SUM(ISNULL(ServiceQty,0)) AS 'ServiceQty'
,	SUM(ISNULL(ExtendedPrice,0)) AS 'ExtendedPrice'
,	SUM(ISNULL(RetailFree,0)) AS 'RetailFree'
FROM #Combined
WHERE (RetailQty = 1 OR ServiceQty = 1)
GROUP BY FullDate
,	CenterSSID
,	Employee
,	MembershipDescriptionShort
,	MembershipDescription
,	SalesCodeDepartmentDescription
,	SalesCodeDescription
,	SalesOrderDetailKey
,	ClientName
,	EmployeePayrollID
,	Position
ORDER BY Employee, ClientName



END
GO
