/* CreateDate: 01/03/2014 07:07:51.557 , ModifyDate: 01/03/2014 07:07:51.557 */
GO
CREATE PROCEDURE [snapshots].[rpt_cpu_usage_per_process]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

    -- Determine the CPU count on the target system by querying the number of "Processor"
    -- counter instances we captured in a perfmon sample that was captured around the same
    -- time.
    DECLARE @cpu_count smallint
    SELECT @cpu_count = COUNT (DISTINCT pc.performance_instance_name)
    FROM snapshots.performance_counters AS pc
    INNER JOIN core.snapshots s ON s.snapshot_id = pc.snapshot_id
    WHERE pc.performance_object_name = 'Processor' AND pc.performance_counter_name = '% Processor Time'
        AND pc.performance_instance_name != '_Total'
        AND s.snapshot_time_id = @snapshot_time_id
        AND s.instance_name = @instance_name
        AND pc.collection_time =
            (SELECT TOP 1 collection_time FROM snapshots.performance_counter_values pcv2 WHERE pcv2.snapshot_id = s.snapshot_id)

    SELECT TOP 10
        cpu.process_name,
        cpu.minimum_value / @cpu_count AS cpu_minimum_value,
        cpu.maximum_value / @cpu_count AS cpu_maximum_value,
        cpu.average_value / @cpu_count AS cpu_average_value,
        tc.average_value AS  tc_average_value
    FROM
    (  SELECT
            ISNULL(pc.performance_instance_name, N'') AS process_name,
            MIN(pc.formatted_value)         AS minimum_value,
            MAX(pc.formatted_value)         AS maximum_value,
            AVG(pc.formatted_value)         AS average_value
        FROM [snapshots].[performance_counters] AS pc
        INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
        WHERE
            s.snapshot_time_id = @snapshot_time_id
            AND s.instance_name = @instance_name
            AND (pc.performance_object_name = 'Process' AND pc.performance_counter_name = '% Processor Time'
                AND pc.performance_instance_name NOT IN ('_Total', 'Idle'))
        GROUP BY pc.performance_instance_name
    ) AS cpu
    INNER JOIN
    (  SELECT
            ISNULL(pc.performance_instance_name, N'') AS process_name,
            MIN(pc.formatted_value)         AS minimum_value,
            MAX(pc.formatted_value)         AS maximum_value,
            AVG(pc.formatted_value)         AS average_value
        FROM [snapshots].[performance_counters] as pc
        INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
        WHERE
            s.snapshot_time_id = @snapshot_time_id
            AND s.instance_name = @instance_name
            AND (pc.performance_object_name = 'Process' AND pc.performance_counter_name = 'Thread Count'
                AND pc.performance_instance_name NOT IN ('_Total', 'Idle'))
        GROUP BY pc.performance_instance_name
    ) AS tc ON (tc.process_name = cpu.process_name)
    ORDER BY cpu_average_value DESC

END;
GO
