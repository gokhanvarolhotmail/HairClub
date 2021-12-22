/*===============================================================================================
-- Procedure Name:			spRpt_DashbLeads
-- Procedure Description:	This is for the Dashboard dashbLeads
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
EXEC spRpt_DashbLeads 'F','12/1/2014','12/31/2014'
================================================================================================*/
CREATE PROCEDURE [dbo].[xxxspRpt_DashbLeads] (
@CenterType CHAR(1)
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
	SET FMTONLY OFF

	/********* Populate temporary table with all centers for the desired region **************/

	SELECT CenterSSID AS 'CenterSSID'
	,	DC.RegionSSID
	INTO #CentersByType
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	WHERE CenterSSID LIKE CASE WHEN @CenterType = 'c' THEN '[2]%' ELSE '[78]%' END

	/********Select statement ***************************************************/

	SELECT C.RegionSSID
	,	R.RegionDescription
	,	C.ReportingCenterSSID AS 'CenterSSID'
	,	C.CenterDescriptionNumber
	,	DD.FullDate AS 'Date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101)) AS 'Period'
	,	SUM(FL.Leads) AS 'Leads'
	INTO #FactLead
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FL.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = R.RegionKey
		INNER JOIN #CentersByType CBT
			ON C.CenterSSID = CBT.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FL.LeadCreationDateKey = dd.DateKey
		WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	GROUP BY C.RegionSSID
	,	R.RegionDescription
	,	C.ReportingCenterSSID
	,	C.CenterDescriptionNumber
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))



	SELECT * FROM #FactLead

END
