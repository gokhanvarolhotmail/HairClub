/* CreateDate: 10/27/2014 10:02:30.963 , ModifyDate: 11/06/2014 16:52:59.847 */
GO
CREATE VIEW [dbo].[cstv_queue_report_by_date]
AS
SELECT queue_id, CONVERT(datetime,CONVERT(nchar(10),start_date, 121))  AS start_date,
	COUNT(DISTINCT user_code) AS total_users,
   (SELECT COUNT(DISTINCT dbo.oncd_activity_contact.contact_id) AS Expr1
    FROM dbo.psoActivitiesInQueueForDates(csta_queue_user_history.queue_id, CONVERT(datetime,CONVERT(nchar(10),csta_queue_user_history.start_date,121)), DATEADD(day,1,CONVERT(datetime,CONVERT(nchar(10),csta_queue_user_history.start_date,121)))) qa
		INNER JOIN dbo.oncd_activity WITH (NOLOCK) ON qa.activity_id = dbo.oncd_activity.activity_id
		INNER JOIN dbo.oncd_activity_contact WITH (NOLOCK) ON dbo.oncd_activity.activity_id = dbo.oncd_activity_contact.activity_id
    WHERE   (dbo.oncd_activity.result_code IS NOT NULL)) AS total_leads,
    (SELECT COUNT(DISTINCT activity_id) AS Expr1
    FROM      dbo.oncd_activity AS oncd_activity_3 WITH (NOLOCK)
    WHERE   (completion_date = CONVERT(datetime,CONVERT(nchar(10),csta_queue_user_history.start_date,121))) AND (cst_queue_id = csta_queue_user_history.queue_id)) AS completed_activities,
    (SELECT COUNT(DISTINCT activity_id) AS Expr1
    FROM      dbo.oncd_activity AS oncd_activity_2 WITH (NOLOCK)
    WHERE   (result_code = 'APPOINT') AND (completion_date = CONVERT(datetime,CONVERT(nchar(10), csta_queue_user_history.start_date, 121))) AND (cst_queue_id = csta_queue_user_history.queue_id)) AS appointment_activities,
    (SELECT COUNT(DISTINCT activity_id) AS Expr1
    FROM      dbo.oncd_activity AS oncd_activity_1 WITH (NOLOCK)
    WHERE   (result_code = 'BROCHURE') AND (completion_date = CONVERT(datetime,CONVERT(nchar(10), csta_queue_user_history.start_date, 121)) AND (cst_queue_id = csta_queue_user_history.queue_id))) AS brochure_activities,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) AS total_seconds,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) / 3600 AS hours,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) % 3600 / 60 AS minutes,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) % 3600 % 60 AS seconds
FROM     dbo.csta_queue_user_history WITH (NOLOCK)
GROUP BY queue_id, CONVERT(datetime,CONVERT(nchar(10),start_date, 121))
GO
