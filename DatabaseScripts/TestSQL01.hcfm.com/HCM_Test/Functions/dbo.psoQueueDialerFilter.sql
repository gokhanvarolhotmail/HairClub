/* CreateDate: 10/15/2013 00:29:05.883 , ModifyDate: 10/15/2013 00:29:05.883 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[psoQueueDialerFilter]
(
	@Date	DATETIME
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Filter	NVARCHAR(MAX)
	SET @Date = dbo.CombineDates(@Date, NULL)

	SET @Filter = (SELECT TOP 1 filter FROM (
	SELECT dbo.psoQueueFilterText(queue.queue_id) AS filter
	FROM csta_queue_schedule_by_date AS schedule
	INNER JOIN csta_queue_queue_schedule_by_date AS queue_schedule ON schedule.queue_schedule_by_date_id = queue_schedule.queue_schedule_by_date_id
	INNER JOIN csta_queue AS queue ON queue_schedule.queue_id = queue.queue_id
	WHERE queue_date = @Date AND queue.active = 'Y' AND queue.is_dialer_queue = 'Y'

	UNION

	SELECT dbo.psoQueueFilterText(queue.queue_id)
	FROM csta_queue_schedule_by_day_of_week AS schedule
	INNER JOIN csta_queue_queue_schedule_by_day_of_week AS queue_schedule ON schedule.queue_schedule_by_day_of_week_id = queue_schedule.queue_schedule_by_day_of_week_id
	INNER JOIN csta_queue AS queue ON queue_schedule.queue_id = queue.queue_id
	WHERE day_of_week = DATEPART(dw, @Date) AND queue.active = 'Y' AND queue.is_dialer_queue = 'Y'
	AND NOT EXISTS (SELECT 1 FROM csta_queue_schedule_by_date
	WHERE queue_date = @Date)) AS filter)

	-- If there isn't a filter found then use the default filter
	IF (LEN(RTRIM(ISNULL(@FILTER,''))) = 0)
	BEGIN
		SET @Filter = 'oncd_contact.cst_has_valid_cell_phone = ''N'' OR oncd_contact.cst_has_open_confirmation_call = ''Y'''
	END

	RETURN @Filter
END
GO
