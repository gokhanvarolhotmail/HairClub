/* CreateDate: 07/12/2019 10:52:43.593 , ModifyDate: 11/13/2019 15:50:34.070 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_CRM_Scorecard]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[CRMscorecard]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/17/2019
------------------------------------------------------------------------
NOTES:
@Position = 'MULTI' for Areas - a list of centers; this is set in the subscription; 'CRM' for CRM; 'CM' for center manager; 'AM' for area manager

------------------------------------------------------------------------
CHANGE HISTORY:
07/30/2019 - RH - Added 3015 Non-Pgm to the PCP Budget (10536,3015)
07/31/2019 - RH - Added OR (SC.SalesCodeDepartmentSSID = 3080 AND SC.SalesCodeDescription LIKE 'Halo%') to Wigs
08/13/2019 - RH - Added PCP_NB2Amt to use in the percent for AR
08/23/2019 - RH - Corrected the Center Manager list (per Jimmy's roster)
09/05/2019 - RH - Corrected the Center Manager list (per Jimmy's roster)
11/13/2019 - RH - Removed Cindy Sneed (TFS13439); Added Addons for New Styles, Chemical Services, Salon Visits; updated center manager (per Jimmy's center roster)
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_CRM_Scorecard] 15816,'CRM','263'
EXEC [spRpt_CRM_Scorecard] 2046,'CRM','203'
--,264,242,244,239,241,243,245,246,247'
EXEC [spRpt_CRM_Scorecard] 203,'MULTI','203,209,240,263,269'
EXEC [spRpt_CRM_Scorecard] 202,'AM','202'
EXEC [spRpt_CRM_Scorecard] 216,'CM','216'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_CRM_Scorecard]
(
	@EmployeeKey INT
,	@Position NVARCHAR(5)
,	@CenterNumberList NVARCHAR(400)
)
AS
BEGIN

SET FMTONLY OFF;



/************** Declare and set variables **********************************************************************/

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @BeginningOfThisMonth DATETIME
DECLARE @BeginningOfThePreviousMonth DATETIME
DECLARE @BeginningOfTheYear DATE


DECLARE @Today DATETIME = CURRENT_TIMESTAMP;


SET @BeginningOfThisMonth = CAST(CAST(MONTH(@Today) AS VARCHAR(2)) + '/1/' + CAST(YEAR(@Today) AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
SET @BeginningOfThePreviousMonth = DATEADD(MONTH,-1,@BeginningOfThisMonth)



--PRINT @BeginningOfThisMonth
--PRINT @Today


--If @Today is the beginning of the month, then set @StartDate to the first day of last month and set @EndDate to yesterday at 11:59 PM

IF @BeginningOfThisMonth = CAST(@Today AS DATE)
BEGIN
SET @StartDate = @BeginningOfThePreviousMonth
SET @EndDate = DATEADD(DAY,-1,CAST(@Today AS DATE))
END
ELSE
BEGIN
SET @StartDate = @BeginningOfThisMonth
SET @EndDate = DATEADD(DAY,-1,CAST(@Today AS DATE))
END

--PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(12))
--PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(12))

DECLARE @MonthWorkdaysTotal INT
DECLARE @CummWorkdays INT
SET @MonthWorkdaysTotal = (SELECT MonthWorkdaysTotal FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @StartDate)
SET @CummWorkdays = (SELECT CummWorkdays FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @EndDate)


DECLARE @DaysRemaining INT
SET @DaysRemaining = @MonthWorkdaysTotal - @CummWorkdays

SET @BeginningOfTheYear = CAST('1/1/' + DATENAME(YEAR,@StartDate) AS DATE)

--PRINT @BeginningOfTheYear

/********** Create temp tables ******************************************************************************/

CREATE TABLE #CenterNumberList (CenterNumber INT)


CREATE TABLE #CenterManager(
	CenterKey INT
,   CenterNumber INT
,   CenterDescriptionNumber NVARCHAR(50)
,	CenterManager NVARCHAR(102)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	AreaManager NVARCHAR(102)
,	EmployeePositionDescription NVARCHAR(50)
)


CREATE TABLE #Employee(
	EmployeeKey INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeePositionSSID NVARCHAR(50)
,	EmployeePositionDescription NVARCHAR(50)
,	EmployeeFullName NVARCHAR(102)
,	EmployeeFirstName NVARCHAR(50)
,	EmployeeLastName NVARCHAR(50)
,	UserLogin NVARCHAR(50)
,	CenterNumber INT
,   CenterDescriptionNumber NVARCHAR(50)
,	CenterManager NVARCHAR(102)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	AreaManager NVARCHAR(102)
,	NoCRM INT
)


CREATE TABLE #Deferred (
       CenterNumber INT  NOT NULL
,      DeferredRevenueType NVARCHAR(50) NULL
,      SortOrder INT NULL
,      Revenue DECIMAL(18, 2) NULL
)


CREATE TABLE #RB_DR(
	CenterNumber INT NOT NULL
,	TotalPCPAmt_Actual DECIMAL(18, 2) NULL
)


CREATE TABLE #Receivable (
	CenterNumber INT
,	Receivable DECIMAL(18,4)
)


CREATE TABLE #Sales(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(200)
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterManager NVARCHAR(200)
,	AreaManager  NVARCHAR(200)
,	Upgrades INT
,	UpgradesRevenue DECIMAL(18,4)
,	BIOConversions INT
,	BIOConversionsRevenue DECIMAL(18,4)
,	EXTConversions INT
,	EXTConversionsRevenue DECIMAL(18,4)
,	XTRConversions INT
,	XTRConversionsRevenue DECIMAL(18,4)
,	MDP INT
,	MDPRevenue DECIMAL(18,4)
,	Laser INT
,	LaserRevenue DECIMAL(18,4)
,	Wigs INT
,	WigsRevenue DECIMAL(18,4)
,	NB_AppsCnt INT
)





/*********************** Begin populating the temp tables ***********************************************************/

--Find CenterNumbers using fnSplit
INSERT INTO #CenterNumberList
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumberList,',')


/********* This code is to set the correct CenterManager excluding inactive center managers  *************************/

IF @Position IN('AM')
BEGIN
INSERT INTO #CenterManager
SELECT  CTR.CenterKey
,	CTR.CenterNumber
,	CTR.CenterDescriptionNumber
,	NULL AS CenterManager
,	CTR.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	AREA.EmployeeFullName AS 'AreaManager'
,	'AreaManager' AS EmployeePositionDescription
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR		WITH(NOLOCK)
INNER JOIN #CenterNumberList CN
		ON CN.CenterNumber = CTR.CenterNumber
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT	WITH(NOLOCK)
		ON CT.CenterTypeKey = CTR.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA	WITH(NOLOCK)
		ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA	WITH(NOLOCK)
		ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE CTR.Active = 'Y'
	AND CMA.Active = 'Y'
END
ELSE
BEGIN
INSERT INTO #CenterManager
SELECT CTR.CenterKey
,	CN.CenterNumber
,	CTR.CenterDescriptionNumber
,	NULL AS CenterManager
,	CTR.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	AREA.EmployeeFullName AS 'AreaManager'
,	NULL AS EmployeePositionDescription
FROM #CenterNumberList CN
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR		WITH(NOLOCK)
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT	WITH(NOLOCK)
		ON CT.CenterTypeKey = CTR.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA	WITH(NOLOCK)
	ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA	WITH(NOLOCK)
	ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE CTR.Active = 'Y'
	AND CMA.Active = 'Y'
