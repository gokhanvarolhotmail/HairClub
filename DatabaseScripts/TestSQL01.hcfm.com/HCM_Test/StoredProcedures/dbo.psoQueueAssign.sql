/* CreateDate: 10/15/2013 00:25:47.547 , ModifyDate: 05/19/2014 08:48:27.643 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[psoQueueAssign]
	@ActivityId	NCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @QueueId	NCHAR(10)
	DECLARE @Filter		NVARCHAR(MAX)
	DECLARE @Sql		NVARCHAR(MAX)
	DECLARE @SqlBase	NVARCHAR(MAX)
	DECLARE @Date		DATETIME

	SET @SqlBase = 'UPDATE oncd_activity
	SET oncd_activity.cst_queue_id = ''{0}''
	FROM oncd_activity
	INNER JOIN oncd_activity_contact ON oncd_activity.activity_id = oncd_activity_contact.activity_id
	INNER JOIN oncd_contact ON oncd_activity_contact.contact_id = oncd_contact.contact_id
	WHERE
	oncd_activity.activity_id = ''{1}'' AND
	oncd_activity.result_code IS NULL AND
	oncd_activity.cst_queue_id IS NULL AND
	(1=1)'

	DECLARE ScheduleCursor CURSOR FOR
	SELECT ISNULL(schedule_by_day_of_week_queue.queue_id, schedule_by_date_queue.queue_id), dbo.psoQueueFilterText(ISNULL(schedule_by_day_of_week_queue.queue_id, schedule_by_date_queue.queue_id))
	FROM dbo.psoQueueScheduleForDate(GETDATE()) schedule
	LEFT OUTER JOIN csta_queue_queue_schedule_by_day_of_week schedule_by_day_of_week ON
		schedule.id = schedule_by_day_of_week.queue_schedule_by_day_of_week_id
	LEFT OUTER JOIN csta_queue schedule_by_day_of_week_queue ON
		schedule_by_day_of_week.queue_id = schedule_by_day_of_week_queue.queue_id AND
		schedule_by_day_of_week_queue.is_dialer_queue = 'N' AND
		schedule_by_day_of_week_queue.object_id IS NULL
	LEFT OUTER JOIN csta_queue_queue_schedule_by_date schedule_by_date ON
		schedule.id = schedule_by_date.queue_schedule_by_date_id
	LEFT OUTER JOIN csta_queue schedule_by_date_queue ON
		schedule_by_date.queue_id = schedule_by_date_queue.queue_id AND
		schedule_by_date_queue.is_dialer_queue = 'N' AND
		schedule_by_date_queue.object_id IS NULL
	WHERE ISNULL(schedule_by_day_of_week_queue.queue_id, schedule_by_date_queue.queue_id) IS NOT NULL
	ORDER BY ISNULL(schedule_by_day_of_week.sort_order, schedule_by_date.sort_order)

	OPEN ScheduleCursor

	FETCH NEXT FROM ScheduleCursor
	INTO @QueueId, @Filter

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (LEN(RTRIM(@Filter)) > 0)
		BEGIN
			SET @Sql = REPLACE(@SqlBase, '1=1', @Filter)
		END
		ELSE
		BEGIN
			SET @Sql = @SqlBase
		END

		SET @Sql = REPLACE(@Sql, '{0}', @QueueId)
		SET @Sql = REPLACE(@Sql, '{1}', @ActivityId)

		EXEC (@Sql)

		-- Exit early if the Activity was assigned to a Queue.
		IF @@ROWCOUNT > 0
			BREAK

		FETCH NEXT FROM ScheduleCursor
		INTO @QueueId, @Filter
	END

	CLOSE ScheduleCursor
	DEALLOCATE ScheduleCursor

END
GO
