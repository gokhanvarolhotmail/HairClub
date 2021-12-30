/* CreateDate: 01/03/2014 07:07:50.337 , ModifyDate: 01/03/2014 07:07:50.337 */
GO
CREATE PROCEDURE [snapshots].[rpt_generic_perfmon_pivot]
    @ServerName sysname,
    @EndTime datetime,
    @WindowSize int,
    @DataGroupID nvarchar(128),
    @CollectionSetUid varchar(64),
    @interval_count int = 1
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #countervalues (
        counter_subgroup_id nvarchar(512),          -- name of the data subgroup (e.g. chart or table) that requested the counter (used by a chart to filter out its rows from the larger resultset)
        series_name nvarchar(1024),                 -- chart series label
        interval_id int,                            -- not used here
        interval_end_time datetime,                 -- not used here
        performance_counter_name nvarchar(2048),    -- perfmon counter name
        avg_formatted_value bigint,                 -- avg perfmon counter value over the time period
        max_formatted_value bigint,                 -- max perfmon counter value over the time period
        min_formatted_value bigint,                 -- min perfmon counter value over the time period
        multi_instance_avg_formatted_value bigint   -- simulated "_Total" instance value for multi-instance counters that lack _Total
    )

    SET @DataGroupID = @DataGroupID + 'Pivot'
    INSERT INTO #countervalues
    EXEC [snapshots].[rpt_generic_perfmon]
        @ServerName,
        @EndTime,
        @WindowSize,
        @DataGroupID,
        @CollectionSetUid,
        @interval_count

    IF EXISTS (SELECT * FROM #countervalues)
    BEGIN
        -- @counterlist looks like "[Counter 1], [Counter 2]"
        DECLARE @counterlist nvarchar(max)
        -- @columnlist_min_inner looks like "[Counter 1] AS [Counter 1_min], [Counter 2] AS [Counter 2_min]"
        DECLARE @columnlist_min_inner nvarchar(max)
        -- @columnlist_max_inner looks like "[Counter 1] AS [Counter 1_max], [Counter 2] AS [Counter 2_max]"
        DECLARE @columnlist_max_inner nvarchar(max)
        -- @columnlist_min_outer looks like "[Counter 1_min], [Counter 2_min]"
        DECLARE @columnlist_min_outer nvarchar(max)
        -- @columnlist_max_outer looks like "[Counter 1_max], [Counter 2_max]"
        DECLARE @columnlist_max_outer nvarchar(max)
        SET @counterlist = ''
        SET @columnlist_min_inner = ''
        SET @columnlist_min_outer = ''
        SET @columnlist_max_inner = ''
        SET @columnlist_max_outer = ''

        -- Build counter lists
        SELECT
            @counterlist = @counterlist
                -- Escape any embedded ']' chars (we can't use QUOTENAME because it can't handle strings > 128 chars)
                + ', [' + REPLACE (performance_counter_name, ']', ']]') + ']'
            , @columnlist_min_outer = @columnlist_min_outer + ', [' + REPLACE (performance_counter_name, ']', ']]') + '_min]'
            , @columnlist_min_inner = @columnlist_min_inner + ', [' + REPLACE (performance_counter_name, ']', ']]') + ']'
                + ' AS [' + REPLACE (performance_counter_name, ']', ']]') + '_min]'
            , @columnlist_max_outer = @columnlist_max_outer + ', [' + REPLACE (performance_counter_name, ']', ']]') + '_max]'
            , @columnlist_max_inner = @columnlist_max_inner + ', [' + REPLACE (performance_counter_name, ']', ']]') + ']'
                + ' AS [' + REPLACE (performance_counter_name, ']', ']]') + '_max]'
        FROM (SELECT DISTINCT performance_counter_name FROM #countervalues) AS t
        GROUP BY performance_counter_name
        OPTION (MAXDOP 1)
        -- Remove the leading comma
        SET @counterlist = SUBSTRING (@counterlist, 3, LEN (@counterlist)-2)
        SET @columnlist_min_inner = SUBSTRING (@columnlist_min_inner, 3, LEN (@columnlist_min_inner)-2)
        SET @columnlist_min_outer = SUBSTRING (@columnlist_min_outer, 3, LEN (@columnlist_min_outer)-2)
        SET @columnlist_max_inner = SUBSTRING (@columnlist_max_inner, 3, LEN (@columnlist_max_inner)-2)
        SET @columnlist_max_outer = SUBSTRING (@columnlist_max_outer, 3, LEN (@columnlist_max_outer)-2)

        -- We have to use three PIVOTs here because SQL only allows one aggregate function
        -- per PIVOT, and we need AVG, MIN, and MAX.  They are over a very small temp table,
        -- though (by default just one row per counter), so the execution cost isn't
        -- excessive.
        DECLARE @sql nvarchar(max)
        SET @sql = '
            SELECT avg_pivot.*, ' + @columnlist_min_outer + ', ' + @columnlist_max_outer + '
            FROM
            (
                SELECT series_name, interval_end_time, ' + @counterlist + '
                FROM
                (
                    SELECT series_name, interval_end_time, performance_counter_name, avg_formatted_value
                    FROM #countervalues
                ) AS SourceTable
                PIVOT
                (
                    AVG (avg_formatted_value)
                    FOR performance_counter_name IN (' + @counterlist + ')
                ) AS PivotTable
            ) AS avg_pivot

            INNER JOIN
            (
                SELECT series_name, interval_end_time, ' + @columnlist_min_inner + '
                FROM
                (
                    SELECT series_name, interval_end_time, performance_counter_name, min_formatted_value
                    FROM #countervalues
                ) AS SourceTable
                PIVOT
                (
                    MIN (min_formatted_value)
                    FOR performance_counter_name IN (' + @counterlist + ')
                ) AS PivotTable
            ) AS min_pivot ON min_pivot.series_name = avg_pivot.series_name AND min_pivot.interval_end_time = avg_pivot.interval_end_time

            INNER JOIN
            (
                SELECT series_name, interval_end_time, ' + @columnlist_max_inner + '
                FROM
                (
                    SELECT series_name, interval_end_time, performance_counter_name, max_formatted_value
                    FROM #countervalues
                ) AS SourceTable
                PIVOT
                (
                    MAX (max_formatted_value)
                    FOR performance_counter_name IN (' + @counterlist + ')
                ) AS PivotTable
            ) AS max_pivot ON max_pivot.series_name = avg_pivot.series_name AND max_pivot.interval_end_time = avg_pivot.interval_end_time
            '
        EXEC sp_executesql @sql
    END
END;
GO
