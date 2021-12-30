/* CreateDate: 01/03/2014 07:07:53.740 , ModifyDate: 01/03/2014 07:07:53.740 */
GO
CREATE PROCEDURE [sysutility_ucp_staging].[sp_get_consistent_batches]
AS
BEGIN
    SET NOCOUNT ON;

    -- Note: As we are not currently caching the aged-out data, this SP
    -- clears the existing records and inserts the new data. However, as a fix for
    -- VSTS #319498 (display aged-out data) this behavior needs to be changed
    -- to UPSERT for any existing or new data and delete the entries whose
    -- data is purged (> 7 days).

    -- Get the manifest information for the latest uploaded batches.  The "manifest" info includes
    -- the expected number of rows that should have been uploaded into each live table for the
    -- batch.  This query captures the manifest for most recent unprocessed batch (T) and the
    -- immediately prior (T-1) unprocessed batch from each managed instance since the last execution
    -- of the sp_copy_live_table_data_into_cache_tables stored proc.
    --
    -- This rowset is staged in a temp table b/c the query optimizer cannot accurately predict the
    -- number of rows that qualify for "WHERE bm.snapshot_id > sp.latest_consistent_snapshot_id".
    --
    -- Note: This view may fetch the last 2 batch manifest rows for a given MI. The reason for
    -- considering two batches is to use the latest one that is consistent. If the latest one is
    -- missing (delayed upload) or inconsistent (failed or still-in-progress upload), we will use
    -- the second-to-last batch, assuming that it is consistent. This makes the caching job
    -- resilient to occasional delays in the MI upload job.
    SELECT server_instance_name
        , batch_time
        , CONVERT(INT, dac_packages_row_count) AS dac_packages_row_count
        , CONVERT(INT, cpu_memory_configurations_row_count) AS cpu_memory_configurations_row_count
        , CONVERT(INT, volumes_row_count) AS volumes_row_count
        , CONVERT(INT, smo_properties_row_count) AS smo_properties_row_count
    INTO #batch_manifests_latest
    FROM  (SELECT bm.server_instance_name, bm.batch_time, bm.parameter_name, bm.parameter_value
           FROM snapshots.sysutility_ucp_batch_manifests_internal bm
              , msdb.dbo.sysutility_ucp_snapshot_partitions_internal AS sp
           WHERE bm.snapshot_id > sp.latest_consistent_snapshot_id
             -- The [time_id] = 1 partition gives us the max snapshot_id the last time that the
             -- sp_copy_live_table_data_into_cache_tables proc was executed (previous high water
             -- mark).  We will consider for processing any snapshots that have been uploaded
             -- since then.
             AND sp.time_id = 1) AS lbm
    PIVOT (MAX(parameter_value) FOR parameter_name IN (dac_packages_row_count
                                                     , cpu_memory_configurations_row_count
                                                     , volumes_row_count
                                                     , smo_properties_row_count)) pvt;

    -- Truncate the table
    TRUNCATE TABLE [sysutility_ucp_staging].[consistent_batch_manifests_internal];

    -- Get the set of latest batches that are consistent with respect to the data uploaded to
    -- each live table.  A check is made to verify that the number of rows uploaded matches the
    -- expected row count in that batch's manifest.
    --
    -- These rowsets are staged in temp tables b/c the query optimizer cannot accurately predict
    -- the number of rows that qualify for "HAVING COUNT(*) = bm.cpu_memory_configurations_row_count".

    SELECT bm.server_instance_name, bm.batch_time
    INTO #dac_statistics_consistent_batches
    FROM #batch_manifests_latest bm
    -- Note: No records in DAC table doesn't mean issue with upload -- a MI with no DACs is
    -- perfectly valid; use an outer join so that we tolerate the no-DACs case.
    LEFT JOIN [snapshots].[sysutility_ucp_dac_collected_execution_statistics_internal] ds
        ON bm.server_instance_name = ds.server_instance_name AND bm.batch_time = ds.batch_time
    GROUP BY bm.server_instance_name, bm.batch_time, bm.dac_packages_row_count, ds.batch_time
    HAVING SUM(CASE WHEN ds.batch_time IS NULL THEN 0 ELSE 1 END) = bm.dac_packages_row_count

    SELECT bm.server_instance_name, bm.batch_time
    INTO #cpu_memory_configurations_consistent_batches
    FROM #batch_manifests_latest bm
    INNER JOIN [snapshots].[sysutility_ucp_cpu_memory_configurations_internal] cm
        ON bm.server_instance_name = cm.server_instance_name AND bm.batch_time = cm.batch_time
    GROUP BY bm.server_instance_name, bm.batch_time, bm.cpu_memory_configurations_row_count
    HAVING COUNT(*) = bm.cpu_memory_configurations_row_count

    SELECT bm.server_instance_name, bm.batch_time
    INTO #volumes_consistent_batches
    FROM #batch_manifests_latest bm
    INNER JOIN [snapshots].[sysutility_ucp_volumes_internal] vo
        ON bm.server_instance_name = vo.server_instance_name AND bm.batch_time = vo.batch_time
    GROUP BY bm.server_instance_name, bm.batch_time, bm.volumes_row_count
    HAVING COUNT(*) = bm.volumes_row_count

    SELECT bm.server_instance_name, bm.batch_time
    INTO #smo_properties_consistent_batches
    FROM #batch_manifests_latest bm
    INNER JOIN [snapshots].[sysutility_ucp_smo_properties_internal] sp
        ON bm.server_instance_name = sp.server_instance_name AND bm.batch_time = sp.batch_time
    GROUP BY bm.server_instance_name, bm.batch_time, bm.smo_properties_row_count
    HAVING COUNT(*) = bm.smo_properties_row_count


    -- Insert the new consistent batch information.  A consistent batch is a batch where all of
    -- the live tables have the expected number of rows.
    INSERT INTO [sysutility_ucp_staging].[consistent_batch_manifests_internal]
    SELECT bm.server_instance_name
        , bm.batch_time
    FROM
    (
        -- Fetch the latest (order by DESC) consistent batches uploaded by the MI's
        SELECT ROW_NUMBER() OVER (PARTITION BY bm.server_instance_name ORDER BY bm.batch_time DESC) AS [rank]
            , bm.server_instance_name
            , bm.batch_time
        FROM #batch_manifests_latest AS bm
        INNER JOIN #dac_statistics_consistent_batches AS ds
            ON bm.server_instance_name = ds.server_instance_name AND bm.batch_time = ds.batch_time
        INNER JOIN #cpu_memory_configurations_consistent_batches AS cm
            ON bm.server_instance_name = cm.server_instance_name AND bm.batch_time = cm.batch_time
        INNER JOIN #volumes_consistent_batches AS vo
            ON bm.server_instance_name = vo.server_instance_name AND bm.batch_time = vo.batch_time
        INNER JOIN #smo_properties_consistent_batches AS sp
            ON bm.server_instance_name = sp.server_instance_name AND bm.batch_time = sp.batch_time
    ) bm
    WHERE bm.[rank] = 1;

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'PROCEDURE',@level1name=N'sp_get_consistent_batches'
GO