END


UPDATE CM
SET CM.CenterManager = E.EmployeeFullName
FROM #CenterManager CM
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH(NOLOCK)
	ON CTR.CenterNumber = CM.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E WITH(NOLOCK)
	ON E.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ	WITH(NOLOCK)
	ON E.EmployeeSSID = EPJ.EmployeeGUID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP	WITH(NOLOCK)
	ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
WHERE EP.EmployeePositionDescription IN('Manager')
       AND E.IsActiveFlag = 1
       AND E.EmployeeFullName NOT LIKE '%Test%'
       AND CTR.Active = 'Y' AND CTR.CenterNumber <> 100
       AND E.EmployeeFullName NOT IN( --These are inactive center managers
       'Ambe, Mara'
,      'Ardeleanu, Raluca'
,      'Atchley, Elissa'
,      'Calhoun, Rochelle'
,      'Chacon, Angela'
,	   'El-Dick, Joseph'
,      'Hickman, Natasha'
,      'Hitt, Erica'
,      'Holz, Jennifer'
,      'Johnson, Lasandra'
,      'Johnson, Lonzell'
,      'King, Sherri'
,      'Lyon, Deena'
,      'Mallard, Anthony'
,      'Masterson, Elizabeth'
,      'Mozafary, Mahmood'
,      'Myers, Caleena'
,      'Perez, Kalena'
,      'Riggi, JoAnn'
,      'Rivera Herth, Ginger'
,      'Rose Baker, Deana'
,      'Santos, Marco'
,      'Spencer, Keyana'
,      'Suddath, Sharon'
,      'Torres, Gladys'
,      'Vitale, Nicole'
,      'Wahl, Nolan'
,      'Wilson, Audrey'
)

--As of 11/13/2019

UPDATE CM
SET CM.CenterManager = 'Wehman, Mark'
FROM #CenterManager CM
WHERE CenterNumber = 290


UPDATE CM
SET CM.CenterManager = 'Wheat, Danielle'
FROM #CenterManager CM
WHERE CenterNumber = 231


UPDATE CM
SET CM.CenterManager = 'Larson, Denise'
FROM #CenterManager CM
WHERE CenterNumber = 222

UPDATE CM
SET CM.CenterManager = 'Kalra, Ricky'
FROM #CenterManager CM
WHERE CenterNumber = 258

UPDATE CM
SET CM.CenterManager = 'Kay, John'
FROM #CenterManager CM
WHERE CenterNumber = 202

UPDATE CM
SET CM.CenterManager = 'Redden, Kristen'
FROM #CenterManager CM
WHERE CenterNumber = 283

UPDATE CM
SET CM.CenterManager = 'Schurman, Matthew'
FROM #CenterManager CM
WHERE CenterNumber = 237

UPDATE CM
SET CM.CenterManager = 'Garrison, Duane'
FROM #CenterManager CM
WHERE CenterNumber = 280


UPDATE CM
SET CM.CenterManager = 'Petersen,Tina'
FROM #CenterManager CM
WHERE CenterNumber = 232

UPDATE CM
SET CM.CenterManager = 'Hudson, William'
FROM #CenterManager CM
WHERE CenterNumber = 259

UPDATE CM
SET CM.CenterManager = 'Corbella, Fernan'
FROM #CenterManager CM
WHERE CenterNumber = 216


UPDATE CM
SET CM.CenterManager = 'Gonzales, Alexander'
FROM #CenterManager CM
WHERE CenterNumber = 278

UPDATE CM
SET CM.CenterManager = 'Gonzales, Alexander'
FROM #CenterManager CM
WHERE CenterNumber = 271

UPDATE CM
SET CM.CenterManager = 'Garrison, Duane'
FROM #CenterManager CM
WHERE CenterNumber = 286

UPDATE CM
SET CM.CenterManager = 'Ziman, Todd'
FROM #CenterManager CM
WHERE CenterNumber = 217

UPDATE CM
SET CM.CenterManager = 'Boyd, Chet'
FROM #CenterManager CM
WHERE CenterNumber = 272

UPDATE CM
SET CM.CenterManager = 'Ziman, Todd'
FROM #CenterManager CM
WHERE CenterNumber = 205

UPDATE CM
SET CM.CenterManager = 'Petersen,Tina'
FROM #CenterManager CM
WHERE CenterNumber = 266

UPDATE CM
SET CM.CenterManager = 'Kalra, Ricky'
FROM #CenterManager CM
WHERE CenterNumber = 269

--SELECT '#CenterManager' AS tablename,*
--FROM #CenterManager
--ORDER BY CenterDescriptionNumber


/************************ Find consultants according to @Position ***********************/

--Find consultants
IF @Position IN('CRM')  ----This is for CRM's
BEGIN
INSERT INTO #Employee
SELECT e.EmployeeKey
,	e.EmployeeSSID
,	ep.EmployeePositionSSID
,	ep.EmployeePositionDescription
,	e.EmployeeFullName
,	e.EmployeeFirstName
,	e.EmployeeLastName
,	e.UserLogin
,	CN.CenterNumber
,	CTR.CenterDescriptionNumber
,	CMGR.CenterManager
,	CMA.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	AREA.EmployeeFullName AS AreaManager
,	NULL AS NoCRM
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR	WITH(NOLOCK)
	INNER JOIN #CenterNumberList CN	--Include where there is no center manager
		ON CN.CenterNumber = CTR.CenterNumber
	INNER JOIN #CenterManager CMGR
			ON CMGR.CenterNumber = CTR.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e	WITH(NOLOCK)
		ON e.CenterSSID = CTR.CenterSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj	WITH(NOLOCK)
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep	WITH(NOLOCK)
		ON epj.EmployeePositionID = ep.EmployeePositionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA	WITH(NOLOCK)
		ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA	WITH(NOLOCK)
		ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE  e.IsActiveFlag = 1
	AND e.EmployeeFullName NOT LIKE '%Test%'
	AND ep.EmployeePositionDescription IN('Client Relationship Manager')
	AND E.EmployeeKey = @EmployeeKey
END
ELSE
--Find consultants
IF @Position IN('MULTI')  ----This is for multiple centers
BEGIN
INSERT INTO #Employee
SELECT e.EmployeeKey
,	e.EmployeeSSID
,	ep.EmployeePositionSSID
,	ep.EmployeePositionDescription
,	e.EmployeeFullName
,	e.EmployeeFirstName
,	e.EmployeeLastName
,	e.UserLogin
,	CN.CenterNumber
,	CTR.CenterDescriptionNumber
,	CMGR.CenterManager
,	CMA.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	AREA.EmployeeFullName AS AreaManager
,	NULL AS NoCRM
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR	WITH(NOLOCK)
	INNER JOIN #CenterNumberList CN	--Include where there is no center manager
		ON CN.CenterNumber = CTR.CenterNumber
	INNER JOIN #CenterManager CMGR
			ON CMGR.CenterNumber = CTR.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e	WITH(NOLOCK)
		ON e.CenterSSID = CTR.CenterSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj	WITH(NOLOCK)
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep	WITH(NOLOCK)
		ON epj.EmployeePositionID = ep.EmployeePositionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA	WITH(NOLOCK)
		ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA	WITH(NOLOCK)
		ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE  e.IsActiveFlag = 1
	AND e.EmployeeFullName NOT LIKE '%Test%'
	AND ep.EmployeePositionDescription IN('Client Relationship Manager')


