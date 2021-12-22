/* CreateDate: 08/14/2019 15:44:27.900 , ModifyDate: 08/27/2019 12:14:42.580 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_PresidentsClubCSC]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[spRpt_PresidentsClubCSC]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/26/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_PresidentsClubCSC] 7, 2019

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubCSC]
(
	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;

/************** Declare and set variables ********************************************************/


DECLARE @StartDate DATETIME
DECLARE	@EndDate DATETIME
DECLARE @BeginningOfTheYear DATE

SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
SET @EndDate = DATEADD(MINUTE, -1, DATEADD(mm, 1, @StartDate))
SET @BeginningOfTheYear = CAST('1/1/' + DATENAME(YEAR,@StartDate) AS DATE)

--PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(120))
--PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(120))
--PRINT '@BeginningOfTheYear = ' + CAST(@BeginningOfTheYear AS NVARCHAR(120))

--Set @OpenPCPDate to beginning of the year
DECLARE @OpenPCPDate DATETIME
SET @OpenPCPDate = @BeginningOfTheYear



/************ Create temp tables *****************************************************************/

CREATE TABLE #Centers (
	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription VARCHAR(50)
,	RecurringBusinessSize NVARCHAR(10)
)


CREATE TABLE #Employee(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(200)
,	EmployeeSSID NVARCHAR(50)
,	CenterNumber INT
,	CenterSSID INT
)


CREATE TABLE #Retail(
	MonthShortNameWithYear CHAR(8)
,	CenterNumber INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeeFullName NVARCHAR(200)
,	RetailSales DECIMAL(18,2)
)


CREATE TABLE #Services(
	MonthShortNameWithYear CHAR(8)
,	CenterNumber INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeeFullName NVARCHAR(200)
,	ClientServicedCnt INT
)



CREATE TABLE #Receivable (
	CenterNumber INT
,	Receivable DECIMAL(18,4)
)


CREATE TABLE #CSC(
	CenterNumber INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(104)
,	RecurringBusinessSize NVARCHAR(10)
,	EmployeeSSID NVARCHAR(50)
,	EmployeeFullName NVARCHAR(150)
,	RetailSales DECIMAL(18,2)
,	ClientServicedCnt INT
,	RetailPerClient DECIMAL(18,2)
,	Receivable DECIMAL(18,2)
,	StartDate DATE
,	EndDate DATE
)



/********************************** Find center information   *************************************/

INSERT INTO #Centers
SELECT c.CenterNumber
,	c.CenterDescriptionNumber
,   CMA.CenterManagementAreaSSID
,   CMA.CenterManagementAreaDescription
,	c.RecurringBusinessSize
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c WITH(NOLOCK)
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT WITH(NOLOCK)
		ON	CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA WITH(NOLOCK)
		ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
WHERE	CT.CenterTypeDescriptionShort IN('C')
		AND C.Active = 'Y'
		AND C.CenterNumber NOT IN(100,199)



CREATE NONCLUSTERED INDEX IDX_Centers_CenterNumber ON #Centers ( CenterNumber );


/********* This code is to set find the correct CSC's from MaryAm's list  *************************/


