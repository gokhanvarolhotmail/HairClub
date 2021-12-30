/* CreateDate: 01/03/2014 07:07:50.023 , ModifyDate: 01/03/2014 07:07:50.023 */
GO
CREATE VIEW [snapshots].[distinct_query_stats]
AS
    SELECT
        dqth.distinct_query_hash,
        SUM(qs.execution_count) AS execution_count,
        SUM(qs.total_worker_time) AS total_worker_time,
        SUM(qs.total_physical_reads) AS total_physical_reads,
        SUM(qs.total_logical_reads) AS total_logical_reads,
        SUM(qs.total_logical_writes) AS total_logical_writes,
        SUM(qs.total_clr_time) AS total_clr_time,
        SUM(qs.total_elapsed_time) AS total_elapsed_time
    FROM
        [snapshots].[query_stats] qs
        JOIN [core].[snapshots_internal] s ON (s.snapshot_id = qs.snapshot_id)
        JOIN [snapshots].[distinct_query_to_handle] dqth ON (s.source_id = dqth.source_id AND qs.sql_handle = dqth.sql_handle)
    GROUP BY
        dqth.distinct_query_hash
GO
