/* CreateDate: 01/03/2014 07:07:51.733 , ModifyDate: 01/03/2014 07:07:51.733 */
GO
CREATE PROCEDURE [snapshots].[rpt_disk_usage_per_process]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10
        wb.process_name,
        wb.minimum_value AS wb_minimum_value,
        wb.maximum_value AS wb_maximum_value,
        wb.average_value AS wb_average_value,
        rb.minimum_value AS rb_minimum_value,
        rb.maximum_value AS rb_maximum_value,
        rb.average_value AS rb_average_value
    FROM
    (  SELECT
            ISNULL(pc.performance_instance_name, N'') AS process_name,
            MIN(pc.formatted_value / (1024))        as minimum_value,
            MAX(pc.formatted_value / (1024))        as maximum_value,
            AVG(pc.formatted_value / (1024))        as average_value
        FROM [snapshots].[performance_counters] as pc
        INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
        WHERE
            s.snapshot_time_id = @snapshot_time_id
            AND s.instance_name = @instance_name
            AND pc.performance_object_name = 'Process'
            AND pc.performance_counter_name = 'IO Read Bytes/sec'
            AND pc.performance_instance_name NOT IN ('_Total', 'Idle')
        GROUP BY pc.performance_instance_name
    ) AS rb
    INNER JOIN
    (  SELECT
            ISNULL(pc.performance_instance_name, N'') AS process_name,
            MIN(pc.formatted_value / (1024))        as minimum_value,
            MAX(pc.formatted_value / (1024))        as maximum_value,
            AVG(pc.formatted_value / (1024))        as average_value
        FROM [snapshots].[performance_counters] as pc
        INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
        WHERE
            s.snapshot_time_id = @snapshot_time_id
            AND s.instance_name = @instance_name
            AND pc.performance_object_name = 'Process'
            AND pc.performance_counter_name = 'IO Write Bytes/sec'
            AND pc.performance_instance_name NOT IN ('_Total', 'Idle')
        GROUP BY pc.performance_instance_name
    ) AS wb ON (wb.process_name = rb.process_name)
    ORDER BY wb_average_value DESC, rb_average_value DESC
END;
GO