--Populate #Employee with missing centers
INSERT INTO #Employee
(
	EmployeeKey,
	EmployeeSSID,
	EmployeePositionSSID,
	EmployeePositionDescription,
	EmployeeFullName,
	EmployeeFirstName,
	EmployeeLastName,
	UserLogin,
	CenterNumber,
	CenterDescriptionNumber,
	CenterManager,
	CenterManagementAreaSSID,
	CenterManagementAreaDescription,
	AreaManager
)
SELECT NULL AS EmployeeKey
,	NULL AS EmployeeSSID
,	NULL AS EmployeePositionSSID
,	NULL AS EmployeePositionDescription
,	NULL AS EmployeeFullName
,	NULL AS EmployeeFirstName
,	NULL AS EmployeeLastName
,	NULL AS UserLogin
,	CenterNumber
,	CenterDescriptionNumber
,	CenterManager
,	CenterManagementAreaSSID
,	CenterManagementAreaDescription
,	AreaManager
FROM #CenterManager CRM
WHERE CRM.CenterNumber NOT IN(SELECT CenterNumber FROM #Employee)



--UPDATE #Employee missing center with the CenterManager if there is no CRM

UPDATE E
SET E.EmployeeFullName = CRM.CenterManager
FROM #Employee E
INNER JOIN #CenterManager CRM
ON CRM.CenterNumber = E.CenterNumber
WHERE E.EmployeeFullName IS NULL



--UPDATE #Employee missing center with the AreaManager if there is no CRM

UPDATE E
SET E.EmployeeFullName = CRM.AreaManager
FROM #Employee E
INNER JOIN #CenterManager CRM
ON CRM.CenterNumber = E.CenterNumber
WHERE E.EmployeeFullName IS NULL


END

/*************** Populate #Employee for other positions **********************/
ELSE
IF @Position = 'CM'
BEGIN
	INSERT INTO #Employee
	(

		EmployeePositionDescription,
		CenterNumber,
		CenterDescriptionNumber,
		CenterManager,
		CenterManagementAreaSSID,
		CenterManagementAreaDescription,
		AreaManager
	)
	SELECT EmployeePositionDescription,
           CenterNumber,
           CenterDescriptionNumber,
           CenterManager,
           CenterManagementAreaSSID,
           CenterManagementAreaDescription,
           AreaManager

	FROM #CenterManager



--UPDATE #Employee missing center with the CenterManager if there is no CRM

UPDATE E
SET E.EmployeeFullName = CRM.CenterManager
FROM #Employee E
INNER JOIN #CenterManager CRM
ON CRM.CenterNumber = E.CenterNumber
WHERE E.EmployeeFullName IS NULL


END
ELSE IF  @Position = 'AM'
BEGIN
INSERT INTO #Employee
(
    EmployeeKey,
    EmployeeSSID,
    EmployeePositionSSID,
    EmployeePositionDescription,
    EmployeeFullName,
    EmployeeFirstName,
    EmployeeLastName,
    UserLogin,
    CenterNumber,
    CenterDescriptionNumber,
    CenterManager,
    CenterManagementAreaSSID,
    CenterManagementAreaDescription,
    AreaManager
)
SELECT NULL AS EmployeeKey
,	e.EmployeeSSID
,	ep.EmployeePositionSSID
,	ep.EmployeePositionDescription
,	e.EmployeeFullName
,	e.EmployeeFirstName
,	e.EmployeeLastName
,	e.UserLogin
,	CTR.CenterNumber
,	CTR.CenterDescriptionNumber
,	NULL AS CenterManager
,	CMA.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	AREA.EmployeeFullName AS AreaManager
FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e	WITH(NOLOCK)
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj	WITH(NOLOCK)
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep	WITH(NOLOCK)
		ON epj.EmployeePositionID = ep.EmployeePositionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA	WITH(NOLOCK)
		ON e.EmployeeSSID = CMA.OperationsManagerSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR	WITH(NOLOCK)
		ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
	INNER JOIN #CenterNumberList CN
		ON CN.CenterNumber = CTR.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA	WITH(NOLOCK)
		ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE ep.EmployeePositionDescription = 'Area Manager'
	AND e.EmployeeFullName NOT LIKE '%Test%'


	--UPDATE #Employee missing center with the AreaManager if there is no CRM

UPDATE E
SET E.EmployeeFullName = CRM.AreaManager
FROM #Employee E
INNER JOIN #CenterManager CRM
ON CRM.CenterNumber = E.CenterNumber
WHERE E.EmployeeFullName IS NULL

END

UPDATE #Employee
SET NoCRM = 0
WHERE EmployeeKey IS NOT NULL


UPDATE #Employee
SET NoCRM = 1
WHERE EmployeeKey IS NULL

--SELECT '#Employee' AS tablename,* FROM #Employee


/********************************** Get Deferred Revenue Type Data *************************************/
INSERT INTO #Deferred (
       CenterNumber
,      DeferredRevenueType
,      SortOrder
,      Revenue
)
SELECT  CNL.CenterNumber
,		drt.TypeDescription
,		drt.SortOrder
,		0 AS Revenue
FROM   HC_DeferredRevenue_DAILY.dbo.DimDeferredRevenueType drt, #CenterNumberList CNL

--SELECT '#Deferred1'AS tablename, * FROM #Deferred
/********************************** Get Revenue for the specific center & period **************************************************/

UPDATE d
SET d.Revenue = o_R.Revenue
FROM   #Deferred d
              OUTER APPLY ( SELECT ISNULL(ROUND(SUM(drd.Revenue), 2), 0) AS Revenue
                                         FROM   HC_DeferredRevenue_DAILY.dbo.vwDeferredRevenueDetails drd
                                         WHERE  drd.Center = d.CenterNumber
                                                       AND drd.DeferredRevenueType = d.DeferredRevenueType
                                                       AND drd.Period = @StartDate ) o_R
              INNER JOIN HC_DeferredRevenue_DAILY.dbo.vwDeferredRevenueDetails drd
                     ON drd.DeferredRevenueType = d.DeferredRevenueType
                     AND drd.Center = d.CenterNumber

--SELECT '#Deferred2'AS tablename, * FROM #Deferred

/********************************** Find Recurring Business Revenue as TotalPCPAmt_Actual *******************************************/
INSERT INTO #RB_DR
SELECT y.CenterNumber
,       SUM(ISNULL(y.Revenue,0)) AS TotalPCPAmt_Actual
FROM (	SELECT CenterNumber
		,   CASE WHEN drt.DeferredRevenueType LIKE 'Recurring Business%' THEN 'Recurring Business'
				WHEN  drt.DeferredRevenueType LIKE 'Non-Program%' THEN 'Non-Program'
				 END AS DeferredRevenueType
		,       SUM(ISNULL(Revenue,0)) AS Revenue
		FROM #Deferred drt
		WHERE (drt.DeferredRevenueType = 'Recurring Business' OR drt.DeferredRevenueType = 'Non-Program')
		GROUP BY CenterNumber
		,       DeferredRevenueType
		) y