INSERT INTO #Employee
SELECT E.EmployeeKey
,	E.EmployeeFullName
,	E.EmployeeSSID
,	CTR.CenterNumber
,	CTR.CenterSSID
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON E.CenterSSID = CTR.CenterSSID
WHERE E.EmployeeFullName IN('Dooley, Stephen',
'Ardeleanu, Raluca',
'Rivera, Denise',
'Dejesus, Briana',
'Byrd, Chance',
'Gamerman, Mark',
'Ramirez, Lizbeth',
'Bermejo, Victoria',
'Gill, Cheyenne',
'Mooney, Charlene',
'Guzman, Ramon',
'Riggi, JoAnn ',
'Cruz, Carlos',
'Young, Cindy',
'Parham, Adalia',
'Shore, Kathie',
'Briles, Mary',
'Sanchez, Roseybi',
'Ramirez, Cindy',
'Hilscher, Randy ',
'Lawes, Yamileth ',
'Stone, Ivalisse',
'Douglas, Reagan',
'Capocciama, Marisol',
'Kenny, James',
'Saldana, Krystile',
'Rodriguez, Maria',
'Pickett, Lauren',
'Torres, Maricruz',
'Diaz, Gabriela',
'Brooks, Rubia',
'Mekasijian, Ani',
'Hall, Sandra',
'Nimmo, Daniel ',
'Hall, Amber',
'Padilla, Ada',
'Desvarieux, Briana',
'Haefeli, Amelia',
'Robb Pillor, Patricia',
'Walker, Brittany',
'Perry, Shelia',
'De Foreste, Emily',
'Mohammed, Shameen ',
'Vallecoccia, Natalie ',
'Tukhi, Zahra ',
'Cecchini, Tyler',
'Calloway, Courtney',
'Bradley, Deserea',
'Hilliard, Gina',
'Morrison, Carolyn ',
'Martinez, Petra',
'Hayhurst, Tammy ',
'Morales Garcia, Marielly',
'Andrioti, Eirini',
'Dias, Jessica-Angela',
'Fitzgerald, Emily',
'Granillo Martinez, Imara',
'Stojsin, Ryan ',
'Haase, Daniella ',
'Jhamb, Meena ',
'Mannila, Liisa ',
'Scott, Maylyn ',
'Spignesi, Lisa ',
'Lee, Wendy Michele',
'Rodriguez, Aleia',
'Brantley, Brittany',
'Garcia Ostiguin, Milagros',
'Arenas, Virginia',
'Cooper, Alexis',
'Jackson, Amber',
'Gilliam, Belinda ',
'Yancey, Kristen',
'Mack, Daniel',
'Houlahan, Kathleen',
'Thornton, Christina',
'Masterson, Elizabeth',
'OBrien, Melinda',
'King, Sherri',
'Alberto, Ingrid',
'Suddath, Sharon',
'Holder, Elouise',
'Christie, Danielle',
'Beik, Reza ',
'Armstrong, Shelley',
'Edwards, Daryan',
'Lubeski, Shannon ',
'Pacheco-Santiago, Kimberly',
'Dorsett, Tracie',
'Sanchez, Natalia',
'Toyer, Katherine',
'King, Jordan',
'Duenas Hernandez, Kassandra',
'Martinez Ocano, Gabriel ',
'Carney, Toya ',
'Lee, Tonna',
'Macpherson, Heather',
'Campana, Christine',
'Gandara, Kassandra ',
'Montiel, Alexandra',
'Cantu, Luis',
'Medrano De Aceituno, Ana Jose',
'Quinn, Hannah',
'Bailey, Alexandra',
'Djordjevic, Goran',
'Lorenzo, Valerie',
'Nugent, Donna K',
'Berlinger, Taylor',
'Downs, Alexis',
'Johnson, Lonzell',
'Abarca, Maritza',
'Holmgren, Latch',
'Rivard, Crystal',
'Mossburg, Margaret',
'Birkenfeld, Julie ',
'Hinojosa, Hope',
'Jagiello, Ewa',
'Rivera, Stephanie',
'Abad, Dustin',
'Mcclain, Jared',
'Justice, Angel',
'Angeles-Escobar, Miriam',
'Ferguson, Danielle',
'Garza, Adrianna',
'Harbor, Kenya',
'Robinson, Donnie',
'Blanchard, Rene',
'Skelton, Joshua',
'Downing, Victoria',
'Maher, Katie',
'Hill, Patricia'
)
AND E.IsActiveFlag = 1
ORDER BY CTR.CenterSSID

UPDATE #Employee
SET CenterSSID = 209 WHERE EmployeeFullName = 'Stone, Ivalisse'

--Diaz, Gabriela 213
UPDATE #Employee
SET CenterSSID = 213 WHERE EmployeeFullName = 'Diaz, Gabriela'

INSERT INTO #Employee
(
	EmployeeKey
,   EmployeeFullName
,	EmployeeSSID
,	CenterNumber
,   CenterSSID
)
VALUES
(   16665
,   N'OBrien, Melinda'
,	'B98FA021-2097-47E4-96F2-136570778337'
,   229
,	229
    )

--SELECT '#Employee' AS tablename,* FROM #Employee
--ORDER BY CenterSSID, EmployeeFullName

/**********Find Retail sales per center per timeframe ***************************/

INSERT  INTO #Retail
        SELECT  DD.MonthShortNameWithYear
			,	CTR.CenterNumber
			,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
					WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID
					END AS 'EmployeeSSID'
			,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
				WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
					ELSE 'UNKNOWN'
				END AS 'EmployeeFullName'
			,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailSales'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FST.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN #Employee EMP
			ON (SOD.Employee2SSID = EMP.EmployeeSSID OR SOD.Employee1SSID = EMP.EmployeeSSID)
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON SOD.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers CTR
            ON c.CenterNumber = CTR.CenterNumber
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON FST.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
				AND FST.RetailAmt <> '0'
GROUP BY CASE
         WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
         WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID
         END,
         CASE
         WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
         WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
         ELSE 'UNKNOWN' END,
         DD.MonthShortNameWithYear,
         CTR.CenterNumber


/********** Find Services per client One per day ******************************************************/


