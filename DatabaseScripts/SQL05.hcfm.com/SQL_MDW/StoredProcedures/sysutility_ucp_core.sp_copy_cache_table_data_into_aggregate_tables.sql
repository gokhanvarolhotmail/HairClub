/* CreateDate: 01/03/2014 07:07:54.453 , ModifyDate: 01/03/2014 07:07:54.453 */
GO
CREATE PROCEDURE sysutility_ucp_core.sp_copy_cache_table_data_into_aggregate_tables
    @aggregation_type INT,
    @endTime DATETIMEOFFSET(7)
AS
BEGIN
    DECLARE @startTime DATETIMEOFFSET(7)
    DECLARE @lowerAggregationLevel [sysutility_ucp_core].AggregationType

    SELECT @lowerAggregationLevel = 0    -- compute from detail rows

    IF (@aggregation_type = 1)
       SELECT @startTime = DATEADD(hour, -1, @endTime)
    ELSE IF (@aggregation_type = 2)
       SELECT @startTime = DATEADD(day, -1, @endTime)
       -- todo (VSTS #345038)
       -- Ideally, we would be using the hourly aggregation values to compute the
       --   daily aggregation ("SELECT @lowerAggregationLevel = 1")
       --
    ELSE BEGIN
        -- todo. Raise an error instead
        RETURN(1)
    END

    INSERT INTO [sysutility_ucp_core].[cpu_utilization_internal] (
         aggregation_type, object_type, processing_time,
         physical_server_name, server_instance_name, database_name,
         percent_total_cpu_utilization)
       SELECT @aggregation_type, object_type, @endTime,
              physical_server_name, server_instance_name, database_name,
              AVG(percent_total_cpu_utilization)
       FROM [sysutility_ucp_core].[cpu_utilization_internal]
       WHERE (processing_time BETWEEN @startTime and @endTime) AND
             aggregation_type = @lowerAggregationLevel
       GROUP BY object_type, physical_server_name, server_instance_name, database_name

    INSERT INTO [sysutility_ucp_core].[space_utilization_internal] (
         aggregation_type, object_type, processing_time,
         virtual_server_name, volume_device_id, server_instance_name, database_name, [filegroup_name], dbfile_name,
         total_space_bytes, allocated_space_bytes, used_space_bytes, available_space_bytes)
       SELECT @aggregation_type, object_type, @endTime,
              virtual_server_name, volume_device_id, server_instance_name, database_name, [filegroup_name], dbfile_name,
              -- Is AVG the right aggregate to use - should this instead be LAST()
              AVG(total_space_bytes), AVG(allocated_space_bytes), AVG(used_space_bytes), AVG(available_space_bytes)
       FROM [sysutility_ucp_core].[space_utilization_internal]
       WHERE (processing_time BETWEEN @startTime and @endTime) AND
             aggregation_type = @lowerAggregationLevel
       GROUP BY object_type, virtual_server_name, volume_device_id, server_instance_name, database_name, [filegroup_name], dbfile_name

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'PROCEDURE',@level1name=N'sp_copy_cache_table_data_into_aggregate_tables'
GO
