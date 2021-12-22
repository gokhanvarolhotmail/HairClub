/***********************************************************************
PROCEDURE:	sprpt_MembershipChange
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

--  04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC [sprpt_MembershipChangeFranchise] 04, 2013
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_MembershipChangeFranchise] (
	@Month VARCHAR(2)
,	@Year VARCHAR(4))

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON

	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME

	SET @StartDate = @Month + '/1/' + @Year
	SET @EndDate = DATEADD(dd,-1,DATEADD(mm,1,@StartDate))

	DECLARE @PCPCounts TABLE (
		[CenterID] [int] NULL
	,	[Upgrades] [int] NULL
	,	[Downgrades] [int] NULL
	)

	DECLARE @PCP TABLE (
		[CenterID]  [smallint] NULL
	,	[PCP] [int] NULL
	)

	INSERT @PCP
	SELECT ce.ReportingCenterSSID center
	,	SUM([FlashReporting]) AS 'PCP'
	FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
	WHERE d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND a.AccountID = 10410
	GROUP BY ce.ReportingCenterSSID

	INSERT @PCPCounts
	SELECT ce.ReportingCenterSSID AS CenterID
	,	SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXU', 'NB2XU', 'ACQUIREDXU') THEN 1 ELSE 0 END) AS 'Upgrades' -- Per PCP Flash
	,	SUM(CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXD') THEN 1 ELSE 0 END) AS 'Downgrades' -- Per PCP Flash
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
	WHERE d.FullDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
		AND sc.SalesCodeDescriptionShort IN ('PCPXU', 'PCPXD', 'PCPX', 'NB2XU', 'ACQUIREDXU') -- Per PCP Flash
		AND so.IsVoidedFlag <> 1
	GROUP BY ce.ReportingCenterSSID


	SELECT ce.CenterSSID Center_Num
	,	re.RegionDescription Region
	,	re.RegionSSID RegionID
	,	ce.CenterDescriptionNumber AS Center
	,	ISNULL([PCPCounts].Upgrades, 0) AS 'Upgrades'
	,	ISNULL([PCPCounts].Downgrades, 0) AS 'Downgrades'
	,	ISNULL([PCPCounts].Upgrades, 0) - ISNULL([PCPCounts].Downgrades, 0) AS 'Net'
	,	ISNULL([PCP].PCP,0) AS 'pcp'
	,	dbo.Divide((ISNULL([PCPCounts].Upgrades, 0) - ISNULL([PCPCounts].Downgrades, 0)),ISNULL([PCP].PCP,0)) AS 'PercentPCP'
	,	dbo.Divide(ISNULL([PCPCounts].Downgrades, 0),ISNULL([PCPCounts].Upgrades, 0)) AS 'PercentDowngrades'
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON ce.RegionKey = re.RegionKey
		LEFT OUTER JOIN @PCP [PCP]
			ON ce.CenterSSID = [PCP].CenterID
		LEFT OUTER JOIN @PCPCounts [PCPCounts]
			ON ce.CenterSSID = [PCPCounts].CenterID
	WHERE ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
END