INSERT INTO #Services
SELECT q.MonthShortNameWithYear
,	q.CenterNumber
,	q.EmployeeSSID
,	q.EmployeeFullName
,	SUM(q.ClientServicedCnt) AS ClientServicedCnt
FROM

	(SELECT #Centers.CenterNumber
	,	DD.Fulldate
	,	DD.MonthShortNameWithYear
	,	FST.ClientKey
	,	DSC.SalesCodeSSID
	,	DSC.SalesCodeDescription
	,	DSC.SalesCodeTypeSSID
	,	DSCD.SalesCodeDepartmentSSID
	,	CASE WHEN DSCD.SalesCodeDepartmentSSID between 5010 and 5040 THEN 1 ELSE 0 END AS 'ClientServicedCnt'
	,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
					WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID
					END AS 'EmployeeSSID'
	,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
			WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
				ELSE 'UNKNOWN'
			END AS 'EmployeeFullName'
	,	ROW_NUMBER() OVER(PARTITION BY FST.ClientKey,DD.FullDate ORDER BY DSC.SalesCodeDescription DESC) AS 'FirstRank'  --One service per day per client
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON #Centers.CenterNumber = C.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN #Employee EMP
			ON (SOD.Employee2SSID = EMP.EmployeeSSID OR SOD.Employee1SSID = EMP.EmployeeSSID)
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
	WHERE 	DSCD.SalesCodeDivisionSSID = 50
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SO.IsVoidedFlag = 0
		AND DSCD.SalesCodeDepartmentSSID between 5010 and 5040  --This is for services
	)q
WHERE FirstRank = 1
GROUP BY q.MonthShortNameWithYear
,         q.CenterNumber
,         q.EmployeeSSID
,         q.EmployeeFullName



/**************** Find Receivables per center *****************************************/
--If @EndDate is this month, then pull yesterday's date, because FactReceivables populates once a day at 3:00 AM
DECLARE @ReceivablesDate DATETIME

IF MONTH(@EndDate) = MONTH(GETDATE())
BEGIN
	SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(dd, -1, GETDATE()), 101)
END
ELSE
BEGIN
	SET @ReceivablesDate = @EndDate
END

PRINT @ReceivablesDate

INSERT INTO #Receivable
SELECT CenterNumber
,	SUM(Balance) AS 'Receivable'
FROM
	(SELECT  C.CenterNumber
		,   CLT.ClientIdentifier
		,	CLT.ClientKey
		,   CM.ClientMembershipKey
		,	FR.Balance AS 'Balance'
		,	ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY CM.ClientMembershipEndDate DESC) AS Ranking
	FROM    HC_Accounting.dbo.FactReceivables FR
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FR.DateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FR.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FR.CenterKey = C.CenterKey
			INNER JOIN #Centers CTR
				ON C.CenterNumber = CTR.CenterNumber
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
				ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON CM.MembershipSSID = M.MembershipSSID
	WHERE   DD.FullDate = CAST(@ReceivablesDate AS DATE)
		AND M.RevenueGroupSSID = 2
		AND FR.Balance >= 0
		) b
WHERE Ranking = 1
GROUP BY CenterNumber


/******************** Final select into #Stylist ******************************************************/

INSERT INTO #CSC
SELECT C.CenterNumber
,	C.CenterManagementAreaSSID
,	C.CenterManagementAreaDescription
,	C.CenterDescriptionNumber
,	C.RecurringBusinessSize
,	EmpID.EmployeeSSID
,	EmpID.EmployeeFullName
,	ISNULL(R.RetailSales,0) AS RetailSales
,	ISNULL(S.ClientServicedCnt,0) AS ClientServicedCnt
,	dbo.DIVIDE_DECIMAL(ISNULL(R.RetailSales,0),ISNULL(S.ClientServicedCnt,0)) AS RetailPerClient
,	ISNULL(AR.Receivable,0) AS Receivable
,	@StartDate AS StartDate
,	@EndDate AS EndDate
FROM #Centers C
	LEFT OUTER JOIN #Employee EmpID
		ON EmpID.CenterNumber = C.CenterNumber
	LEFT OUTER JOIN #Retail R
		ON R.CenterNumber = C.CenterNumber AND R.EmployeeSSID = EmpID.EmployeeSSID
	LEFT OUTER JOIN #Services S
		ON S.CenterNumber = C.CenterNumber AND S.EmployeeSSID = EmpID.EmployeeSSID
	LEFT OUTER JOIN #Receivable AR
		ON AR.CenterNumber = C.CenterNumber


SELECT CenterNumber
,       CenterManagementAreaSSID
,       CenterManagementAreaDescription
,       CenterDescriptionNumber
,       RecurringBusinessSize
,       EmployeeSSID
,       EmployeeFullName
,       RetailSales
,       ClientServicedCnt
,       RetailPerClient
,       Receivable
,       StartDate
,       EndDate
,		RetailPerClient - Receivable AS Total   --We want the Maximum RetailPerClient and the least Receivable amount
FROM #CSC
WHERE EmployeeFullName IS NOT NULL



END
GO
