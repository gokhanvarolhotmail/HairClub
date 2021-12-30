/* CreateDate: 01/03/2014 07:07:51.657 , ModifyDate: 01/03/2014 07:07:51.657 */
GO
CREATE PROCEDURE [snapshots].[rpt_tempdb]
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
        AND (pc.performance_object_name LIKE '%SQL%:Transactions' OR pc.performance_object_name LIKE '%SQL%:General Statistics')
        AND pc.performance_counter_name IN ('Free Space in tempdb (KB)', 'Active Temp Tables')
    ORDER BY pc.collection_time, pc.performance_counter_name
END;
GO
