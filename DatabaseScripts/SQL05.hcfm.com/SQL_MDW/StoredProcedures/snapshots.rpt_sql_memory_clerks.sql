/* CreateDate: 01/03/2014 07:07:50.870 , ModifyDate: 01/03/2014 07:07:50.870 */
GO
CREATE PROCEDURE [snapshots].[rpt_sql_memory_clerks]
    @ServerName sysname,
    @EndTime datetime = NULL,
    @WindowSize smallint = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Divide our time window up into 40 evenly-sized time intervals, and find the last collection_time within each of these intervals
    CREATE TABLE #intervals (
        interval_time_id        int,
        interval_start_time     datetimeoffset(7),
        interval_end_time       datetimeoffset(7),
        interval_id             int,
        first_collection_time   datetimeoffset(7),
        last_collection_time    datetimeoffset(7),
        first_snapshot_id       int,
        last_snapshot_id        int,
        source_id               int,
        snapshot_id             int,
        collection_time         datetimeoffset(7),
        collection_time_id      int
    )
    -- GUID 49268954-... is the Server Activity CS
    INSERT INTO #intervals
    EXEC [snapshots].[rpt_interval_collection_times]
        @ServerName, @EndTime, @WindowSize, 'snapshots.os_memory_clerks', '49268954-4FD4-4EB6-AA04-CD59D9BB5714', 40, 0

    -- Get memory clerk stats for these collection times
    SELECT
        coll.interval_time_id,
        -- Convert datetimeoffsets to UTC datetimes
        CONVERT (datetime, SWITCHOFFSET (coll.interval_start_time, '+00:00')) AS interval_start_time,
        CONVERT (datetime, SWITCHOFFSET (coll.interval_end_time,  '+00:00')) AS interval_end_time,
        coll.interval_id,
        CONVERT (datetime, SWITCHOFFSET (coll.first_collection_time, '+00:00')) AS first_collection_time,
        CONVERT (datetime, SWITCHOFFSET (coll.last_collection_time, '+00:00')) AS last_collection_time,
        coll.first_snapshot_id, coll.last_snapshot_id,
        mc.[type], mc.memory_node_id, mc.single_pages_kb, mc.multi_pages_kb, mc.virtual_memory_reserved_kb,
        mc.virtual_memory_committed_kb, mc.awe_allocated_kb, mc.shared_memory_reserved_kb, mc.shared_memory_committed_kb,
        CONVERT (datetime, SWITCHOFFSET (mc.collection_time, '+00:00')) AS collection_time,
        CAST (mc.single_pages_kb AS bigint)
            + mc.multi_pages_kb
            + (CASE WHEN type <> 'MEMORYCLERK_SQLBUFFERPOOL' THEN mc.virtual_memory_committed_kb ELSE 0 END)
            + mc.shared_memory_committed_kb AS total_kb
    INTO #memory_clerks
    FROM snapshots.os_memory_clerks AS mc
    INNER JOIN #intervals AS coll ON coll.last_snapshot_id = mc.snapshot_id AND coll.last_collection_time = mc.collection_time

    -- Return memory stats to the caller
    SELECT
        mc.*,
        mc.single_pages_kb + mc.multi_pages_kb as allocated_kb,
        ta.total_kb_all_clerks,
        mc.total_kb / CONVERT(decimal, ta.total_kb_all_clerks) AS percent_total_kb,
        -- There are many memory clerks. We'll chart any that make up 5% of SQL memory or more; less significant clerks will be lumped into an "Other" bucket
        CASE
            WHEN mc.total_kb / CONVERT(decimal, ta.total_kb_all_clerks) > 0.05 THEN mc.[type]
            ELSE N'Other'
        END AS graph_type
    FROM #memory_clerks AS mc
    -- Use a self-join to calculate the total memory allocated for each time interval
    JOIN
    (
        SELECT
            mc_ta.collection_time,
            SUM (mc_ta.total_kb) AS total_kb_all_clerks
        FROM #memory_clerks AS mc_ta
        GROUP BY mc_ta.collection_time
    ) AS ta ON (mc.collection_time = ta.collection_time)
    ORDER BY collection_time
END;
GO
