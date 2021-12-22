/* CreateDate: 10/15/2013 00:28:12.493 , ModifyDate: 01/30/2014 10:33:41.540 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[cstv_queue_report_by_date_user]
AS
SELECT
queue_id,
start_date,
user_code,
(SELECT COUNT(DISTINCT oncd_activity.activity_id)
FROM oncd_activity
WHERE
oncd_activity.result_code IS NOT NULL AND
oncd_activity.completion_date = cstv_user_queue_history.start_date AND
oncd_activity.completed_by_user_code = cstv_user_queue_history.user_code AND
oncd_activity.cst_queue_id = cstv_user_queue_history.queue_id) AS completed_activities,
(SELECT COUNT(DISTINCT oncd_activity.activity_id)
FROM oncd_activity
WHERE
oncd_activity.result_code = 'APPOINT' AND
oncd_activity.completion_date = cstv_user_queue_history.start_date AND
oncd_activity.completed_by_user_code = cstv_user_queue_history.user_code AND
oncd_activity.cst_queue_id = cstv_user_queue_history.queue_id) AS appointment_activities,
(SELECT COUNT(DISTINCT oncd_activity.activity_id)
FROM oncd_activity
WHERE
oncd_activity.result_code = 'BROCHURE' AND
oncd_activity.completion_date = cstv_user_queue_history.start_date AND
oncd_activity.completed_by_user_code = cstv_user_queue_history.user_code AND
oncd_activity.cst_queue_id = cstv_user_queue_history.queue_id) AS brochure_activities,
cstv_user_queue_history.total_seconds,
cstv_user_queue_history.hours,
cstv_user_queue_history.minutes,
cstv_user_queue_history.seconds
FROM cstv_user_queue_history
GROUP BY user_code,start_date, queue_id,
total_seconds,
hours,
minutes,
seconds
GO