GROUP BY y.CenterNumber

--SELECT '#RB_DR' AS tablename, * FROM #RB_DR

/********* Find Budget and Actual Amounts **************************************************/

SELECT CNL.CenterNumber
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BIOConversionsActual'  --BIO only
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'BIOConversionsBudget'	--BIO only
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Flash ELSE 0 END, 0)) AS 'EXTConversionsActual'  --EXT only
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'EXTConversionsBudget'	--EXT only
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Flash ELSE 0 END, 0)) AS 'XtrandsConversionsActual'  --Xtrands only
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'XtrandsConversionsBudget'	--Xtrands only
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10555) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10555) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'RetailBudget'	--Retail
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'ServiceBudget'	--Service
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN ABS(Budget) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN ABS(Budget) ELSE 0 END, 0)) END AS 'PCPRevenueBudget'	--BIO,EXT and Xtrands
INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA	WITH(NOLOCK)
	INNER JOIN #CenterNumberList CNL
		ON FA.CenterID = CNL.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C	WITH(NOLOCK)
		ON C.CenterNumber = CNL.CenterNumber
	WHERE FA.PartitionDate BETWEEN @StartDate AND @EndDate
GROUP BY CNL.CenterNumber


/**********Find Retail sales per center ***************************************************/


CREATE TABLE #CtrRetailSales(
CenterNumber INT
,	CtrRetailSales DECIMAL(18,4)
)


INSERT  INTO #CtrRetailSales
        SELECT  CNL.CenterNumber
		,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'CtrRetailSales'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST	WITH(NOLOCK)
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d 	WITH(NOLOCK)
			ON d.DateKey = FST.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod	WITH(NOLOCK)
			ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c	WITH(NOLOCK)
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #CenterNumberList CNL
            ON c.CenterNumber = CNL.CenterNumber
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc		WITH(NOLOCK)
			ON FST.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd	WITH(NOLOCK)
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   d.FullDate BETWEEN @StartDate AND @EndDate
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
		GROUP BY CNL.CenterNumber

	--SELECT '#CtrRetailSales' AS tablename,* FROM #CtrRetailSales



/********************************** Get Open PCP data *************************************/

CREATE TABLE #OpenPCP(
	CenterNumber INT
,	PCPBegin INT
,	YearPCPBegin INT
,	BIOopenPCP INT
,	EXTMEMopenPCP INT
,	XTRopenPCP INT
,	BIOopenPCPBudget INT
,	EXTMEMopenPCPBudget INT
,	XTRopenPCPBudget INT
)

--Set @OpenPCPDate to beginning of the year
DECLARE @OpenPCPDate DATETIME
SET @OpenPCPDate = @BeginningOfTheYear

--PRINT '@OpenPCPDate = ' + cast(@OpenPCPDate as NVARCHAR(12))

INSERT INTO #OpenPCP
select s.CenterNumber
,       s.PCPBegin
,       s.YearPCPBegin
,       SUM(s.BIOopenPCP) AS BIOopenPCP
,       SUM(s.EXTMEMopenPCP) AS EXTMEMopenPCP
,       SUM(s.XTRopenPCP) AS XTRopenPCP
,       SUM(s.BIOopenPCPBudget) AS BIOopenPCPBudget
,       SUM(s.EXTMEMopenPCPBudget) AS EXTMEMopenPCPBudget
,       SUM(s.XTRopenPCPBudget) AS XTRopenPCPBudget
from(
SELECT  a.CenterID AS 'CenterNumber'
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate)) AS 'PCPBegin'
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate)) AS 'YearPCPBegin'
,	CASE WHEN a.AccountID = 10400 THEN ISNULL(a.Flash,0) ELSE 0 END AS 'BIOopenPCP'
,	CASE WHEN a.AccountID = 10405 THEN ISNULL(a.Flash,0) ELSE 0 END AS 'EXTMEMopenPCP'
,	CASE WHEN a.AccountID = 10401 THEN ISNULL(a.Flash,0) ELSE 0 END AS 'XTRopenPCP'
,	CASE WHEN a.AccountID = 10400 THEN (ISNULL(a.Flash,0)+ 1) ELSE 0 END AS 'BIOopenPCPBudget'
,	CASE WHEN a.AccountID = 10405 THEN (ISNULL(a.Flash,0)+ 1) ELSE 0 END AS 'EXTMEMopenPCPBudget'
,	CASE WHEN a.AccountID = 10401 THEN (ISNULL(a.Flash,0)+ 1) ELSE 0 END AS 'XTRopenPCPBudget'
FROM    HC_Accounting.dbo.FactAccounting a
        INNER JOIN #CenterNumberList CNL
            ON a.CenterID = CNL.CenterNumber
WHERE   MONTH(a.PartitionDate) = MONTH(@OpenPCPDate)
        AND YEAR(a.PartitionDate) = YEAR(@OpenPCPDate)
        AND a.AccountID IN(10400,10401,10405)
)s
GROUP BY s.CenterNumber
,       s.PCPBegin
,       s.YearPCPBegin

--SELECT '#OpenPCP' AS tablename,* FROM #OpenPCP

/**************** Find PCP Counts per center *******************************************/


CREATE TABLE #ClosePCP(
	CenterNumber INT
,	PCPEnd INT
,	YearPCPEnd INT
,	BIOClosePCP INT
,	EXTMEMClosePCP INT
,	XTRClosePCP INT
)

INSERT INTO #ClosePCP
SELECT u.CenterNumber
,       u.PCPEnd
,       u.YearPCPEnd
,       SUM(u.BIOClosePCP) AS BIOClosePCP
,       SUM(u.EXTMEMClosePCP) AS EXTMEMClosePCP
,       SUM(u.XTRClosePCP) AS  XTRClosePCP
FROM
(SELECT  b.CenterID AS 'CenterNumber'   --CenterID matches CenterNumber in FactAccounting
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate)) AS 'PCPEnd'
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate)) AS 'YearPCPEnd'
,	CASE WHEN b.AccountID = 10400 THEN ISNULL(b.Flash,0) ELSE 0 END AS 'BIOClosePCP'
,	CASE WHEN b.AccountID = 10405 THEN ISNULL(b.Flash,0) ELSE 0 END AS 'EXTMEMClosePCP'
,	CASE WHEN b.AccountID = 10401 THEN ISNULL(b.Flash,0) ELSE 0 END AS 'XTRClosePCP'
FROM    HC_Accounting.dbo.FactAccounting b
        INNER JOIN #CenterNumberList CNL
            ON b.CenterID = CNL.CenterNumber
WHERE   MONTH(b.PartitionDate) = MONTH(@EndDate)
        AND YEAR(b.PartitionDate) = YEAR(@EndDate)
        AND b.AccountID IN(10400,10401,10405)
)u
GROUP BY u.CenterNumber
,         u.PCPEnd
,         u.YearPCPEnd



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
			INNER JOIN #CenterNumberList CNL
				ON C.CenterNumber = CNL.CenterNumber
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
				ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON CM.MembershipSSID = M.MembershipSSID
	WHERE   DD.FullDate = @ReceivablesDate
		AND M.RevenueGroupSSID = 2
		AND FR.Balance >= 0
		) b
