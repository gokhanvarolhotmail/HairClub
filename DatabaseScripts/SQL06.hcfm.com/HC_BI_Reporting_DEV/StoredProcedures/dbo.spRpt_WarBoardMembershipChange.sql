/* CreateDate: 08/07/2012 09:24:39.233 , ModifyDate: 04/08/2013 09:02:35.950 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardMembershipChange

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/02/2012

==============================================================================
DESCRIPTION:	New Business War Board
==============================================================================
NOTES:

04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardMembershipChange] 4, 2013, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardMembershipChange] (
	@Month			TINYINT
,	@Year			SMALLINT
,	@RegionSSID INT)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME

	SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
	SET @EndDate = DATEADD(dd, -1, DATEADD(mm, 1, @StartDate))


	CREATE TABLE #Centers (
		CenterID INT
	,	CenterDescriptionNumber VARCHAR(50)
	,	RegionSSID INT
	,	RegionDescription VARCHAR(50)
	)

	IF @RegionSSID=0
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
			,	C.CenterDescriptionNumber
			,	R.RegionSSID
			,	R.RegionDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = r.RegionKey
			WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
				AND c.Active='Y'
		END
	ELSE
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
			,	C.CenterDescriptionNumber
			,	R.RegionSSID
			,	R.RegionDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = r.RegionKey
			WHERE R.RegionSSID=@RegionSSID
				AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
				AND c.Active='Y'
		END



	SELECT c.ReportingCenterSSID AS 'CenterSSID'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) AS 'Upgrades'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END) AS 'Downgrades'
	INTO #Change
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN (1070, 1080)
	GROUP BY c.ReportingCenterSSID


	SELECT a.CenterID AS 'CenterSSID'
	,	SUM(a.Flash) AS 'PCPCount'
	INTO #PCP
	FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN #Centers c
			ON a.CenterID = c.CenterID
	WHERE MONTH(a.PartitionDate) = @Month
		AND YEAR(a.PartitionDate) = @Year
		AND a.AccountID = 10410
	GROUP BY a.CenterID


	SELECT C.CenterID AS 'Center_Num'
	,	C.RegionDescription AS 'Region'
	,	C.RegionSSID AS 'RegionID'
	,	C.CenterDescriptionNumber AS 'Center'
	,	ISNULL(CHG.Upgrades, 0) AS 'Upgrades'
	,	ISNULL(CHG.Downgrades, 0) AS 'Downgrades'
	,	ISNULL(CHG.Upgrades, 0) - ISNULL(CHG.Downgrades, 0) AS 'Net'
	,	ISNULL(P.PCPCount, 0) AS 'PCP'
	,	dbo.DIVIDE_DECIMAL((ISNULL(CHG.Upgrades, 0) - ISNULL(CHG.Downgrades, 0)), ISNULL(P.PCPCount, 0)) AS 'PercentPCP'
	,	dbo.DIVIDE_DECIMAL(ISNULL(CHG.Downgrades, 0), ISNULL(CHG.Upgrades, 0)) AS 'PercentDowngrades'
	FROM #Centers C
		LEFT OUTER JOIN #Change CHG
			ON C.CenterID = CHG.CenterSSID
		LEFT OUTER JOIN #PCP P
			ON C.CenterID = P.CenterSSID
END
GO
