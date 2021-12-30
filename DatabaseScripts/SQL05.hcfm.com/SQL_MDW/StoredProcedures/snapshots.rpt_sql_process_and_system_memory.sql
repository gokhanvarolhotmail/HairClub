/* CreateDate: 01/03/2014 07:07:50.890 , ModifyDate: 01/03/2014 07:07:50.890 */
GO
CREATE PROCEDURE [snapshots].[rpt_sql_process_and_system_memory]
    @ServerName sysname,
    @EndTime datetime = NULL,
    @WindowSize int
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
    -- GUID 49268954-... is Server Activity
    INSERT INTO #intervals
    EXEC [snapshots].[rpt_interval_collection_times]
        @ServerName, @EndTime, @WindowSize, 'snapshots.sql_process_and_system_memory', '49268954-4FD4-4EB6-AA04-CD59D9BB5714', 40, 0

    -- Get the earliest and latest snapshot_id values that contain data for the selected time interval.
    -- This will allow a more efficient query plan.
    DECLARE @start_snapshot_id int;
    DECLARE @end_snapshot_id int;
    SELECT @start_snapshot_id = MIN (first_snapshot_id)
    FROM #intervals
    SELECT @end_snapshot_id = MAX (last_snapshot_id)
    FROM #intervals

    -- Get sys.dm_os_process_memory for these intervals
    SELECT
        coll.interval_time_id, coll.interval_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (coll.last_collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (coll.interval_start_time AS datetimeoffset(7)), '+00:00')) AS interval_start_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (coll.interval_end_time AS datetimeoffset(7)), '+00:00')) AS interval_end_time,
        coll.last_snapshot_id,
        AVG (sql_physical_memory_in_use_kb)             AS avg_sql_physical_memory_in_use_kb,
        MAX (sql_physical_memory_in_use_kb)             AS max_sql_physical_memory_in_use_kb,
        MIN (sql_physical_memory_in_use_kb)             AS min_sql_physical_memory_in_use_kb,
        AVG (sql_total_virtual_address_space_kb)        AS avg_sql_total_virtual_address_space_kb,
        AVG (sql_virtual_address_space_reserved_kb)     AS avg_sql_virtual_address_space_reserved_kb,
        AVG (sql_virtual_address_space_committed_kb)    AS avg_sql_virtual_address_space_committed_kb,
        AVG (sql_virtual_address_space_available_kb)    AS avg_sql_virtual_address_space_available_kb,
        MAX (sql_virtual_address_space_available_kb)    AS max_sql_virtual_address_space_available_kb,
        MIN (sql_virtual_address_space_available_kb)    AS min_sql_virtual_address_space_available_kb,
        AVG (sql_memory_utilization_percentage)         AS avg_sql_memory_utilization_percentage,
        MIN (sql_memory_utilization_percentage)         AS min_sql_memory_utilization_percentage,
        AVG (sql_available_commit_limit_kb)             AS avg_sql_available_commit_limit_kb,
        MIN (sql_available_commit_limit_kb)             AS min_sql_available_commit_limit_kb,
        AVG (sql_large_page_allocations_kb)             AS avg_sql_large_page_allocations_kb,
        AVG (sql_locked_page_allocations_kb)            AS avg_sql_locked_page_allocations_kb,
        SUM (CAST (sql_process_physical_memory_low AS int)) AS sql_process_physical_memory_low_count,
        SUM (CAST (sql_process_virtual_memory_low AS int))  AS sql_process_virtual_memory_low_count,
        MAX (sql_page_fault_count) - MIN (sql_page_fault_count) AS interval_sql_page_fault_count,
        AVG (system_total_physical_memory_kb)           AS system_total_physical_memory_kb,
        AVG (system_available_physical_memory_kb)       AS avg_system_available_physical_memory_kb,
        MAX (system_available_physical_memory_kb)       AS max_system_available_physical_memory_kb,
        MIN (system_available_physical_memory_kb)       AS min_system_available_physical_memory_kb,
        AVG (system_total_page_file_kb)                 AS avg_system_total_page_file_kb,
        AVG (system_available_page_file_kb)             AS avg_system_available_page_file_kb,
        MIN (system_available_page_file_kb)             AS min_system_available_page_file_kb,
        AVG (system_cache_kb)                           AS avg_system_cache_kb,
        AVG (system_kernel_paged_pool_kb)               AS avg_system_kernel_paged_pool_kb,
        AVG (system_kernel_nonpaged_pool_kb)            AS avg_system_kernel_nonpaged_pool_kb,
        SUM (CAST (system_high_memory_signal_state AS int)) AS system_high_memory_signal_state_count,
        SUM (CAST (system_low_memory_signal_state AS int))  AS system_low_memory_signal_state_count,
        AVG (bpool_commit_target)                       AS avg_bpool_commit_target,
        MAX (bpool_commit_target)                       AS max_bpool_commit_target,
        MIN (bpool_commit_target)                       AS min_bpool_commit_target,
        AVG (bpool_committed)                           AS avg_bpool_committed,
        MAX (bpool_committed)                           AS max_bpool_committed,
        MIN (bpool_committed)                           AS min_bpool_committed,
        AVG (bpool_visible)                             AS avg_bpool_visible,
        MAX (bpool_visible)                             AS max_bpool_visible,
        MIN (bpool_visible)                             AS min_bpool_visible
    FROM snapshots.sql_process_and_system_memory AS pm
    INNER JOIN #intervals AS coll ON coll.last_snapshot_id = pm.snapshot_id AND coll.last_collection_time = pm.collection_time
    GROUP BY
        coll.interval_start_time, coll.interval_end_time, coll.interval_time_id, coll.last_collection_time, coll.interval_id, coll.last_snapshot_id
    ORDER BY coll.last_collection_time ASC;
END
GO
