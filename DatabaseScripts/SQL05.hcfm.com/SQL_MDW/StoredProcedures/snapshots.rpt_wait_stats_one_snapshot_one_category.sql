/* CreateDate: 01/03/2014 07:07:51.913 , ModifyDate: 01/03/2014 07:07:51.913 */
GO
CREATE PROCEDURE [snapshots].[rpt_wait_stats_one_snapshot_one_category]
    @instance_name sysname,
    @snapshot_time_id int,
    @category_name nvarchar(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Use CTE to select first all raw data that we neeed
    -- For each snapshot append a [rank] column, which later will be used to do the self-join
    WITH wait_times AS
    (
    -- First part gets resource wait times for each wait_type,
    -- calculated as wait_time_ms - signal_wait_time_ms
    SELECT
        DENSE_RANK() OVER (ORDER BY ws1.collection_time) AS [rank],
        s.snapshot_time_id,
        ws1.collection_time,
        ct.category_name,
        ev.wait_type,
        ws1.waiting_tasks_count,
        ws1.wait_time_ms - ws1.signal_wait_time_ms as resource_wait_time_ms
    FROM core.snapshots s
    JOIN snapshots.os_wait_stats ws1 on (ws1.snapshot_id = s.snapshot_id)
    JOIN core.wait_types ev on (ev.wait_type = ws1.wait_type)
    JOIN core.wait_categories ct on (ct.category_id = ev.category_id)
    WHERE ct.category_name = @category_name
      AND s.instance_name = @instance_name
      AND (s.snapshot_time_id = @snapshot_time_id OR s.snapshot_time_id = @snapshot_time_id - 1)
    )
    -- Do a self-join to calculate deltas between snapshots
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (t1.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        t1.wait_type,
        (t1.waiting_tasks_count - t2.waiting_tasks_count) AS waiting_tasks_count_delta,
        (t1.resource_wait_time_ms - ISNULL(t2.resource_wait_time_ms,0))/CAST(DATEDIFF(second, t2.collection_time, t1.collection_time) AS decimal) AS resource_wait_time_delta
    FROM wait_times t1
    LEFT OUTER JOIN wait_times t2 on (t2.rank = t1.rank-1 and t2.wait_type = t1.wait_type)
    WHERE t1.snapshot_time_id = @snapshot_time_id
    ORDER BY collection_time, wait_type
END;
GO
