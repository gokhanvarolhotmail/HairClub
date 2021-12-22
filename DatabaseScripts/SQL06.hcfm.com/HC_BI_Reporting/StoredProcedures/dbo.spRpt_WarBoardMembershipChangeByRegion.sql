/* CreateDate: 09/14/2012 14:14:34.363 , ModifyDate: 07/13/2018 16:06:58.107 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardMembershipChangeByRegion

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/02/2012

==============================================================================
DESCRIPTION:	New Business War Board
==============================================================================
NOTES:

04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
07/13/2018 - JL - (#149913) Replaced Corporate Regions with Areas, Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardMembershipChangeByRegion] 7, 2018

==============================================================================
*/


CREATE PROCEDURE [dbo].[spRpt_WarBoardMembershipChangeByRegion] (
	@Month			TINYINT
,	@Year			SMALLINT)
AS
BEGIN

/*
DECLARE
	@Month			TINYINT
,	@Year			SMALLINT
SET @Month   = 6
SET @Year    = 2018
*/

	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME

	SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
	SET @EndDate = DATEADD(dd, -1, DATEADD(mm, 1, @StartDate))


	SELECT
	CMA.CenterManagementAreaDescription as 'CenterManagementAreaDescription'
,   CMA.CenterManagementAreaSSID as 'CenterManagementAreaSSID'
	INTO #Centers
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON	CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
            ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
	WHERE	CT.CenterTypeDescriptionShort IN('C')
			AND C.Active = 'Y'
	GROUP BY
	CMA.CenterManagementAreaDescription
,   CMA.CenterManagementAreaSSID


	SELECT
	    CTR.CenterManagementAreaDescription
	,	CTR.CenterManagementAreaSSID
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) AS 'Upgrades'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END) AS 'Downgrades'
	INTO #Change
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN #Centers CTR
            ON C.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN (1070, 1080)
	GROUP BY
	    CTR.CenterManagementAreaDescription
	,	CTR.CenterManagementAreaSSID



	SELECT
	c.CenterManagementAreaDescription
,	c.CenterManagementAreaSSID
	,	SUM(a.Flash) AS 'PCPCount'
	INTO #PCP
	FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON a.CenterID = CTR.CenterSSID
		INNER JOIN #Centers c
            ON CTR.CenterManagementAreaSSID = c.CenterManagementAreaSSID
	WHERE MONTH(a.PartitionDate) = @Month
		AND YEAR(a.PartitionDate) = @Year
		AND a.AccountID = 10410
	GROUP BY c.CenterManagementAreaDescription
	,	c.CenterManagementAreaSSID



	SELECT C.CenterManagementAreaDescription AS 'Region'
	,	C.CenterManagementAreaSSID AS 'RegionID'
	,	ISNULL(CHG.Upgrades, 0) AS 'Upgrades'
	,	ISNULL(CHG.Downgrades, 0) AS 'Downgrades'
	,	ISNULL(CHG.Upgrades, 0) - ISNULL(CHG.Downgrades, 0) AS 'Net'
	,	ISNULL(P.PCPCount, 0) AS 'PCP'
	,	dbo.DIVIDE_DECIMAL((ISNULL(CHG.Upgrades, 0) - ISNULL(CHG.Downgrades, 0)), ISNULL(P.PCPCount, 0)) AS 'PercenterPCP'
	,	dbo.DIVIDE_DECIMAL(ISNULL(CHG.Downgrades, 0), ISNULL(CHG.Upgrades, 0)) AS 'PercentDowngrades'
	FROM #Centers C
		LEFT OUTER JOIN #Change CHG
			ON C.CenterManagementAreaSSID = CHG.CenterManagementAreaSSID
		LEFT OUTER JOIN #PCP P
			ON C.CenterManagementAreaSSID = P.CenterManagementAreaSSID
END


--drop table #centers
--drop table #change
--drop table #pcp
GO
