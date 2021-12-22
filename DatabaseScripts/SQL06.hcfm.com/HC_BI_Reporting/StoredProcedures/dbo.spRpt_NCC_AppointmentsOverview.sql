/* CreateDate: 03/20/2019 10:27:51.733 , ModifyDate: 09/15/2020 16:36:24.297 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		[spRpt_NCC_AppointmentsOverview] (Originally sprpt_booking_overview )

VERSION:		v2.0

DESTINATION SERVER:	SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:  	NCC

AUTHOR: 			EM 2004

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/11/2007
------------------------------------------------------------------------
NOTES:

	09/15/2020	KMurdoch Changed reference from Fact Activity to Fact Activity Results.
------------------------------------------------------------------------
CHANGE HISTORY:
03/20/2019 - RH - Changed the name of the stored procedure to match the report; Added BEGIN and END; Added #Centers
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_NCC_AppointmentsOverview] '09/14/2020', A
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NCC_AppointmentsOverview]
    (
      @BegDt datetime,
      @Gender char(1)
    )
AS

BEGIN

    DECLARE  @EndDt datetime

    SET @EndDt = DATEADD(day, 14, @BegDt)

/*************** Create temp tables **************************************/

CREATE TABLE #Centers(
	MainGroupKey INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(104)
,	CenterTypeDescription NVARCHAR(50)
)

/*************** Find Main Group and Centers *****************************/

INSERT INTO #Centers
SELECT
		CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionKey ELSE CMA.CenterManagementAreaKey END AS MainGroupKey
	,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionDescription ELSE CMA.CenterManagementAreaDescription END AS MainGroupDescription
	,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionSortOrder ELSE CMA.CenterManagementAreaSortOrder END AS MainGroupSortOrder
	,	DC.CenterKey
	,	DC.CenterNumber
	,	DC.CenterSSID
	,	DC.CenterDescriptionNumber
	,	DCT.CenterTypeDescription
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DCT.CenterTypeKey = DC.CenterTypeKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
			ON DR.RegionKey = DC.RegionKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
WHERE   DCT.CenterTypeDescriptionShort IN('F','JV','C')
		AND DC.Active = 'Y'
		AND DC.CenterNumber NOT IN(-2,100)


/*************** Select into #Activity *****************************/

    SELECT
		DD.FullDate
    ,   AC.ActionCodeSSID
    ,   CASE WHEN AC.ActionCodeSSID IN ( 'APPOINT' , 'INHOUSE', 'BEBACK')
			AND (RC.ResultCodeSSID NOT IN ( 'RESCHEDULE', 'CANCEL','CTREXCPTN','VOID') OR RC.ResultCodeSSID IS NULL)
             THEN 1 ELSE 0
        END is_appt
    ,	C.MainGroupKey
	,	C.MainGroupDescription
	,	C.MainGroupSortOrder
	,	C.CenterKey
	,	C.CenterNumber
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.CenterTypeDescription
	INTO #Activity
    FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults Activity
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON Activity.ActivityDueDateKey = DD.DateKey
				AND DD.FullDate BETWEEN @begdt AND @enddt
		INNER JOIN #Centers C
			ON C.CenterKey = Activity.CenterKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActionCode AC
			ON Activity.ActionCodeKey = AC.ActionCodeKey
				AND Activity.ActionCodeKey > 0
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimResultCode RC
			ON Activity.ResultCodeKey = RC.ResultCodeKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON Activity.ContactKey = DC.ContactKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON Activity.ActivityKey = DA.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead Lead
			ON Activity.ContactKey = Lead.ContactKey
				AND Activity.ContactKey > 0
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
			ON Lead.CenterKey = CE.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender DG
					ON Lead.GenderKey = DG.GenderKey
					AND DG.GenderSSID LIKE CASE @Gender
											   WHEN 'm' THEN 'M'
											   WHEN 'f' THEN 'F'
											   ELSE '%'
											 END


/********** SUM the results from #Activity *********************************************************************/

    SELECT
		a.MainGroupDescription 'region',
        a.CenterDescriptionNumber AS 'center',
		CASE a.CenterTypeDescription WHEN 'Joint' THEN 'Franchise' ELSE a.CenterTypeDescription END AS 'Type',
        SUM(CASE WHEN a.FullDate = dateadd(dd, 0, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY1,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 1, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY2,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 2, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY3,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 3, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY4,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 4, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY5,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 5, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY6,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 6, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY7,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 7, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY8,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 8, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY9,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 9, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY10,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 10, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY11,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 11, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY12,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 12, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY13,
        SUM(CASE WHEN a.FullDate = dateadd(dd, 13, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY14,
        SUM(a.is_appt) total_appt
	FROM	#Activity a
	GROUP BY a.MainGroupDescription
            ,a.CenterNumber
            ,a.CenterDescriptionNumber
            ,a.CenterTypeDescription


END
GO
