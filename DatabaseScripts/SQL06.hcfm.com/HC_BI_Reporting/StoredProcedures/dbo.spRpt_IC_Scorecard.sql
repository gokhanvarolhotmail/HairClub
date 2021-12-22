/* CreateDate: 12/04/2018 14:24:34.520 , ModifyDate: 12/11/2019 11:22:54.470 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_IC_Scorecard]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[IC_Scorecard]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		12/27/2018
------------------------------------------------------------------------
NOTES:
@Position = 'MULTI' for Areas - a list of centers; this is set in the subscription; 'IC' for Consultant; 'CM' for center manager; 'AM' for area manager

------------------------------------------------------------------------
CHANGE HISTORY:
02/08/2019 - RH - (Case #7012) Added NB_MDPCnt and NB_MDPAmt, removed S_SurCnt, changed Budget for NB1 to use a collection of $ account ID's (10305,10306,10310,10315,10325)
02/11/2019 - RH - (Case #7012) Added code to set Consultation Budget to that of December 2018 if it is zero
03/01/2019 - RH - (Case #7012) Moved the @StartDate and @EndDate to within the stored procedure
03/19/2019 - RH - (Case #9270) Changed DIVIDE_DECIMAL to DIVIDE_NOROUND since ClosingPercent needs 4 characters past the decimal; Changed NB1Revenue > 0 to not equal to zero for #IC
03/27/2019 - RH - (Per email from Nicole K) Changed Refunds to one per day per client; Separated Discounts from Refunds to include all
04/25/2019 - RH - Changed code to find center manager excluding inactive center managers; Changed code to find area managers to allow for missing Area Managers
04/29/2019 - RH - Removed DC.CreationDate >= @BeginningOfThePreviousYear from #NetConsultations so the IC Scorecard reports will match - this was removing consultations
05/03/2019 - RH - Added Surgery(#) Actual and Budget (AccountID 10220) to NB1Count; Moved #Sales with GROUP BY to the ContractPrice section
05/23/2019 - RH - Combined the area and IC versions with two more parameters - @Position and @CenterNumberList; Removed DAR.SalesTypeDescription AS SolutionOffered since it is not used
07/29/2019 - RH - Added Area Directors to the "non-Manager" list; added GROUP BY to #NetConsultations; Replaced join on DimActivityDemographic with join on SQL05.HC_BI_SFDC.dbo.Task
08/16/2019 - RH - Removed budget fields from #Employee; Added a UNION to #CenterManagers query to include ALL centers; changed join on DimContact to SFDC_LeadID
08/23/2019 - RH - Updated list for Center Managers (per Jimmy's roster)
08/27/2019 - RH - Changed #CenterManagers query to match the one from [spRpt_CRM_Scorecard]; removed Budget amounts from the #CenterManager
09/05/2019 - RH - Corrected the Center Manager list (per Jimmy's roster)
11/13/2019 - RH - Removed Cindy Sneed (TFS13439); updated center manager (per Jimmy's center roster)
12/10/2019 - RH - Added NetNB1Count to Number of IC's:WHERE (S.NetNB1Revenue <> 0 OR S.NetNB1Count <> 0); Added Julie Jones(Center Manager) as IC
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_IC_Scorecard] 15443,'IC','228' --Priyanka Kaul
EXEC [spRpt_IC_Scorecard] 16372,'IC','247' --Baranoff, Steven
EXEC [spRpt_IC_Scorecard] 291,'CM','291' --AChacon@hcfm.com
EXEC [spRpt_IC_Scorecard] 217,'AM','217' --AChristy@hcfm.com
EXEC [spRpt_IC_Scorecard] 0,'MULTI','285,251,252,221,269'

EXEC [spRpt_IC_Scorecard] 12464,'IC','287' --Julie Jones in Portland(287)

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_IC_Scorecard]
(
	@EmployeeKey INT
,	@Position NVARCHAR(5)
,	@CenterNumberList NVARCHAR(150)
)
AS
BEGIN

SET FMTONLY OFF;


/************** Declare and set variables **********************************************************************/

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @BeginningOfThisMonth DATETIME
DECLARE @BeginningOfThePreviousMonth DATETIME


DECLARE @Today DATETIME = CURRENT_TIMESTAMP;


SET @BeginningOfThisMonth = CAST(CAST(MONTH(@Today) AS VARCHAR(2)) + '/1/' + CAST(YEAR(@Today) AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
SET @BeginningOfThePreviousMonth = DATEADD(MONTH,-1,@BeginningOfThisMonth)


--PRINT @BeginningOfTheYear
--PRINT @BeginningOfThePreviousYear
--PRINT @BeginningOfThisMonth
--PRINT @BeginningOfThePreviousMonth
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
SET @EndDate = CAST(@Today AS DATE)
END

--PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(12))
--PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(12))

DECLARE @MonthWorkdaysTotal INT
DECLARE @CummWorkdays INT
SET @MonthWorkdaysTotal = (SELECT MonthWorkdaysTotal FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @StartDate)
SET @CummWorkdays = (SELECT CummWorkdays FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @EndDate)


DECLARE @DaysRemaining INT
SET @DaysRemaining = @MonthWorkdaysTotal - @CummWorkdays


DECLARE @ClosingBudget DECIMAL(18,4)				--Percent
DECLARE @AvgSalePriceBudget DECIMAL(18,4)			--Money

SET @ClosingBudget = .45
SET @AvgSalePriceBudget = 3000


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
)


CREATE TABLE #Consultant(
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
)

CREATE TABLE #Budget(
	CenterNumber INT
,	ConsultationBudget INT
,	NB1SalesBudget INT
,	NB1RevenueBudget DECIMAL(18,4)
,	BudgetNewStyles INT
)


CREATE TABLE #NB1A(
	NB1A DATETIME
,	SalesOrderDetailKey INT
,	SalesOrderKey INT
,	SalesCodeDescription NVARCHAR(150)
,	SalesCodeDescriptionShort NVARCHAR(50)
,	Quantity INT
,	CenterKey INT
,	ClientKey INT
,	EmployeeKey INT
)


CREATE TABLE #INITASG(
	FullDate DATETIME
,	ClientKey INT
,	CenterKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	EmployeeKey INT
,	Quantity INT
,	SalesCodeDescriptionShort NVARCHAR(50)
,	MembershipDescription NVARCHAR(150)
,	BusinessSegmentSSID INT
,	ClientMembershipContractPrice DECIMAL(18,4)
,	TotalPayments DECIMAL(18,4)
)


CREATE TABLE #NBSalesWithApps(
	EmployeeKey INT
,	Quantity INT
)



CREATE TABLE #NBSalesWithApps_Center(
	CenterKey INT
,	Quantity INT
)


CREATE TABLE #SUM_Sales(
	EmployeeKey INT
,	Employee1FullName NVARCHAR(102)
,	NetNB1Count	INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_EXTAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XTRAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


CREATE TABLE #SUM_Sales_Center(
	CenterKey INT
,	NetNB1Count	INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_EXTAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XTRAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)

--#NetSales and #NetSales_Center
CREATE TABLE #NetSales(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_ExtAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


CREATE TABLE #NetSales_Center(
	CenterKey INT
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_ExtAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


--#SUM_NetSales and #SUM_NetSales_Center
CREATE TABLE #SUM_NetSales(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_ExtAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


CREATE TABLE #SUM_NetSales_Center(
	CenterKey INT
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_ExtAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


--#NetConsultations and #NetConsultations_Center
CREATE TABLE #NetConsultations(
	EmployeeKey INT
,	Performer NVARCHAR(102)
,	ActivityDueDate DATE
,	ActivitySSID NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
--,	SolutionOffered NVARCHAR(50)
)

CREATE TABLE #NetConsultations_Center(
	CenterKey INT
,	FullDate DATETIME
,	Consultations INT
)



--#IC
CREATE TABLE #IC(
	CenterNumber INT
,	NumberOfIC INT
,	ConsultationBudget INT
,	ConsBudgetPerIC INT
,	SalesBudgetPerIC INT
,	RevenueBudgetPerIC DECIMAL(18,4)
,	BudgetNewStylesPerIC INT
)