WHERE Ranking = 1
GROUP BY CenterNumber


/**************** Find Sales and counts per center ************************************/

CREATE TABLE #SalesCenter(
	CenterNumber INT
,	CtrRetailAmt DECIMAL(18,4)
,	CtrServiceAmt DECIMAL(18,4)
,	Upgrades INT
,	UpgradesRevenue DECIMAL(18,4)
,	BIOConversions INT
,	BIOConversionsRevenue DECIMAL(18,4)
,	EXTConversions INT
,	EXTConversionsRevenue DECIMAL(18,4)
,	XTRConversions INT
,	XTRConversionsRevenue DECIMAL(18,4)
,	MDP INT
,	MDPRevenue DECIMAL(18,4)
,	Laser INT
,	LaserRevenue DECIMAL(18,4)
,	Wigs INT
,	WigsRevenue DECIMAL(18,4)
,	NB_AppsCnt INT
,	PCP_NB2Amt DECIMAL(18,4)
,	TotalPCPAmt_Actual DECIMAL(18,4)
,	CtrReceivable DECIMAL(18,4)
,	BIOopenPCP INT
,	EXTMEMopenPCP INT
,	XTRopenPCP INT
,	BIOopenPCPBudget INT
,	EXTMEMopenPCPBudget INT
,	XTRopenPCPBudget INT
,	BIOclosePCP INT
,	EXTMEMclosePCP INT
,	XTRclosePCP INT
 )

INSERT INTO	#SalesCenter
		SELECT  CNL.CenterNumber
		,	NULL AS CtrRetailAmt
		,	SUM(ISNULL(FST.ServiceAmt,'0')) AS CtrServiceAmt
		,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID = 1070 THEN 1 ELSE 0 END) AS 'Upgrades'
		,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID = 1070 THEN ISNULL(FST.ExtendedPrice,'0') ELSE '0' END) AS 'UpgradesRevenue'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 1075 AND ISNULL(FST.NB_BIOCOnvCnt,0) = 1 THEN 1 ELSE 0 END) AS 'BIOConversions'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 1075 AND ISNULL(FST.NB_BIOCOnvCnt,'0') = 1 THEN FST.ExtendedPrice ELSE '0' END) AS 'BIOConversionsRevenue'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 1075 AND ISNULL(FST.NB_EXTCOnvCnt,0) = 1 THEN 1 ELSE 0 END) AS 'EXTConversions'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 1075 AND ISNULL(FST.NB_EXTCOnvCnt,'0') = 1 THEN FST.ExtendedPrice ELSE '0' END) AS 'EXTConversionsRevenue'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 1075 AND ISNULL(FST.NB_XTRCOnvCnt,0) = 1 THEN 1 ELSE 0 END) AS 'XTRConversions'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 1075 AND ISNULL(FST.NB_XTRCOnvCnt,'0') = 1 THEN FST.ExtendedPrice ELSE '0' END) AS 'XTRConversionsRevenue'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 5062 THEN 1 ELSE 0 END) AS 'MDP'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 5062 THEN ISNULL(FST.ExtendedPrice,'0') ELSE '0' END) AS 'MDPRevenue'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 3065 AND FST.PCP_LaserCnt = 1 THEN 1 ELSE 0 END) AS 'Laser'
		,	SUM(CASE WHEN  SC.SalesCodeDepartmentSSID = 3065 AND ISNULL(FST.PCP_LaserAmt,'0') > '0'  THEN  FST.ExtendedPrice ELSE '0' END) AS 'LaserRevenue'
		,	SUM(CASE WHEN  (SC.SalesCodeDepartmentSSID = 7052 OR (SC.SalesCodeDepartmentSSID = 3080 AND SC.SalesCodeDescription LIKE 'Halo%')) THEN 1 ELSE 0 END) AS 'Wigs'
		,	SUM(CASE WHEN  (SC.SalesCodeDepartmentSSID = 7052 OR (SC.SalesCodeDepartmentSSID = 3080 AND SC.SalesCodeDescription LIKE 'Halo%')) THEN  FST.ExtendedPrice ELSE '0' END) AS 'WigsRevenue'
		,	SUM(ISNULL(FST.NB_AppsCnt,0)) AS 'NB_AppsCnt'
		,	SUM(ISNULL(FST.PCP_NB2Amt,0)) AS 'PCP_NB2Amt'
		,	NULL AS TotalPCPAmt_Actual
		,	NULL AS CtrReceivable
		,	NULL AS BIOopenPCP
		,	NULL AS EXTMEMopenPCP
		,	NULL AS XTRopenPCP
		,	NULL AS BIOopenPCPBudget
		,	NULL AS EXTMEMopenPCPBudget
		,	NULL AS XTRopenPCPBudget
		,	NULL AS BIOclosePCP
		,	NULL AS EXTMEMclosePCP
		,	NULL AS XTRclosePCP
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
							ON FST.OrderDateKey = DD.DateKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
							ON FST.SalesOrderKey = SO.SalesOrderKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
							ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
							ON SO.ClientMembershipKey = CM.ClientMembershipKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
							ON CM.CenterKey = C.CenterKey       --KEEP HomeCenter Based
						INNER JOIN #CenterNumberList CNL
							ON C.CenterNumber = CNL.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
							ON FST.SalesCodeKey = SC.SalesCodeKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
							ON CM.MembershipSSID = M.MembershipSSID
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND SOD.IsVoidedFlag = 0
		GROUP BY CNL.CenterNumber




UPDATE SC
SET SC.CtrRetailAmt = CtrRetail.CtrRetailSales
FROM #SalesCenter SC
INNER JOIN #CtrRetailSales CtrRetail
	ON CtrRetail.CenterNumber = SC.CenterNumber
WHERE SC.CtrRetailAmt IS NULL


UPDATE SC
SET SC.TotalPCPAmt_Actual = RB_DR.TotalPCPAmt_Actual
FROM #SalesCenter SC
INNER JOIN #RB_DR RB_DR
	ON RB_DR.CenterNumber = SC.CenterNumber
WHERE SC.TotalPCPAmt_Actual IS NULL

UPDATE SC
SET SC.CtrReceivable = REC.Receivable
FROM #SalesCenter SC
INNER JOIN #Receivable REC
	ON REC.CenterNumber = SC.CenterNumber
WHERE SC.CtrReceivable IS NULL

/***** PCP Counts ********/

UPDATE SC
SET SC.BIOopenPCP = PCPOpen.BIOopenPCP				--1
FROM #SalesCenter SC
INNER JOIN #OpenPCP PCPOpen
	ON PCPOpen.CenterNumber = SC.CenterNumber
WHERE SC.BIOopenPCP IS NULL

UPDATE SC
SET SC.EXTMEMopenPCP = PCPOpen.EXTMEMopenPCP
FROM #SalesCenter SC
INNER JOIN #OpenPCP PCPOpen
	ON PCPOpen.CenterNumber = SC.CenterNumber
WHERE SC.EXTMEMopenPCP IS NULL

