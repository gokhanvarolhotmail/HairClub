/* CreateDate: 08/03/2011 12:36:30.767 , ModifyDate: 02/12/2020 15:41:18.530 */
GO
/*******************************************************************************************************

PROCEDURE:				sprpt_TM_Summary

VERSION:				v3.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:  	Bookings Report

AUTHOR: 				Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		10/11/2007

LAST REVISION DATE: 	02/06/2020

---------------------------------------------------------------------------------------------------------
NOTES: Gets Query For Report

@ReportType = 1 - All centers and the @Flags will equal the CenterSSID
			= 2 - @Flags = 'C' all corporate centers; @Flags <> 'C' By single selected area
			= 3 - @Flags = 'F' all franchise centers; @Flags <> 'F' By single selected region
			= 4 - All Centers
---------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
11/12/2007 - HAbelow	- revised for Lead/Activity tqbles
08/03/2011 - KMurdoch	- Migrated to BI Environment
08/04/2011 - KMurdoch	- Changed SP to return zeros rather than Null
10/19/2015 - RHut		- Changed SP to pull centers based on @Flags into temp table #Centers
05/21/2018 - DLeiba		- Changed COUNT(*) for Lead table to be SUM(fl.Leads)
02/06/2020 - RHut		- Added @ReportType; Changed #Center to be based on @ReportType and @Flags
02/12/2020 - RHut		- Added @ReportType = 4 for "All Centers"
---------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [sprpt_TM_Summary] 1, '1/1/2020', '1/31/2020', '201'
EXEC [sprpt_TM_Summary] 2, '1/1/2020', '1/31/2020', 'C'
EXEC [sprpt_TM_Summary] 2, '1/1/2020', '1/31/2020', '9'
EXEC [sprpt_TM_Summary] 3, '1/1/2020', '1/31/2020', 'F'
EXEC [sprpt_TM_Summary] 3, '1/1/2020', '1/31/2020', '9'
EXEC [sprpt_TM_Summary] 4, '1/1/2020', '1/31/2020', '0'

********************************************************************************************************/


CREATE   PROCEDURE [dbo].[sprpt_TM_Summary]
    ( @ReportType INT,
      @BegDt datetime,
      @EndDt datetime,
      @Flags NVARCHAR(5)
    )

AS

/********************************** Create temp table objects *******************************************/

CREATE TABLE #Centers (
	MainGroupSSID INT
,	MainGroupDescription VARCHAR(50)
,	CenterSSID INT
,	CenterKey INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
)

/********************************** Get list of centers *************************************************/

IF @ReportType = 1
BEGIN
INSERT  INTO #Centers
		SELECT  CASE WHEN DCT.CenterTypeDescriptionShort IN ('F','JV') THEN DR.RegionSSID ELSE CMA.CenterManagementAreaSSID END AS MainGroupSSID
		,		CASE WHEN  DCT.CenterTypeDescriptionShort IN ('F','JV') THEN DR.RegionDescription ELSE CMA.CenterManagementAreaDescription END  AS MainGroupDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DR.RegionKey = DC.RegionKey
		WHERE   DCT.CenterTypeDescriptionShort IN('C','F','JV')
				AND DC.Active = 'Y'
				AND DC.CenterNumber <> 100
				AND DC.CenterSSID = @Flags
END
ELSE IF @ReportType = 2  AND @Flags = 'C' --All corporate centers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupSSID
		,		CMA.CenterManagementAreaDescription AS MainGroupDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   DCT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'
				AND DC.CenterNumber <> 100
END
ELSE IF @ReportType = 2 AND  @Flags <> 'C' -- By single area
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupSSID
		,		CMA.CenterManagementAreaDescription AS MainGroupDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   DCT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'
				AND CMA.CenterManagementAreaSSID = @Flags
END
ELSE IF @ReportType = 3  AND @Flags = 'F' --All franchise centers
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS MainGroupSSID
		,		DR.RegionDescription AS MainGroupDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE  DCT.CenterTypeDescriptionShort IN('F','JV')
				AND DC.Active = 'Y'
END
ELSE IF @ReportType = 3  AND @Flags <> 'F' --By selected region
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS MainGroupSSID
		,		DR.RegionDescription AS MainGroupDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE   DR.RegionSSID = @Flags
				AND DC.Active = 'Y'
END
ELSE IF @ReportType = 4  --All Centers
BEGIN
INSERT  INTO #Centers
		SELECT  CASE WHEN DCT.CenterTypeDescriptionShort IN ('F','JV') THEN DR.RegionSSID ELSE CMA.CenterManagementAreaSSID END AS MainGroupSSID
		,		CASE WHEN  DCT.CenterTypeDescriptionShort IN ('F','JV') THEN DR.RegionDescription ELSE CMA.CenterManagementAreaDescription END  AS MainGroupDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DR.RegionKey = DC.RegionKey
		WHERE   DCT.CenterTypeDescriptionShort IN('C','F','JV')
				AND DC.Active = 'Y'
				AND DC.CenterNumber <> 100
END


/*****************  Get Appointment, Show, Sale count by Due Date by Center ***********************/

	SELECT
		ctr.CenterSSID as 'Center'
	,	SUM(Appointments) as 'Appt'
	,	SUM(Show) as 'Show'
	,	SUM(Sale) as 'Sale'
	INTO    #shows
	FROM dbo.synHC_MKTG_DDS_vwFactActivityResults far
		inner join #Centers ctr
			on far.CenterKey = ctr.CenterKey
		inner join dbo.synHC_ENT_DDS_vwDimDate dd
			on far.ActivityDueDateKey = dd.datekey
	WHERE dd.FullDate between @BegDt and @EndDt
	GROUP BY ctr.CenterSSID

/*****************  Get Lead Count by Create Date by Center **************************************/


	SELECT
		ctr.CenterSSID as 'Center'
	,	SUM(fl.Leads) as 'Lead'
	INTO #leads
	FROM dbo.synHC_MKTG_DDS_vwFactLead fl
		inner join #Centers ctr
			on fl.CenterKey = ctr.CenterKey
		inner join dbo.synHC_ENT_DDS_vwDimDate dd
			on fl.LeadCreationDateKey = dd.datekey
	WHERE dd.FullDate between @BegDt and @EndDt
	GROUP BY ctr.CenterSSID



/*****************  Get Center/Region Descriptions, do calculations *****************************/
SELECT  ctr.CenterSSID
,		ctr.MainGroupDescription
,		ctr.CenterDescriptionNumber
,		ISNULL(l.Lead,0) as 'Lead'
,		ISNULL(s.Appt,0) as 'Appt'
,		ISNULL(s.Show,0) as 'Show'
,		ISNULL(s.Sale,0) as 'Sale'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Appt,0), ISNULL(l.Lead,0)) as 'BookingPace'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Show,0), ISNULL(s.Appt,0)) as 'ShowRate'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Sale,0), ISNULL(s.Show,0)) as 'ClosingRate'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Sale,0), ISNULL(l.Lead,0)) as 'SalesToLeads'
FROM    #Centers ctr
		LEFT OUTER JOIN #leads l
			ON l.Center = ctr.CenterSSID
		LEFT OUTER JOIN #shows s
			ON s.Center = ctr.CenterSSID
GO
