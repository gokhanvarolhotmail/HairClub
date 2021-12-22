/* CreateDate: 10/15/2013 00:22:03.957 , ModifyDate: 10/15/2013 00:22:03.957 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[psoQueueScheduleForDate]
(
@Date DATE
)
RETURNS TABLE
AS
RETURN
(
	SELECT 'ByDate' AS [type], queue_schedule_by_date_id AS [id]
	FROM csta_queue_schedule_by_date
	WHERE queue_date = dbo.CombineDates(@Date, NULL) AND active = 'Y'

	UNION

	SELECT 'ByDayOfWeek', queue_schedule_by_day_of_week_id
	FROM csta_queue_schedule_by_day_of_week
	WHERE day_of_week = DATEPART(dw, @Date) AND active = 'Y'
	AND NOT EXISTS (SELECT 1 FROM csta_queue_schedule_by_date
	WHERE queue_date = dbo.CombineDates(@Date, NULL))
)
GO