--#Refunds and #Refunds_Center

CREATE TABLE #Refunds(
	Employee1Key INT
,	Refunded INT
)

CREATE TABLE #Refunds_Center(
	CenterKey INT
,	Refunded INT
)

--#Discounts and #Discounts_Center
CREATE TABLE #Discounts(
	Employee1Key INT
,	Discount DECIMAL(18,4)
)


CREATE TABLE #Discounts_Center(
	CenterKey INT
,	Discount DECIMAL(18,4)
)


--#Commissions  -- There will be no commissions shown for the 'CM' and 'AM' versions
CREATE TABLE #Commissions(
	EmployeeKey INT
,	EmployeePayrollID NVARCHAR(20)
,	EmployeeFullName NVARCHAR(102)
,   AdvancedCommission DECIMAL(18,4)
)

--#Sales and #Sales_Center
CREATE TABLE #Sales(
	EmployeeKey INT
,	Employee1FullName NVARCHAR(102)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(250)
,	ClientMembershipKey INT
,	ClientMembershipEndDate DATETIME
,	ClientMembershipContractPrice DECIMAL(18,4)
,	NB_GradCnt INT
,	NB_GradAmt DECIMAL(18,4)
,	NB_TradCnt INT
,	NB_TradAmt DECIMAL(18,4)
,	NB_ExtCnt INT
,	NB_ExtAmt DECIMAL(18,4)
,	S_PostExtCnt INT
,	S_PostExtAmt DECIMAL(18,4)
,	NB_XtrCnt INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
,	S_SurCnt DECIMAL(18,4)
)


CREATE TABLE #Sales_Center(
	CenterKey INT
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(250)
,	ClientMembershipKey INT
,	ClientMembershipEndDate DATETIME
,	ClientMembershipContractPrice DECIMAL(18,4)
,	NB_GradCnt INT
,	NB_GradAmt DECIMAL(18,4)
,	NB_TradCnt INT
,	NB_TradAmt DECIMAL(18,4)
,	NB_ExtCnt INT
,	NB_ExtAmt DECIMAL(18,4)
,	S_PostExtCnt INT
,	S_PostExtAmt DECIMAL(18,4)
,	NB_XtrCnt INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
,	S_SurCnt DECIMAL(18,4)
)


--#ContractPrice and #ContractPrice_Center

CREATE TABLE #ContractPrice(
	EmployeeKey INT
,   ClientKey INT
,   ClientMembershipContractPrice DECIMAL(18,4)
,   NB_GradCP INT
,   S_PostExtCP INT
,   NB_TradCP INT
,   NB_ExtCP INT
,   NB_XtrCP INT
,   S_SurCP INT
)


CREATE TABLE #ContractPrice_Center(
	CenterKey INT
,   ClientKey INT
,   ClientMembershipContractPrice DECIMAL(18,4)
,   NB_GradCP INT
,   S_PostExtCP INT
,   NB_TradCP INT
,   NB_ExtCP INT
,   NB_XtrCP INT
,   S_SurCP INT
)

--#SUM_ContractPrice and #SUM_ContractPrice_Center

CREATE TABLE #SUM_ContractPrice(
	EmployeeKey INT
,	XP_Price DECIMAL(18,4)
,	EXT_Price DECIMAL(18,4)
,	XTR_Price DECIMAL(18,4)
,	SUR_Price DECIMAL(18,4)
)


CREATE TABLE #SUM_ContractPrice_Center(
	CenterKey INT
,	XP_Price DECIMAL(18,4)
,	EXT_Price DECIMAL(18,4)
,	XTR_Price DECIMAL(18,4)
,	SUR_Price DECIMAL(18,4)
)


CREATE TABLE #Final(
		EmployeeKey INT
,       EmployeeSSID NVARCHAR(50)
,       EmployeePositionSSID NVARCHAR(50)
,       EmployeePositionDescription NVARCHAR(50)
,       EmployeeFullName NVARCHAR(1002)
,       EmployeeFirstName NVARCHAR(50)
,       EmployeeLastName NVARCHAR(50)
,       UserLogin NVARCHAR(50)
,       CenterNumber INT
,       CenterDescriptionNumber NVARCHAR(50)
,       NumberOfIC INT
,		ConsBudgetPerIC INT
,		SalesBudgetPerIC INT
,		RevenueBudgetPerIC DECIMAL(18,4)
,		BudgetNewStylesPerIC INT
,       CenterManager NVARCHAR(102)
,       CenterManagementAreaDescription NVARCHAR(50)
,       AreaManager NVARCHAR(102)
,		Consultations INT
,		NetNB1Count INT
,		NetNB1Revenue DECIMAL(18,4)

,		XTRPlus INT
,		NB_XPAmt DECIMAL(18,4)
,		EXT INT
,		NB_ExtAmt DECIMAL(18,4)
,		Xtrands INT
,		NB_XtrAmt DECIMAL(18,4)

,		LaserCnt INT
,		LaserAmt DECIMAL(18,4)
,		NB_MDPCnt INT
,		NB_MDPAmt DECIMAL(18,4)

,		XP_Price DECIMAL(18,4)
,		XP_Payments DECIMAL(18,4)

,		EXT_Price DECIMAL(18,4)
,		EXT_Payments DECIMAL(18,4)

,		XTR_Price DECIMAL(18,4)
,		XTR_Payments DECIMAL(18,4)

,		NSD INT
,		AdvancedCommission DECIMAL(18,4)
,		Refunded INT
,		Discount DECIMAL(18,4)
)

/*********************** Begin populating the temp tables ***********************************************************/

--Find CenterNumbers using fnSplit
INSERT INTO #CenterNumberList
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumberList,',')


/********* This code is to set the correct CenterManager excluding inactive center managers - same as [spRpt_CRM_Scorecard]*************************/

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
WHERE AREA.IsActiveFlag = 1
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
WHERE AREA.IsActiveFlag = 1
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


/************************ Find consultants according to @Position ***********************/

--Find consultants
IF @Position IN('MULTI','IC')  ----This is for Areas - multiple centers *** and IC's
BEGIN
	INSERT INTO #Consultant(
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
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		INNER JOIN #CenterNumberList CN
			ON CN.CenterNumber = CTR.CenterNumber
	LEFT JOIN #CenterManager CMGR
			ON CMGR.CenterNumber = CTR.CenterNumber
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
		ON e.CenterSSID = CTR.CenterSSID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
			ON e.EmployeeSSID = epj.EmployeeGUID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
			ON epj.EmployeePositionID = ep.EmployeePositionSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA
			ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
	WHERE  e.IsActiveFlag = 1
		AND e.EmployeeFullName NOT LIKE '%Test%'
		AND ep.EmployeePositionDescription IN('Consultant','Manager','Area Manager')

	INSERT INTO #Employee(
			EmployeeKey
	,       EmployeeSSID
	,       EmployeePositionSSID
	,       EmployeePositionDescription
	,       EmployeeFullName
	,       EmployeeFirstName
	,       EmployeeLastName
	,       UserLogin
	,       CenterNumber
	,       CenterDescriptionNumber
	,       CenterManager
	,       CenterManagementAreaSSID
	,       CenterManagementAreaDescription
	,       AreaManager
	)
	SELECT CONS.EmployeeKey
	,       CONS.EmployeeSSID
	,       CONS.EmployeePositionSSID
	,       CONS.EmployeePositionDescription
	,       CONS.EmployeeFullName
	,       CONS.EmployeeFirstName
	,       CONS.EmployeeLastName
	,       CONS.UserLogin
	,       CONS.CenterNumber
	,       CONS.CenterDescriptionNumber
	,       CONS.CenterManager
	,       CONS.CenterManagementAreaSSID
	,       CONS.CenterManagementAreaDescription
	,       CONS.AreaManager
	FROM #Consultant CONS
	WHERE CONS.EmployeePositionDescription IN('Consultant')
	GROUP BY CONS.EmployeeKey,
			 CONS.EmployeeSSID,
			 CONS.EmployeePositionSSID,
			 CONS.EmployeePositionDescription,
			 CONS.EmployeeFullName,
			 CONS.EmployeeFirstName,
			 CONS.EmployeeLastName,
			 CONS.UserLogin,
			 CONS.CenterNumber,
			 CONS.CenterDescriptionNumber,
			 CONS.CenterManager,
			 CONS.CenterManagementAreaSSID,
			 CONS.CenterManagementAreaDescription,
			 CONS.AreaManager
	ORDER BY CONS.CenterNumber

					--SELECT '#Employee' AS tablename, * FROM #Employee

