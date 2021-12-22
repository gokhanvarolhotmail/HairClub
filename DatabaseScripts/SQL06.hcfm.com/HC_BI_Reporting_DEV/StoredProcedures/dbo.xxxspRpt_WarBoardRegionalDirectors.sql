/* CreateDate: 08/06/2012 11:27:32.433 , ModifyDate: 01/06/2016 08:53:56.570 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardRegionalDirectors

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/02/2012

==============================================================================
DESCRIPTION:	New Business War Board - This version is for Corporate @sType = 'C'
==============================================================================
NOTES:	@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
12/17/2013 - MB - Modified all budget amounts to be 1 if they are currently budgeted at 0 (WO# 94762)
06/18/2014 - RH - Added AccountID = 10206 and 10306 for Xtrands
12/16/2014 - RH - Changed source of RetailSales to be Transaction Center based.
01/26/2015 - RH - (WO#111085) Removed 10555 (RetailSales$), found RetailSales$ in a temp table from FactSalesTransaction
					and then updated TotalRevenueActual = SubTotalRevenueActual + RetailSales
05/08/2015 - RH - (WO#110875) Added @Filter By Region, By RSM - NB1, By RSM - MA, By RTM
05/19/2015 - RH - (WO#114770) Added @Filter By ROM - Assistant Regional Manager
06/10/2015 - RH - (WO#115208) Changed 10440 to 10430 for Conversions (BIO only); Changed PCPRevenueActual and Budget to BIO, EXT and Xtrands;
					Added separate fields for EXT Conversions and Xtrands Conversions; Changed AccountID's for TotalRevenueActual_Sub to match the Flash Recurring Customer
07/14/2015 - RH - (WO#116450) Changed AccountID's to include 10540 Non-Program $ for TotalRevenueActual_Sub to match the Flash Recurring Customer
07/30/2015 - RH - (WO#117322) Added rounding to the final amounts
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
==============================================================================
SAMPLE EXECUTION:

EXEC spRpt_WarBoardRegionalDirectors 1,12,2015, 3
EXEC spRpt_WarBoardRegionalDirectors 2,12,2015, 12771
EXEC spRpt_WarBoardRegionalDirectors 3,12,2015, 287
==============================================================================
*/
CREATE PROCEDURE [dbo].[xxxspRpt_WarBoardRegionalDirectors] (
	@Filter	INT
,	@Month	INT
,	@Year	INT
,	@MainGroupID INT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

/********************************** Create temp table objects *************************************/
IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
BEGIN
	DROP TABLE #Centers
END
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
,	EmployeeKey INT
,	EmployeeFullName VARCHAR(102)
)
IF OBJECT_ID('tempdb..#Centers_sub') IS NOT NULL
BEGIN
	DROP TABLE #Centers_sub
END
CREATE TABLE #Centers_sub (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
,	EmployeeKey INT
,	EmployeeFullName VARCHAR(102)
)

/********************************** Get list of centers ************************************************/


IF @Filter = 1 -- By Region
BEGIN
	INSERT  INTO #Centers_sub
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			,		NULL AS EmployeeKey
			,		NULL AS EmployeeFullName
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
					AND DC.Active = 'Y'
END


IF @Filter = 2 -- By Area Managers
BEGIN
	INSERT  INTO #Centers_sub
			SELECT  AM.EmployeeKey AS 'MainGroupID'
			,		AM.EmployeeFullName AS 'MainGroup'
			,		AM.CenterSSID
			,		AM.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		AM.CenterKey
			,		AM.EmployeeKey
			,		AM.EmployeeFullName
			FROM   dbo.vw_AreaManager AM
			WHERE   CONVERT(VARCHAR, AM.CenterSSID) LIKE '[2]%'
					AND AM.Active = 'Y'
END


IF @Filter = 3 -- By Center
BEGIN
	INSERT  INTO #Centers_sub
			SELECT  DC.CenterSSID AS 'MainGroupID'
			,		DC.CenterDescriptionNumber AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			,		NULL AS EmployeeKey
			,		NULL AS EmployeeFullName
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
					AND DC.Active = 'Y'
