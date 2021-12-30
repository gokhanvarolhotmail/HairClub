/* CreateDate: 01/03/2014 07:07:51.553 , ModifyDate: 01/03/2014 07:07:51.553 */
GO
CREATE PROCEDURE [snapshots].[rpt_cpu_queues_one_snapshot]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CASE pc.performance_counter_name
            WHEN 'Processor Queue Length' THEN N'Processor Queue Length'
            ELSE N'CPU ' + CONVERT (nvarchar(10), ISNULL(pc.performance_instance_name, N''))
        END AS series,
        CONVERT (datetime, SWITCHOFFSET (CAST (pc.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        pc.formatted_value
    FROM snapshots.performance_counters pc
    JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id = @snapshot_time_id
        AND
        (
            (pc.performance_object_name = 'Server Work Queues' AND pc.performance_counter_name = 'Queue Length'
                AND pc.performance_instance_name != '_Total' AND ISNUMERIC (pc.performance_instance_name) = 1)
            OR (pc.performance_object_name = 'System' AND pc.performance_counter_name = 'Processor Queue Length')
        )
    ORDER BY
        pc.collection_time, series
END;
GO