UPDATE SC
SET SC.XTRopenPCP = PCPOpen.XTRopenPCP			--3
FROM #SalesCenter SC
INNER JOIN #OpenPCP PCPOpen
	ON PCPOpen.CenterNumber = SC.CenterNumber
WHERE SC.XTRopenPCP IS NULL

UPDATE SC
SET SC.BIOopenPCPBudget = PCPOpen.BIOopenPCPBudget
FROM #SalesCenter SC
INNER JOIN #OpenPCP PCPOpen
	ON PCPOpen.CenterNumber = SC.CenterNumber
WHERE SC.BIOopenPCPBudget IS NULL

UPDATE SC
SET SC.EXTMEMopenPCPBudget = PCPOpen.EXTMEMopenPCPBudget	--5
FROM #SalesCenter SC
INNER JOIN #OpenPCP PCPOpen
	ON PCPOpen.CenterNumber = SC.CenterNumber
WHERE SC.EXTMEMopenPCPBudget IS NULL

UPDATE SC
SET SC.XTRopenPCPBudget = PCPOpen.XTRopenPCPBudget
FROM #SalesCenter SC
INNER JOIN #OpenPCP PCPOpen
	ON PCPOpen.CenterNumber = SC.CenterNumber
WHERE SC.XTRopenPCPBudget IS NULL

UPDATE SC
SET SC.BIOclosePCP = PCPClose.BIOclosePCP				--7
FROM #SalesCenter SC
INNER JOIN #ClosePCP PCPClose
	ON PCPClose.CenterNumber = SC.CenterNumber
WHERE SC.BIOclosePCP IS NULL

UPDATE SC
SET SC.EXTMEMclosePCP = PCPClose.EXTMEMclosePCP
FROM #SalesCenter SC
INNER JOIN #ClosePCP PCPClose
	ON PCPClose.CenterNumber = SC.CenterNumber
WHERE SC.EXTMEMclosePCP IS NULL

UPDATE SC
SET SC.XTRclosePCP = PCPClose.XTRclosePCP			--9
FROM #SalesCenter SC
INNER JOIN #ClosePCP PCPClose
	ON PCPClose.CenterNumber = SC.CenterNumber
WHERE SC.XTRclosePCP IS NULL


/****************** Find AddOns ***********************************************************/

CREATE TABLE #AddOns(
	MainGroupID INT
,       MainGroup NVARCHAR(50)
,       MainGroupSortOrder INT
,       CenterNumber INT
,       CenterSSID INT
,       CenterDescription NVARCHAR(50)
,       CenterDescriptionNumber NVARCHAR(104)
,       CenterTypeDescription NVARCHAR(50)
,       ClientIdentifier INT
,       ClientLastName NVARCHAR(50)
,       ClientFirstName NVARCHAR(50)
,       MembershipDescription NVARCHAR(50)
,		CANCELADDON INT
,	    OmbreCnt  INT
,       OmbreAmt DECIMAL(18,4)
,       ExLaceCnt INT
,       ExLaceAmt DECIMAL(18,4)
,       LongHairCnt INT
,       LongHairAmt DECIMAL(18,4)
,       SignatureCnt INT
,       SignatureAmt DECIMAL(18,4)
,       SSCnt INT
,       SSAmt DECIMAL(18,4)
,       PKCnt INT
,       PKAmt DECIMAL(18,4)
,		NSDCnt INT
,		NSDAmt DECIMAL(18,4)
,		CHCnt INT
,		CHAmt DECIMAL(18,4)
,		SVCnt INT
,		SVAmt DECIMAL(18,4)
,	   TotalCnt INT
,	   TotalAmt DECIMAL(18,4)
)

INSERT INTO #AddOns
EXEC [spRpt_FlashRecurringBusinessAddOns] @StartDate, @EndDate, 'C', 3



CREATE TABLE #TotalAddOns(
	CenterNumber INT
,	TotalAddOnCnt INT
,	TotalAddOnAmt DECIMAL(18,4)
)

INSERT INTO  #TotalAddOns
SELECT CenterNumber
,	SUM(ISNULL(TotalCnt,0)) AS TotalAddOnCnt
,	SUM(ISNULL(TotalAmt,'0')) AS TotalAddOnAmt
FROM #AddOns
GROUP BY CenterNumber


/****************************  Select for Totals  ************************************************************************/

CREATE TABLE #Totals(
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,   EmployeeKey INT
,	EmployeeFullName NVARCHAR(200)
,	CenterManagementAreaDescription NVARCHAR(104)
,	CenterManager NVARCHAR(200)
,	AreaManager NVARCHAR(200)

,   BIOConversionsActual INT
,   BIOConversionsBudget INT
,   EXTConversionsActual INT
,   EXTConversionsBudget INT
,   XtrandsConversionsActual INT
,   XtrandsConversionsBudget INT

,   PCPRevenueBudget DECIMAL(18,4)
,   RetailBudget  DECIMAL(18,4)
,   ServiceBudget DECIMAL(18,4)

,   Upgrades INT
,   UpgradesRevenue DECIMAL(18,4)
,   MDP INT
,   MDPRevenue DECIMAL(18,4)
,   Laser INT
,   LaserRevenue DECIMAL(18,4)
,   Wigs INT
,   WigsRevenue DECIMAL(18,4)

,	NB_AppsCnt INT
,   CtrRetailAmt DECIMAL(18,4)
,   CtrServiceAmt DECIMAL(18,4)

,	PCP_NB2Amt DECIMAL(18,4)
,   TotalPCPAmt_Actual DECIMAL(18,4)
,   Receivable DECIMAL(18,4)

,	BIOopenPCP INT
,	EXTMEMopenPCP INT
,	XTRopenPCP INT
,	BIOopenPCPBudget INT
,	EXTMEMopenPCPBudget INT
,	XTRopenPCPBudget INT
,	BIOclosePCP INT
,	EXTMEMclosePCP INT
,	XTRclosePCP INT

,	BIOConversionDiff INT
,	BIOConversionPercent DECIMAL(18,4)
,	EXTConversionDiff  INT
,	EXTConversionPercent  DECIMAL(18,4)
,	XTRConversionDiff INT
,	XTRConversionPercent DECIMAL(18,4)

,	TotalAddOnCnt INT
,	TotalAddOnAmt DECIMAL(18,4)

,	StartDate DATE
,	EndDate DATE
,	NoCRM INT
,	TotalActual DECIMAL(18,4)
,	TotalBudget DECIMAL(18,4)
)

