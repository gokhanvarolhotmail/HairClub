/* CreateDate: 01/03/2014 07:07:51.473 , ModifyDate: 01/03/2014 07:07:51.473 */
GO
CREATE PROCEDURE [snapshots].[rpt_sql_process_memory_one_snapshot]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

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
        FROM [snapshots].[os_process_memory] pm
        JOIN core.snapshots s ON (s.snapshot_id = pm.snapshot_id)
        WHERE s.instance_name = @instance_name
            AND s.snapshot_time_id = @snapshot_time_id
    ) AS pvt
    UNPIVOT
    (
        [value] for [series] in
            (virtual_address_space_reserved_kb, virtual_address_space_committed_kb,
            physical_memory_in_use_kb)
    ) AS unpvt
    UNION ALL
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        'Stolen Buffer Pool' AS [series],
        pc.formatted_value * 8 AS [value] -- Convert from pages to KB
    FROM snapshots.performance_counters AS pc
    INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id = @snapshot_time_id
        AND pc.performance_object_name LIKE '%SQL%:Buffer Manager'
        AND pc.performance_counter_name = 'Stolen pages'
    ORDER BY collection_time
END
GO
