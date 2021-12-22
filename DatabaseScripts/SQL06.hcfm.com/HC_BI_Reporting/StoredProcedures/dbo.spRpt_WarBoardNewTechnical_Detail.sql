/* CreateDate: 04/06/2016 15:55:57.633 , ModifyDate: 06/25/2019 09:12:21.393 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
04/06/2016 - RH - (#123781) Added "NSD to Budget" and "Conversions to NSD"; Added new MainGroupID - By Groups
09/01/2016 - RH - (#129822) Changed (Budget * (-1)) to ABS(Budget)
09/07/2016 - RH - (#129822) Added CASE WHEN C.CenterSSID = 247 THEN '528.00'for Montreal as Goal since they had no budget; Added 247 to Small group
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
07/10/2017 - RH - (#141042) Changed center size to use the RecurringBusinessSize listed in the DimCenter table
03/15/2018 - RH - (#145957) Changed CenterSSID to CenterNumber
01/07/2019 - RH - (per Rev) Removed code that was hard-coded for Montreal - for RetailAmountBudget
01/24/2019 - RH - (Case #1733) Split Retail to Retail(3090) and Laser(3096)
06/19/2019 - JL - (TFS 12573) Laser Report adjustment
==============================================================================
@Filter 1 = ByRegion	2 = By Area Managers	3 = By Centers	 4 = By Groups

SAMPLE EXECUTION:

EXEC [spRpt_WarBoardNewTechnical_Detail] 1, 2, 2018, 6
EXEC [spRpt_WarBoardNewTechnical_Detail] 2, 2, 2018, 9
EXEC [spRpt_WarBoardNewTechnical_Detail] 3, 2, 2018, 239
EXEC [spRpt_WarBoardNewTechnical_Detail] 4, 3, 2018, 1

EXEC [spRpt_WarBoardNewTechnical_Detail] 1, 6, 2019, 2
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardNewTechnical_Detail] (
	@Filter	INT
,	@Month	TINYINT
,	@Year	SMALLINT
,	@MainGroupID INT
)
AS
BEGIN
SET FMTONLY OFF
SET NOCOUNT OFF


DECLARE @FirstDayMonth DATETIME
,	@LastDayMonth DATETIME
,	@PCPGrowth_Cap NUMERIC(15,5) -- Added 10/03/2014 - RH
,	@RetailToBudgetPercent_Cap NUMERIC(15,5)
,	@LaserToBudgetPercent_Cap NUMERIC(15,5)

/********************* Set Variables ******************************************************/

SELECT @FirstDayMonth = CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))
,	@LastDayMonth = DATEADD(dd, -1, DATEADD(mm, 1, @FirstDayMonth))
,	@PCPGrowth_Cap = 1.50
,	@RetailToBudgetPercent_Cap = 1.50
,	@LaserToBudgetPercent_Cap = 1.50

--PRINT @FirstDayMonth
--PRINT @LastDayMonth
--PRINT @PCPGrowth_Cap
--PRINT @RetailToBudgetPercent_Cap
--PRINT @LaserToBudgetPercent_Cap

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
)


CREATE TABLE #Centers_sub (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
)


CREATE TABLE #pcpcounts(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterNumber INT
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
,	CenterNumber INT
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
			,		DC.CenterNumber
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DCT.CenterTypeKey = DC.CenterTypeKey
			WHERE   DCT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END


IF @Filter = 2 -- By Area Managers
BEGIN
	INSERT  INTO #Centers_sub
			SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,		CMA.CenterManagementAreaDescription AS 'MainGroup'
			,		DC.CenterNumber
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DCT.CenterTypeKey = DC.CenterTypeKey
			WHERE  DCT.CenterTypeDescriptionShort = 'C'
					AND CMA.Active = 'Y'
END


IF @Filter = 3 -- By Center
BEGIN
	INSERT  INTO #Centers_sub
			SELECT  DC.CenterNumber AS 'MainGroupID'
			,		DC.CenterDescriptionNumber AS 'MainGroup'
			,		DC.CenterNumber
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DCT.CenterTypeKey = DC.CenterTypeKey
			WHERE	DCT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END

