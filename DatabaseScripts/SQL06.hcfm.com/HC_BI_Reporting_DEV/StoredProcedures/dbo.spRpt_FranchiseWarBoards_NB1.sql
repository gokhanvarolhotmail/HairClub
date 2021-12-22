/* CreateDate: 08/29/2012 14:00:17.607 , ModifyDate: 03/17/2015 09:04:38.270 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 	[spRpt_FranchiseWarBoards_NB1]
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/29/2012
-- Date Implemented:       8/29/2012
-- Date Last Modified:     8/29/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- 04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
-- 03/17/2015 - RH - Added 10206 (NB - Xtrands Sales #) and 10306 (NB - Xtrands Sales $)
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC [spRpt_FranchiseWarBoards_NB1] 3, 2013
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FranchiseWarBoards_NB1]
	@Month TINYINT
,	@Year	int
AS

DECLARE
	@RankMax			INT
,	@CurrentRank		INT
,	@SavedRank			INT
,	@CurrentValueINT	INT
,	@SavedValueINT		INT
,	@CurrentValueDEC	DECIMAL(10,4)
,	@SavedValueDEC		DECIMAL(10,4)

BEGIN

	SET FMTONLY OFF
	SET NOCOUNT OFF

	-- Get Closing Numbers.
	SELECT
		re.RegionDescription Region
	,	de.CenterSSID CenterID
	,	de.CenterDescriptionNumber Center
	,	dbo.DIVIDE_DECIMAL(
			SUM(ISNULL(CASE WHEN a.AccountID IN (10215, 10210, 10205, 10206, 10220, 10225) THEN [Flash] ELSE 0 END, 0)) --Added Xtrands RH 03/17/2015
				, SUM(ISNULL(CASE WHEN a.AccountID IN (10110) THEN [Flash] ELSE 0 END, 0)
			)
		) 'Closing'
	,	0.45 'ClosingGoal'
	INTO #ClosingData
	FROM HC_Accounting.dbo.FactAccounting a
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter de ON de.CenterSSID = ce.ReportingCenterSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = de.RegionKey
	WHERE d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
	GROUP BY re.RegionDescription,de.CenterSSID,de.CenterDescriptionNumber


	-- Get Dollar per Sale numbers.
	SELECT
		ce.ReportingCenterSSID  Center_Num
	,	ABS(dbo.Divide(
			SUM(ISNULL(CASE WHEN a.AccountID IN (10315, 10310, 10305, 10306, 10320, 10325) THEN [Flash] ELSE 0 END, 0))  --Added Xtrands RH 03/17/2015
				, SUM(ISNULL(CASE WHEN a.AccountID IN (10215, 10210, 10205,10206, 10220, 10225) THEN [Flash] ELSE 0 END, 0))  --Added Xtrands RH 03/17/2015
			)
		) AS '$per_nb1'
	INTO #DollarPerSaleData
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	INNER JOIN HC_Accounting.dbo.FactAccounting a ON a.CenterID = ce.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
	WHERE d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
	GROUP BY ce.ReportingCenterSSID


	-- Get Hair Sales numbers.
	SELECT ce.ReportingCenterSSID AS CenterID
	,	SUM(ISNULL(CASE WHEN a.AccountID IN (10205, 10210) THEN [Flash] ELSE 0 END, 0)) 'HairSales'
	,	SUM(ISNULL(CASE WHEN a.AccountID IN (10240) THEN [Flash] ELSE 0 END, 0)) 'net_nb1_apps'
	,	dbo.Divide(
			SUM(ISNULL(CASE WHEN a.AccountID IN (10240) THEN [Flash] ELSE 0 END, 0))
				, SUM(ISNULL(CASE WHEN a.AccountID IN (10205, 10210) THEN [Flash] ELSE 0 END, 0)
			)
		) AS 'Percentage'	--6210,6211
	INTO #HairSalesData
	FROM HC_Accounting.dbo.FactAccounting a
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
	WHERE d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
	GROUP BY ce.ReportingCenterSSID


	-- Get Hair Sales Mix numbers.
	SELECT ce.ReportingCenterSSID AS CenterID
	,	CASE WHEN SUM(ISNULL(CASE WHEN a.AccountID IN (10205, 10215, 10210, 10220) THEN [Flash] ELSE 0 END, 0)) = 0 THEN 1.00 ELSE
		CAST(dbo.Divide(
			SUM(ISNULL(CASE WHEN a.AccountID IN (10205, 10210) THEN [Flash] ELSE 0 END, 0))
				, SUM(ISNULL(CASE WHEN a.AccountID IN (10205, 10215, 10210, 10220) THEN [Flash] ELSE 0 END, 0)
			)
		) AS DECIMAL(10,5)) END AS 'HairSalesMix'
	INTO #HairSalesMixData
	FROM HC_Accounting.dbo.FactAccounting a
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
	WHERE d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
	GROUP BY ce.ReportingCenterSSID


	-- Set Dollar Per Sale Goals
	SELECT ce.CenterSSID CenterID
	--HMM THIS SEEMS TO NOT BE POSSIBLE TO GET THE SAME RESULTS AS IN WAREHOUSE, WITH THE DATA THAT IS CURRENTLY IN BI
	--,	CASE WHEN [Surgery_Num] IS NOT NULL THEN 3500.0 ELSE 2500.0 END AS 'Goal'
	,2500.0 AS 'Goal'
	INTO #DollarPerSaleGoal
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	WHERE ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'


	-- Join the tables together to get one result set.
	SELECT
		c.Region
	,	c.CenterID
	,	c.Center 'CenterName'
	,	c.Closing
	,	c.ClosingGoal
	,	CAST((c.closing / c.ClosingGoal) AS DECIMAL(8, 4)) 'ClosingPercentage'
	,	ROUND(ISNULL(d.[$per_nb1], 0),0) 'DollarPerSale'
	,	#DollarPerSaleGoal.Goal AS 'DollarPerSaleGoal'
	,	CAST((ISNULL(d.[$per_nb1], 0) / #DollarPerSaleGoal.Goal) AS DECIMAL(8, 4)) AS 'DollarPerSalePercentage'
	,	h.HairSales
	,	h.net_nb1_apps 'HairAppsToSales'
	,	CASE WHEN h.Percentage > 1.5 THEN 1.5 ELSE h.Percentage END 'HairSalePercentage'
	,	hsm.HairSalesMix
	,	.50 AS 'HairSalesMixGoal'
	,	hsm.HairSalesMix - .50 AS 'HairSalesMixPercentage'
	INTO #NB1
	FROM #ClosingData c
		LEFT OUTER JOIN #DollarPerSaleData d
			ON c.[CenterID] = d.[Center_Num]
		LEFT OUTER JOIN #HairSalesData h
			ON c.[CenterID] = h.[CenterID]
		LEFT OUTER JOIN #HairSalesMixData hsm
			ON c.[CenterID] = hsm.[CenterID]
		INNER JOIN #DollarPerSaleGoal
			ON c.[CenterID] = #DollarPerSaleGoal.[CenterID]

	SELECT *
	, ((ClosingPoints * 50)
	+ (DollarPerSalePoints * 20)
	+ (HairSalesMixPoints * 30)) / 100 AS TotalPoints
	FROM (
		SELECT Region, CenterID, CenterName
		, Closing, ClosingGoal, ClosingPercentage
		, CASE WHEN ClosingPoints > 1.75 THEN 1.75 ELSE ClosingPoints END ClosingPoints
		, DollarPerSale, DollarPerSaleGoal, DollarPerSalePercentage
		, CASE WHEN DollarPerSalePoints > 1.5 THEN 1.5 ELSE DollarPerSalePoints END DollarPerSalePoints
		, HairSalesMix, HairSalesMixGoal, HairSalesMixPercentage
		, CASE WHEN HairSalesMixPoints > 1.2 THEN 1.2 ELSE HairSalesMixPoints END HairSalesMixPoints
		FROM (
			SELECT
			n.Region
			,n.CenterID
			,n.CenterName
			,n.Closing
			,n.ClosingGoal
			,n.ClosingPercentage
			,n.Closing / n.ClosingGoal AS 'ClosingPoints'
			,n.DollarPerSale
			,n.DollarPerSaleGoal
			,n.DollarPerSalePercentage
			,CAST(n.DollarPerSale AS DECIMAL)/ CAST(n.DollarPerSaleGoal AS DECIMAL) AS 'DollarPerSalePoints'
			,n.HairSalesMix
			,n.HairSalesMixGoal
			,n.HairSalesMixPercentage
			,n.HairSalesMix / n.HairSalesMixGoal  AS 'HairSalesMixPoints'
			FROM #NB1 n
		) TBL
	) TBLfinal
	ORDER BY TotalPoints DESC
END
GO