--Enter a consultant who is also a Center Manager - Julie Jones in Portland(287)
IF  (@Position IN('IC') AND (SELECT CenterNumber FROM #CenterNumberList) = 287)
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
	SELECT 12464,
		'7C61E982-BD3E-4E37-AAE2-4DEDB8FFE6EF',
		4,
		'Consultant',
		'Jones, Julie',
		'Julie',
		'Jones',
		'JJones',
		287,
		'Portland (287)',
		'Jones, Julie',
		21,
		'West',
		'Gonzales, Alexander'
END
	--If there in no consultant then enter the center manager
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
	SELECT EmployeeKey,
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
	FROM #Consultant CONS
	WHERE CONS.CenterNumber NOT IN(SELECT CenterNumber FROM #Employee)
	AND CONS.EmployeePositionDescription = 'Manager'
	ORDER BY CONS.CenterNumber

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
	SELECT * FROM #Consultant CONS
	WHERE CONS.CenterNumber NOT IN(SELECT CenterNumber FROM #Employee)
	AND CONS.EmployeePositionDescription = 'AreaManager'
END
ELSE IF @Position = 'CM'
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
	SELECT e.EmployeeKey
	,	e.EmployeeSSID
	,	ep.EmployeePositionSSID
	,	ep.EmployeePositionDescription
	,	e.EmployeeFullName
	,	e.EmployeeFirstName
	,	e.EmployeeLastName
	,	e.UserLogin
	,	CTR.CenterNumber
	,	CTR.CenterDescriptionNumber
	,	e.EmployeeFullName AS CenterManager
	,	CMA.CenterManagementAreaSSID
	,	CMA.CenterManagementAreaDescription
	,	AREA.EmployeeFullName AS AreaManager
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
			ON e.EmployeeSSID = epj.EmployeeGUID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
			ON epj.EmployeePositionID = ep.EmployeePositionSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterSSID = e.CenterSSID
		INNER JOIN #CenterNumberList CN
			ON CN.CenterNumber = CTR.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA
			ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
	WHERE ep.EmployeePositionDescription = 'Center Manager'
		AND e.EmployeeFullName NOT LIKE '%Test%'
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
SELECT e.EmployeeKey
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
FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		ON e.EmployeeSSID = CMA.OperationsManagerSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
	INNER JOIN #CenterNumberList CN
		ON CN.CenterNumber = CTR.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA
		ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE ep.EmployeePositionDescription = 'Area Manager'
	AND e.EmployeeFullName NOT LIKE '%Test%'
END



/************************ NB1A ********************************************/
--Find clients with NB1A's --Query to find Initial New Styles
IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #NB1A
SELECT DD.FullDate AS NB1A
,	SOD.SalesOrderDetailKey
,	SOD.SalesOrderKey
,	SOD.SalesCodeDescription
,	SOD.SalesCodeDescriptionShort
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS Quantity
,	FST.CenterKey
,	FST.ClientKey
,	E.EmployeeKey
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
INNER JOIN #CenterNumberList CN
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
	ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
	ON DSO.SalesOrderKey = SOD.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
	ON SC.SalesCodeKey = FST.SalesCodeKey
LEFT JOIN #Employee E
	ON E.EmployeeKey = DSO.EmployeeKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipKey = FST.MembershipKey
WHERE DSO.OrderDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeDescriptionShort = 'NB1A'
	AND SOD.IsVoidedFlag = 0
END
ELSE			--IF @Position IN('CM','AM')
BEGIN
INSERT INTO #NB1A
SELECT DD.FullDate AS NB1A
,	SOD.SalesOrderDetailKey
,	SOD.SalesOrderKey
,	SOD.SalesCodeDescription
,	SOD.SalesCodeDescriptionShort
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS Quantity
,	FST.CenterKey
,	FST.ClientKey
,	NULL AS EmployeeKey
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
INNER JOIN #CenterNumberList CN
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
	ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
	ON DSO.SalesOrderKey = SOD.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
	ON SC.SalesCodeKey = FST.SalesCodeKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipKey = FST.MembershipKey
WHERE DSO.OrderDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeDescriptionShort = 'NB1A'
	AND SOD.IsVoidedFlag = 0
END


----Then find the sales for those clients

INSERT INTO #INITASG
SELECT p.FullDate,
       p.ClientKey,
       p.CenterKey,
       p.ClientMembershipKey,
       p.MembershipKey,
       p.EmployeeKey,
       p.Quantity,
       p.SalesCodeDescriptionShort,
       p.MembershipDescription,
       p.BusinessSegmentSSID,
       p.ClientMembershipContractPrice,
       SUM(p.ExtendedPrice) AS TotalPayments
FROM
(SELECT DD.FullDate
,	FST.ClientKey
,	FST.CenterKey
,	FST.ClientMembershipKey
,	FST.MembershipKey
,	FST.Employee1Key AS EmployeeKey
,	1 AS Quantity						--FST.Quantity will show too many for surgery
,	SC.SalesCodeDescriptionShort
,	M.MembershipDescription
,	M.BusinessSegmentSSID
,	DCM.ClientMembershipContractPrice
,   FST.ExtendedPrice
FROM  HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON SO.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
		ON DCM.MembershipKey = m.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON DCM.CenterKey = CTR.CenterKey
WHERE SC.SalesCodeDescriptionShort  = 'INITASG'
AND FST.ClientKey IN(SELECT ClientKey FROM #NB1A)
AND SOD.IsVoidedFlag = 0
AND M.MembershipDescription NOT IN('New Client (ShowNoSale)','New Client (Surgery Offered)')
GROUP BY DD.FullDate
,	FST.ClientKey
,	FST.CenterKey
,	FST.ClientMembershipKey
,	FST.MembershipKey
,	FST.Employee1Key
,	FST.Quantity
,	SC.SalesCodeDescriptionShort
,	M.MembershipDescription
,	M.BusinessSegmentSSID
,	DCM.ClientMembershipContractPrice
,   FST.ExtendedPrice
)p
GROUP BY
p.FullDate,
       p.ClientKey,
       p.CenterKey,
       p.ClientMembershipKey,
       p.MembershipKey,
       p.EmployeeKey,
       p.Quantity,
       p.SalesCodeDescriptionShort,
       p.MembershipDescription,
       p.BusinessSegmentSSID,
       p.ClientMembershipContractPrice


--SUM the Quantities
IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #NBSalesWithApps
SELECT EmployeeKey
,	SUM(Quantity) AS Quantity
FROM #INITASG
GROUP BY EmployeeKey
END
ELSE  --IF @Position IN('CM','AM')
BEGIN
INSERT INTO #NBSalesWithApps_Center
SELECT CenterKey
,	SUM(Quantity) AS Quantity
FROM #INITASG
GROUP BY CenterKey
END



--Find the Center Manager and Budget Consultations for this month and NB1 Sales Budget
INSERT INTO #Budget
SELECT a.CenterNumber
	,	SUM(CASE WHEN a.AccountID = 10110 THEN ISNULL(a.Budget,0) ELSE 0 END) AS ConsultationBudget   --10110	Activity - Consultations #
	,	SUM(CASE WHEN a.AccountID IN (10205, 10206, 10215, 10210,  10225)THEN ISNULL(a.Budget,0) ELSE 0 END) AS NB1SalesBudget
	,	SUM(CASE WHEN a.AccountID IN (10305, 10306, 10315, 10310,  10325, 10552 ) THEN ISNULL(a.Budget,0) ELSE 0 END) AS NB1RevenueBudget
	,	SUM(CASE WHEN a.AccountID IN (10240) THEN ISNULL(a.Budget,0) ELSE 0 END) AS BudgetNewStyles
FROM
	(
	SELECT CTR.CenterNumber
	, FA.PartitionDate
	, FA.AccountID
	, FA.Budget
	FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterNumber
	INNER JOIN #CenterNumberList CN
		ON CN.CenterNumber = CTR.CenterNumber
	WHERE FA.PartitionDate = @BeginningOfThisMonth
		AND FA.AccountID IN( 10110,10205,10206,10215,10210,10225,10305,10306,10315,10310, 10325,10240,10552)
	) a
GROUP BY a.CenterNumber




--Find the activities that are consultations and employees
IF (@Position IN('IC') AND (SELECT TOP 1 EmployeePositionDescription FROM #Employee) = 'Consultant')
BEGIN
INSERT INTO #NetConsultations
SELECT  E.EmployeeKey
,		TK.Performer__c AS Performer
,		DA.ActivityDueDate
,		DA.ActivitySSID
,		ISNULL(DA.ActionCodeDescription, '') AS ActionCode
,		ISNULL(DA.ResultCodeDescription, '') AS ResultCode
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON DC.SFDC_LeadID = DA.SFDC_LeadID
		INNER JOIN SQL05.HC_BI_SFDC.dbo.Task TK
			ON TK.ID = DA.SFDC_TaskID
		INNER JOIN #Employee E WITH(NOLOCK)
			--ON FAR.ActivityEmployeeKey = E.EmployeeKey --These employees are from the NCC
			ON TK.Performer__c = E.EmployeeFullName
WHERE   DA.ActivityDueDate BETWEEN @StartDate AND @EndDate
		AND FAR.Consultation = 1
		AND TK.Performer__c IN(SELECT EmployeeFullName FROM #Employee WHERE EmployeePositionDescription IN('Consultant','Manager'))
GROUP BY ISNULL(DA.ActionCodeDescription, '')
,         ISNULL(DA.ResultCodeDescription, '')
,         E.EmployeeKey
,         TK.Performer__c
,         DA.ActivityDueDate
,         DA.ActivitySSID

		--SELECT '#NetConsultations' AS tablename, * FROM #NetConsultations
END
ELSE
IF @Position IN('IC') AND (SELECT TOP 1 EmployeePositionDescription FROM #Employee) = 'Manager'
BEGIN
INSERT INTO #NetConsultations
SELECT  FAR.CenterKey AS EmployeeKey
,		CTR.CenterDescription AS Performer
,		DD.FullDate AS ActivityDueDate
,		CASE WHEN FAR.Consultation = 1 THEN 1 ELSE 0 END AS ActivitySSID
,		NULL AS ActionCode
,		NULL AS ResultCode
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterKey = FAR.CenterKey
		INNER JOIN #CenterNumberList CN
			ON CN.CenterNumber = CTR.CenterNumber
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.Consultation = 1
END
ELSE IF @Position IN('MULTI')
BEGIN
INSERT INTO #NetConsultations
SELECT  E.EmployeeKey
,		TK.Performer__c AS Performer
,		DA.ActivityDueDate
,		DA.ActivitySSID
,		ISNULL(DA.ActionCodeDescription, '') AS ActionCode
,		ISNULL(DA.ResultCodeDescription, '') AS ResultCode
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON DC.SFDC_LeadID = DA.SFDC_LeadID
		INNER JOIN SQL05.HC_BI_SFDC.dbo.Task TK
			ON TK.ID = DA.SFDC_TaskID
		INNER JOIN #Employee E WITH(NOLOCK)
			--ON FAR.ActivityEmployeeKey = E.EmployeeKey --These employees are from the NCC
			ON TK.Performer__c = E.EmployeeFullName
WHERE   DA.ActivityDueDate BETWEEN @StartDate AND @EndDate
		AND FAR.Consultation = 1
		AND TK.Performer__c IN(SELECT EmployeeFullName FROM #Employee WHERE EmployeePositionDescription IN('Consultant','Manager'))
END
ELSE
BEGIN
INSERT INTO #NetConsultations_Center
SELECT  FAR.CenterKey
,		DD.FullDate
,		SUM(CASE WHEN FAR.Consultation = 1 THEN 1 ELSE 0 END) AS Consultations
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterKey = FAR.CenterKey
		INNER JOIN #CenterNumberList CN
			ON CN.CenterNumber = CTR.CenterNumber
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FAR.Consultation = 1
GROUP BY FAR.CenterKey
,		DD.FullDate
END

--Find the Sales

/**************** This section finds the Sales for the IC *************************************/
/**********************************************************************************************/

IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #SUM_Sales
SELECT  FST.Employee1Key
,		SOD.Employee1FullName
,		SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
		+ SUM(ISNULL(FST.NB_XtrCnt, 0))
        + SUM(ISNULL(FST.NB_GradCnt, 0))
		+ SUM(ISNULL(FST.NB_MDPCnt,0))
        + SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.S_SurCnt, 0)) AS 'NetNB1Count'
,       SUM(ISNULL(FST.NB_TradAmt, 0))
		+ SUM(ISNULL(FST.NB_ExtAmt, 0))
		+ SUM(ISNULL(FST.NB_XtrAmt, 0))
        + SUM(ISNULL(FST.NB_GradAmt, 0))
		+ SUM(ISNULL(FST.NB_MDPAmt,0))
        + SUM(ISNULL(FST.S_PostExtAmt, 0))
		+ SUM(ISNULL(FST.NB_LaserAmt, 0))  AS 'NetNB1Revenue'
,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XTRPlus'
,       SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NB_XPAmt'
,       SUM(ISNULL(FST.NB_ExtCnt, 0)) +  SUM(ISNULL(FST.S_PostExtCnt, 0)) AS EXT
,       SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS NB_ExtAmt
,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS Xtrands
,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS NB_XtrAmt
,       SUM(ISNULL(FST.NB_LaserCnt, 0)) AS LaserCnt
,       SUM(ISNULL(FST.NB_LaserAmt, 0)) AS LaserAmt
,       SUM(ISNULL(FST.NB_MDPCnt, 0)) AS NB_MDPCnt
,       SUM(ISNULL(FST.NB_MDPAmt, 0)) AS NB_MDPAmt
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
		INNER JOIN #Employee E
			ON FST.Employee1Key = E.EmployeeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSCD.SalesCodeDepartmentKey = DSC.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON cm.MembershipKey = m.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON cm.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
GROUP BY FST.Employee1Key
 ,       SOD.Employee1FullName


 --SELECT * FROM #SUM_Sales

--Join both sets of data with a UNION
INSERT INTO #NetSales
SELECT 	E.EmployeeKey
,	NC.Performer AS EmployeeFullName
,	COUNT(NC.ActivitySSID) AS Consultations  --This is to count consultations for AM and CM
,	0 AS NetNB1Count
,	0 AS NetNB1Revenue
,	0 AS XTRPlus
,	0 AS NB_XPAmt
,	0 AS EXT
,	0 AS NB_ExtAmt
,	0 AS Xtrands
,	0 AS NB_XtrAmt
,	0 AS LaserCnt
,	0 AS LaserAmt
,	0 AS NB_MDPCnt
,	0 AS NB_MDPAmt
FROM #Employee E
INNER JOIN #NetConsultations NC
	ON NC.EmployeeKey = E.EmployeeKey
GROUP BY E.EmployeeKey
,	NC.Performer
UNION
SELECT 	E.EmployeeKey
,	S.Employee1FullName AS EmployeeFullName
,	0 AS Consultations
,	S.NetNB1Count
,	S.NetNB1Revenue
,	S.XTRPlus
,	S.NB_XPAmt
,	S.EXT
,	S.NB_ExtAmt
,	S.Xtrands
,	S.NB_XtrAmt
,	S.LaserCnt
,	S.LaserAmt
,	S.NB_MDPCnt
,	S.NB_MDPAmt
FROM #Employee E
INNER JOIN #SUM_Sales S
	ON E.EmployeeKey = S.EmployeeKey
GROUP BY E.EmployeeKey
,	S.Employee1FullName
,	S.NetNB1Count
,	S.NetNB1Revenue
,	S.XTRPlus
,	S.NB_XPAmt
,	S.EXT
,	S.NB_ExtAmt
,	S.Xtrands
,	S.NB_XtrAmt
,	S.LaserCnt
,	S.LaserAmt
,	S.NB_MDPCnt
,	S.NB_MDPAmt


--SUM the results
INSERT INTO #SUM_NetSales
SELECT 	NS.EmployeeKey
,	NS.EmployeeFullName
,	SUM(Consultations) AS Consultations
,	SUM(NetNB1Count) AS NetNB1Count
,	SUM(NetNB1Revenue) AS NetNB1Revenue
,	SUM(XTRPlus) AS XTRPlus
,	SUM(NB_XPAmt) AS NB_XPAmt
,	SUM(EXT) AS EXT
,	SUM(NB_ExtAmt) AS NB_ExtAmt
,	SUM(Xtrands) AS Xtrands
,	SUM(NB_XtrAmt) AS NB_XtrAmt
,	SUM(LaserCnt) AS LaserCnt
,	SUM(LaserAmt) AS LaserAmt
,	SUM(NB_MDPCnt) AS NB_MDPCnt
,	SUM(NB_MDPAmt) AS NB_MDPAmt
FROM #NetSales NS
GROUP BY NS.EmployeeKey
,	NS.EmployeeFullName
END
ELSE
BEGIN
/*************** This section finds the sales for the CM or AM center *****************************/
--Find the Sales - and use @CenterKey
INSERT INTO #SUM_Sales_Center
SELECT  FST.CenterKey
,		SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
		+ SUM(ISNULL(FST.NB_XtrCnt, 0))
        + SUM(ISNULL(FST.NB_GradCnt, 0))
		+ SUM(ISNULL(FST.NB_MDPCnt,0))
        + SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.S_SurCnt, 0)) AS 'NetNB1Count'
,       SUM(ISNULL(FST.NB_TradAmt, 0))
		+ SUM(ISNULL(FST.NB_ExtAmt, 0))
		+ SUM(ISNULL(FST.NB_XtrAmt, 0))
        + SUM(ISNULL(FST.NB_GradAmt, 0))
		+ SUM(ISNULL(FST.NB_MDPAmt,0))
        + SUM(ISNULL(FST.S_PostExtAmt, 0))
		+ SUM(ISNULL(FST.NB_LaserAmt, 0)) 		AS 'NetNB1Revenue'
,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XTRPlus'
,       SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NB_XPAmt'
,       SUM(ISNULL(FST.NB_ExtCnt, 0)) +  SUM(ISNULL(FST.S_PostExtCnt, 0)) AS EXT
,       SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS NB_ExtAmt
,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS Xtrands
,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS NB_XtrAmt
,       SUM(ISNULL(FST.NB_LaserCnt, 0)) AS LaserCnt
,       SUM(ISNULL(FST.NB_LaserAmt, 0)) AS LaserAmt
,       SUM(ISNULL(FST.NB_MDPCnt, 0)) AS NB_MDPCnt
,       SUM(ISNULL(FST.NB_MDPAmt, 0)) AS NB_MDPAmt
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN #CenterNumberList CN
			ON CN.CenterNumber = C.CenterNumber
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSCD.SalesCodeDepartmentKey = DSC.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON cm.MembershipKey = m.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
		AND m.MembershipSSID NOT IN(57,58)  --New Client (ShowNoSale),New Client (Surgery Offered)
GROUP BY FST.CenterKey


--Join both sets of data with a UNION

INSERT INTO #NetSales_Center
SELECT 	NCA.CenterKey
,	SUM(NCA.Consultations) AS Consultations
,	0 AS NetNB1Count
,	0 AS NetNB1Revenue
,	0 AS XTRPlus
,	0 AS NB_XPAmt
,	0 AS EXT
,	0 AS NB_ExtAmt
,	0 AS Xtrands
,	0 AS NB_XtrAmt
,	0 AS LaserCnt
,	0 AS LaserAmt
,	0 AS NB_MDPCnt
,	0 AS NB_MDPAmt
FROM #NetConsultations_Center NCA
GROUP BY NCA.CenterKey
UNION
SELECT 	SAM.CenterKey
,	0 AS Consultations
,	SAM.NetNB1Count
,	SAM.NetNB1Revenue
,	SAM.XTRPlus
,	SAM.NB_XPAmt
,	SAM.EXT
,	SAM.NB_ExtAmt
,	SAM.Xtrands
,	SAM.NB_XtrAmt
,	SAM.LaserCnt
,	SAM.LaserAmt
,	SAM.NB_MDPCnt
,	SAM.NB_MDPAmt
FROM #SUM_Sales_Center SAM
GROUP BY SAM.CenterKey
,	SAM.NetNB1Count
,	SAM.NetNB1Revenue
,	SAM.XTRPlus
,	SAM.NB_XPAmt
,	SAM.EXT
,	SAM.NB_ExtAmt
,	SAM.Xtrands
,	SAM.NB_XtrAmt
,	SAM.LaserCnt
,	SAM.LaserAmt
,	SAM.NB_MDPCnt
,	SAM.NB_MDPAmt



--SUM the results
INSERT INTO #SUM_NetSales_Center
SELECT 	NSAM.CenterKey
,	SUM(Consultations) AS Consultations
,	SUM(NetNB1Count) AS NetNB1Count
,	SUM(NetNB1Revenue) AS NetNB1Revenue
,	SUM(XTRPlus) AS XTRPlus
,	SUM(NB_XPAmt) AS NB_XPAmt
,	SUM(EXT) AS EXT
,	SUM(NB_ExtAmt) AS NB_ExtAmt
,	SUM(Xtrands) AS Xtrands
,	SUM(NB_XtrAmt) AS NB_XtrAmt
,	SUM(LaserCnt) AS LaserCnt
,	SUM(LaserAmt) AS LaserAmt
,	SUM(NB_MDPCnt) AS NB_MDPCnt
,	SUM(NB_MDPAmt) AS NB_MDPAmt
FROM #NetSales_Center NSAM
GROUP BY NSAM.CenterKey

END

/**************************************************************************************************/
--Find the number of active IC's in this timeframe for the center
IF @Position = 'IC'
BEGIN
INSERT INTO #IC
SELECT E.CenterNumber AS CenterNumber
,	COUNT(S.EmployeeKey) AS NumberOfIC
,	MAN.ConsultationBudget
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.ConsultationBudget/COUNT(S.EmployeeKey)) END AS ConsBudgetPerIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.NB1SalesBudget/COUNT(S.EmployeeKey)) END AS SalesBudgetPerIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.NB1RevenueBudget/COUNT(S.EmployeeKey)) END AS RevenueBudgetPerIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.BudgetNewStyles/COUNT(S.EmployeeKey)) END AS BudgetNewStylesPerIC
FROM #SUM_Sales S
INNER JOIN #Employee E
	ON S.EmployeeKey = E.EmployeeKey
INNER JOIN #Budget MAN
	ON E.CenterNumber = MAN.CenterNumber
--WHERE S.NetNB1Revenue <> 0
WHERE (S.NetNB1Revenue <> 0 OR S.NetNB1Count <> 0)
GROUP BY E.CenterNumber
,       MAN.ConsultationBudget
,		MAN.NB1SalesBudget
,		MAN.NB1RevenueBudget
,		MAN.BudgetNewStyles
END
ELSE
IF @Position = 'MULTI'
BEGIN
INSERT INTO #IC
SELECT MAN.CenterNumber
,	COUNT(S.EmployeeKey) AS NumberOfIC
,	MAN.ConsultationBudget
,	MAN.ConsultationBudget AS ConsBudgetPerIC
,	MAN.NB1SalesBudget AS SalesBudgetPerIC
,	MAN.NB1RevenueBudget AS RevenueBudgetPerIC
,	MAN.BudgetNewStyles AS BudgetNewStylesPerIC
FROM #SUM_Sales S
INNER JOIN #Employee E
	ON S.EmployeeKey = E.EmployeeKey
INNER JOIN #Budget MAN
	ON E.CenterNumber = MAN.CenterNumber
--WHERE S.NetNB1Revenue <> 0
WHERE (S.NetNB1Revenue <> 0 OR S.NetNB1Count <> 0)
GROUP BY MAN.CenterNumber
,       MAN.ConsultationBudget
,		MAN.NB1SalesBudget
,		MAN.NB1RevenueBudget
,		MAN.BudgetNewStyles
END
ELSE
IF @Position IN('CM','AM')
BEGIN
INSERT INTO #IC
SELECT MAN.CenterNumber
,	1 AS NumberOfIC
,	MAN.ConsultationBudget
,	MAN.ConsultationBudget AS ConsBudgetPerIC
,	MAN.NB1SalesBudget AS SalesBudgetPerIC
,	MAN.NB1RevenueBudget AS RevenueBudgetPerIC
,	MAN.BudgetNewStyles AS BudgetNewStylesPerIC
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
INNER JOIN #Budget MAN
	ON CTR.CenterNumber = MAN.CenterNumber
GROUP BY MAN.CenterNumber
,       MAN.ConsultationBudget
,		MAN.NB1SalesBudget
,		MAN.NB1RevenueBudget
,		MAN.BudgetNewStyles
END



/************* Find Refunds - one per day per client ***********************************************************************/
IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #Refunds
SELECT q.Employee1Key
,	SUM(ISNULL(q.Refunded,0)) AS Refunded
FROM (
		SELECT  FST.Employee1Key
		,	SOD.Employee1FullName
		,	DD.FullDate
		,	FST.Discount
		,	CASE WHEN SO.IsRefundedFlag = 0 THEN 0 ELSE 1 END AS Refunded
		,	SC.SalesCodeDescription
		,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	m.BusinessSegmentDescription
		,	ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier, DD.FullDate ORDER BY DD.FullDate DESC) AS Ranking
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN #Employee E
					ON FST.Employee1Key = E.EmployeeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipKey = m.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON cm.CenterKey = c.CenterKey
				INNER JOIN #CenterNumberList CN
					ON CN.CenterNumber = C.CenterNumber
				INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
				AND SO.IsVoidedFlag = 0
				AND SO.IsRefundedFlag = 1
				AND (SC.SalesCodeDescription LIKE 'Payment - Membership%' OR SC.SalesCodeDescription IN('Assign Membership','Transfer Member In','Transfer Member Out'))
				AND m.RevenueGroupDescription = 'New Business'
)q
WHERE Ranking = 1
GROUP BY q.Employee1Key
END
ELSE
BEGIN
INSERT INTO #Refunds_Center
SELECT q.CenterKey
,	SUM(ISNULL(q.Refunded,0)) AS Refunded
FROM (
		SELECT  FST.CenterKey
		,	DD.FullDate
		,	FST.Discount
		,	CASE WHEN SO.IsRefundedFlag = 0 THEN 0 ELSE 1 END AS Refunded
		,	SC.SalesCodeDescription
		,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	m.BusinessSegmentDescription
		,	ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier, DD.FullDate ORDER BY DD.FullDate DESC) AS Ranking
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipKey = m.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CMC
					ON cm.CenterKey = CMC.CenterKey
				INNER JOIN #CenterNumberList CN
					ON CN.CenterNumber = CMC.CenterNumber
				INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
				AND SO.IsVoidedFlag = 0
				AND SO.IsRefundedFlag = 1
				AND (SC.SalesCodeDescription LIKE 'Payment - Membership%' OR SC.SalesCodeDescription IN('Assign Membership','Transfer Member In','Transfer Member Out'))
				AND m.RevenueGroupDescription = 'New Business'
)q
WHERE Ranking = 1
GROUP BY q.CenterKey
END