IF @Filter = 4 -- By Groups - 1 = Small  2 = Medium  3 = Large
BEGIN
	INSERT  INTO #Centers_sub
			SELECT  1 AS 'MainGroupID'
			,		'Small 0 - 200' AS 'MainGroup'
			,		DC.CenterNumber
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DCT.CenterTypeKey = DC.CenterTypeKey
			WHERE	DCT.CenterTypeDescriptionShort = 'C'
					AND DC.RecurringBusinessSize = 'Small'
					AND DC.Active = 'Y'
		UNION
			SELECT  2 AS 'MainGroupID'
			,		'Medium 201 - 399' AS 'MainGroup'
			,		DC.CenterNumber
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DCT.CenterTypeKey = DC.CenterTypeKey
			WHERE	DCT.CenterTypeDescriptionShort = 'C'
					AND DC.RecurringBusinessSize = 'Medium'
					AND DC.Active = 'Y'

		UNION
			SELECT  3 AS 'MainGroupID'
			,		'Large 400+' AS 'MainGroup'
			,		DC.CenterNumber
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DCT.CenterTypeKey = DC.CenterTypeKey
			WHERE	DCT.CenterTypeDescriptionShort = 'C'
					AND DC.RecurringBusinessSize = 'Large'
					AND DC.Active = 'Y'
END

IF @MainGroupID = 0 --Show all
BEGIN
	INSERT INTO #Centers
	SELECT MainGroupID
            , MainGroup
            , CenterNumber
            , CenterDescriptionNumber
            , CenterTypeDescriptionShort
            , CenterKey
	FROM #Centers_sub
	GROUP BY MainGroupID
            , MainGroup
            , CenterNumber
            , CenterDescriptionNumber
            , CenterTypeDescriptionShort
            , CenterKey
END
ELSE
BEGIN
	INSERT INTO #Centers
	SELECT MainGroupID
            , MainGroup
            , CenterNumber
            , CenterDescriptionNumber
            , CenterTypeDescriptionShort
            , CenterKey
	FROM #Centers_sub
	WHERE MainGroupID = @MainGroupID
	AND MainGroupID IS NOT NULL
	GROUP BY MainGroupID
            , MainGroup
            , CenterNumber
            , CenterDescriptionNumber
            , CenterTypeDescriptionShort
            , CenterKey

END


/************************** Get Accounting [#Accounting] Budgets **************************************************/

SELECT #Centers.MainGroupID
,	#Centers.MainGroup
,	#Centers.CenterNumber

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'NewStyleDays'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 1)) AS 'NewStyleDays_Budget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'Conversions'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10400) THEN Flash ELSE 0 END, 0)) AS 'CurrentMonthPCPCount'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10210, 10215, 10220, 10225) THEN Flash ELSE 0 END, 0)) AS 'NetNb1Count'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'NetNb1Budget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (3090) THEN ABS(Budget) ELSE 0 END, 0)) AS 'RetailAmountBudget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10551) THEN ABS(Budget) ELSE 0 END, 0)) AS 'LaserAmountBudget'
INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers
		ON FA.CenterID = #Centers.CenterNumber
WHERE MONTH(FA.PartitionDate)=@Month
	AND YEAR(FA.PartitionDate)=@Year
GROUP BY #Centers.MainGroupID
,	#Centers.MainGroup
,	#Centers.CenterNumber


/********************** Find RetailSales and Laser Sales *************************************************************************/

SELECT  CTR.CenterNumber
--,   SUM(CASE WHEN (DSCD.SalesCodeDivisionSSID = 30 AND DSCD.SalesCodeDepartmentSSID <> 3065) THEN FST.ExtendedPrice ELSE 0 END) AS 'RetailSales'
,   SUM(CASE WHEN (DSCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND DSCD.SalesCodeDepartmentSSID <> 3065) THEN FST.RetailAmt ELSE 0 END) AS 'RetailSales'
--,	SUM(CASE WHEN (DSCD.SalesCodeDivisionSSID = 30 AND DSCD.SalesCodeDepartmentSSID = 3065) THEN FST.ExtendedPrice ELSE 0 END) AS 'LaserSales'
--,	SUM(FST.PCP_LaserAmt) AS 'LaserSales'
,   SUM(CASE WHEN (DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)) THEN FST.PCP_LaserAmt ELSE 0 END) AS 'LaserSales'

INTO	#Retail
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
		INNER JOIN #Centers
			ON CTR.CenterNumber = #Centers.CenterNumber
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
            ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
WHERE   DD.MonthNumber = @Month
        AND DD.YearNumber = @Year
        --AND ( DSCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND DSC.SalesCodeDepartmentSSID <> 3065)
		AND DSO.IsVoidedFlag = 0
GROUP BY CTR.CenterNumber


/************************** Get Data [#Data] **************************************************/

