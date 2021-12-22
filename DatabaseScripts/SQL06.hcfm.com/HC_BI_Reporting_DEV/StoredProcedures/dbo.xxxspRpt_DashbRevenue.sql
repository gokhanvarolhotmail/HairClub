/* CreateDate: 01/05/2015 16:30:04.540 , ModifyDate: 01/07/2016 11:21:42.950 */
GO
/*===============================================================================================
-- Procedure Name:			spRpt_DashbRevenue
-- Procedure Description:
--
-- Created By:				Rachelen Hut
-- Date Created:			1/5/2015
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- ----------------------------------------------------------------------------------------------
-- Notes:

-- ----------------------------------------------------------------------------------------------
--
EXEC spRpt_DashbRevenue 'C','East','12/1/2014','12/31/2014'
================================================================================================*/
CREATE PROCEDURE [dbo].[xxxspRpt_DashbRevenue]
(
@CenterType CHAR(1)
,	@Region NVARCHAR(100)
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

	SET NOCOUNT ON
	SET FMTONLY OFF

	/********* Populate temporary table with all centers for the desired region **************/

	SELECT DC.CenterSSID AS 'CenterSSID'
	,	DC.RegionSSID
	,	R.RegionDescription
	INTO #Centers
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
		ON DC.RegionKey = R.RegionKey
	WHERE DC.CenterSSID LIKE CASE WHEN @CenterType = 'C' THEN '[2]%' ELSE '[78]%' END
	AND RegionDescription = @Region


	SELECT C.ReportingCenterSSID AS 'CenterSSID'
		,	@StartDate AS StartDate
		,	@EndDate AS EndDate
		,	@CenterType AS 'CenterType'
		,	C.CenterDescriptionNumber
		,	C.CenterDescription
		,	C.RegionKey
		,	R.RegionDescription
		,	SUM(ISNULL(FST.PCP_PCPAmt, 0)) AS 'PCPRevenue'
		,	SUM(ISNULL(FST.NB_TradAmt, 0))
			+ SUM(ISNULL(FST.NB_ExtAmt, 0))
			+ SUM(ISNULL(FST.NB_GradAmt, 0))
			+ SUM(ISNULL(FST.S_SurAmt, 0))
			+ SUM(ISNULL(FST.S_PostExtAmt, 0))
			+ SUM(ISNULL(FST.NB_XTRAmt, 0))
		AS 'NetNB1Revenue'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeKey NOT IN (665, 654, 393, 668)
	GROUP BY c.ReportingCenterSSID
		,	C.CenterDescriptionNumber
		,	C.CenterDescription
		,	C.RegionKey
		,	R.RegionDescription


END
GO
