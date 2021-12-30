/* CreateDate: 01/03/2014 07:07:51.470 , ModifyDate: 01/03/2014 07:07:51.470 */
GO
CREATE PROCEDURE [snapshots].[rpt_sql_memory_clerks_one_snapshot]
    @instance_name sysname,
    @snapshot_time_id int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @total_allocated TABLE (
        collection_time datetimeoffset(7),
        total_kb bigint
    );

    INSERT INTO @total_allocated
    SELECT
        mc.collection_time,
        SUM(mc.single_pages_kb +
            mc.multi_pages_kb +
            (CASE WHEN type <> N'MEMORYCLERK_SQLBUFFERPOOL' THEN mc.virtual_memory_committed_kb
            ELSE 0 END) +
            mc.shared_memory_committed_kb)
    FROM snapshots.os_memory_clerks mc
    JOIN core.snapshots s ON (s.snapshot_id = mc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id = @snapshot_time_id
    GROUP BY mc.collection_time

    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (mc.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        mc.type,
        mc.single_pages_kb + mc.multi_pages_kb as allocated_kb,
        mc.virtual_memory_reserved_kb as virtual_reserved_kb,
        mc.virtual_memory_committed_kb as virtual_committed_kb,
        mc.awe_allocated_kb as awe_allocated_kb,
        mc.shared_memory_reserved_kb as shared_reserved_kb,
        mc.shared_memory_committed_kb as shared_committed_kb,
        (mc.single_pages_kb + mc.multi_pages_kb + (CASE WHEN type <> 'MEMORYCLERK_SQLBUFFERPOOL' THEN mc.virtual_memory_committed_kb ELSE 0 END) + mc.shared_memory_committed_kb) as total_kb,
        (mc.single_pages_kb + mc.multi_pages_kb + (CASE WHEN type <> 'MEMORYCLERK_SQLBUFFERPOOL' THEN mc.virtual_memory_committed_kb ELSE 0 END) + mc.shared_memory_committed_kb) / CONVERT(decimal, ta.total_kb) AS percent_total_kb,
        CASE
            WHEN (mc.single_pages_kb + mc.multi_pages_kb + (CASE WHEN type <> 'MEMORYCLERK_SQLBUFFERPOOL' THEN mc.virtual_memory_committed_kb ELSE 0 END) + mc.shared_memory_committed_kb) / CONVERT(decimal, ta.total_kb) > 0.05 THEN mc.type
            ELSE N'Other'
        END AS graph_type
    FROM snapshots.os_memory_clerks mc
    JOIN @total_allocated ta ON (mc.collection_time = ta.collection_time)
    ORDER BY collection_time

END;
GO