SELECT A.MainGroupID
,	A.MainGroup
,	A.CenterNumber
,	A.NewStyleDays
,	A.NewStyleDays_Budget
,	A.Conversions
,	R.RetailSales
,	R.LaserSales
,	A.RetailAmountBudget
,	A.LaserAmountBudget
,	dbo.DIVIDE_DECIMAL(NewStyleDays, NewStyleDays_Budget) AS NSDtoBudgetPercent
,	dbo.DIVIDE_DECIMAL(Conversions, NewStyleDays) AS ConversionsToNSDPercent
,	CASE WHEN dbo.DIVIDE_DECIMAL(RetailSales, RetailAmountBudget) > @RetailToBudgetPercent_Cap
		THEN @RetailToBudgetPercent_Cap
		ELSE dbo.DIVIDE_DECIMAL(RetailSales, RetailAmountBudget)
	END AS RetailToBudgetPercent
,	CASE WHEN dbo.DIVIDE_DECIMAL(LaserSales, LaserAmountBudget) > @LaserToBudgetPercent_Cap
		THEN @LaserToBudgetPercent_Cap
		ELSE dbo.DIVIDE_DECIMAL(LaserSales, LaserAmountBudget)
	END AS LaserToBudgetPercent
INTO #Data
FROM #Accounting A
	LEFT OUTER JOIN #Retail R
		ON A.CenterNumber = R.CenterNumber




/***************************Get past 6 months PCP Counts and Averages********************/
DECLARE @FirstDay6MonthsAgo DATETIME
DECLARE @FirstDay5MonthsAgo DATETIME
DECLARE @FirstDay4MonthsAgo DATETIME
DECLARE @FirstDay3MonthsAgo DATETIME
DECLARE @FirstDay2MonthsAgo DATETIME
DECLARE @FirstDay1MonthAgo DATETIME

--1
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

INSERT INTO #pcpcounts	(MainGroupID, MainGroup, CenterNumber, PCPMonth)
SELECT #Centers.MainGroupID
,	#Centers.MainGroup
,	#Centers.CenterNumber
,	@FirstDay1MonthAgo AS 'PCPMonth'

FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers
		ON FA.CenterID = #Centers.CenterNumber
GROUP BY #Centers.MainGroupID
,	#Centers.MainGroup
,	#Centers.CenterNumber



UPDATE pcp
SET pcp.PCPCount6MonthsAgo = FA.Flash
FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterNumber = FA.CenterID
WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay6MonthsAgo


UPDATE pcp
SET pcp.PCPCount5MonthsAgo = FA.Flash
FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterNumber = FA.CenterID
WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay5MonthsAgo



UPDATE pcp
SET pcp.PCPCount4MonthsAgo = FA.Flash
FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterNumber = FA.CenterID
WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay4MonthsAgo



UPDATE pcp
SET pcp.PCPCount3MonthsAgo = FA.Flash
FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterNumber = FA.CenterID
WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay3MonthsAgo



UPDATE pcp
SET pcp.PCPCount2MonthsAgo = FA.Flash
FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterNumber = FA.CenterID
WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay2MonthsAgo



UPDATE pcp
SET pcp.PCPCount1MonthAgo = FA.Flash
FROM #pcpcounts pcp
	INNER JOIN HC_Accounting.dbo.FactAccounting FA
		ON pcp.CenterNumber = FA.CenterID
WHERE FA.AccountID IN (10400)
	AND FA.PartitionDate = @FirstDay1MonthAgo

--SELECT * FROM #pcpcounts

INSERT INTO #avgpcp
SELECT MainGroupID
		,	MainGroup
		,	CenterNumber
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
		,	CenterNumber
		,	PCPMonth
		,   PCPCount6MonthsAgo
		,   PCPCount5MonthsAgo
		,   PCPCount4MonthsAgo
		,   PCPCount3MonthsAgo
		,   PCPCount2MonthsAgo
		,   PCPCount1MonthAgo





/************************** Get Totals **************************************************/
----Find the cap for PCGrowthCount

