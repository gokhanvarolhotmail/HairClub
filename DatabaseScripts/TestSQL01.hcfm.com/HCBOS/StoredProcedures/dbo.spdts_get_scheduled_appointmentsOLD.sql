/* CreateDate: 08/20/2007 16:16:36.330 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
/*
	** spdts_get_scheduled_appointments **
	Finds all appointments scheduled going out
	the number of days passed in
	Created: 	5/3/2006
	Created By: 	Howard Abelow
	Modified By:	MJW 2006-12-20
			Rewrite for ONCV schema
*/

/*
==============================================================================

PROCEDURE:				spdts_get_scheduled_appointment

VERSION:				v1.0

DESTINATION SERVER:		HCTESTSQL1\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	OnContact

AUTHOR: 				Howard Abelow

IMPLEMENTOR: 			Brian Kellman

DATE IMPLEMENTED: 		 5/3/2006

LAST REVISION DATE: 	 8/13/2007

==============================================================================
DESCRIPTION: Finds all appointments scheduled going out the number of days passed in
==============================================================================

==============================================================================
NOTES: 	8/13/2007: Modified to run in the BOS database(Post OnContact modification)
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spdts_get_scheduled_appointment 1
==============================================================================
*/
CREATE  PROCEDURE [dbo].[spdts_get_scheduled_appointmentsOLD]
	 @days int
AS

/*SELECT CASE WHEN sls_psn_code LIKE 'TM%' THEN RTRIM(territory) ELSE RTRIM(sls_psn_code) END as 'Center'
,	Convert(char(10),date_,101) as 'ApptDate'
,	time_ as 'ApptTime'
,	Count(time_) as 'Appts'
INTO #raw
FROM HCM.dbo.gmin_mngr
	INNER JOIN HCM.dbo.gminfo ON
			HCM.dbo.gmin_mngr.recordid = HCM.dbo.gminfo.recordid
WHERE date_ BETWEEN DateAdd(day, -1, GetDate()) AND  DateAdd(day, @days,GetDate())
AND HCM.dbo.ISAPPT(RTRIM(act_code)) = 1
GROUP BY date_ , time_, sls_psn_code, territory
ORDER BY  Center, ApptDate, ApptTime

UNION
SELECT CASE WHEN sls_psn_code LIKE 'TM%' THEN RTRIM(territory) ELSE RTRIM(sls_psn_code) END as 'Center'
,	Convert(char(10),date_,101) as 'ApptDate'
,	time_ as 'ApptTime'
,	Count(time_) as 'Appts'
FROM HCM.dbo.gmin_mngr
	INNER JOIN HCM.dbo.gminfo ON
			HCM.dbo.gmin_mngr.recordid = HCM.dbo.gminfo.recordid
WHERE date_ BETWEEN DateAdd(day, -1, GetDate()) AND DateAdd(day, 0, GetDate())
AND  time_  > Convert(char(5),GetDate(),8)
AND HCM.dbo.ISAPPT(RTRIM(act_code)) = 1
GROUP BY date_ , time_, sls_psn_code, territory


INSERT INTO dbo.Appointments_Scheduled
SELECT Center, ApptDate, ApptTime, SUM(Appts)
FROM #raw
GROUP BY Center, ApptDate, ApptTime
--EXEC spdts_get_scheduled_appointments 14
DROP TABLE #raw
*/

--INSERT INTO dbo.appointments_scheduled
INSERT INTO dbo.appointments_scheduled
SELECT center, apptdate, appttime, COUNT(*) FROM (
SELECT
	--CASE WHEN au.user_code LIKE 'TM%' THEN au.user_code ELSE c.cst_center_number END AS center
	CAST(c.cst_center_number AS int) AS center
,	CONVERT(varchar(10), a.due_date, 101) AS apptdate
,	SUBSTRING(CONVERT(varchar(19),a.start_time,120),12,5) AS appttime
	FROM HCM.dbo.oncd_activity a
	INNER JOIN HCM.dbo.oncd_activity_company ac	ON ac.activity_id = a.activity_id AND ac.primary_flag = 'Y'
	INNER JOIN HCM.dbo.oncd_company c		ON c.company_id = ac.company_id
	LEFT OUTER JOIN HCM.dbo.oncd_activity_user au 	ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
	INNER JOIN HCM.dbo.onca_action aa		ON aa.action_code = a.action_code
WHERE aa.action_type_code = 'APPOINT'
) temp
WHERE center IS NOT NULL AND apptdate IS NOT NULL AND appttime IS NOT NULL
GROUP BY center, apptdate, appttime
ORDER BY center, apptdate, appttime
GO
