/* CreateDate: 10/15/2013 00:28:42.520 , ModifyDate: 10/15/2013 00:28:42.520 */
GO
CREATE PROCEDURE [dbo].[psoQueuesByDate]
	@Date DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 'ByDate' AS [type], queue_schedule_by_date_id AS [id]
	FROM csta_queue_schedule_by_date
	WHERE queue_date = @Date AND active = 'Y'

	UNION

	SELECT 'ByDayOfWeek', queue_schedule_by_day_of_week_id
	FROM csta_queue_schedule_by_day_of_week
	WHERE day_of_week = DATEPART(dw, @Date) AND active = 'Y'
	AND NOT EXISTS (SELECT 1 FROM csta_queue_schedule_by_date
	WHERE queue_date = @Date)

END
GO