SELECT MainGroupID
		,	MainGroup
		,	CenterNumber
		,	CenterDescriptionNumber
		,	PCPMonth
		,   ISNULL(PCPCount6MonthsAgo,0) AS 'PCPCount6MonthsAgo'
		,   ISNULL(PCPCount5MonthsAgo,0) AS 'PCPCount5MonthsAgo'
		,   ISNULL(PCPCount4MonthsAgo,0) AS 'PCPCount4MonthsAgo'
		,   ISNULL(PCPCount3MonthsAgo,0) AS 'PCPCount3MonthsAgo'
		,   ISNULL(PCPCount2MonthsAgo,0) AS 'PCPCount2MonthsAgo'
		,   ISNULL(PCPCount1MonthAgo,0) AS 'PCPCount1MonthAgo'
		,	ISNULL(NSDtoBudgetPercent,0) AS 'NSDtoBudgetPercent'
		,	ISNULL(ConversionsToNSDPercent,0) AS 'ConversionsToNSDPercent'

		,	ISNULL(RetailToBudgetPercent,0) AS 'RetailToBudgetPercent'
		,	ISNULL(LaserToBudgetPercent,0) AS 'LaserToBudgetPercent'

		,	ISNULL(Past3MonthsAvgPCPCounts,0) AS 'Past3MonthsAvgPCPCounts'
		,	ISNULL(Current3MonthsAvgPCPCounts,0) AS 'Current3MonthsAvgPCPCounts'
		,	CASE WHEN PCGrowthCount > 1.5 THEN 1.5 ELSE ISNULL(PCGrowthCount,0)  END AS 'PCGrowthCount'
		,	ISNULL(NewStyleDays,0) AS 'NewStyleDays'
		,	ISNULL(NewStyleDays_Budget,0) AS 'NewStyleDays_Budget'
		,	ISNULL(Conversions,0) AS 'Conversions'

		,	ISNULL(RetailSales,0) AS 'RetailSales'
		,	ISNULL(LaserSales,0) AS 'LaserSales'
		,	ISNULL(RetailAmountBudget,0) AS 'RetailAmountBudget'
		,	ISNULL(LaserAmountBudget,0) AS 'LaserAmountBudget'

		,	ISNULL((NSDtoBudgetPercent * .15),0) AS 'WeightedNSDtoBudget'
		,	ISNULL((ConversionsToNSDPercent * .15),0) AS 'WeightedConversionsToNSD'

		,	ISNULL((RetailToBudgetPercent * .25),0) AS 'WeightedRetailToBudget'
		,	ISNULL((LaserToBudgetPercent * .25),0) AS 'WeightedLaserToBudget'

		,	ISNULL((PCGrowthCount * .20),0) AS 'WeightedPCGrowthCount'
		,	(ISNULL((NSDtoBudgetPercent * .15),0) + ISNULL((ConversionsToNSDPercent * .15),0) + ISNULL((RetailToBudgetPercent * .25),0) + ISNULL((LaserToBudgetPercent * .25),0) + ISNULL((PCGrowthCount * .20),0)) AS TotalPercent


FROM (
	SELECT
		tbl.MainGroupID
		,	tbl.MainGroup
		,	tbl.NewStyleDays
		,	tbl.NewStyleDays_Budget
		,	tbl.Conversions
		,	tbl.RetailSales
		,	tbl.LaserSales
		,	tbl.RetailAmountBudget
		,	tbl.LaserAmountBudget

		,	tbl.CenterNumber
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
		,	NSDtoBudgetPercent
		,	ConversionsToNSDPercent

		,	CASE WHEN RetailToBudgetPercent >= 1.5 THEN 1.5 ELSE RetailToBudgetPercent END AS 'RetailToBudgetPercent'
		,	CASE WHEN LaserToBudgetPercent >= 1.5 THEN 1.5 ELSE LaserToBudgetPercent END AS 'LaserToBudgetPercent'

		,	(Current3MonthsAvgPCPCounts/Past3MonthsAvgPCPCounts) AS 'PCGrowthCount'
	FROM (  --Join the two temp tables #Data and #avgpcp

		SELECT d.MainGroupID
		,	d.MainGroup
		,	d.NewStyleDays
		,	ROUND(d.NewStyleDays_Budget,0) AS 'NewStyleDays_Budget'
		,	d.Conversions
		,	d.RetailSales
		,	d.LaserSales
		,	d.RetailAmountBudget
		,	d.LaserAmountBudget
		,	#avgpcp.CenterNumber
		,	CenterDescriptionNumber
		,	ISNULL(d.NSDtoBudgetPercent, 0) AS 'NSDtoBudgetPercent'
		,	ISNULL(d.ConversionsToNSDPercent, 0) AS 'ConversionsToNSDPercent'

		,	ISNULL(d.RetailToBudgetPercent, 0) AS 'RetailToBudgetPercent'
		,	ISNULL(d.LaserToBudgetPercent, 0) AS 'LaserToBudgetPercent'

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
			ON	d.CenterNumber = #avgpcp.CenterNumber
		INNER JOIN #Centers c
			ON #avgpcp.CenterNumber = c.CenterNumber
		) tbl
) RESULT



END
GO
