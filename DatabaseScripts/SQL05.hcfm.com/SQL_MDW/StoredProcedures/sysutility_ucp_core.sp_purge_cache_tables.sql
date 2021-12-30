/* CreateDate: 01/03/2014 07:07:54.497 , ModifyDate: 01/03/2014 07:07:54.497 */
GO
CREATE PROCEDURE sysutility_ucp_core.sp_purge_cache_tables
AS
BEGIN
    DECLARE @rows_affected bigint;
    DECLARE @delete_batch_size varchar(30);

    SET @delete_batch_size = 500;
    SET @rows_affected = -1;

    DECLARE @days_to_retain_minute_data int;
    DECLARE @days_to_retain_hour_data int;
    DECLARE @days_to_retain_day_data int;

    SELECT @days_to_retain_minute_data = CONVERT (int,current_value)
    FROM [msdb].[dbo].[sysutility_ucp_configuration_internal]
    WHERE name = 'MdwRetentionLengthInDaysForMinutesHistory';

    SELECT @days_to_retain_hour_data = CONVERT (int,current_value)
    FROM [msdb].[dbo].[sysutility_ucp_configuration_internal]
    WHERE name = 'MdwRetentionLengthInDaysForHoursHistory';

    SELECT @days_to_retain_day_data = CONVERT (int,current_value)
    FROM [msdb].[dbo].[sysutility_ucp_configuration_internal]
    WHERE name = 'MdwRetentionLengthInDaysForDaysHistory';

    DECLARE @date_threshold_minute_data DATETIMEOFFSET(7) = DATEADD(day, -@days_to_retain_minute_data, SYSDATETIMEOFFSET());
    DECLARE @date_threshold_hour_data DATETIMEOFFSET(7) = DATEADD(day, -@days_to_retain_hour_data, SYSDATETIMEOFFSET());
    DECLARE @date_threshold_day_data DATETIMEOFFSET(7) = DATEADD(day, -@days_to_retain_day_data, SYSDATETIMEOFFSET());

    DECLARE @schema sysname
    DECLARE @name sysname
    DECLARE @query NVARCHAR(MAX)

    DECLARE dimensions_cursor CURSOR FOR
    SELECT object_schema, [object_name]
    FROM sysutility_ucp_misc.utility_objects_internal
    WHERE utility_object_type = 'DIMENSION';

    -- Purge the dimension tables.
    -- The number of rows that can be deleted from these tables can be very large.  If we deleted
    -- all of these rows in a single delete statement, we would hold locks for an arbitrarily-long
    -- time (and potentially escalate to table locks), causing long-duration blocking.  This could
    -- also lead to transaction log growth, since log records after the oldest still-open transaction
    -- can't be truncated.  To avoid these two problems, we delete rows in batches of 500 and loop
    -- until we've deleted all rows that we no longer need.
    OPEN dimensions_cursor;
    FETCH NEXT FROM dimensions_cursor INTO @schema, @name;
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        SET @rows_affected = -1;
        WHILE (@rows_affected != 0)
        BEGIN
            -- We use dynamic SQL here because the table name is variable, but this also has the benefit of
            -- providing the optimizer with the final value for @delete_batch_size and @date_threshold.
            SET @query = 'DELETE TOP (' + @delete_batch_size + ') FROM ' + QUOTENAME(@schema) + '.' + QUOTENAME(@name) +
                         ' WHERE processing_time < @date_threshold';
            EXEC sp_executesql @query, N'@date_threshold datetimeoffset(7)', @date_threshold = @date_threshold_minute_data;
            SET @rows_affected = @@ROWCOUNT;
        END;

        FETCH NEXT FROM dimensions_cursor INTO @schema, @name;
    END;
    CLOSE dimensions_cursor;
    DEALLOCATE dimensions_cursor;

    DECLARE measures_cursor CURSOR FOR
    SELECT object_schema, [object_name]
    FROM sysutility_ucp_misc.utility_objects_internal
    WHERE utility_object_type = 'MEASURE';

    -- Delete "per-minute" (15 minute) data from measure tables
    OPEN measures_cursor;
    FETCH NEXT FROM measures_cursor INTO @schema, @name;
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        SET @rows_affected = -1;
        WHILE (@rows_affected != 0)
        BEGIN
            SET @query = 'DELETE TOP (' + @delete_batch_size + ') FROM ' + QUOTENAME(@schema) + '.' + QUOTENAME(@name) +
                         ' WHERE processing_time < @date_threshold AND aggregation_type = 0';
            EXEC sp_executesql @query, N'@date_threshold datetimeoffset(7)', @date_threshold = @date_threshold_minute_data;
            SET @rows_affected = @@ROWCOUNT;
        END;

        FETCH NEXT FROM measures_cursor INTO @schema, @name;
    END;
    CLOSE measures_cursor;

    -- Delete "per-hour" data from our measure-tables
    OPEN measures_cursor;
    FETCH NEXT FROM measures_cursor INTO @schema, @name;
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        SET @rows_affected = -1;
        WHILE (@rows_affected != 0)
        BEGIN
            SET @query = 'DELETE TOP (' + @delete_batch_size + ') FROM ' + QUOTENAME(@schema) + '.' + QUOTENAME(@name) +
                         ' WHERE processing_time < @date_threshold AND aggregation_type = 1';
            EXEC sp_executesql @query, N'@date_threshold datetimeoffset(7)', @date_threshold = @date_threshold_hour_data;
            SET @rows_affected = @@ROWCOUNT;
        END;

        FETCH NEXT FROM measures_cursor INTO @schema, @name;
    END;
    CLOSE measures_cursor;

    -- Delete "per-day" data from measure tables
    OPEN measures_cursor;
    FETCH NEXT FROM measures_cursor INTO @schema, @name;
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        SET @rows_affected = -1;
        WHILE (@rows_affected != 0)
        BEGIN
            SET @query = 'DELETE TOP (' + @delete_batch_size + ') FROM ' + QUOTENAME(@schema) + '.' + QUOTENAME(@name) +
                         ' WHERE processing_time < @date_threshold AND aggregation_type = 2';
            EXEC sp_executesql @query, N'@date_threshold datetimeoffset(7)', @date_threshold = @date_threshold_day_data;
            SET @rows_affected = @@ROWCOUNT;
        END;

        FETCH NEXT FROM measures_cursor INTO @schema, @name;
    END;
    CLOSE measures_cursor;
    DEALLOCATE measures_cursor;

END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'PROCEDURE',@level1name=N'sp_purge_cache_tables'
GO
