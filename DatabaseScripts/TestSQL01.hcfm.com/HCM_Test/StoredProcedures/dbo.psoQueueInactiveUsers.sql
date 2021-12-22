/* CreateDate: 10/15/2013 00:32:25.507 , ModifyDate: 10/15/2013 00:32:25.507 */
GO
CREATE PROCEDURE [dbo].[psoQueueInactiveUsers]
	@Date DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT user_code, display_name FROM onca_user
	WHERE
	active = 'Y' AND cst_is_queue_user = 'Y' AND
	user_code NOT IN (
	SELECT
	u.user_code AS [user_code]
	FROM csta_queue_schedule_by_date qsbd
	INNER JOIN csta_queue_schedule_by_date_user qsbdu ON qsbd.queue_schedule_by_date_id = qsbdu.queue_schedule_by_date_id
	INNER JOIN csta_queue q ON qsbdu.queue_id = q.queue_id
	INNER JOIN onca_user u ON qsbdu.user_code = u.user_code
	WHERE
	qsbd.queue_date = @Date AND qsbd.active = 'Y'

	UNION

	SELECT
	u.user_code
	FROM csta_queue_schedule_by_day_of_week qsbdow
	INNER JOIN csta_queue_schedule_by_day_of_week_user qsbdowu ON qsbdow.queue_schedule_by_day_of_week_id = qsbdowu.queue_schedule_by_day_of_week_id
	INNER JOIN csta_queue q ON qsbdowu.queue_id = q.queue_id
	INNER JOIN onca_user u ON qsbdowu.user_code = u.user_code
	WHERE
	qsbdow.active = 'Y' AND
	qsbdow.day_of_week = DATEPART(dw, @Date) AND
	NOT EXISTS (SELECT 1
	FROM csta_queue_schedule_by_date
	WHERE
	queue_date = @Date AND active = 'Y'))
END
GO
