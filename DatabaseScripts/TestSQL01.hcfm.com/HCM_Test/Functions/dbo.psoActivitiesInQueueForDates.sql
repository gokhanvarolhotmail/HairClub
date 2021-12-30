/* CreateDate: 11/06/2014 16:52:42.993 , ModifyDate: 11/06/2014 16:52:42.993 */
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2014-11-05
-- Description:	Select Activities with in a queue
--				during a particular datarange
--				Note: given that csta_queue_history
--				does not contain an activity for each
--				activity for each day, only on days where
--				the queue assignment for that activity changed
--				need some logic to look back to see the most recent
--				queue assignment prior to a specific date and use that
--				as the current queue for that date
-- =============================================
CREATE FUNCTION [dbo].[psoActivitiesInQueueForDates]
(
	-- Add the parameters for the function here
	@queueID nchar(10),
	@fromDate datetime,
	@toDate datetime
)
RETURNS
@temp TABLE
(
	-- Add the column definitions for the TABLE variable here
	activity_id nchar(10),
	queue_id nchar(10),
	queue_from_date datetime,
	queue_to_date datetime
)
AS
BEGIN

	IF @fromDate IS NULL OR @fromDate = '1/1/1900'
		SET @fromDate = '1/1/1753'

	IF @toDate IS NULL OR @toDate = '1/1/1900'
		SET @toDate = '12/31/9999 23:59:59'

	IF @queueID = ''
		SET @queueID = NULL

	IF @queueID IS NOT NULL
		INSERT INTO @temp
		SELECT DISTINCT a.activity_id, qh.queue_id, @fromDate, @toDate
		FROM oncd_activity a WITH (NOLOCK)
		LEFT OUTER JOIN csta_queue_history qh WITH (NOLOCK)
			ON qh.queue_history_id = (SELECT TOP 1 queue_history_id FROM csta_queue_history qha WITH (NOLOCK) WHERE qha.activity_id = a.activity_id AND qha.queue_date <= @fromDate ORDER BY qha.queue_date DESC)
		WHERE EXISTS (SELECT 1 FROM csta_queue_history qhb WITH (NOLOCK) WHERE qhb.activity_id = a.activity_id AND qhb.queue_id = @queueID)
		AND (qh.queue_id = @queueID )
		UNION
		SELECT a.activity_id, qh.queue_id, @fromDate, @toDate
		FROM oncd_activity a WITH (NOLOCK)
		LEFT OUTER JOIN csta_queue_history qh WITH (NOLOCK)
		ON qh.queue_history_id = (SELECT TOP 1 queue_history_id FROM csta_queue_history qha WITH (NOLOCK) WHERE qha.activity_id = a.activity_id AND qha.queue_date <= @toDate
			ORDER BY qha.queue_date DESC)
		WHERE EXISTS (SELECT 1 FROM csta_queue_history qhb WITH (NOLOCK) WHERE qhb.activity_id = a.activity_id AND qhb.queue_id = @queueID)
		AND (qh.queue_id = @queueID )
		UNION
		SELECT qh.activity_id, qh.queue_id, @fromDate, @toDate
		FROM csta_queue_history qh WITH (NOLOCK)
		WHERE qh.queue_id = @queueID
			AND qh.queue_date >= @fromDate AND qh.queue_date <= @toDate
	ELSE
		INSERT INTO @temp
		SELECT DISTINCT a.activity_id, qh.queue_id, @fromDate, @toDate
		FROM oncd_activity a WITH (NOLOCK)
		LEFT OUTER JOIN csta_queue_history qh WITH (NOLOCK)
			ON qh.queue_history_id = (SELECT TOP 1 queue_history_id FROM csta_queue_history qha WITH (NOLOCK) WHERE qha.activity_id = a.activity_id AND qha.queue_date <= @fromDate ORDER BY qha.queue_date DESC)
		WHERE EXISTS (SELECT 1 FROM csta_queue_history qhb WITH (NOLOCK) WHERE qhb.activity_id = a.activity_id AND qhb.queue_date <= @fromDate)
		UNION
		SELECT a.activity_id, qh.queue_id, @fromDate, @toDate
		FROM oncd_activity a WITH (NOLOCK)
		LEFT OUTER JOIN csta_queue_history qh WITH (NOLOCK)
		ON qh.queue_history_id = (SELECT TOP 1 queue_history_id FROM csta_queue_history qha WITH (NOLOCK) WHERE qha.activity_id = a.activity_id AND qha.queue_date <= @toDate ORDER BY qha.queue_date DESC)
		WHERE EXISTS (SELECT 1 FROM csta_queue_history qhb WITH (NOLOCK) WHERE qhb.activity_id = a.activity_id AND qhb.queue_date <= @toDate)
		UNION
		SELECT qh.activity_id, qh.queue_id, @fromDate, @toDate
		FROM csta_queue_history qh WITH (NOLOCK)
		WHERE qh.queue_date >= @fromDate AND qh.queue_date <= @toDate


	RETURN
END
GO
