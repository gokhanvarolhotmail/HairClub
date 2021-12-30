/* CreateDate: 10/15/2013 00:24:26.080 , ModifyDate: 10/27/2014 10:02:44.700 */
GO
CREATE PROCEDURE [dbo].[psoQueueAssignActivities]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @QueueId	NCHAR(10)
	DECLARE @BaseSQL	NVARCHAR(MAX)
	DECLARE @BaseWhere	NVARCHAR(MAX)
	DECLARE @SQL		NVARCHAR(MAX)
	DECLARE @Filter		NVARCHAR(MAX)
	DECLARE @timetext	NVARCHAR(MAX)
	DECLARE @lastRowcount int
	DECLARE @maxActivityId nchar(10)

	SET @BaseSQL = '
	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
	INNER JOIN oncd_contact WITH (NOLOCK) ON oncd_activity_contact.contact_id = oncd_contact.contact_id
	INNER JOIN oncd_contact_address WITH (NOLOCK) ON oncd_contact.contact_id = oncd_contact_address.contact_id
	INNER JOIN onca_action ON oncd_activity.action_code = onca_action.action_code	'

	--We assume that the Noble activities are already set with oncd_activity.cst_in_noble_queue = 'Y'
	--and just deal with the remainder
	SET @BaseWhere = '
	WHERE
	oncd_contact.contact_status_code = ''LEAD'' AND
	oncd_contact.do_not_solicit = ''N'' AND oncd_contact.cst_do_not_call = ''N'' AND
	oncd_activity.result_code IS NULL AND
	ISNULL(oncd_activity.cst_in_noble_queue,'''') <> ''Y'' AND
	(1=1)'

	--Establish a temp table to contain the limited set of activities we're dealing with
	CREATE TABLE #activityQueue (activity_id nchar(10) PRIMARY KEY, cst_queue_id nchar(10))

	SET @SQL = 'INSERT INTO #activityQueue SELECT DISTINCT oncd_activity.activity_id, NULL FROM oncd_activity WITH (NOLOCK)	'
	SET @SQL = @SQL + @BaseSQL + @BaseWhere
	SET @timetext = CONVERT(nchar(23),GETDATE(),121)
	RAISERROR(@timetext,0,0) WITH NOWAIT
	RAISERROR(@Sql, 0,0) WITH NOWAIT

	EXEC (@SQL)

	SET @lastRowcount = @@ROWCOUNT
	SET @timetext = CONVERT(nchar(23),GETDATE(),121) + ' (' + CONVERT(nvarchar(10), @lastRowcount)+ ')'
	RAISERROR(@timetext,0,0) WITH NOWAIT

	CREATE NONCLUSTERED INDEX ix1 ON #activityQueue(cst_queue_id)

	DECLARE QueueCursor CURSOR FOR
		SELECT
		ISNULL(qdowq.queue_id, qdq.queue_id)
		FROM dbo.psoQueueScheduleForDate(GETDATE()) schedule
		LEFT JOIN csta_queue_schedule_by_day_of_week dow ON schedule.id = dow.queue_schedule_by_day_of_week_id
		LEFT JOIN csta_queue_queue_schedule_by_day_of_week qdow ON dow.queue_schedule_by_day_of_week_id = qdow.queue_schedule_by_day_of_week_id
		LEFT JOIN csta_queue qdowq ON qdow.queue_id = qdowq.queue_id AND qdowq.is_dialer_queue = 'N' AND qdowq.object_id IS NULL
		LEFT JOIN csta_queue_schedule_by_date d ON schedule.id = d.queue_schedule_by_date_id
		LEFT JOIN csta_queue_queue_schedule_by_date qd ON d.queue_schedule_by_date_id = qd.queue_schedule_by_date_id
		LEFT JOIN csta_queue qdq ON qd.queue_id = qdq.queue_id AND qdq.is_dialer_queue = 'N' AND qdq.object_id IS NULL
		WHERE ISNULL(qdowq.queue_id, qdq.queue_id) IS NOT NULL
		ORDER BY qdowq.sort_order

	OPEN QueueCursor

	FETCH NEXT FROM QueueCursor
	INTO @QueueId

	DECLARE @orderBy varchar(max)
	DECLARE @table_name nvarchar(128)
	DECLARE @column_name nvarchar(128)
	DECLARE @sort_direction nvarchar(4)
	DECLARE @maxQueueSize int

	SET @maxQueueSize = 10000

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Filter  = (SELECT dbo.psoQueueFilterText(@QueueId))

		--Each queue has its own sort order; select the TOP x based on that
		SET @orderBy = ''

		DECLARE orderBy CURSOR FOR SELECT table_name, column_name, sort_direction FROM csta_queue_sort WHERE queue_id = @QueueId ORDER BY sort_order ASC
		OPEN orderBy
		FETCH NEXT FROM orderBy INTO @table_name, @column_name, @sort_direction
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (ISNULL(@table_name,'') <> '' AND ISNULL(@column_name,'') <> '')
			BEGIN
				IF (RTRIM(@orderBy) <> '')
					SET @orderBy = @orderBy + ', '

				SET @orderBy = @orderBy + ISNULL(@table_name,'') + '.' + ISNULL(@column_name,'') + ' ' + ISNULL(@sort_direction,'')
			END

			FETCH NEXT FROM orderBy INTO @table_name, @column_name, @sort_direction
		END
		CLOSE orderBy
		DEALLOCATE orderBy

		IF @orderBy <> ''
			SET @orderBy = 'ORDER BY ' + @orderBy
		--END order by logic

		IF (LEN(RTRIM(@Filter)) > 0)
		BEGIN
			SET @SQL = 'UPDATE #activityQueue SET #activityQueue.cst_queue_id = ''{0}''
			WHERE #activityQueue.activity_id IN
			(SELECT TOP ' + CONVERT(varchar(10),ISNULL(@maxQueueSize,0)) + ' #activityQueue.activity_id
			FROM #activityQueue
			INNER JOIN oncd_activity WITH (NOLOCK) ON oncd_activity.activity_id = #activityQueue.activity_id ' + @BaseSQL + '
			WHERE #activityQueue.cst_queue_id IS NULL
			AND (' + @Filter + ') ' + @orderBy + ')'
		END
		ELSE
		BEGIN
			SET @SQL = 'UPDATE #activityQueue SET #activityQueue.cst_queue_id = ''{0}''
			WHERE #activityQueue.activity_id IN
			(SELECT TOP ' + CONVERT(varchar(10),ISNULL(@maxQueueSize,0)) + ' #activityQueue.activity_id
			FROM #activityQueue
			INNER JOIN oncd_activity WITH (NOLOCK) ON oncd_activity.activity_id = #activityQueue.activity_id ' + @BaseSQL + '
			WHERE #activityQueue.cst_queue_id IS NULL
			' + @orderBy + ')'
		END

		SET @SQL = REPLACE(@Sql, '{0}', @QueueId)
		SET @timetext = CONVERT(nchar(23),GETDATE(),121)
		RAISERROR(@timetext,0,0) WITH NOWAIT
		RAISERROR(@Sql, 0,0) WITH NOWAIT

		EXEC (@SQL)

		SET @lastRowcount = @@ROWCOUNT
		SET @timetext = CONVERT(nchar(23),GETDATE(),121) + ' (' + CONVERT(nvarchar(10), @lastRowcount) + ')'
		RAISERROR(@timetext,0,0) WITH NOWAIT

		FETCH NEXT FROM QueueCursor
		INTO @QueueId
	END

	CLOSE QueueCursor
	DEALLOCATE QueueCursor


	SET @timetext = 'Final Update Start: ' + CONVERT(nchar(23),GETDATE(),121)
	RAISERROR(@timetext,0,0) WITH NOWAIT

	--DELETE #activityQueue WHERE cst_queue_id IS NULL

	SET @lastRowcount = 0
	--Do the final update in batches of 10000
	--WHILE EXISTS (SELECT TOP 1 1 FROM #activityQueue)
	--BEGIN
	--	SELECT @maxActivityId = MAX(activity_id) FROM (SELECT TOP 10000 activity_id FROM #activityQueue ORDER BY activity_id) temp

	--	UPDATE oncd_activity SET oncd_activity.cst_queue_id = #activityQueue.cst_queue_id
	--	FROM oncd_activity
	--	INNER JOIN #activityQueue ON #activityQueue.activity_id = oncd_activity.activity_id
	--	WHERE #activityQueue.activity_id <= @maxActivityId

	--	SET @lastRowcount = @lastRowcount + @@ROWCOUNT
	--	SET @timetext = CONVERT(nchar(23),GETDATE(),121) + '(' + CONVERT(nvarchar(10), @lastRowcount) + ')'

	--	IF (@lastRowcount % 10000 = 0)
	--		RAISERROR(@timetext,0,0) WITH NOWAIT

	--	DELETE #activityQueue WHERE activity_id <= @maxActivityId
	--END

	--2014-10-22	MJW		Workwise
	--Previously a trigger on oncd_activity would populate csta_queue_history for all activities since we were updating all
	--but now since we're only updating a limited set of activities below, we want to insert values in csta_queue_history
	--for all the others manually, so that every activity gets a history entry every day
	--So here we insert the converse set of the UPDATE statement below
	--INSERT INTO csta_queue_history (queue_date, queue_id, activity_id)
	--SELECT GETDATE(), #activityQueue.cst_queue_id, #activityQueue.activity_id
	--	FROM oncd_activity
	--	INNER JOIN #activityQueue ON #activityQueue.activity_id = oncd_activity.activity_id
	--WHERE #activityQueue.cst_queue_id IS NOT NULL
	--	AND #activityQueue.cst_queue_id = oncd_activity.cst_queue_id


	--SET @lastRowcount = @@ROWCOUNT
	--SET @timetext = 'Queue History Insert Completed: ' + CONVERT(nchar(23),GETDATE(),121) + '(' + CONVERT(nvarchar(10), @lastRowcount) + ')'
	--RAISERROR(@timetext,0,0) WITH NOWAIT

	UPDATE oncd_activity
	SET cst_queue_id = #activityQueue.cst_queue_id
	FROM oncd_activity
	INNER JOIN #activityQueue ON #activityQueue.activity_id = oncd_activity.activity_id
	WHERE #activityQueue.cst_queue_id <> oncd_activity.cst_queue_id
		OR (#activityQueue.cst_queue_id IS NULL AND oncd_activity.cst_queue_id IS NOT NULL)
		OR (#activityQueue.cst_queue_id IS NOT NULL AND oncd_activity.cst_queue_id IS NULL)

	SET @lastRowcount = @@ROWCOUNT
	SET @timetext = 'Final Update End:   ' + CONVERT(nchar(23),GETDATE(),121) + '(' + CONVERT(nvarchar(10), @lastRowcount) + ')'
	RAISERROR(@timetext,0,0) WITH NOWAIT
END
GO
