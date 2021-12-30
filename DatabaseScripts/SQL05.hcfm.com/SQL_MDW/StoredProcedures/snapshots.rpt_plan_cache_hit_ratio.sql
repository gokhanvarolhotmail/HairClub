/* CreateDate: 01/03/2014 07:07:51.640 , ModifyDate: 01/03/2014 07:07:51.640 */
GO
CREATE PROCEDURE [snapshots].[rpt_plan_cache_hit_ratio]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ISNULL(pc.performance_instance_name, N'') AS series,
        CONVERT (datetime, SWITCHOFFSET (CAST (pc.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        pc.formatted_value
    FROM snapshots.performance_counters pc
    INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id = @snapshot_time_id
        AND pc.performance_object_name LIKE '%SQL%:Plan Cache'
        AND pc.performance_counter_name = 'Cache Hit Ratio'
        AND pc.performance_instance_name != '_Total'
    ORDER BY pc.collection_time, ISNULL(pc.performance_instance_name, N'')
END;
GO