INSERT INTO #Totals
		SELECT SC.CenterNumber
		,	E.CenterDescriptionNumber
		,	E.EmployeeKey
		,	E.EmployeeFullName
		,	E.CenterManagementAreaDescription
		,	E.CenterManager
		,	E.AreaManager

		,	ISNULL(SC.BIOConversions,0) AS 'BIOConversionsActual'
		,	CASE WHEN ROUND(ISNULL(A.BIOConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.BIOConversionsBudget,0),0) END AS 'BIOConversionsBudget'
		,	ISNULL(SC.EXTConversions,0) AS 'EXTConversionsActual'
		,	CASE WHEN ROUND(ISNULL(A.EXTConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.EXTConversionsBudget,0),0) END AS 'EXTConversionsBudget'
		,	ISNULL(SC.XTRConversions,0) AS 'XtrandsConversionsActual'
		,	CASE WHEN ROUND(ISNULL(A.XtrandsConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.XtrandsConversionsBudget,0),0) END AS 'XtrandsConversionsBudget'

		,	CASE WHEN ROUND(ISNULL(A.PCPRevenueBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.PCPRevenueBudget,0),0) END AS 'PCPRevenueBudget'
		,	CASE WHEN ROUND(ISNULL(A.RetailBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.RetailBudget,0),0) END AS 'RetailBudget'
		,	CASE WHEN ROUND(ISNULL(A.ServiceBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.ServiceBudget,0),0) END AS 'ServiceBudget'

		,	ISNULL(SC.Upgrades,0) AS 'Upgrades'
		,	ISNULL(SC.UpgradesRevenue,0) AS 'UpgradesRevenue'
		,	ISNULL(SC.MDP, 0) AS 'MDP'
		,	ISNULL(SC.MDPRevenue, 0) AS 'MDPRevenue'
		,	ISNULL(SC.Laser, 0) AS 'Laser'
		,	ISNULL(SC.LaserRevenue, 0) AS 'LaserRevenue'
		,	ISNULL(SC.Wigs, 0) AS 'Wigs'
		,	ISNULL(SC.WigsRevenue, 0) AS 'WigsRevenue'

		,	ISNULL(SC.NB_AppsCnt,0) AS 'NB_AppsCnt'
		,	ISNULL(SC.CtrRetailAmt, 0) AS 'CtrRetailAmt'
		,	ISNULL(SC.CtrServiceAmt, 0) AS 'CtrServiceAmt'

		,	ISNULL(SC.PCP_NB2Amt,0) AS 'PCP_NB2Amt'
		,	ISNULL(SC.TotalPCPAmt_Actual, 0) AS 'TotalPCPAmt_Actual'
		,	ISNULL(SC.CtrReceivable,0) AS 'Receivable'

		,	ISNULL(SC.BIOopenPCP, 0) AS 'BIOopenPCP'
		,	ISNULL(SC.EXTMEMopenPCP, 0) AS 'EXTMEMopenPCP'
		,	ISNULL(SC.XTRopenPCP, 0) AS 'XTRopenPCP'
		,	ISNULL(SC.BIOopenPCPBudget, 0) AS 'BIOopenPCPBudget'
		,	ISNULL(SC.EXTMEMopenPCPBudget, 0) AS 'EXTMEMopenPCPBudget'
		,	ISNULL(SC.XTRopenPCPBudget, 0) AS 'XTRopenPCPBudget'
		,	ISNULL(SC.BIOclosePCP, 0) AS 'BIOclosePCP'
		,	ISNULL(SC.EXTMEMclosePCP, 0) AS 'EXTMEMclosePCP'
		,	ISNULL(SC.XTRclosePCP, 0) AS 'XTRclosePCP'

		,	NULL AS BIOConversionDiff
		,	NULL AS BIOConversionPercent
		,	NULL AS EXTConversionDiff
		,	NULL AS EXTConversionPercent
		,	NULL AS XTRConversionDiff
		,	NULL AS XTRConversionPercent

		,	TAO.TotalAddOnCnt
		,	TAO.TotalAddOnAmt

		,	@StartDate AS 'StartDate'
		,	@EndDate AS 'EndDate'
		,	E.NoCRM
		,	NULL AS TotalActual
		,	NULL AS TotalBudget
		FROM #Accounting A
			INNER JOIN #CenterNumberList CNL
				ON A.CenterNumber = CNL.CenterNumber
			LEFT JOIN #Employee E
				ON E.CenterNumber = CNL.CenterNumber
			LEFT JOIN #SalesCenter SC
				ON CNL.CenterNumber = SC.CenterNumber
			LEFT JOIN #TotalAddOns TAO
				ON  CNL.CenterNumber = TAO.CenterNumber
		GROUP BY SC.CenterNumber
		,	E.CenterDescriptionNumber
		,	E.EmployeeKey
		,	E.EmployeeFullName
		,	E.CenterManagementAreaDescription
		,	E.CenterManager
		,	E.AreaManager
		,	ISNULL(SC.BIOConversions,0)
		,	CASE WHEN ROUND(ISNULL(A.BIOConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.BIOConversionsBudget,0),0) END
		,	ISNULL(SC.EXTConversions,0)
		,	CASE WHEN ROUND(ISNULL(A.EXTConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.EXTConversionsBudget,0),0) END
		,	ISNULL(SC.XTRConversions,0)
		,	CASE WHEN ROUND(ISNULL(A.XtrandsConversionsBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.XtrandsConversionsBudget,0),0) END
		,	CASE WHEN ROUND(ISNULL(A.PCPRevenueBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.PCPRevenueBudget,0),0) END
		,	CASE WHEN ROUND(ISNULL(A.RetailBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.RetailBudget,0),0) END
		,	CASE WHEN ROUND(ISNULL(A.ServiceBudget,0),0) = 0 THEN 1 ELSE ROUND(ISNULL(A.ServiceBudget,0),0) END
		,	ISNULL(SC.Upgrades,0)
		,	ISNULL(SC.UpgradesRevenue,0)
		,	ISNULL(SC.MDP, 0)
		,	ISNULL(SC.MDPRevenue, 0)
		,	ISNULL(SC.Laser, 0)
		,	ISNULL(SC.LaserRevenue, 0)
		,	ISNULL(SC.Wigs, 0)
		,	ISNULL(SC.WigsRevenue, 0)
		,	ISNULL(SC.NB_AppsCnt,0)

		,	ISNULL(SC.CtrRetailAmt, 0)
		,	ISNULL(SC.CtrServiceAmt, 0)
		,	ISNULL(SC.PCP_NB2Amt,0)
		,	ISNULL(SC.TotalPCPAmt_Actual, 0)
		,	ISNULL(SC.CtrReceivable, 0)

		,	ISNULL(SC.BIOopenPCP, 0)
		,	ISNULL(SC.EXTMEMopenPCP, 0)
		,	ISNULL(SC.XTRopenPCP, 0)
		,	ISNULL(SC.BIOopenPCPBudget, 0)
		,	ISNULL(SC.EXTMEMopenPCPBudget, 0)
		,	ISNULL(SC.XTRopenPCPBudget, 0)
		,	ISNULL(SC.BIOclosePCP, 0)
		,	ISNULL(SC.EXTMEMclosePCP, 0)
		,	ISNULL(SC.XTRclosePCP, 0)

		,	TAO.TotalAddOnCnt
		,	TAO.TotalAddOnAmt
		,	E.NoCRM


/********** UPDATE values for centers without CRMs *************************************************************************************/
UPDATE TTL
SET TTL.CenterDescriptionNumber = MAN.CenterDescriptionNumber
FROM #Totals TTL
INNER JOIN #CenterManager MAN
	ON MAN.CenterNumber = TTL.CenterNumber
WHERE TTL.CenterDescriptionNumber IS NULL

UPDATE TTL
SET TTL.CenterManagementAreaDescription = MAN.CenterManagementAreaDescription
FROM #Totals TTL
INNER JOIN #CenterManager MAN
	ON MAN.CenterNumber = TTL.CenterNumber
