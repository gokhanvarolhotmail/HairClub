/* CreateDate: 01/03/2014 07:07:51.833 , ModifyDate: 01/03/2014 07:07:51.833 */
GO
CREATE PROCEDURE [snapshots].[rpt_memory_usage_per_process]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10
        ws.process_name,
        ws.minimum_value AS ws_minimum_value,
        ws.maximum_value AS ws_maximum_value,
        ws.average_value AS ws_average_value,
        vb.minimum_value AS vb_minimum_value,
        vb.maximum_value AS vb_maximum_value,
        vb.average_value AS vb_average_value
    FROM
    (  SELECT
            ISNULL(pc.performance_instance_name, N'') as process_name,
            MIN(pc.formatted_value / (1024*1024))        as minimum_value,
            MAX(pc.formatted_value / (1024*1024))        as maximum_value,
            AVG(pc.formatted_value / (1024*1024))        as average_value
        FROM [snapshots].[performance_counters] as pc
        INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
        WHERE
            s.snapshot_time_id = @snapshot_time_id
            AND s.instance_name = @instance_name
            AND pc.performance_object_name = 'Process' AND pc.performance_counter_name = 'Working Set'
            AND pc.performance_instance_name NOT IN ('_Total', 'Idle')
        GROUP BY pc.performance_instance_name
    ) AS ws
    INNER JOIN
    (  SELECT
            ISNULL(pc.performance_instance_name, N'') as process_name,
            MIN(pc.formatted_value / (1024*1024))        as minimum_value,
            MAX(pc.formatted_value / (1024*1024))        as maximum_value,
            AVG(pc.formatted_value / (1024*1024))        as average_value
        FROM [snapshots].[performance_counters] as pc
        INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
        WHERE
            s.snapshot_time_id = @snapshot_time_id
            AND s.instance_name = @instance_name
            AND pc.performance_object_name = 'Process' AND pc.performance_counter_name = 'Virtual Bytes'
            AND pc.performance_instance_name NOT IN ('_Total', 'Idle')
        GROUP BY pc.performance_instance_name
    ) AS vb ON (vb.process_name = ws.process_name)
    ORDER BY ws_average_value DESC

END;
GO
