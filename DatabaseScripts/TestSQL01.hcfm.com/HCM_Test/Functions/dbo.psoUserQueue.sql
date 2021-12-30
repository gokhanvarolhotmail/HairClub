/* CreateDate: 10/15/2013 00:26:57.673 , ModifyDate: 10/15/2013 00:26:57.673 */
GO
CREATE FUNCTION [dbo].[psoUserQueue]
(
	@UserCode	NCHAR(20)
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @QueueId	NCHAR(10)

	SELECT TOP 1
	@QueueId = ISNULL(qdowq.queue_id, qdq.queue_id)
	FROM dbo.psoQueueScheduleForDate(GETDATE()) schedule
	LEFT JOIN csta_queue_schedule_by_day_of_week dow ON schedule.id = dow.queue_schedule_by_day_of_week_id
	LEFT JOIN csta_queue_queue_schedule_by_day_of_week qdow ON dow.queue_schedule_by_day_of_week_id = qdow.queue_schedule_by_day_of_week_id
	LEFT JOIN csta_queue_queue_schedule_by_day_of_week_user qdowu ON qdow.queue_queue_schedule_by_day_of_week_id = qdowu.queue_queue_schedule_by_day_of_week_id
	LEFT JOIN csta_queue qdowq ON qdow.queue_id = qdowq.queue_id AND qdowq.is_dialer_queue = 'N'
	LEFT JOIN csta_queue_schedule_by_date d ON schedule.id = d.queue_schedule_by_date_id
	LEFT JOIN csta_queue_queue_schedule_by_date qd ON d.queue_schedule_by_date_id = qd.queue_schedule_by_date_id
	LEFT JOIN csta_queue_queue_schedule_by_date_user qdu ON qd.queue_queue_schedule_by_date_id = qdu.queue_queue_schedule_by_date_id
	LEFT JOIN csta_queue qdq ON qd.queue_id = qdq.queue_id AND qdq.is_dialer_queue = 'N'
	WHERE ISNULL(qdowq.queue_id, qdq.queue_id) IS NOT NULL AND
	ISNULL(qdowu.user_code, qdu.user_code) = @UserCode
	ORDER BY qdowq.sort_order

	RETURN @QueueId

END
GO
