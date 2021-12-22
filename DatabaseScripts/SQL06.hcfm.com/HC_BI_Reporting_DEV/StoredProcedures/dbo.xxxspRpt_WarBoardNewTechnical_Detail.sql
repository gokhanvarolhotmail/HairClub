/*
==============================================================================

PROCEDURE:				spRpt_WarBoardNewTechnical_Detail

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		08/29/2014

==============================================================================
DESCRIPTION:	New Business War Board (Detail)
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
08/28/2014 - RH - (#104657) Created a new version stored procedure and report with - Budget + (.10 * Budget) as the Goal;
					Found past 3 months and current 3 months PCP counts to compare them; Added 10206 - NB-Xtrands Sales#, 10306 Xtrands Revenue
09/08/2014 - RH - Removed Xtrands per Tina; Changed Accountid = 10555 to 3090 for Budget Amounts per Danny.
09/22/2014 - RH - Removed cap for Retail
10/03/2014 - RH - Added cap of 150% for PCP Growth
12/16/2014 - DL - Seperated Retail Sales from Main Query & Determined From FactSalesTransactions instead of FactAccounting.
02/04/2015 - RH - Added cap of 150% for Retail Sales
03/18/2015 - RH - Changed AccountID to 10400 (Only BIO PCP) from 10410 (All PCP) WO#110674
07/16/2015 - RH - (#115665) Added the Budget for Laser Retail AccountID = 3096
11/16/2015 - RH - (#120354) Changed @FirstDay1MonthAgo to match the Flash Recurring Business - moved it one month forward.
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
==============================================================================

SAMPLE EXECUTION:

EXEC [spRpt_WarBoardNewTechnical_Detail] 1, 12, 2015, 3
EXEC [spRpt_WarBoardNewTechnical_Detail] 2, 12, 2015, 12771
EXEC [spRpt_WarBoardNewTechnical_Detail] 3, 12, 2015, 287

==============================================================================
*/
CREATE PROCEDURE [dbo].[xxxspRpt_WarBoardNewTechnical_Detail] (
	@Filter	INT
,	@Month	TINYINT
,	@Year	SMALLINT
,	@MainGroupID INT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @stype VARCHAR(1)
	,	@FirstDayMonth DATETIME
	,	@LastDayMonth DATETIME
	,	@StartDate SMALLDATETIME
	,	@EndDate SMALLDATETIME
	,	@AppsToHairSales_Cap NUMERIC(15,5)
	,	@PCPGrowth_Cap NUMERIC(15,5) -- Added 10/03/2014 - RH
	,	@RetailToGoalPercent_Cap NUMERIC(15,5)

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

	CREATE TABLE #pcpcounts(
		MainGroupID INT
	,	MainGroup NVARCHAR(50)
	,	CenterSSID INT
	,	PCPMonth DATETIME
	,   PCPCount6MonthsAgo FLOAT
	,   PCPCount5MonthsAgo FLOAT
	,   PCPCount4MonthsAgo FLOAT
	,   PCPCount3MonthsAgo FLOAT
	,   PCPCount2MonthsAgo FLOAT
	,   PCPCount1MonthAgo FLOAT
	)


	CREATE TABLE #avgpcp(
		MainGroupID INT
	,	MainGroup NVARCHAR(50)
	,	CenterSSID INT
	,	PCPMonth DATETIME
	,   PCPCount6MonthsAgo FLOAT
	,   PCPCount5MonthsAgo FLOAT
	,   PCPCount4MonthsAgo FLOAT
	,   PCPCount3MonthsAgo FLOAT
	,   PCPCount2MonthsAgo FLOAT
	,   PCPCount1MonthAgo FLOAT
	,	Past3MonthsAvgPCPCounts FLOAT
	,	Current3MonthsAvgPCPCounts FLOAT
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
							ON DC.RegionSSID = DR.RegionSSID
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



	/********************* Set Variables ******************************************************/

	SELECT @FirstDayMonth = CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))
	,	@LastDayMonth = DATEADD(dd, -1, DATEADD(mm, 1, @FirstDayMonth))
	,	@AppsToHairSales_Cap = 1.5
	,	@PCPGrowth_Cap = 1.5
	,	@RetailToGoalPercent_Cap = 1.50



	/************************** Get Accounting [#Accounting] **************************************************/

	SELECT C.MainGroupID
	,	C.MainGroup
	,	C.CenterSSID
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205) THEN Flash ELSE 0 END, 0)) AS 'NetTradCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10210) THEN Flash ELSE 0 END, 0)) AS 'NetGradCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10215) THEN Flash ELSE 0 END, 0)) AS 'NetEXTCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10220) THEN Flash ELSE 0 END, 0)) AS 'NetSurCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10225) THEN Flash ELSE 0 END, 0)) AS 'NetPostEXTCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10110) THEN Flash ELSE 0 END, 0)) AS 'Consultations'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BioConversions'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'Applications' --NB - Applications #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10400) THEN Flash ELSE 0 END, 0)) AS 'CurrentMonthPCPCount'  --Changed to 10400 RH 03/18/2015
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10210, 10215, 10220, 10225) THEN Flash ELSE 0 END, 0)) AS 'NetNb1Count'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'NetNb1Budget'					--Added 10306 XTrands
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (3090,3096) THEN (Budget*(-1)) ELSE 0 END, 0)) AS 'RetailAmountBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (3090,3096) THEN ((Budget*(-1)) + (.10 * (Budget*(-1)))) ELSE 0 END, 0)) AS 'Goal'  --Goal is 10% above Budget


	INTO #Accounting
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterSSID
	WHERE MONTH(FA.PartitionDate)=@Month
	  AND YEAR(FA.PartitionDate)=@Year
	GROUP BY C.MainGroupID
	,	C.MainGroup
	,	C.CenterSSID



