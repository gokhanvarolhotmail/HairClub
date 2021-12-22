/* CreateDate: 10/15/2013 00:29:29.713 , ModifyDate: 10/15/2013 00:29:29.713 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[psoQueueDialerId]
(
	@Date	DATETIME
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @QueueId	NVARCHAR(MAX)
	SET @Date = dbo.CombineDates(@Date, NULL)

	SET @QueueId = (SELECT TOP 1 queue_id FROM (
	SELECT queue.queue_id
	FROM csta_queue_schedule_by_date AS schedule
	INNER JOIN csta_queue_queue_schedule_by_date AS queue_schedule ON schedule.queue_schedule_by_date_id = queue_schedule.queue_schedule_by_date_id
	INNER JOIN csta_queue AS queue ON queue_schedule.queue_id = queue.queue_id
	WHERE queue_date = @Date AND queue.active = 'Y' AND queue.is_dialer_queue = 'Y'

	UNION

	SELECT queue.queue_id
	FROM csta_queue_schedule_by_day_of_week AS schedule
	INNER JOIN csta_queue_queue_schedule_by_day_of_week AS queue_schedule ON schedule.queue_schedule_by_day_of_week_id = queue_schedule.queue_schedule_by_day_of_week_id
	INNER JOIN csta_queue AS queue ON queue_schedule.queue_id = queue.queue_id
	WHERE day_of_week = DATEPART(dw, @Date) AND queue.active = 'Y' AND queue.is_dialer_queue = 'Y'
	AND NOT EXISTS (SELECT 1 FROM csta_queue_schedule_by_date
	WHERE queue_date = @Date)) AS filter)

	-- If there isn't a queue found then use the queue filter
	IF (LEN(RTRIM(ISNULL(@QueueId,''))) = 0)
	BEGIN
		SET @QueueId = 'YSLEDVKDR1'
	END

	RETURN @QueueId
END
GO