/************* Find SUM of Discounts ***********************************************************************/
IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #Discounts
SELECT q.Employee1Key
,	SUM(ISNULL(q.Discount,0)) AS Discount
FROM (
		SELECT  FST.Employee1Key
		,	SOD.Employee1FullName
		,	DD.FullDate
		,	FST.Discount
		,	CASE WHEN SO.IsRefundedFlag = 0 THEN 0 ELSE 1 END AS Refunded
		,	SO.InvoiceNumber
		,	SC.SalesCodeDescription
		,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	m.BusinessSegmentDescription
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN #Employee E
					ON FST.Employee1Key = E.EmployeeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipKey = m.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON cm.CenterKey = c.CenterKey
				INNER JOIN #CenterNumberList CN
					ON CN.CenterNumber = C.CenterNumber
				INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
				AND SO.IsVoidedFlag = 0
				AND FST.Discount <> 0
				AND (SC.SalesCodeDescription LIKE 'Payment - Membership%' OR SC.SalesCodeDescription IN('Assign Membership','Transfer Member In','Transfer Member Out'))
				AND m.RevenueGroupDescription = 'New Business'
)q
GROUP BY q.Employee1Key
END
ELSE
BEGIN
INSERT INTO #Discounts_Center
SELECT q.CenterKey
,	SUM(ISNULL(q.Discount,0)) AS Discount
FROM (
		SELECT FST.CenterKey
		,	DD.FullDate
		,	FST.Discount
		,	CASE WHEN SO.IsRefundedFlag = 0 THEN 0 ELSE 1 END AS Refunded
		,	SO.InvoiceNumber
		,	SC.SalesCodeDescription
		,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	m.BusinessSegmentDescription
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipKey = m.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON cm.CenterKey = c.CenterKey
				INNER JOIN #CenterNumberList CN
					ON CN.CenterNumber = C.CenterNumber
				INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
				AND SO.IsVoidedFlag = 0
				AND FST.Discount <> 0
				AND (SC.SalesCodeDescription LIKE 'Payment - Membership%' OR SC.SalesCodeDescription IN('Assign Membership','Transfer Member In','Transfer Member Out'))
				AND m.RevenueGroupDescription = 'New Business'
)q
GROUP BY q.CenterKey
END