SELECT  CTR.ReportingCenterSSID AS 'CenterSSID'
,       SUM(CASE WHEN DSCD.SalesCodeDivisionSSID = 30 THEN FST.ExtendedPrice ELSE 0 END) AS 'RetailSales'
INTO	#Retail
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
            ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DD.MonthNumber = @Month
        AND DD.YearNumber = @Year
        AND ( DSCD.SalesCodeDivisionSSID IN ( 30, 50 )
              OR DSC.SalesCodeDescriptionShort IN ( 'HM3V5', 'EXTPMTLC', 'EXTPMTLCP' ) )
GROUP BY CTR.ReportingCenterSSID



	/************************** Get Data [#Data] **************************************************/

	SELECT A.MainGroupID
	,	A.MainGroup
	,	A.CenterSSID
	,	A.Applications
	,	R.RetailSales
	,	A.RetailAmountBudget
	,	A.Goal
	,	(NetTradCount + NetGradCount) AS 'HairSales'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(Applications, (NetTradCount + NetGradCount)) > @AppsToHairSales_Cap
			THEN @AppsToHairSales_Cap
			ELSE dbo.DIVIDE_DECIMAL(Applications, (NetTradCount + NetGradCount))
		END AS 'AppsToHairSalesPercent'
	,	CASE WHEN dbo.DIVIDE_DECIMAL((RetailSales), Goal) > @RetailToGoalPercent_Cap
			THEN @RetailToGoalPercent_Cap
			ELSE dbo.DIVIDE_DECIMAL((RetailSales), Goal)
		END AS 'RetailToGoalPercent'
	INTO	#Data
	FROM	#Accounting A
			LEFT OUTER JOIN #Retail R
				ON A.CenterSSID = R.CenterSSID




	/***************************Get past 6 months PCP Counts and Averages********************/
	DECLARE @FirstDay6MonthsAgo DATETIME
	DECLARE @FirstDay5MonthsAgo DATETIME
	DECLARE @FirstDay4MonthsAgo DATETIME
	DECLARE @FirstDay3MonthsAgo DATETIME
	DECLARE @FirstDay2MonthsAgo DATETIME
	DECLARE @FirstDay1MonthAgo DATETIME

	--1
	--SELECT @FirstDay1MonthAgo = DATEADD(m,-1,(CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))))
	SELECT @FirstDay1MonthAgo = CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))
	PRINT @FirstDay1MonthAgo

	--2
	SELECT @FirstDay2MonthsAgo = DATEADD(m,-1,@FirstDay1MonthAgo)
	PRINT @FirstDay2MonthsAgo

	--3
	SELECT @FirstDay3MonthsAgo = DATEADD(m,-2,@FirstDay1MonthAgo)
	PRINT @FirstDay3MonthsAgo

	--4
	SELECT @FirstDay4MonthsAgo = DATEADD(m,-3,@FirstDay1MonthAgo)
	PRINT @FirstDay4MonthsAgo

	--5
	SELECT @FirstDay5MonthsAgo = DATEADD(m,-4,@FirstDay1MonthAgo)
	PRINT @FirstDay5MonthsAgo

	--6
	SELECT @FirstDay6MonthsAgo = DATEADD(m,-5,@FirstDay1MonthAgo)
	PRINT @FirstDay6MonthsAgo

	/******************************/

	INSERT INTO #pcpcounts	(MainGroupID, MainGroup, CenterSSID, PCPMonth)
	SELECT C.MainGroupID
	,	C.MainGroup
	,	C.CenterSSID
	,	@FirstDay1MonthAgo AS 'PCPMonth'

	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterSSID
	GROUP BY C.MainGroupID
	,	C.MainGroup
	,	C.CenterSSID



	--SELECT * FROM #pcpcounts

	UPDATE pcp
	SET pcp.PCPCount6MonthsAgo = FA.Flash
	FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterSSID = FA.CenterID
	WHERE FA.AccountID IN (10400)				--Changed to 10400 RH 03/18/2015
	AND FA.PartitionDate = @FirstDay6MonthsAgo


	UPDATE pcp
	SET pcp.PCPCount5MonthsAgo = FA.Flash
	FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterSSID = FA.CenterID
	WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay5MonthsAgo



	UPDATE pcp
	SET pcp.PCPCount4MonthsAgo = FA.Flash
	FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterSSID = FA.CenterID
	WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay4MonthsAgo



	UPDATE pcp
	SET pcp.PCPCount3MonthsAgo = FA.Flash
	FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterSSID = FA.CenterID
	WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay3MonthsAgo



	UPDATE pcp
	SET pcp.PCPCount2MonthsAgo = FA.Flash
	FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterSSID = FA.CenterID
	WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay2MonthsAgo



	UPDATE pcp
	SET pcp.PCPCount1MonthAgo = FA.Flash
	FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterSSID = FA.CenterID
	WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay1MonthAgo

	--SELECT * FROM #pcpcounts

	INSERT INTO #avgpcp
	SELECT MainGroupID
			,	MainGroup
			,	CenterSSID
			,	PCPMonth
			,   PCPCount6MonthsAgo
			,   PCPCount5MonthsAgo
			,   PCPCount4MonthsAgo
			,   PCPCount3MonthsAgo
			,   PCPCount2MonthsAgo
			,   PCPCount1MonthAgo
	,	(PCPCount6MonthsAgo + PCPCount5MonthsAgo + PCPCount4MonthsAgo)/3 AS 'Past3MonthsAvgPCPCounts'
	,	(PCPCount3MonthsAgo + PCPCount2MonthsAgo + PCPCount1MonthAgo)/3 AS 'Current3MonthsAvgPCPCounts'
	FROM #pcpcounts
	GROUP BY MainGroupID
			,	MainGroup
			,	CenterSSID
			,	PCPMonth
			,   PCPCount6MonthsAgo
			,   PCPCount5MonthsAgo
			,   PCPCount4MonthsAgo
			,   PCPCount3MonthsAgo
			,   PCPCount2MonthsAgo
			,   PCPCount1MonthAgo

	--SELECT * FROM #avgpcp



	/************************** Get Totals **************************************************/
	----Find the cap for PCGrowthCount

	SELECT MainGroupID
			,	MainGroup
			,	CenterSSID
			,	CenterDescriptionNumber
			,	PCPMonth
			,   ISNULL(PCPCount6MonthsAgo,0) AS 'PCPCount6MonthsAgo'
			,   ISNULL(PCPCount5MonthsAgo,0) AS 'PCPCount5MonthsAgo'
			,   ISNULL(PCPCount4MonthsAgo,0) AS 'PCPCount4MonthsAgo'
			,   ISNULL(PCPCount3MonthsAgo,0) AS 'PCPCount3MonthsAgo'
			,   ISNULL(PCPCount2MonthsAgo,0) AS 'PCPCount2MonthsAgo'
			,   ISNULL(PCPCount1MonthAgo,0) AS 'PCPCount1MonthAgo'
			,	ISNULL(AppsToHairSalesPercent,0) AS 'AppsToHairSalesPercent'
			,	ISNULL(RetailToGoalPercent,0) AS 'RetailToGoalPercent'
			,	ISNULL(Past3MonthsAvgPCPCounts,0) AS 'Past3MonthsAvgPCPCounts'
			,	ISNULL(Current3MonthsAvgPCPCounts,0) AS 'Current3MonthsAvgPCPCounts'
			,	CASE WHEN PCGrowthCount > 1.5 THEN 1.5 ELSE ISNULL(PCGrowthCount,0)  END AS 'PCGrowthCount'-- Cap 150, Weight 25
			,	ISNULL(HairSales,0) AS 'HairSales'
			,	ISNULL(Applications,0) AS 'Applications'
			,	ISNULL(RetailSales,0) AS 'RetailSales'
			,	ISNULL(RetailAmountBudget,0) AS 'RetailAmountBudget'
			,	ISNULL(Goal,0) AS 'Goal'
			,	ISNULL((AppsToHairSalesPercent * .25),0) AS 'WeightedAppsToHairSales'
			,	ISNULL((RetailToGoalPercent * .50),0) AS 'WeightedRetailToGoal'
			,	ISNULL((PCGrowthCount * .25),0) AS 'WeightedPCGrowthCount'
			,	ISNULL(((AppsToHairSalesPercent * .25) + (RetailToGoalPercent * .50) + (PCGrowthCount * .25)),0) AS 'TotalPercent'


	FROM (
		SELECT  --Find the cap for AppsToHairSalesPercent
			tbl.MainGroupID
			,	tbl.MainGroup
			,	tbl.HairSales
			,	tbl.Applications
			,	tbl.RetailSales
			,	tbl.RetailAmountBudget
			,	tbl.Goal
			,	tbl.CenterSSID
			,	CenterDescriptionNumber
			,	tbl.PCPMonth
			,   tbl.PCPCount6MonthsAgo
			,   tbl.PCPCount5MonthsAgo
			,   tbl.PCPCount4MonthsAgo
			,   tbl.PCPCount3MonthsAgo
			,   tbl.PCPCount2MonthsAgo
			,   tbl.PCPCount1MonthAgo
			,	tbl.Past3MonthsAvgPCPCounts
			,	tbl.Current3MonthsAvgPCPCounts
			,	CASE WHEN AppsToHairSalesPercent >= 1.5 THEN 1.5 ELSE AppsToHairSalesPercent END AS 'AppsToHairSalesPercent'-- Cap 150, Weight 25
			,	CASE WHEN RetailToGoalPercent < 0 THEN 0 WHEN RetailToGoalPercent >= 1.5 THEN 1.5 ELSE RetailToGoalPercent END AS 'RetailToGoalPercent'
			,	(Current3MonthsAvgPCPCounts/Past3MonthsAvgPCPCounts) AS 'PCGrowthCount'


		FROM (  --Join the two temp tables #Data and #avgpcp
			SELECT d.MainGroupID
			,	d.MainGroup
			,	d.HairSales
			,	d.Applications
			,	d.RetailSales
			,	d.RetailAmountBudget
			,	d.Goal
			,	#avgpcp.CenterSSID
			,	CenterDescriptionNumber
			,	ISNULL(d.AppsToHairSalesPercent, 0) AS 'AppsToHairSalesPercent'
			,	ISNULL(d.RetailToGoalPercent, 0) AS 'RetailToGoalPercent'
			,	#avgpcp.PCPMonth
			,   #avgpcp.PCPCount6MonthsAgo
			,   #avgpcp.PCPCount5MonthsAgo
			,   #avgpcp.PCPCount4MonthsAgo
			,   #avgpcp.PCPCount3MonthsAgo
			,   #avgpcp.PCPCount2MonthsAgo
			,   #avgpcp.PCPCount1MonthAgo
			,	#avgpcp.Past3MonthsAvgPCPCounts
			,	#avgpcp.Current3MonthsAvgPCPCounts
			FROM #Data d
			INNER JOIN #avgpcp
				ON	d.CenterSSID = #avgpcp.CenterSSID
			INNER JOIN #Centers c
				ON #avgpcp.CenterSSID = c.CenterSSID
			) tbl
		) RESULT



END
