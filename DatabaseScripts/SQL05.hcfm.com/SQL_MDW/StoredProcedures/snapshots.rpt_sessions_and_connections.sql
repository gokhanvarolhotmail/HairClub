/* CreateDate: 01/03/2014 07:07:51.577 , ModifyDate: 01/03/2014 07:07:51.577 */
GO
CREATE PROCEDURE [snapshots].[rpt_sessions_and_connections]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;


    SELECT
        pc.performance_counter_name AS series,
        CONVERT (datetime, SWITCHOFFSET (CAST (pc.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        pc.formatted_value
    FROM snapshots.performance_counters pc
    INNER JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id = @snapshot_time_id
        AND (pc.performance_object_name LIKE '%SQL%:General Statistics' OR pc.performance_object_name LIKE '%SQL%:Databases')
        AND pc.performance_counter_name IN ('User Connections', 'Active Transactions')

    UNION ALL

    SELECT
        N'Active sessions' AS series,
        ar.collection_time,
        COUNT(DISTINCT ar.session_id) AS formatted_value
    FROM snapshots.active_sessions_and_requests ar
    INNER JOIN core.snapshots s ON (s.snapshot_id = ar.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id = @snapshot_time_id
    GROUP BY ar.collection_time

    ORDER BY collection_time
END;
GO