WHERE TTL.CenterManagementAreaDescription IS NULL

UPDATE TTL
SET TTL.CenterManager = MAN.CenterManager
FROM #Totals TTL
INNER JOIN #CenterManager MAN
	ON MAN.CenterNumber = TTL.CenterNumber
WHERE TTL.CenterManager IS NULL

UPDATE TTL
SET TTL.AreaManager = MAN.AreaManager
FROM #Totals TTL
INNER JOIN #CenterManager MAN
	ON MAN.CenterNumber = TTL.CenterNumber
WHERE TTL.AreaManager IS NULL



UPDATE TTL
SET TTL.StartDate = @StartDate
FROM #Totals TTL
WHERE TTL.StartDate IS NULL

UPDATE TTL
SET TTL.EndDate = @EndDate
FROM #Totals TTL
WHERE TTL.EndDate IS NULL

UPDATE TTL
SET TTL.EmployeeFullName = E.EmployeeFullName
FROM #Totals TTL
INNER JOIN #Employee E
	ON E.CenterNumber = TTL.CenterNumber
WHERE TTL.EmployeeFullName IS NULL



/*********** Final select with calculations ********************************************************************************************/

UPDATE #Totals
SET BIOConversionDiff = CASE WHEN ROUND(ISNULL(BIOConversionsBudget,0),0) = 0 THEN (ROUND(ISNULL(BIOConversionsActual,0),0) - 1) ELSE ROUND(ISNULL(BIOConversionsActual,0),0) - ROUND(ISNULL(BIOConversionsBudget,0),0)END

UPDATE #Totals
SET BIOConversionPercent =  CASE WHEN ROUND(ISNULL(BIOConversionsBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(BIOConversionsActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(BIOConversionsActual,0),0), ROUND(ISNULL(BIOConversionsBudget,0),0))	END

UPDATE #Totals
SET EXTConversionDiff = CASE WHEN ROUND(ISNULL(EXTConversionsBudget,0),0) = 0 THEN (ROUND(ISNULL(EXTConversionsActual,0),0) - 1) ELSE ROUND(ISNULL(EXTConversionsActual,0),0) - ROUND(ISNULL(EXTConversionsBudget,0),0) END

UPDATE #Totals
SET EXTConversionPercent = CASE WHEN ROUND(ISNULL(EXTConversionsBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(EXTConversionsActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(EXTConversionsActual,0),0), ROUND(ISNULL(EXTConversionsBudget,0),0))END

UPDATE #Totals
SET XTRConversionDiff = CASE WHEN ROUND(ISNULL(XtrandsConversionsBudget,0),0) = 0 THEN (ROUND(ISNULL(XtrandsConversionsActual,0),0) - 1) ELSE ROUND(ISNULL(XtrandsConversionsActual,0),0) - ROUND(ISNULL(XtrandsConversionsBudget,0),0) END

UPDATE #Totals
SET XTRConversionPercent = CASE WHEN ROUND(ISNULL(XtrandsConversionsBudget,0),0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(ISNULL(XtrandsConversionsActual,0),0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(ISNULL(XtrandsConversionsActual,0),0), ROUND(ISNULL(XtrandsConversionsBudget,0),0))END

UPDATE #Totals
SET TotalBudget = ISNULL(PCPRevenueBudget,'0') + ISNULL(RetailBudget,'0') + ISNULL(ServiceBudget,'0')

UPDATE #Totals
SET TotalActual = ISNULL(TotalPCPAmt_Actual,'0') + ISNULL(CtrRetailAmt,'0') + ISNULL(CtrServiceAmt,'0')

SELECT CenterNumber
,       CenterDescriptionNumber
,       EmployeeKey
,       EmployeeFullName
,		CenterManagementAreaDescription
,		CenterManager
,		AreaManager
,       ISNULL(BIOConversionsActual,0) AS BIOConversionsActual
,       ISNULL(BIOConversionsBudget,0) AS BIOConversionsBudget
,       ISNULL(EXTConversionsActual,0) AS EXTConversionsActual
,       ISNULL(EXTConversionsBudget,0) AS EXTConversionsBudget
,       ISNULL(XtrandsConversionsActual,0) AS XtrandsConversionsActual
,       ISNULL(XtrandsConversionsBudget,0) AS XtrandsConversionsBudget
,       ISNULL(PCPRevenueBudget,'0') AS PCPRevenueBudget
,       ISNULL(RetailBudget,'0') AS RetailBudget
,       ISNULL(ServiceBudget,'0') AS ServiceBudget
,       ISNULL(Upgrades,0) AS Upgrades
,       ISNULL(UpgradesRevenue,'0') AS UpgradesRevenue
,       ISNULL(MDP,0) AS MDP
,       ISNULL(MDPRevenue,'0') AS MDPRevenue
,       ISNULL(Laser,0) AS Laser
,       ISNULL(LaserRevenue,'0') AS LaserRevenue
,       ISNULL(Wigs,0) AS Wigs
,       ISNULL(WigsRevenue,'0') AS WigsRevenue
,		ISNULL(NB_AppsCnt,0) AS NB_AppsCnt
,       ISNULL(CtrRetailAmt,'0') AS CtrRetailAmt
,       ISNULL(CtrServiceAmt,'0') AS CtrServiceAmt

,		ISNULL(PCP_NB2Amt,'0') AS PCP_NB2Amt
,       ISNULL(TotalPCPAmt_Actual,'0') AS TotalPCPAmt_Deferred
,       ISNULL(Receivable,'0') AS Receivable

,       ISNULL(BIOOpenPCP,0) AS BIOOpenPCP
,       ISNULL(EXTMEMOpenPCP,0) AS EXTMEMOpenPCP
,       ISNULL(XTROpenPCP,0) AS XTROpenPCP

,       ISNULL(BIOOpenPCPBudget,0) AS BIOOpenPCPBudget
,       ISNULL(EXTMEMOpenPCPBudget,0) AS EXTMEMOpenPCPBudget
,       ISNULL(XTRopenPCPBudget,0) AS XTRopenPCPBudget


,       ISNULL(BIOclosePCP,0) AS BIOclosePCP
,       ISNULL(EXTMEMclosePCP,0) AS EXTMEMclosePCP
,       ISNULL(XTRclosePCP,0) AS XTRclosePCP

,       StartDate
,       EndDate
,       ISNULL(BIOConversionDiff,0) AS BIOConversionDiff
,       ISNULL(BIOConversionPercent,'0') AS BIOConversionPercent
,       ISNULL(EXTConversionDiff,0) AS EXTConversionDiff
,       ISNULL(EXTConversionPercent,'0') AS EXTConversionPercent
,       ISNULL(XTRConversionDiff,0) AS XTRConversionDiff
,       ISNULL(XTRConversionPercent,'0') AS XTRConversionPercent
,		ISNULL(TotalAddOnCnt,0) AS TotalAddOnCnt
,		ISNULL(TotalAddOnAmt,'0') AS TotalAddOnAmt
,		NoCrm
,		TotalActual
,		TotalBudget
,		@DaysRemaining AS DaysRemaining
,		CASE WHEN TotalBudget = '0' THEN '0'ELSE (TotalActual/TotalBudget) END AS TotalPercent
FROM #Totals



END
GO