END

IF @MainGroupID = 0 --Show all
BEGIN
	INSERT INTO #Centers
	SELECT MainGroupID
         , MainGroup
         , CenterSSID
         , CenterDescriptionNumber
         , CenterTypeDescriptionShort
         , CenterKey
         , EmployeeKey
         , EmployeeFullName
	FROM #Centers_sub
	GROUP BY MainGroupID
         , MainGroup
         , CenterSSID
         , CenterDescriptionNumber
         , CenterTypeDescriptionShort
         , CenterKey
         , EmployeeKey
         , EmployeeFullName
END
ELSE
BEGIN
	INSERT INTO #Centers
	SELECT MainGroupID
         , MainGroup
         , CenterSSID
         , CenterDescriptionNumber
         , CenterTypeDescriptionShort
         , CenterKey
         , EmployeeKey
         , EmployeeFullName
	FROM #Centers_sub
	WHERE MainGroupID = @MainGroupID
	AND MainGroupID IS NOT NULL
	GROUP BY MainGroupID
         , MainGroup
         , CenterSSID
         , CenterDescriptionNumber
         , CenterTypeDescriptionShort
         , CenterKey
         , EmployeeKey
         , EmployeeFullName
END

	--SELECT * FROM #Centers_sub


	/*/********************************** Create temp table objects *************************************/

	CREATE TABLE #Centers (
		MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	CenterSSID INT
	,	CenterDescriptionNumber VARCHAR(255)
	,	CenterTypeDescriptionShort VARCHAR(50)
	,	CenterKey INT
	)

	CREATE TABLE #Centers_sub (
		MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	CenterSSID INT
	,	CenterDescriptionNumber VARCHAR(255)
	,	CenterTypeDescriptionShort VARCHAR(50)
	,	CenterKey INT
	)

