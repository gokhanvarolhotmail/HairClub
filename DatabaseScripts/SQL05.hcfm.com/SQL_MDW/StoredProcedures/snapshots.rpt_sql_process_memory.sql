/* CreateDate: 01/03/2014 07:07:51.927 , ModifyDate: 01/03/2014 07:07:51.927 */
GO
CREATE PROCEDURE [snapshots].[rpt_sql_process_memory]
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
    -- GUID 49268954-... is the Server Activity CS
    INSERT INTO #intervals
    EXEC [snapshots].[rpt_interval_collection_times]
        @ServerName, @EndTime, @WindowSize, 'snapshots.os_process_memory', '49268954-4FD4-4EB6-AA04-CD59D9BB5714', 40, 0

    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        CASE
            WHEN series = 'virtual_address_space_reserved_kb' THEN 'Virtual Memory Reserved'
            WHEN series = 'virtual_address_space_committed_kb' THEN 'Virtual Memory Committed'
            WHEN series = 'physical_memory_in_use_kb' THEN 'Physical Memory In Use'
            WHEN series = 'process_physical_memory_low' THEN 'Physical Memory Low'
            WHEN series = 'process_virtual_memory_low' THEN 'Virtual Memory Low'
            ELSE series
        END AS series,
        [value] / 1024 AS [value] -- convert KB to MB
    FROM
    (
        SELECT
            pm.collection_time,
            pm.virtual_address_space_reserved_kb,
            pm.virtual_address_space_committed_kb,
            pm.physical_memory_in_use_kb,
            CONVERT (bigint, pm.process_physical_memory_low) AS process_physical_memory_low,
            CONVERT (bigint, pm.process_virtual_memory_low) AS process_virtual_memory_low
        FROM [snapshots].[os_process_memory] AS pm
        INNER JOIN #intervals AS i ON (i.last_snapshot_id = pm.snapshot_id AND i.last_collection_time = pm.collection_time)
    ) AS pvt
    UNPIVOT
    (
        [value] for [series] in
            (virtual_address_space_reserved_kb, virtual_address_space_committed_kb,
            physical_memory_in_use_kb)
    ) AS unpvt
END
GO
