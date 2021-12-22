/* CreateDate: 08/31/2011 09:54:55.727 , ModifyDate: 09/01/2011 10:31:59.517 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		sprpt_booking_overview

VERSION:		v2.0

DESTINATION SERVER:	HCDEVWH1

DESTINATION DATABASE: 	Warehouse

RELATED APPLICATION:  	Bookings Report

AUTHOR: 		EM 2004

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/11/2007

LAST REVISION DATE: 	8/30/2011

8/30/2011 - HDu - Update to SQL06 BI queries

------------------------------------------------------------------------
NOTES: Gets Query For Report
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC sprpt_booking_overview '11/06/07', a

***********************************************************************/


CREATE   PROCEDURE [dbo].[sprpt_booking_overview]
    (
      @BegDt datetime,
      @gender char(1)
    )
AS
    DECLARE  @EndDt datetime
			,@TempDt datetime
    SET @EndDt = DATEADD(day, 14, @BegDt)

    SELECT
		DD.FullDate date_,
        AC.ActionCodeSSID Act_code,
        CASE WHEN HC_BI_Reporting.dbo.ISAPPT(RTRIM(AC.ActionCodeSSID)) = 1 AND (RC.ResultCodeSSID NOT IN ( 'RESCHEDULE', 'CANCEL','CTREXCPTN') OR RC.ResultCodeSSID IS NULL)
             THEN 1
             ELSE 0
        END is_appt
        --GROUP BY fields
        , DR.RegionDescription
        , CE.CenterSSID
        , CE.CenterDescription
        , CT.CenterTypeDescription
	INTO #Activity
    FROM    dbo.synHC_MKTG_DDS_vwFactActivity Activity
			--Filters
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimDate DD
				ON Activity.ActivityDueDateKey = DD.DateKey
					AND DD.FullDate BETWEEN @begdt AND @enddt

			--Related data
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActionCode AC
			ON Activity.ActionCodeKey = AC.ActionCodeKey
			AND Activity.ActionCodeKey >0

			INNER JOIN dbo.synHC_MKTG_DDS_vwDimResultCode RC
				ON Activity.ResultCodeKey = RC.ResultCodeKey
				-- ResultCodes are allowed to be NULL or Empty
				--AND Activity.ResultCodeKey >0

			INNER JOIN dbo.synHC_MKTG_DDS_vwDimContact DC
				ON Activity.ContactKey = DC.ContactKey

			/* HDu - Activity and Contact Center data are incorrect, using Lead instead */
			--INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter CE
			--	ON Activity.CenterKey = CE.CenterKey
			--	AND Activity.CenterKey >0

			--	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenterType CT
			--		ON CE.CenterTypeKey = CT.CenterTypeKey
			--		AND CE.CenterTypeKey >0

			--	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimRegion DR
			--		ON CE.RegionKey = DR.RegionKey
			--		AND CE.RegionKey >0

			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActivity DA
				ON Activity.ActivityKey = DA.ActivityKey

			INNER JOIN dbo.synHC_MKTG_DDS_vwFactLead Lead
				ON Activity.ContactKey = Lead.ContactKey
				AND Activity.ContactKey >0

				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter CE
					ON Lead.CenterKey = CE.CenterKey
					AND Activity.CenterKey >0

					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenterType CT
						ON CE.CenterTypeKey = CT.CenterTypeKey
						AND CE.CenterTypeKey >0

					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimRegion DR
						ON CE.RegionKey = DR.RegionKey
						AND CE.RegionKey >0

				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimGender DG
					ON Lead.GenderKey = DG.GenderKey
					AND DG.GenderSSID LIKE CASE @Gender
											   WHEN 'm' THEN 'M'
											   WHEN 'f' THEN 'F'
											   ELSE '%'
											 END

    SELECT
		a.RegionDescription 'Region',
        CONVERT(VARCHAR, a.CenterSSID) + ' - ' + a.CenterDescription AS 'Center',
		CASE a.CenterTypeDescription WHEN 'Joint' THEN 'Franchise' ELSE a.CenterTypeDescription END AS 'Type',
        SUM(CASE WHEN a.date_ = dateadd(dd, 0, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY1,
        SUM(CASE WHEN a.date_ = dateadd(dd, 1, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY2,
        SUM(CASE WHEN a.date_ = dateadd(dd, 2, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY3,
        SUM(CASE WHEN a.date_ = dateadd(dd, 3, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY4,
        SUM(CASE WHEN a.date_ = dateadd(dd, 4, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY5,
        SUM(CASE WHEN a.date_ = dateadd(dd, 5, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY6,
        SUM(CASE WHEN a.date_ = dateadd(dd, 6, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY7,
        SUM(CASE WHEN a.date_ = dateadd(dd, 7, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY8,
        SUM(CASE WHEN a.date_ = dateadd(dd, 8, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY9,
        SUM(CASE WHEN a.date_ = dateadd(dd, 9, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY10,
        SUM(CASE WHEN a.date_ = dateadd(dd, 10, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY11,
        SUM(CASE WHEN a.date_ = dateadd(dd, 11, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY12,
        SUM(CASE WHEN a.date_ = dateadd(dd, 12, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY13,
        SUM(CASE WHEN a.date_ = dateadd(dd, 13, @begdt) THEN a.is_appt
                 ELSE 0
            END) AS DAY14,
        SUM(a.is_appt) total_appt
	FROM	#Activity a
	GROUP BY a.RegionDescription
            ,a.CenterSSID
            ,a.CenterDescription
            ,a.CenterTypeDescription
    ORDER BY a.CenterTypeDescription
			,a.RegionDescription
            ,a.CenterSSID

DROP TABLE #Activity
GO