/********************************** Get list of centers ************************************************/

	DECLARE @sType NVARCHAR(1)
	SET @sType = 'C'  --This report is only pulling for Corporate (War Board Corporate)

	IF @sType = 'C' AND @Filter = 1 -- By Region
	BEGIN
		INSERT  INTO #Centers_sub
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'C' AND @Filter = 2 -- By RSM - NB1
	BEGIN
		INSERT  INTO #Centers_sub
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionNB1, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMNBConsultantSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'C' AND @Filter = 3 -- By RSM - MA
	BEGIN
		INSERT  INTO #Centers_sub
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionMA, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMMembershipAdvisorSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END

	IF @sType = 'C' AND @Filter = 4 -- By RTM
	BEGIN
		INSERT  INTO #Centers_sub
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionTM, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END

		IF @sType = 'C' AND @Filter = 5 -- By ROM --Assistant Regional Director
	BEGIN
		INSERT  INTO #Centers_sub
				SELECT  CAST(RIGHT(DE.EmployeePayrollID,4) AS INT) AS 'MainGroupID'
				,		DE.EmployeeFullNameCalc AS 'MainGroup'
				,		[DEC].CenterID AS 'CenterSSID'
				,		CenterDescriptionFullCalc AS 'CenterDescriptionNumber'
				,		'C' AS 'CenterTypeDescriptionShort'
				,		DC.CenterKey
				FROM    SQL05.HairclubCMS.dbo.datEmployee DE
						INNER JOIN SQL05.HairclubCMS.dbo.datEmployeeCenter [DEC]
							ON [DEC].EmployeeGUID = DE.EmployeeGUID
						INNER JOIN SQL05.HairclubCMS.dbo.cfgEmployeePositionJoin CEPJ
							ON CEPJ.EmployeeGUID = DE.EmployeeGUID
						INNER JOIN SQL05.HairclubCMS.dbo.lkpEmployeePosition LEP
							ON LEP.EmployeePositionID = CEPJ.EmployeePositionID
						INNER JOIN SQL05.HairclubCMS.dbo.cfgCenter C
							ON [DEC].CenterID = C.CenterID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
							ON C.CenterID = DC.CenterSSID
				WHERE   LEP.EmployeePositionID = 47
				AND DE.FirstName <> 'Test'
				AND [DEC].CenterID LIKE '[2]%'
				AND DC.Active = 'Y'
				AND DE.EmployeePayrollID IS NOT NULL

	END


	IF @sType = 'F' AND @Filter = 1
	BEGIN
		INSERT  INTO #Centers_sub
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'F' AND @Filter = 2
	BEGIN
		INSERT  INTO #Centers_sub
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionNB1, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMNBConsultantSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'F' AND @Filter = 3
		BEGIN
			INSERT  INTO #Centers_sub
					SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
					,		ISNULL(DC.RegionMA, 'Unknown, Unknown') AS 'MainGroup'
					,		DC.CenterSSID
					,		DC.CenterDescriptionNumber
					,		DCT.CenterTypeDescriptionShort
					,		DC.CenterKey
					FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
								ON DC.CenterTypeKey = DCT.CenterTypeKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
								ON DC.RegionSSID = DR.RegionKey
							LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON DC.RegionRSMMembershipAdvisorSSID = DE.EmployeeSSID
					WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
							AND DC.Active = 'Y'
		END

	IF @sType = 'F' AND @Filter = 4
		BEGIN
			INSERT  INTO #Centers_sub
					SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
					,		ISNULL(DC.RegionTM, 'Unknown, Unknown') AS 'MainGroup'
					,		DC.CenterSSID
					,		DC.CenterDescriptionNumber
					,		DCT.CenterTypeDescriptionShort
					,		DC.CenterKey
					FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
								ON DC.CenterTypeKey = DCT.CenterTypeKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
								ON DC.RegionSSID = DR.RegionKey
							LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
					WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
							AND DC.Active = 'Y'
		END


	IF @MainGroupID = 0 --Show all
	BEGIN
		INSERT INTO #Centers
		SELECT * FROM #Centers_sub
		GROUP BY MainGroupID, MainGroup, CenterSSID, CenterDescriptionNumber, CenterTypeDescriptionShort, CenterKey
	END
	ELSE
	BEGIN
		INSERT INTO #Centers
		SELECT * FROM #Centers_sub
		WHERE MainGroupID = @MainGroupID
		AND MainGroupID IS NOT NULL
		GROUP BY MainGroupID, MainGroup, CenterSSID, CenterDescriptionNumber, CenterTypeDescriptionShort, CenterKey
	END
