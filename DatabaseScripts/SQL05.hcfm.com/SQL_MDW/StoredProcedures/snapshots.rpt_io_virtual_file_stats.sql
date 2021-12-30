/* CreateDate: 01/03/2014 07:07:50.967 , ModifyDate: 01/03/2014 07:07:50.967 */
GO
CREATE PROCEDURE [snapshots].[rpt_io_virtual_file_stats]
    @ServerName sysname,
    @EndTime datetime = NULL,
    @WindowSize int,
    @LogicalDisk nvarchar(255) = NULL,
    @Database nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Clean string params (on drillthrough, RS may pass in empty string instead of NULL)
    IF @LogicalDisk = '' SET @LogicalDisk = NULL
    IF @Database = '' SET @Database = NULL

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
        @ServerName, @EndTime, @WindowSize, 'snapshots.io_virtual_file_stats', '49268954-4FD4-4EB6-AA04-CD59D9BB5714', 40, 0

    -- Get the earliest and latest snapshot_id values that contain data for the selected time interval.
    -- This will allow a more efficient query plan.
    DECLARE @start_snapshot_id int;
    DECLARE @end_snapshot_id int;
    SELECT @start_snapshot_id = MIN (first_snapshot_id)
    FROM #intervals
    SELECT @end_snapshot_id = MAX (last_snapshot_id)
    FROM #intervals

    -- Get the file stats for these collection times
    SELECT
        coll.interval_id, coll.interval_time_id, coll.interval_start_time, coll.interval_end_time,
        coll.first_collection_time, coll.last_collection_time, coll.first_snapshot_id, coll.last_snapshot_id,
        fs.*
    INTO #file_stats
    FROM snapshots.io_virtual_file_stats AS fs
    INNER JOIN #intervals AS coll ON coll.last_snapshot_id = fs.snapshot_id AND coll.last_collection_time = fs.collection_time
    WHERE
        fs.logical_disk = ISNULL (@LogicalDisk, fs.logical_disk)
        AND fs.database_name = ISNULL (@Database, fs.database_name)

    -- Get file stats deltas for each interval.
    SELECT
        t.*,
        /**** Combined reads + write values ****/
        t.num_of_reads_delta + t.num_of_writes_delta                    AS num_of_transfers_delta,
        t.num_of_reads_cumulative + t.num_of_writes_cumulative          AS num_of_transfers_cumulative,
        t.num_of_mb_read_delta + t.num_of_mb_written_delta              AS num_of_mb_transferred_delta,
        t.num_of_mb_read_cumulative + t.num_of_mb_written_cumulative    AS num_of_mb_transferred_cumulative,
        /**** Calc "Disk sec/Transfer" type values ***/
        t.io_stall_read_ms_delta + t.io_stall_write_ms_delta            AS io_stall_ms_delta,
        t.io_stall_read_ms_cumulative + t.io_stall_write_ms_cumulative  AS io_stall_ms_cumulative,
        CASE
            WHEN t.num_of_reads_delta = 0 THEN 0
            ELSE t.io_stall_read_ms_delta / t.num_of_reads_delta
        END                                                             AS io_stall_ms_per_read_delta,
        CASE
            WHEN t.num_of_reads_cumulative = 0 THEN 0
            ELSE t.io_stall_read_ms_cumulative / t.num_of_reads_cumulative
        END                                                             AS io_stall_ms_per_read_cumulative,
        CASE
            WHEN t.num_of_writes_delta = 0 THEN 0
            ELSE t.io_stall_write_ms_delta / t.num_of_writes_delta
        END                                                             AS io_stall_ms_per_write_delta,
        CASE
            WHEN t.num_of_writes_cumulative = 0 THEN 0
            ELSE t.io_stall_write_ms_cumulative / t.num_of_writes_cumulative
        END                                                             AS io_stall_ms_per_write_cumulative,
        CASE
            WHEN (t.num_of_reads_delta + t.num_of_writes_delta) = 0 THEN 0
            ELSE (t.io_stall_read_ms_delta + t.io_stall_write_ms_delta) / (t.num_of_reads_delta + t.num_of_writes_delta)
        END                                                             AS io_stall_ms_per_transfer_delta,
        CASE
            WHEN (t.num_of_reads_cumulative + t.num_of_writes_cumulative) = 0 THEN 0
            ELSE (t.io_stall_read_ms_cumulative + t.io_stall_write_ms_cumulative) / (t.num_of_reads_cumulative + t.num_of_writes_cumulative)
        END                                                             AS io_stall_ms_per_transfer_cumulative
    FROM
    (
        SELECT
            fs1.interval_id, fs1.interval_time_id, fs1.first_snapshot_id, fs1.last_snapshot_id,
            -- Convert all datetimeoffset values to UTC datetime values before returning to Reporting Services
            CONVERT (datetime, SWITCHOFFSET (CAST (fs1.first_collection_time AS datetimeoffset(7)), '+00:00')) AS first_collection_time,
            CONVERT (datetime, SWITCHOFFSET (CAST (fs2.first_collection_time AS datetimeoffset(7)), '+00:00')) AS last_collection_time,
            CONVERT (datetime, SWITCHOFFSET (CAST (fs1.interval_start_time AS datetimeoffset(7)), '+00:00')) AS interval_start,
            CONVERT (datetime, SWITCHOFFSET (CAST (fs2.interval_start_time AS datetimeoffset(7)), '+00:00')) AS interval_end,
            fs2.database_name, fs2.database_id, fs2.logical_file_name, fs2.[file_id], fs2.type_desc, fs2.logical_disk,
            -- All file stats will be reset to zero by a service cycle, which will cause
            -- (snapshot2_io_time-snapshot1_io_time) calculations to produce an incorrect
            -- negative wait time for the interval.  Detect this and avoid calculating
            -- negative IO wait time deltas.
            /***** READS ****/
            CASE
                WHEN (fs2.num_of_reads - fs1.num_of_reads) < 0 THEN fs2.num_of_reads
                ELSE (fs2.num_of_reads - fs1.num_of_reads)
            END AS num_of_reads_delta,                                              -- num_of_reads_delta
            fs2.num_of_reads AS num_of_reads_cumulative,                            -- num_of_reads_cumulative
            CASE
                WHEN (fs2.num_of_bytes_read - fs1.num_of_bytes_read) < 0 THEN fs2.num_of_bytes_read
                ELSE (fs2.num_of_bytes_read - fs1.num_of_bytes_read)
            END / 1024 / 1024 AS num_of_mb_read_delta,                              -- num_of_mb_read_delta
            fs2.num_of_bytes_read /1024/1024 AS num_of_mb_read_cumulative,          -- num_of_mb_read_cumulative
            CASE
                WHEN (fs2.io_stall_read_ms - fs1.io_stall_read_ms) < 0 THEN fs2.io_stall_read_ms
                ELSE (fs2.io_stall_read_ms - fs1.io_stall_read_ms)
            END AS io_stall_read_ms_delta,                                          -- io_stall_read_ms_delta
            fs2.io_stall_read_ms AS io_stall_read_ms_cumulative,                    -- io_stall_read_ms_cumulative
            /**** WRITES ****/
            CASE
                WHEN (fs2.num_of_writes - fs1.num_of_writes) < 0 THEN fs2.num_of_writes
                ELSE (fs2.num_of_writes - fs1.num_of_writes)
            END AS num_of_writes_delta,                                             -- num_of_writes_delta
            fs2.num_of_writes AS num_of_writes_cumulative,                          -- num_of_writes_cumulative
            CASE
                WHEN (fs2.num_of_bytes_written - fs1.num_of_bytes_written) < 0 THEN fs2.num_of_bytes_written
                ELSE (fs2.num_of_bytes_written - fs1.num_of_bytes_written)
            END / 1024 / 1024 AS num_of_mb_written_delta,                           -- num_of_mb_written_delta
            fs2.num_of_bytes_written /1024/1024 AS num_of_mb_written_cumulative,    -- num_of_mb_written_cumulative
            CASE
                WHEN (fs2.io_stall_write_ms - fs1.io_stall_write_ms) < 0 THEN fs2.io_stall_write_ms
                ELSE (fs2.io_stall_write_ms - fs1.io_stall_write_ms)
            END AS io_stall_write_ms_delta,                                         -- io_stall_write_ms_delta
            fs2.io_stall_write_ms AS io_stall_write_ms_cumulative,                  -- io_stall_write_ms_cumulative
            fs1.size_on_disk_bytes / 1024 / 1024 AS size_on_disk_mb_interval_start, -- size_on_disk_mb_interval_start
            fs2.size_on_disk_bytes / 1024 / 1024 AS size_on_disk_mb_interval_end    -- size_on_disk_mb_interval_end
        FROM #file_stats AS fs1
        -- Self-join - fs1 represents IO stats at the beginning of the sample interval, while fs2
        -- shows file stats at the end of the interval.
        INNER JOIN #file_stats AS fs2 ON fs1.database_id = fs2.database_id AND fs1.[file_id] = fs2.[file_id] AND fs1.interval_id = fs2.interval_id-1

    ) AS t
    ORDER BY t.database_name, t.logical_file_name, t.last_collection_time
END
GO
