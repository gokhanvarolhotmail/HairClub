/* CreateDate: 01/03/2014 07:07:51.550 , ModifyDate: 01/03/2014 07:07:51.550 */
GO
CREATE PROCEDURE [snapshots].[rpt_cpu_counters_one_snapshot]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        N'CPU ' + CONVERT (nvarchar(10), ISNULL(pc.performance_instance_name, N'')) as series,
        CONVERT (datetime, SWITCHOFFSET (CAST (pc.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        pc.formatted_value
    FROM snapshots.performance_counters pc
    JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id = @snapshot_time_id
        AND pc.performance_object_name = 'Processor' AND pc.performance_counter_name = '% Processor Time'
        AND pc.performance_instance_name != '_Total'
    ORDER BY
        pc.collection_time, series
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END;
GO
