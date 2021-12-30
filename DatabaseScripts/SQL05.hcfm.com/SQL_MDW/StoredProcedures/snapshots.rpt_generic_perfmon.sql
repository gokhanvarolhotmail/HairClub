/* CreateDate: 01/03/2014 07:07:50.310 , ModifyDate: 01/03/2014 07:07:50.310 */
GO
CREATE PROCEDURE [snapshots].[rpt_generic_perfmon]
    @ServerName sysname,
    @EndTime datetime,
    @WindowSize int,
    @DataGroupID nvarchar(128),
    @CollectionSetUid nvarchar(64),
    @interval_count int = 40
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time_internal datetimeoffset(7);
    DECLARE @end_time_internal datetimeoffset(7);

    -- Start time should be passed in as a UTC datetime
    IF (@EndTime IS NOT NULL)
    BEGIN
        -- Assumed time zone offset for this conversion is +00:00 (datetime must be passed in as UTC)
        SET @end_time_internal = CAST (@EndTime AS datetimeoffset(7));
    END
    ELSE BEGIN
        SELECT @end_time_internal = MAX(snapshot_time)
        FROM core.snapshots
        WHERE instance_name = @ServerName AND collection_set_uid = @CollectionSetUid
    END
    SET @start_time_internal = DATEADD (minute, -1 * @WindowSize, @end_time_internal);

    -- Divide the time window up into N equal intervals.  Each interval will correspond to one
    -- point on a line chart.  Calc the duration of one interval, in seconds.
    DECLARE @group_interval_sec int
    IF @interval_count < 1 SET @interval_count = 1
    SET @group_interval_sec = ROUND (DATEDIFF (second, @start_time_internal, @end_time_internal) / @interval_count, 0)
    IF @group_interval_sec < 10 SET @group_interval_sec = 10

    -- For counter groups that include the "Process(abc)\% Processor Time" counter (e.g. 'ServerActivity' and 'SystemCpuUsagePivot'),
    -- we must determine the logical CPU count on the target system by querying the number of "Processor" counter instances we
    -- captured in a perfmon sample that was captured around the same time.
    DECLARE @cpu_count smallint
    SET @cpu_count = 1
    IF EXISTS (
        SELECT * FROM [core].[performance_counter_report_group_items]
        WHERE counter_group_id = @DataGroupID AND [divide_by_cpu_count] = 1
    )
    BEGIN
        SELECT @cpu_count = COUNT (DISTINCT pc.performance_instance_name)
        FROM snapshots.performance_counters AS pc
        INNER JOIN core.snapshots s ON s.snapshot_id = pc.snapshot_id
        WHERE pc.performance_object_name = 'Processor' AND pc.performance_counter_name = '% Processor Time'
            AND pc.performance_instance_name != '_Total' AND ISNUMERIC (pc.performance_instance_name) = 1
            AND s.instance_name = @ServerName AND s.collection_set_uid = @CollectionSetUid
            AND s.snapshot_id =
                (SELECT TOP 1 s2.snapshot_id FROM core.snapshots AS s2
                INNER JOIN snapshots.performance_counters AS pc2 ON s2.snapshot_id = pc2.snapshot_id
                WHERE s2.snapshot_time > @start_time_internal
                    AND s2.instance_name = @ServerName AND s2.collection_set_uid = @CollectionSetUid
                    AND pc2.performance_object_name = 'Processor' AND pc2.performance_counter_name = '% Processor Time')
            AND pc.collection_time =
                (SELECT TOP 1 collection_time FROM snapshots.performance_counter_values pcv2 WHERE pcv2.snapshot_id = s.snapshot_id)
        -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
        OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)

        IF ISNULL (@cpu_count, 0) = 0
        BEGIN
            -- This message will never be shown on a report. It is included here only as a troubleshooting aid.
            RAISERROR ('Unable to determine CPU count. Assuming 1 CPU for process CPU calculations', 9, 1)
            SET @cpu_count = 1
        END
    END

    -- Get the matching performance counter instances for this data group
    SELECT
        pci.*,
        cl.counter_group_item_id, cl.counter_group_id, cl.counter_subgroup_id, cl.series_name,
        cl.multiply_by, cl.divide_by_cpu_count
    INTO #pci
    FROM snapshots.performance_counter_instances AS pci
    INNER JOIN [core].[performance_counter_report_group_items] AS cl
        ON cl.counter_group_id = @DataGroupID
        AND pci.counter_name = cl.counter_name
        AND ISNULL(pci.instance_name, N'') LIKE cl.instance_name
        AND
        (
            (cl.object_name_wildcards = 0 AND pci.[object_name] = cl.[object_name])
            OR (cl.object_name_wildcards = 1 AND pci.[object_name] LIKE cl.[object_name])
        )
        AND (cl.not_instance_name IS NULL OR pci.instance_name NOT LIKE cl.not_instance_name);

    -- Get the perfmon counter values for these counters in each time interval.
    -- NOTE: If you change the schema of this resultset, you must also update the CREATE TABLE in [rpt_generic_perfmon_pivot].
    SELECT
        #pci.counter_subgroup_id,
        REPLACE (#pci.series_name, '[COUNTER_INSTANCE]', ISNULL(#pci.instance_name, N'')) AS series_name,
        -- Using our time window end time (@end_time_internal) as a reference point, divide
        -- the time window into [@interval_count] intervals of [@group_interval_sec] duration
        -- per interval.
        DATEDIFF (second, @end_time_internal, SWITCHOFFSET (CONVERT (datetimeoffset(7), pc.collection_time), '+00:00')) / @group_interval_sec AS interval_id,
        -- Find the end time for the current time interval, and return as a UTC datetime
        -- Do this by converting [collection_time] into a second count, dividing and multiplying
        -- the count by [@group_interval_sec] to discard any fraction of an interval, then
        -- converting the second count back into a datetime.  That datetime is the end point for
        -- the time interval that this [collection_time] value falls within.
        CONVERT (datetime,
            DATEADD (
                second,
                (DATEDIFF (second, @end_time_internal, SWITCHOFFSET (CONVERT (datetimeoffset(7), pc.collection_time), '+00:00')) / @group_interval_sec) * @group_interval_sec,
                @end_time_internal
            )
        ) AS interval_end_time,
        #pci.counter_name,
        AVG( pc.formatted_value * #pci.multiply_by / CASE WHEN #pci.divide_by_cpu_count = 1 THEN @cpu_count ELSE 1 END ) AS avg_formatted_value,
        MAX( pc.formatted_value * #pci.multiply_by / CASE WHEN #pci.divide_by_cpu_count = 1 THEN @cpu_count ELSE 1 END ) AS max_formatted_value,
        MIN( pc.formatted_value * #pci.multiply_by / CASE WHEN #pci.divide_by_cpu_count = 1 THEN @cpu_count ELSE 1 END ) AS min_formatted_value,
        -- This column can be used to simulate a "_Total" instance for multi-instance counters that lack _Total -- use a "%" for #counterlist.instance_name
        -- Expression "1.0 * pc.formatted_value * cl.multiply_by / CASE WHEN cl.divide_by_cpu_count = 1 THEN @cpu_count ELSE 1 END" is the counter value.
        -- Expression "AVG(<counter_value>) * COUNT (DISTINCT pc.performance_instance_name)" returns the simulated "_Total" instance.
        -- Only valid for multi-instance counters that don't already have a "_Total").
        CONVERT (bigint, AVG( 1.0 * pc.formatted_value * #pci.multiply_by / CASE WHEN #pci.divide_by_cpu_count = 1 THEN @cpu_count ELSE 1 END))
            * COUNT (DISTINCT #pci.instance_name) AS multi_instance_avg_formatted_value
    FROM snapshots.performance_counter_values AS pc
    INNER JOIN #pci ON #pci.performance_counter_id = pc.performance_counter_instance_id
    INNER JOIN core.snapshots s ON s.snapshot_id = pc.snapshot_id
    WHERE s.instance_name = @ServerName AND s.collection_set_uid = @CollectionSetUid
        AND pc.collection_time BETWEEN @start_time_internal AND @end_time_internal
    GROUP BY
        DATEDIFF (second, @end_time_internal, SWITCHOFFSET (CONVERT (datetimeoffset(7), pc.collection_time), '+00:00')) / @group_interval_sec, #pci.counter_subgroup_id,
        #pci.counter_name,
        REPLACE (#pci.series_name, '[COUNTER_INSTANCE]', ISNULL(#pci.instance_name, N''))
    ORDER BY #pci.counter_subgroup_id, interval_end_time, 2, #pci.counter_name
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END
GO