--Find the AdvancedCommission by Employee
IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #Commissions
SELECT fch.EmployeeKey
,	fch.EmployeePayrollID
,	fch.EmployeeFullName
,	SUM(fch.AdvancedCommission) AS 'AdvancedCommission'
FROM   HC_Commission.dbo.vw_FactCommissionHeader fch
WHERE  fch.AdvancedCommissionDate BETWEEN @StartDate AND @EndDate
	AND fch.[Role] = 'Image Consultant'
	AND fch.EmployeeKey IN(SELECT EmployeeKey FROM #Employee)
GROUP BY fch.EmployeeKey
,	fch.EmployeePayrollID
,	fch.EmployeeFullName
END


/******Find the ClientMembershipContractPrice ********************************************************/
-- Find the Sales in order to find the contract price
IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #Sales
SELECT FST.Employee1Key AS EmployeeKey
,		SOD.Employee1FullName
,		FST.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CM.ClientMembershipKey
,		CM.ClientMembershipEndDate
,		CM.ClientMembershipContractPrice
,		FST.NB_GradCnt
,		FST.NB_GradAmt
,       FST.NB_TradCnt
,       FST.NB_TradAmt
,       FST.NB_ExtCnt
,       FST.NB_ExtAmt
,		FST.S_PostExtCnt
,		FST.S_PostExtAmt
,       FST.NB_XtrCnt
,       FST.NB_XtrAmt
,       FST.NB_LaserCnt
,       FST.NB_LaserAmt
,       FST.NB_MDPCnt
,       FST.NB_MDPAmt
,		FST.S_SurCnt
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
		INNER JOIN #Employee E
			ON FST.Employee1Key = E.EmployeeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON fst.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSCD.SalesCodeDepartmentKey = DSC.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON cm.MembershipKey = m.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON cm.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
		AND m.MembershipSSID NOT IN(57,58)  --New Client (ShowNoSale),New Client (Surgery Offered)
 GROUP by   FST.Employee1Key
,		SOD.Employee1FullName
,		FST.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CM.ClientMembershipKey
,		CM.ClientMembershipEndDate
,		CM.ClientMembershipContractPrice
,		FST.NB_GradCnt
,		FST.NB_GradAmt
,		FST.NB_TradCnt
,		FST.NB_TradAmt
,		FST.NB_ExtCnt
,		FST.NB_ExtAmt
,		FST.S_PostExtCnt
,		FST.S_PostExtAmt
,		FST.NB_XTRCnt
,		FST.NB_XTRAmt
,		FST.NB_LaserCnt
,		FST.NB_LaserAmt
,       FST.NB_MDPCnt
,       FST.NB_MDPAmt
,		FST.S_SurCnt
END
ELSE
BEGIN
INSERT INTO #Sales_Center
SELECT C.CenterKey
,		FST.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CM.ClientMembershipKey
,		CM.ClientMembershipEndDate
,		CM.ClientMembershipContractPrice
,		FST.NB_GradCnt
,		FST.NB_GradAmt
,       FST.NB_TradCnt
,       FST.NB_TradAmt
,       FST.NB_ExtCnt
,       FST.NB_ExtAmt
,		FST.S_PostExtCnt
,		FST.S_PostExtAmt
,       FST.NB_XtrCnt
,       FST.NB_XtrAmt
,       FST.NB_LaserCnt
,       FST.NB_LaserAmt
,       FST.NB_MDPCnt
,       FST.NB_MDPAmt
,		FST.S_SurCnt
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON fst.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSCD.SalesCodeDepartmentKey = DSC.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON cm.MembershipKey = m.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON cm.CenterKey = c.CenterKey
		INNER JOIN #CenterNumberList CN
			ON CN.CenterNumber = C.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
		AND m.MembershipSSID NOT IN(57,58)  --New Client (ShowNoSale),New Client (Surgery Offered)
 GROUP by   C.CenterKey
,		FST.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CM.ClientMembershipKey
,		CM.ClientMembershipEndDate
,		CM.ClientMembershipContractPrice
,		FST.NB_GradCnt
,		FST.NB_GradAmt
,		FST.NB_TradCnt
,		FST.NB_TradAmt
,		FST.NB_ExtCnt
,		FST.NB_ExtAmt
,		FST.S_PostExtCnt
,		FST.S_PostExtAmt
,		FST.NB_XTRCnt
,		FST.NB_XTRAmt
,		FST.NB_LaserCnt
,		FST.NB_LaserAmt
,       FST.NB_MDPCnt
,       FST.NB_MDPAmt
,		FST.S_SurCnt
END


--Find the ContractPrice

IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #ContractPrice
SELECT EmployeeKey
,		ClientKey
,		ClientMembershipContractPrice
,		(NB_GradCnt * ClientMembershipContractPrice) AS NB_GradCP
,		(S_PostExtCnt * ClientMembershipContractPrice) AS S_PostExtCP
,       (NB_TradCnt * ClientMembershipContractPrice) AS NB_TradCP
,       (NB_ExtCnt * ClientMembershipContractPrice) AS NB_ExtCP
,       (NB_XtrCnt * ClientMembershipContractPrice) AS NB_XtrCP
,       (S_SurCnt * ClientMembershipContractPrice) AS S_SurCP
FROM #Sales
WHERE (NB_GradCnt <> 0
	OR	S_PostExtCnt <> 0
	OR  NB_TradCnt	 <> 0
	OR  NB_ExtCnt	 <> 0
	OR  NB_XtrCnt	 <> 0
	OR  S_SurCnt <> 0
)
END
ELSE
BEGIN
INSERT INTO #ContractPrice_Center
SELECT CenterKey
,		ClientKey
,		ClientMembershipContractPrice
,		(NB_GradCnt * ClientMembershipContractPrice) AS NB_GradCP
,		(S_PostExtCnt * ClientMembershipContractPrice) AS S_PostExtCP
,       (NB_TradCnt * ClientMembershipContractPrice) AS NB_TradCP
,       (NB_ExtCnt * ClientMembershipContractPrice) AS NB_ExtCP
,       (NB_XtrCnt * ClientMembershipContractPrice) AS NB_XtrCP
,       (S_SurCnt * ClientMembershipContractPrice) AS S_SurCP
FROM #Sales_Center
WHERE (NB_GradCnt <> 0
	OR	S_PostExtCnt <> 0
	OR  NB_TradCnt	 <> 0
	OR  NB_ExtCnt	 <> 0
	OR  NB_XtrCnt	 <> 0
	OR  S_SurCnt <> 0
)
END


IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #SUM_ContractPrice
SELECT EmployeeKey
,	SUM(NB_GradCP) + SUM(NB_TradCP) AS XP_Price
,	SUM(S_PostExtCP) + SUM(NB_ExtCP) AS EXT_Price
,	SUM(NB_XtrCP) AS XTR_Price
,	SUM(S_SurCP) AS SUR_Price
FROM #ContractPrice
GROUP BY EmployeeKey
END
ELSE
BEGIN
INSERT INTO #SUM_ContractPrice_Center
SELECT CenterKey
,	SUM(NB_GradCP) + SUM(NB_TradCP) AS XP_Price
,	SUM(S_PostExtCP) + SUM(NB_ExtCP) AS EXT_Price
,	SUM(NB_XtrCP) AS XTR_Price
,	SUM(S_SurCP) AS SUR_Price
FROM #ContractPrice_Center
GROUP BY CenterKey
END


/******** Final select *******************************************************************/


IF @Position IN('IC','MULTI')
BEGIN
INSERT INTO #Final
SELECT E.EmployeeKey
,       E.EmployeeSSID
,       E.EmployeePositionSSID
,       E.EmployeePositionDescription
,       E.EmployeeFullName
,       E.EmployeeFirstName
,       E.EmployeeLastName
,       E.UserLogin
,       E.CenterNumber
,       E.CenterDescriptionNumber
,       MAX(IC.NumberOfIC) AS NumberOfIC
,		MAX(IC.ConsBudgetPerIC) AS ConsBudgetPerIC
,		MAX(IC.SalesBudgetPerIC) AS SalesBudgetPerIC
,		MAX(IC.RevenueBudgetPerIC) AS RevenueBudgetPerIC
,		MAX(IC.BudgetNewStylesPerIC) AS BudgetNewStylesPerIC
,       E.CenterManager
,       E.CenterManagementAreaDescription
,       E.AreaManager
,		ISNULL(NS.Consultations,0) AS Consultations
,		ISNULL(NS.NetNB1Count,0) AS NetNB1Count
,		ISNULL(NS.NetNB1Revenue,0) AS NetNB1Revenue

,		ISNULL(NS.XTRPlus,0) AS XTRPlus
,		ISNULL(NS.NB_XPAmt,0) AS NB_XPAmt
,		ISNULL(NS.EXT,0) AS EXT
,		ISNULL(NS.NB_ExtAmt,0) AS NB_ExtAmt
,		ISNULL(NS.Xtrands,0) AS Xtrands
,		ISNULL(NS.NB_XtrAmt,0) AS NB_XtrAmt

,		ISNULL(NS.LaserCnt,0) AS LaserCnt
,		ISNULL(NS.LaserAmt,0) AS LaserAmt
,		ISNULL(NS.NB_MDPCnt,0) AS NB_MDPCnt
,		ISNULL(NS.NB_MDPAmt,0) AS NB_MDPAmt

,		ISNULL(CP.XP_Price,0) AS XP_Price
,		ISNULL(NS.NB_XPAmt,0) AS XP_Payments

,		ISNULL(CP.EXT_Price,0) AS EXT_Price
,		ISNULL(NS.NB_EXTAmt,0) AS EXT_Payments

,		ISNULL(CP.XTR_Price,0) AS XTR_Price
,		ISNULL(NS.NB_XtrAmt,0) AS XTR_Payments

,		ISNULL(Apps.Quantity,0) AS NSD
,		ISNULL(COM.AdvancedCommission,0) AS AdvancedCommission
,		ISNULL(R.Refunded,0) AS Refunded
,		ISNULL(D.Discount,0) AS Discount

FROM #Employee E
INNER JOIN #SUM_NetSales NS
	ON E.EmployeeKey = NS.EmployeeKey
LEFT JOIN #IC IC
	ON IC.CenterNumber = E.CenterNumber
LEFT JOIN #INITASG INI
	ON	INI.EmployeeKey = E.EmployeeKey
LEFT JOIN #NBSalesWithApps Apps
	ON E.EmployeeKey = Apps.EmployeeKey
LEFT JOIN #Refunds R
	ON E.EmployeeKey = R.Employee1Key
LEFT JOIN #Discounts D
	ON E.EmployeeKey = D.Employee1Key
LEFT JOIN #Commissions COM
	ON E.EmployeeKey = COM.EmployeeKey
LEFT JOIN #SUM_ContractPrice CP
	ON CP.EmployeeKey = E.EmployeeKey

GROUP BY E.EmployeeKey
,		E.EmployeeSSID
,		E.EmployeePositionSSID
,		E.EmployeePositionDescription
,		E.EmployeeFullName
,		E.EmployeeFirstName
,		E.EmployeeLastName
,		E.UserLogin
,		E.CenterNumber
,		E.CenterDescriptionNumber
,		E.CenterManager
,		E.CenterManagementAreaDescription
,		E.AreaManager
,		NS.Consultations
,		NS.NetNB1Count
,		NS.NetNB1Revenue

,		NS.XTRPlus
,		NS.NB_XPAmt
,		NS.EXT
,		NS.NB_ExtAmt
,		NS.Xtrands
,		NS.NB_XtrAmt
,		NS.LaserCnt
,		NS.LaserAmt
,		NS.NB_MDPCnt
,		NS.NB_MDPAmt

,		CP.XP_Price

,		CP.EXT_Price

,		CP.XTR_Price
,		ISNULL(COM.AdvancedCommission,0)
,		Apps.Quantity
,		R.Refunded
,		D.Discount
END
ELSE
BEGIN
INSERT INTO #Final
SELECT NULL AS EmployeeKey
,       NULL AS EmployeeSSID
,       NULL AS EmployeePositionSSID
,       MAN.EmployeePositionDescription
,       ISNULL(MAN.CenterManager,MAN.AreaManager) AS EmployeeFullName
,       NULL AS EmployeeFirstName
,       NULL AS EmployeeLastName
,       NULL AS UserLogin
,       MAN.CenterNumber
,       MAN.CenterDescriptionNumber
,       MAX(IC.NumberOfIC) AS NumberOfIC
,		MAX(IC.ConsBudgetPerIC) AS ConsBudgetPerIC
,		MAX(IC.SalesBudgetPerIC) AS SalesBudgetPerIC
,		MAX(IC.RevenueBudgetPerIC) AS RevenueBudgetPerIC
,		MAX(IC.BudgetNewStylesPerIC) AS BudgetNewStylesPerIC
,       MAN.CenterManager
,       MAN.CenterManagementAreaDescription
,		MAN.AreaManager
,		ISNULL(NSC.Consultations,0) AS Consultations
,		ISNULL(NSC.NetNB1Count,0) AS NetNB1Count
,		ISNULL(NSC.NetNB1Revenue,0) AS NetNB1Revenue

,		ISNULL(NSC.XTRPlus,0) AS XTRPlus
,		ISNULL(NSC.NB_XPAmt,0) AS NB_XPAmt
,		ISNULL(NSC.EXT,0) AS EXT
,		ISNULL(NSC.NB_ExtAmt,0) AS NB_ExtAmt
,		ISNULL(NSC.Xtrands,0) AS Xtrands
,		ISNULL(NSC.NB_XtrAmt,0) AS NB_XtrAmt

,		ISNULL(NSC.LaserCnt,0) AS LaserCnt
,		ISNULL(NSC.LaserAmt,0) AS LaserAmt
,		ISNULL(NSC.NB_MDPCnt,0) AS NB_MDPCnt
,		ISNULL(NSC.NB_MDPAmt,0) AS NB_MDPAmt

,		ISNULL(CPC.XP_Price,0) AS XP_Price
,		ISNULL(NSC.NB_XPAmt,0) AS XP_Payments

,		ISNULL(CPC.EXT_Price,0) AS EXT_Price
,		ISNULL(NSC.NB_EXTAmt,0) AS EXT_Payments

,		ISNULL(CPC.XTR_Price,0) AS XTR_Price
,		ISNULL(NSC.NB_XtrAmt,0) AS XTR_Payments

,		ISNULL(AppsC.Quantity,0) AS NSD
,		0 AS AdvancedCommission
,		ISNULL(RC.Refunded,0) AS Refunded
,		ISNULL(DC.Discount,0) AS Discount

FROM #CenterNumberList CN
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN #SUM_NetSales_Center NSC
	ON CTR.CenterKey = NSC.CenterKey
INNER JOIN #IC IC
	ON IC.CenterNumber = CTR.CenterNumber
INNER JOIN #CenterManager MAN
	ON MAN.CenterNumber = CN.CenterNumber
LEFT JOIN #INITASG INI
	ON	INI.CenterKey = CTR.CenterKey
LEFT JOIN #NBSalesWithApps_Center AppsC
	ON CTR.CenterKey = AppsC.CenterKey
LEFT JOIN #Refunds_Center RC
	ON CTR.CenterKey = RC.CenterKey
LEFT JOIN #Discounts_Center DC
	ON CTR.CenterKey = DC.CenterKey
LEFT JOIN #SUM_ContractPrice_Center CPC
	ON CPC.CenterKey = CTR.CenterKey
GROUP BY MAN.EmployeePositionDescription
,       MAN.CenterNumber
,       MAN.CenterManager
,		NSC.Consultations
,		NSC.NetNB1Count
,		NSC.NetNB1Revenue
,		NSC.XTRPlus
,		NSC.NB_XPAmt
,		NSC.EXT
,		NSC.NB_ExtAmt
,		NSC.Xtrands
,		NSC.NB_XtrAmt
,		NSC.LaserCnt
,		NSC.LaserAmt
,		NSC.NB_MDPCnt
,		NSC.NB_MDPAmt
,		CPC.XP_Price
,		CPC.EXT_Price
,		CPC.XTR_Price
,		AppsC.Quantity
,		RC.Refunded
,		DC.Discount
,		MAN.AreaManager
,		MAN.CenterDescriptionNumber
,		MAN.CenterManagementAreaDescription
,		MAN.CenterManagementAreaSSID
END


/********** Last select  ******************************/

SELECT EmployeeKey
,       EmployeeSSID
,       EmployeePositionSSID
,       EmployeePositionDescription
,       EmployeeFullName
,       EmployeeFirstName
,       EmployeeLastName
,       UserLogin
,       CenterNumber
,       CenterDescriptionNumber
,       NumberOfIC
,       ConsBudgetPerIC
,       SalesBudgetPerIC
,		RevenueBudgetPerIC
,		BudgetNewStylesPerIC
,       CenterManager
,       CenterManagementAreaDescription
,       AreaManager
,       Consultations
,       NetNB1Count
,       NetNB1Revenue

,		XTRPlus
,		NB_XPAmt
,		EXT
,		NB_ExtAmt
,		Xtrands
,		NB_XtrAmt
,		LaserCnt
,		LaserAmt
,		NB_MDPCnt
,		NB_MDPAmt

,		XP_Price
,		XP_Payments
,		EXT_Price
,		EXT_Payments
,		XTR_Price
,		XTR_Payments

,       NSD
,       AdvancedCommission
,       Refunded
,       Discount
,		@DaysRemaining AS DaysRemaining
,		RevenueBudgetPerIC - (XP_Payments + EXT_Payments + XTR_Payments) AS DollarsRemaining
,		CASE WHEN @DaysRemaining = 0 THEN 0 ELSE ((RevenueBudgetPerIC - (XP_Payments + EXT_Payments + XTR_Payments))/@DaysRemaining) END AS DollarsPerDay
,		@AvgSalePriceBudget AS AvgSalePriceBudget
,		@ClosingBudget AS ClosingBudget
,		dbo.DIVIDE_DECIMAL(NetNB1Revenue,NetNB1Count) AS AvgSalePriceActual
,		dbo.DIVIDE_NOROUND(NetNB1Count,Consultations) AS ClosingPercentActual  --ClosingPercent needs 4 characters past the decimal
,		dbo.DIVIDE_DECIMAL(Discount,NetNB1Revenue) AS DiscountPercent
,		@StartDate AS StartDate
,		@EndDate AS EndDate
FROM #Final



END
GO