*/
	/********* Find Retail Sales based on Transaction Center **************************************************/

	SELECT  C.MainGroupID
		,	C.MainGroup
		,	C.CenterSSID
		,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailSales' --To match the Flash
	INTO	#Retail
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN #Centers C
				ON FST.CenterKey = C.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
				ON FST.SalesCodeKey = DSC.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
				ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
	WHERE   DD.MonthNumber = @Month
			AND DD.YearNumber = @Year
			AND ( DSCD.SalesCodeDivisionSSID IN ( 30, 50 )
				  OR DSC.SalesCodeDescriptionShort IN ( 'HM3V5', 'EXTPMTLC', 'EXTPMTLCP' ) )
	GROUP BY C.MainGroupID
		,	C.MainGroup
		,	C.CenterSSID



	/********* Find Budget and Actual Amounts **************************************************/


	SELECT C.MainGroupID
		,	C.MainGroup
		,	C.CenterSSID
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN Flash ELSE 0 END, 0)) AS 'NetNB1CountActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN Budget ELSE 0 END, 0)) END AS 'NetNB1CountBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325) THEN Flash ELSE 0 END, 0)) AS 'NetNb1RevenueActual'  --BIO, EXT, Xtrands, Surgery and Post EXT
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) END AS 'NetNb1RevenueBudget' --BIO, EXT, Xtrands, Surgery and Post EXT
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'ApplicationsActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 0)) END AS 'ApplicationsBudget'

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BIOConversionsActual'  --BIO only
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Budget ELSE 0 END, 0)) END AS 'BIOConversionsBudget'	--BIO only

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Flash ELSE 0 END, 0)) AS 'EXTConversionsActual'  --EXT only
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Budget ELSE 0 END, 0)) END AS 'EXTConversionsBudget'	--EXT only

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Flash ELSE 0 END, 0)) AS 'XtrandsConversionsActual'  --Xtrands only
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Budget ELSE 0 END, 0)) END AS 'XtrandsConversionsBudget'	--Xtrands only


	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN Flash ELSE 0 END, 0)) AS 'PCPRevenueActual'						--BIO,EXT and Xtrands
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN Budget ELSE 0 END, 0)) END AS 'PCPRevenueBudget'	--BIO,EXT and Xtrands
		,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306,  10310, 10315,10320, 10325, 10530, 10540, 10575) THEN Flash ELSE 0 END, 0)) = 0
			THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306,  10310, 10315,10320, 10325, 10530, 10540, 10575) THEN Flash ELSE 0 END, 0))
			END AS 'SubTotalRevenueActual'
	,	NULL AS 'TotalRevenueActual'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306,  10310, 10315, 10320, 10325, 10530, 10555, 10575) THEN Budget ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10306,  10310, 10315, 10320, 10325, 10530, 10555, 10575) THEN Budget ELSE 0 END, 0)) END AS 'TotalRevenueBudget'

	INTO #Accounting
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterSSID
	WHERE MONTH(FA.PartitionDate)=@Month
	  AND YEAR(FA.PartitionDate)=@Year
	GROUP BY C.MainGroupID
		,	C.MainGroup
		,	C.CenterSSID


	UPDATE ACCT  --Added statement RH 1/26/2015  Retail Sales is based on Transaction Center
	SET ACCT.TotalRevenueActual = (ACCT.SubTotalRevenueActual + R.RetailSales)
	FROM #Accounting ACCT
	INNER JOIN #Retail R ON ACCT.CenterSSID = R.CenterSSID
	WHERE ACCT.TotalRevenueActual IS NULL


	/****************************  Final Select  ************************************************************************/

	SELECT C.MainGroupID
		,	C.MainGroup
		,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	ROUND(A.NetNB1CountActual,0) AS 'NetNB1CountActual'
	,	CASE WHEN ROUND(A.NetNB1CountBudget,0)= 0 THEN 1 ELSE ROUND(A.NetNB1CountBudget,0)END AS 'NetNB1CountBudget'
	,	CASE WHEN ROUND(A.NetNB1CountBudget,0)= 0 THEN (ROUND(A.NetNB1CountActual,0) - 1) ELSE ROUND(A.NetNB1CountActual,0) - ROUND(A.NetNB1CountBudget,0)END AS 'NetNB1CountDiff'
	,	CASE WHEN ROUND(A.NetNB1CountBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.NetNB1CountActual,0), 1)ELSE dbo.DIVIDE_DECIMAL(ROUND(A.NetNB1CountActual,0), ROUND(A.NetNB1CountBudget,0)) END AS 'NetNB1CountPercent'

	,	ROUND(A.NetNb1RevenueActual,0) AS 'NetNb1RevenueActual'
	,	CASE WHEN ROUND(A.NetNb1RevenueBudget,0) = 0 THEN 1 ELSE ROUND(A.NetNb1RevenueBudget,0) END AS 'NetNb1RevenueBudget'
	,	CASE WHEN ROUND(A.NetNb1RevenueBudget,0) = 0 THEN (ROUND(A.NetNb1RevenueActual,0) - 1) ELSE ROUND(A.NetNb1RevenueActual,0) - ROUND(A.NetNb1RevenueBudget,0)END AS 'NetNB1RevenueDiff'
	,	CASE WHEN ROUND(A.NetNb1RevenueBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.NetNb1RevenueActual,0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(A.NetNb1RevenueActual,0), ROUND(A.NetNb1RevenueBudget,0))	END AS 'NetNB1RevenuePercent'


	,	ROUND(A.ApplicationsActual,0) AS 'ApplicationsActual'
	,	CASE WHEN ROUND(A.ApplicationsBudget,0) = 0 THEN 1 ELSE ROUND(A.ApplicationsBudget,0) END  AS 'ApplicationsBudget'
	,	CASE WHEN ROUND(A.ApplicationsBudget,0) = 0 THEN (ROUND(A.ApplicationsActual,0) - 1) ELSE ROUND(A.ApplicationsActual,0) - ROUND(A.ApplicationsBudget,0)END AS 'ApplicationDiff'
	,	CASE WHEN ROUND(A.ApplicationsBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.ApplicationsActual,0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(A.ApplicationsActual,0), ROUND(A.ApplicationsBudget,0))	END AS 'ApplicationPercent'

	,	ROUND(A.BIOConversionsActual,0) AS 'BIOConversionsActual'
	,	CASE WHEN ROUND(A.BIOConversionsBudget,0) = 0 THEN 1 ELSE ROUND(A.BIOConversionsBudget,0) END AS 'BIOConversionsBudget'
	,	CASE WHEN ROUND(A.BIOConversionsBudget,0) = 0 THEN (ROUND(A.BIOConversionsActual,0) - 1) ELSE ROUND(A.BIOConversionsActual,0) - ROUND(A.BIOConversionsBudget,0)END AS 'BIOConversionDiff'
	,	CASE WHEN ROUND(A.BIOConversionsBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.BIOConversionsActual,0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(A.BIOConversionsActual,0), ROUND(A.BIOConversionsBudget,0))	END AS 'BIOConversionPercent'

	,	ROUND(A.EXTConversionsActual,0) AS 'EXTConversionsActual'
	,	CASE WHEN ROUND(A.EXTConversionsBudget,0) = 0 THEN 1 ELSE ROUND(A.EXTConversionsBudget,0) END AS 'EXTConversionsBudget'
	,	CASE WHEN ROUND(A.EXTConversionsBudget,0) = 0 THEN (ROUND(A.EXTConversionsActual,0) - 1) ELSE ROUND(A.EXTConversionsActual,0) - ROUND(A.EXTConversionsBudget,0) END AS 'EXTConversionDiff'
	,	CASE WHEN ROUND(A.EXTConversionsBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.EXTConversionsActual,0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(A.EXTConversionsActual,0), ROUND(A.EXTConversionsBudget,0))	END AS 'EXTConversionPercent'

	,	ROUND(A.XtrandsConversionsActual,0) AS 'XtrandsConversionsActual'
	,	CASE WHEN ROUND(A.XtrandsConversionsBudget,0) = 0 THEN 1 ELSE ROUND(A.XtrandsConversionsBudget,0) END AS 'XtrandsConversionsBudget'
	,	CASE WHEN ROUND(A.XtrandsConversionsBudget,0) = 0 THEN (ROUND(A.XtrandsConversionsActual,0) - 1) ELSE ROUND(A.XtrandsConversionsActual,0) - ROUND(A.XtrandsConversionsBudget,0)END AS 'XtrandsConversionDiff'
	,	CASE WHEN ROUND(A.XtrandsConversionsBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.XtrandsConversionsActual,0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(A.XtrandsConversionsActual,0), ROUND(A.XtrandsConversionsBudget,0))	END AS 'XtrandsConversionPercent'

	,	ROUND(A.PCPRevenueActual,0) AS 'PCPRevenueActual'
	,	CASE WHEN ROUND(A.PCPRevenueBudget,0) = 0 THEN 1 ELSE ROUND(A.PCPRevenueBudget,0) END AS 'PCPRevenueBudget'
	,	CASE WHEN ROUND(A.PCPRevenueBudget,0) = 0 THEN (ROUND(A.PCPRevenueActual,0) - 1) ELSE ROUND(A.PCPRevenueActual,0) - ROUND(A.PCPRevenueBudget,0)END AS 'PCPDiff'
	,	CASE WHEN ROUND(A.PCPRevenueBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.PCPRevenueActual,0),1) ELSE dbo.DIVIDE_DECIMAL(ROUND(A.PCPRevenueActual,0), ROUND(A.PCPRevenueBudget,0)) 	END AS 'PCPPercent'

	,	ROUND(A.TotalRevenueActual,0) AS 'TotalRevenueActual'
	,	CASE WHEN ROUND(A.TotalRevenueBudget,0) = 0 THEN 1 ELSE ROUND(A.TotalRevenueBudget,0) END  AS 'TotalRevenueBudget'
	,	CASE WHEN ROUND(A.TotalRevenueBudget,0) = 0 THEN (ROUND(A.TotalRevenueActual,0) - 1) ELSE ROUND(A.TotalRevenueActual,0) - ROUND(A.TotalRevenueBudget,0)END AS 'TotalDiff'
	,	CASE WHEN ROUND(A.TotalRevenueBudget,0)= 0 THEN dbo.DIVIDE_DECIMAL(ROUND(A.TotalRevenueActual,0), 1) ELSE dbo.DIVIDE_DECIMAL(ROUND(A.TotalRevenueActual,0), ROUND(A.TotalRevenueBudget,0)) 	END AS 'TotalPercent'
	FROM #Accounting A
		INNER JOIN #Centers C
			ON A.CenterSSID = C.CenterSSID
	GROUP BY C.MainGroupID
		,	C.MainGroup
		,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	A.NetNB1CountActual
	,	A.NetNB1CountBudget
	,	A.NetNB1CountActual - A.NetNB1CountBudget
	,	dbo.DIVIDE_DECIMAL(A.NetNB1CountActual, A.NetNB1CountBudget)
	,	A.NetNb1RevenueActual
	,	A.NetNb1RevenueBudget
	,	A.NetNb1RevenueActual - A.NetNb1RevenueBudget
	,	dbo.DIVIDE_DECIMAL(A.NetNb1RevenueActual, A.NetNb1RevenueBudget)
	,	A.ApplicationsActual
	,	A.ApplicationsBudget
	,	A.ApplicationsActual - A.ApplicationsBudget
	,	dbo.DIVIDE_DECIMAL(A.ApplicationsActual, A.ApplicationsBudget)

	,	A.BIOConversionsActual
	,	A.BIOConversionsBudget
	,	A.BIOConversionsActual - A.BIOConversionsBudget
	,	dbo.DIVIDE_DECIMAL(A.BIOConversionsActual, A.BIOConversionsBudget)

		,	A.EXTConversionsActual
	,	A.EXTConversionsBudget
	,	A.EXTConversionsActual - A.EXTConversionsBudget
	,	dbo.DIVIDE_DECIMAL(A.EXTConversionsActual, A.EXTConversionsBudget)

		,	A.XtrandsConversionsActual
	,	A.XtrandsConversionsBudget
	,	A.XtrandsConversionsActual - A.XtrandsConversionsBudget
	,	dbo.DIVIDE_DECIMAL(A.XtrandsConversionsActual, A.XtrandsConversionsBudget)

	,	A.PCPRevenueActual
	,	A.PCPRevenueBudget
	,	A.PCPRevenueActual - A.PCPRevenueBudget
	,	dbo.DIVIDE_DECIMAL(A.PCPRevenueActual, A.PCPRevenueBudget)
	,	A.TotalRevenueActual
	,	A.TotalRevenueBudget
	,	A.TotalRevenueActual - A.TotalRevenueBudget
	,	dbo.DIVIDE_DECIMAL(A.TotalRevenueActual, A.TotalRevenueBudget)


END
GO
