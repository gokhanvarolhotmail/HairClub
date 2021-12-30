/* CreateDate: 10/15/2013 00:25:17.887 , ModifyDate: 11/06/2014 16:52:51.587 */
GO
CREATE VIEW [dbo].[cstv_user_queue_history]
AS

SELECT
csta_queue_user_history.queue_id AS [queue_id],
csta_queue_user_history.user_code AS [user_code],
--dbo.CombineDates(start_date, NULL) AS [start_date],
CONVERT(datetime,CONVERT(nchar(10),start_date, 121)) AS start_date,
SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) AS [total_seconds],
SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) / 3600 AS [hours],
(SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) % 3600) / 60 AS [minutes],
(SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) % 3600) % 60 AS [seconds]
FROM dbo.csta_queue_user_history
INNER JOIN dbo.csta_queue ON
	csta_queue_user_history.queue_id = csta_queue.queue_id
INNER JOIN dbo.onca_user ON
	csta_queue_user_history.user_code = onca_user.user_code
GROUP BY
csta_queue_user_history.queue_id,
csta_queue_user_history.user_code,
onca_user.display_name,
--dbo.CombineDates(start_date, NULL)
CONVERT(datetime,CONVERT(nchar(10),start_date, 121))
GO
