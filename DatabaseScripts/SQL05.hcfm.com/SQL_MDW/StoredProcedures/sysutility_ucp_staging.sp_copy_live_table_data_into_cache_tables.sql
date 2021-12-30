/* CreateDate: 01/03/2014 07:07:54.343 , ModifyDate: 01/03/2014 07:07:54.343 */
GO
CREATE PROCEDURE sysutility_ucp_staging.sp_copy_live_table_data_into_cache_tables
AS
BEGIN
      SET NOCOUNT ON;
      -- Snapshot isolation prevents the nightly purge jobs that delete much older data from blocking us.
      SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

      DECLARE @max_snapshot_id INT, @num_snapshots_partitions INT

      SELECT @max_snapshot_id = ISNULL(MAX(snapshot_id),0) FROM [core].[snapshots]
      SELECT @num_snapshots_partitions = COUNT(*) FROM [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal]
      DECLARE @task_start_time DATETIME = GETUTCDATE();
      DECLARE @task_elapsed_ms INT;
      DECLARE @row_count INT;

        -- Initialize the snapshot partitions to default (0)
        IF(@num_snapshots_partitions = 0)
        BEGIN
            INSERT INTO [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] VALUES (2, 0)
            INSERT INTO [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] VALUES (1, 0)
            INSERT INTO [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] VALUES (0, 0)
        END

        DECLARE @processing_time_current DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

         --
         -- Stage 0:
         --  Identify the batches that were recently uploaded and are consistent
         --  Data belonging to these batches will be copied from live to cache table.
         EXEC [sysutility_ucp_staging].[sp_get_consistent_batches]
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('sp_get_consistent_batches: %d ms', 0, 1, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();

         -----
         ----- Stage 1: Insert into all the dimension tables
         -----          computers_internal, dacs_internal, volumes_internal,
         -----          smo_servers_internal, databases_internal, filegroups_internal,
         -----          datafiles_internal, logfiles_internal
         -----   (Then move to Stage 2: the "measure" tables)
         -----

         -- A note about the expression used for [batch_time] in the INSERT queries, below:
         --
         -- We want to expose batch_time w/a UCP-local time zone so it can be exposed as a UCP-local datetime
         -- in the GUI (the GUI consumes directly from the enumerator).  The batch_time values in each of the
         -- queries below have their time zone offset switched to produce a datetimeoffset with the local UCP
         -- server's time zone offset.
         --
         -- This works well except when the server's time zone offset has changed since the [batch_time] was
         -- generated due to a Daylight Saving Time change.  (Unfortunately, there is no way in T-SQL to
         -- determine what the server's time zone offset was at some arbitrary point in the past.)  The risk
         -- of this is low since we generally do this processing within 15 minutes of timestamp generation.
         -- This doesn't actually result in truly incorrect batch_times that would affect data processing
         -- since the UTC time value that underlies every datetimeoffset is unchanged when you switch the
         -- value's time zone offset.

         --
         -- Insert into the "computers" dimension table
         --
         INSERT INTO [sysutility_ucp_core].[computers_internal] (
               virtual_server_name,
               is_clustered_server,
               physical_server_name,
               num_processors,
               cpu_name, cpu_caption, cpu_family, cpu_architecture, cpu_max_clock_speed, cpu_clock_speed,
               l2_cache_size, l3_cache_size,
               percent_total_cpu_utilization,
               batch_time, processing_time,
               urn, powershell_path)
            SELECT virtual_server_name, is_clustered_server, physical_server_name,
                   num_processors,
                   cpu_name, cpu_caption, cpu_family, cpu_architecture, cpu_max_clock_speed, cpu_clock_speed,
                   l2_cache_size, l3_cache_size,
                   server_processor_usage,
                   SWITCHOFFSET (batch_time, DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS batch_time,
                   @processing_time_current AS processing_time,
                   urn, powershell_path
            FROM [sysutility_ucp_staging].[latest_computer_cpu_memory_configuration]
          SET @row_count = @@ROWCOUNT;
          SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
          RAISERROR ('Insert into [computers_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
          SET @task_start_time = GETUTCDATE();

          --
          -- Insert into the "dacs_internal" dimension-table
          --
          INSERT INTO [sysutility_ucp_core].[dacs_internal] (
                 server_instance_name, dac_name,
                 physical_server_name, dac_deploy_date, dac_description,
                 dac_percent_total_cpu_utilization,
                 batch_time, processing_time,
                 urn, powershell_path)
           SELECT server_instance_name, dac_name,
                  physical_server_name, dac_deploy_date, dac_description,
                  latest_cpu_pct,
                  SWITCHOFFSET (batch_time, DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS batch_time,
                  @processing_time_current AS processing_time,
                  urn, powershell_path
           FROM [sysutility_ucp_staging].[latest_dac_cpu_utilization]
          SET @row_count = @@ROWCOUNT;
          SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
          RAISERROR ('Insert into [dacs_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
          SET @task_start_time = GETUTCDATE();

         --- Insert into the volumes_internal dimension table
         INSERT INTO [sysutility_ucp_core].[volumes_internal] (
                virtual_server_name, physical_server_name, volume_device_id, volume_name,
                total_space_available, free_space, powershell_path,
                batch_time, processing_time)
           SELECT virtual_server_name, physical_server_name, volume_device_id, volume_name,
                  total_space_available, free_space, powershell_path,
                  SWITCHOFFSET (batch_time, DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS batch_time,
                  @processing_time_current AS processing_time
           FROM [sysutility_ucp_staging].[latest_volumes]
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [volumes_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();

         INSERT INTO [sysutility_ucp_core].[smo_servers_internal]
         (
            [urn]
            , [powershell_path]
            , [processing_time]
            , [batch_time]
            , [AuditLevel]
            , [BackupDirectory]
            , [BrowserServiceAccount]
            , [BrowserStartMode]
            , [BuildClrVersionString]
            , [BuildNumber]
            , [Collation]
            , [CollationID]
            , [ComparisonStyle]
            , [ComputerNamePhysicalNetBIOS]
            , [DefaultFile]
            , [DefaultLog]
            , [Edition]
            , [EngineEdition]
            , [ErrorLogPath]
            , [FilestreamShareName]
            , [InstallDataDirectory]
            , [InstallSharedDirectory]
            , [InstanceName]
            , [IsCaseSensitive]
            , [IsClustered]
            , [IsFullTextInstalled]
            , [IsSingleUser]
            , [Language]
            , [MailProfile]
            , [MasterDBLogPath]
            , [MasterDBPath]
            , [MaxPrecision]
            , [Name]
            , [NamedPipesEnabled]
            , [NetName]
            , [NumberOfLogFiles]
            , [OSVersion]
            , [PerfMonMode]
            , [PhysicalMemory]
            , [Platform]
            , [Processors]
            , [ProcessorUsage]
            , [Product]
            , [ProductLevel]
            , [ResourceVersionString]
            , [RootDirectory]
            , [ServerType]
            , [ServiceAccount]
            , [ServiceInstanceId]
            , [ServiceName]
            , [ServiceStartMode]
            , [SqlCharSet]
            , [SqlCharSetName]
            , [SqlDomainGroup]
            , [SqlSortOrder]
            , [SqlSortOrderName]
            , [Status]
            , [TapeLoadWaitTime]
            , [TcpEnabled]
            , [VersionMajor]
            , [VersionMinor]
            , [VersionString]
        )

        SELECT  urn
              , CONVERT(NVARCHAR(MAX), [powershell_path]) AS [powershell_path]
                , @processing_time_current AS [processing_time]  -- $FIXED: SQLBUVSTS-316258
                , SWITCHOFFSET (batch_time, DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS [batch_time]
                , CONVERT(SMALLINT,[AuditLevel]) AS [AuditLevel]
                , CONVERT(NVARCHAR(260) ,[BackupDirectory]) AS [BackupDirectory]
                , CONVERT(NVARCHAR(128) ,[BrowserServiceAccount]) AS [BrowserServiceAccount]
                , CONVERT(SMALLINT,[BrowserStartMode]) AS [BrowserStartMode]
                , CONVERT(NVARCHAR(20) ,[BuildClrVersionString]) AS [BuildClrVersionString]
                , CONVERT(INT,[BuildNumber]) AS [BuildNumber]
                , CONVERT(NVARCHAR(128),[Collation]) AS [Collation]
                , CONVERT(INT,[CollationID]) AS [CollationID]
                , CONVERT(INT,[ComparisonStyle]) AS [ComparisonStyle]
                , CONVERT(NVARCHAR(128),[ComputerNamePhysicalNetBIOS]) AS [ComputerNamePhysicalNetBIOS]
                , CONVERT(NVARCHAR(260),[DefaultFile]) AS [DefaultFile]
                , CONVERT(NVARCHAR(260),[DefaultLog]) AS [DefaultLog]
                , CONVERT(NVARCHAR(64),[Edition]) AS [Edition]
                , CONVERT(SMALLINT,[EngineEdition]) AS [EngineEdition]
                , CONVERT(NVARCHAR(260) ,[ErrorLogPath]) AS [ErrorLogPath]
                , CONVERT(NVARCHAR(260) ,[FilestreamShareName]) AS [FilestreamShareName]
                , CONVERT(NVARCHAR(260) ,[InstallDataDirectory]) AS [InstallDataDirectory]
                , CONVERT(NVARCHAR(260) ,[InstallSharedDirectory]) AS [InstallSharedDirectory]
                , CONVERT(NVARCHAR(128) ,[InstanceName]) AS [InstanceName]
                , CONVERT(BIT,[IsCaseSensitive]) AS [IsCaseSensitive]
                , CONVERT(BIT,[IsClustered]) AS [IsClustered]
                , CONVERT(BIT,[IsFullTextInstalled]) AS [IsFullTextInstalled]
                , CONVERT(BIT,[IsSingleUser]) AS [IsSingleUser]
                , CONVERT(NVARCHAR(64) ,[Language]) AS [Language]
                , CONVERT(NVARCHAR(128),[MailProfile]) AS [MailProfile]
                , CONVERT(NVARCHAR(260),[MasterDBLogPath]) AS [MasterDBLogPath]
                , CONVERT(NVARCHAR(260),[MasterDBPath]) AS [MasterDBPath]
                , CONVERT(TINYINT,[MaxPrecision]) AS [MaxPrecision]
                , CONVERT(NVARCHAR(128) ,[Name]) AS [Name]
                , CONVERT(BIT,[NamedPipesEnabled]) AS [NamedPipesEnabled]
                , CONVERT(NVARCHAR(128) ,[NetName]) AS [NetName]
                , CONVERT(INT,[NumberOfLogFiles]) AS [NumberOfLogFiles]
                , CONVERT(NVARCHAR(32) ,[OSVersion]) AS [OSVersion]
                , CONVERT(SMALLINT,[PerfMonMode]) AS [PerfMonMode]
                , CONVERT(INT,[PhysicalMemory]) AS [PhysicalMemory]
                , CONVERT(NVARCHAR(32) ,[Platform]) AS [Platform]
                , CONVERT(SMALLINT,[Processors]) AS [Processors]
                , CONVERT(INT,[ProcessorUsage]) AS [ProcessorUsage]
                , CONVERT(NVARCHAR(48) ,[Product]) AS [Product]
                , CONVERT(NVARCHAR(32) ,[ProductLevel]) AS [ProductLevel]
                , CONVERT(NVARCHAR(32) ,[ResourceVersionString]) AS [ResourceVersionString]
                , CONVERT(NVARCHAR(260) ,[RootDirectory]) AS [RootDirectory]
                , CONVERT(SMALLINT,[ServerType]) AS [ServerType]
                , CONVERT(NVARCHAR(128),[ServiceAccount]) AS [ServiceAccount]
                , CONVERT(NVARCHAR(64),[ServiceInstanceId]) AS [ServiceInstanceId]
                , CONVERT(NVARCHAR(64),[ServiceName]) AS [ServiceName]
                , CONVERT(SMALLINT,[ServiceStartMode]) AS [ServiceStartMode]
                , CONVERT(SMALLINT,[SqlCharSet]) AS [SqlCharSet]
                , CONVERT(NVARCHAR(32),[SqlCharSetName]) AS [SqlCharSetName]
                , CONVERT(NVARCHAR(128),[SqlDomainGroup]) AS [SqlDomainGroup]
                , CONVERT(SMALLINT,[SqlSortOrder]) AS [SqlSortOrder]
                , CONVERT(NVARCHAR(64),[SqlSortOrderName]) AS [SqlSortOrderName]
                , CONVERT(SMALLINT,[Status]) AS [Status]
                , CONVERT(INT,[TapeLoadWaitTime]) AS [TapeLoadWaitTime]
                , CONVERT(BIT,[TcpEnabled]) AS [TcpEnabled]
                , CONVERT(INT,[VersionMajor]) AS [VersionMajor]
                , CONVERT(INT,[VersionMinor]) AS [VersionMinor]
                , CONVERT(NVARCHAR(32),[VersionString]) AS [VersionString]

                FROM
                    (SELECT urn, property_name, property_value, batch_time
                    FROM [sysutility_ucp_staging].[latest_smo_properties]
                    WHERE object_type = 1) props     -- object_type = 1 is Server
                PIVOT
                (
                    MAX(property_value)
                    FOR property_name IN (
                                   [powershell_path]
                                 , [AuditLevel]
                            , [BackupDirectory]
                            , [BrowserServiceAccount]
                            , [BrowserStartMode]
                            , [BuildClrVersionString]
                            , [BuildNumber]
                            , [Collation]
                            , [CollationID]
                            , [ComparisonStyle]
                            , [ComputerNamePhysicalNetBIOS]
                            , [DefaultFile]
                            , [DefaultLog]
                            , [Edition]
                            , [EngineEdition]
                            , [ErrorLogPath]
                            , [FilestreamShareName]
                            , [InstallDataDirectory]
                            , [InstallSharedDirectory]
                            , [InstanceName]
                            , [IsCaseSensitive]
                            , [IsClustered]
                            , [IsFullTextInstalled]
                            , [IsSingleUser]
                            , [Language]
                            , [MailProfile]
                            , [MasterDBLogPath]
                            , [MasterDBPath]
                            , [MaxPrecision]
                            , [Name]
                            , [NamedPipesEnabled]
                            , [NetName]
                            , [NumberOfLogFiles]
                            , [OSVersion]
                            , [PerfMonMode]
                            , [PhysicalMemory]
                            , [Platform]
                            , [Processors]
                            , [ProcessorUsage]
                            , [Product]
                            , [ProductLevel]
                            , [ResourceVersionString]
                            , [RootDirectory]
                            , [ServerType]
                            , [ServiceAccount]
                            , [ServiceInstanceId]
                            , [ServiceName]
                            , [ServiceStartMode]
                            , [SqlCharSet]
                            , [SqlCharSetName]
                            , [SqlDomainGroup]
                            , [SqlSortOrder]
                            , [SqlSortOrderName]
                            , [Status]
                            , [TapeLoadWaitTime]
                            , [TcpEnabled]
                            , [VersionMajor]
                            , [VersionMinor]
                            , [VersionString] )
                ) AS pvt
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [smo_servers_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();

         INSERT INTO [sysutility_ucp_core].[databases_internal]
                ([urn]
                , [powershell_path]
                , [processing_time]
                , [batch_time]
                , [server_instance_name]
                , [parent_urn]
                , [Collation]
                , [CompatibilityLevel]
                , [CreateDate]
                , [EncryptionEnabled]
                , [Name]
                , [RecoveryModel]
                , [Trustworthy]
                , [state])
            SELECT  [urn]
                  , CONVERT(NVARCHAR(MAX), [powershell_path]) AS [powershell_path]
                    , @processing_time_current AS processing_time  -- $FIXED: SQLBUVSTS-316258
                    , SWITCHOFFSET ([batch_time], DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS [batch_time]
                    , [server_instance_name]
                    , Left(urn, CHARINDEX('/Database[', urn, 1)-1) AS parent_urn
                    , CONVERT(NVARCHAR(128),[Collation]) AS Collation
                    , CONVERT(SMALLINT,[CompatibilityLevel]) AS CompatibilityLevel
                    -- DC (SSIS) doesn't support sql_variant, so all properties are uploaded as nvarchar(4000).  To successfully round-trip
                    -- the property values through nvarchar, we use the same language-independent conversion style on MI and UCP. The shared
                    -- fn_sysutility_get_culture_invariant_conversion_style_internal function gives us a consistent conversion style for each
                    -- property data type that is language-independent and that won't cause data loss.  We also use this function on the MI
                    -- when converting to nvarchar so that the two conversions are symmetrical.  (Ref: VSTS 361531, 359504, 12967)
                    , CONVERT(DATETIME, [CreateDate], msdb.dbo.fn_sysutility_get_culture_invariant_conversion_style_internal('datetime')) AS CreateDate
                    , CONVERT(BIT,[EncryptionEnabled]) AS EncryptionEnabled
                    , CONVERT(SYSNAME,[Name])AS [Name]
                    , CONVERT(SMALLINT,[RecoveryModel]) AS RecoveryModel
                    , CONVERT(BIT,[Trustworthy]) AS Trustworthy
                    -- Default to 0 (available) state. We'll update this to 1 (not available) for emergency/offline/etc databases later (we
                    -- need to examine file and filegroup properties to infer whether a database should be available or not available).
                    , 0 AS state
             FROM
             (SELECT urn, server_instance_name, property_name, property_value, batch_time
             FROM [sysutility_ucp_staging].[latest_smo_properties]
             WHERE object_type = 2) props -- object_type = 1 is Database
                PIVOT
                (
                    MAX(property_value)
                    FOR property_name IN (
                                       [powershell_path]
                                      , [ID]
                                      , [Collation]
                                            , [CompatibilityLevel]
                                            , [CreateDate]
                                            , [EncryptionEnabled]
                                            , [Name]
                                            , [RecoveryModel]
                                            , [Trustworthy] )
                ) AS pvt
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [databases_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();


         INSERT INTO [sysutility_ucp_core].[filegroups_internal]
                ([urn]
                , [powershell_path]
                , [processing_time]
                , [batch_time]
                , [server_instance_name]
                , [database_name]
                , [parent_urn]
                , [Name])
            SELECT  [urn]
                  , CONVERT(NVARCHAR(MAX), [powershell_path]) AS [powershell_path]
                    , @processing_time_current AS processing_time  -- $FIXED: SQLBUVSTS-316258
                    , SWITCHOFFSET ([batch_time], DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS [batch_time]
                    , [server_instance_name]
                    , CONVERT(SYSNAME,[parent_name]) AS [database_name]
                    , Left(urn, CHARINDEX('/FileGroup[', urn, 1)-1) AS parent_urn
                    , CONVERT(SYSNAME,[Name]) AS Name
             FROM
             (SELECT urn, server_instance_name, property_name, property_value, batch_time
             FROM [sysutility_ucp_staging].[latest_smo_properties]
             WHERE object_type = 4) props -- object_type = 4 is FileGroup
                PIVOT
                (
                    MAX(property_value)
                    FOR property_name IN (
                                        [powershell_path]
                                      , [parent_name]
                                      , [ID]
                                            , [Name])
                ) AS pvt
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [filegroups_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();



         INSERT INTO [sysutility_ucp_core].[datafiles_internal]
                ([urn]
                , [powershell_path]
                , [processing_time]
                , [batch_time]
                , [server_instance_name]
                , [database_name]
                , [filegroup_name]
                , [parent_urn]
                , [Growth]
                , [GrowthType]
                , [MaxSize]
                , [Name]
                , [Size]
                , [UsedSpace]
                , [FileName]
                , [VolumeFreeSpace]
                , [volume_name]
                , [volume_device_id]
                , [physical_server_name])
            SELECT  [urn]
                  , CONVERT(NVARCHAR(MAX), pvt.[powershell_path]) AS [powershell_path]
                    , @processing_time_current AS processing_time  -- $FIXED: SQLBUVSTS-316258
                    , SWITCHOFFSET (pvt.[batch_time], DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS [batch_time]
                    , pvt.[server_instance_name]
                    , CONVERT(SYSNAME,[grandparent_name]) AS [database_name]
                    , CONVERT(SYSNAME,[parent_name]) AS [filegroup_name]
                    , Left(urn, CHARINDEX('/File[', urn, 1)-1) AS parent_urn
                    , CONVERT(REAL,[Growth]) AS Growth
                    , CONVERT(SMALLINT,[GrowthType]) AS GrowthType
                    , CONVERT(REAL,[MaxSize]) AS MaxSize
                    , CONVERT(SYSNAME,[Name]) AS Name
                    , CONVERT(REAL,[Size]) AS Size
                    , CONVERT(REAL,[UsedSpace]) AS UsedSpace
                    , CONVERT(NVARCHAR(260),[FileName]) AS FileName
                    , ISNULL(v.free_space, 0.0) * 1024 AS VolumeFreeSpace -- volumes_internal.free_space is MB, and VolumeFreeSpace is expected to be KB.
                    , ISNULL(v.volume_name, N'') AS volume_name
                    , v.[volume_device_id] AS [volume_device_id]
                    , pvt.[physical_server_name]
             FROM
             (SELECT urn, physical_server_name, server_instance_name, property_name, property_value, batch_time
             FROM [sysutility_ucp_staging].[latest_smo_properties]
             WHERE object_type = 5) props -- object_type = 5 is DataFile
                PIVOT
                (
                    MAX(property_value)
                    FOR property_name IN (
                                        [powershell_path]
                                      , [parent_name]
                                      , [grandparent_name]
                                      , [ID]
                                      , [Growth]
                                      , [GrowthType]
                                      , [MaxSize]
                                      , [Name]
                                      , [Size]
                                      , [UsedSpace]
                                      , [FileName]
                                      , [volume_device_id])
                ) AS pvt
            LEFT OUTER JOIN
            [sysutility_ucp_core].[volumes_internal] v
            ON
            v.physical_server_name = pvt.physical_server_name AND
            CONVERT(SYSNAME, pvt.[volume_device_id]) = v.volume_device_id
            WHERE v.processing_time = @processing_time_current
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [datafiles_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();


         INSERT INTO [sysutility_ucp_core].[logfiles_internal]
                ([urn]
                , [powershell_path]
                , [processing_time]
                , [batch_time]
                , [server_instance_name]
                , [database_name]
                , [parent_urn]
                , [Growth]
                , [GrowthType]
                , [MaxSize]
                , [Name]
                , [Size]
                , [UsedSpace]
                , [FileName]
                , [VolumeFreeSpace]
                , [volume_name]
                , [volume_device_id]
                , [physical_server_name])
            SELECT[urn]
                  , CONVERT(NVARCHAR(MAX), pvt.[powershell_path]) AS [powershell_path]
                    , @processing_time_current AS processing_time  -- $FIXED: SQLBUVSTS-316258
                    , SWITCHOFFSET (pvt.[batch_time], DATENAME(TZoffset, SYSDATETIMEOFFSET())) AS [batch_time]
                    , pvt.[server_instance_name]
                    , CONVERT(SYSNAME,[parent_name]) AS [database_name]
                    , Left(urn, CHARINDEX('/LogFile[', urn, 1)-1) AS parent_urn
                    , CONVERT(REAL,[Growth]) AS Growth
                    , CONVERT(SMALLINT,[GrowthType]) AS GrowthType
                    , CONVERT(REAL,[MaxSize]) AS MaxSize
                    , CONVERT(SYSNAME,[Name]) AS Name
                    , CONVERT(REAL,[Size]) AS Size
                    --- The collection data may not contain the UsedSpace property of the log file of a database in EMERGENCY state.
                    , ISNULL(CONVERT(REAL,[UsedSpace]), 0.0) AS UsedSpace
                    , CONVERT(NVARCHAR(260),[FileName]) AS FileName
                    , ISNULL(v.free_space, 0.0) * 1024 AS VolumeFreeSpace -- volumes_internal.free_space is MB, and VolumeFreeSpace is expected to be KB.
                    , ISNULL(v.volume_name, N'') AS volume_name
                    , v.[volume_device_id] AS [volume_device_id]
                    , pvt.[physical_server_name]
             FROM
             (SELECT urn, physical_server_name, server_instance_name, property_name, property_value, batch_time
             FROM [sysutility_ucp_staging].[latest_smo_properties]
             WHERE object_type = 3) props -- object_type = 3 is LogFile
                PIVOT
                (
                    MAX(property_value)
                    FOR property_name IN (
                                       [powershell_path]
                                      , [parent_name]
                                      , [ID]
                                      , [Growth]
                                      , [GrowthType]
                                      , [MaxSize]
                                      , [Name]
                                      , [Size]
                                      , [UsedSpace]
                                      , [FileName]
                                      , [volume_device_id])
                ) AS pvt
            LEFT OUTER JOIN
            [sysutility_ucp_core].[volumes_internal] v
            ON
            v.physical_server_name = pvt.physical_server_name AND
            CONVERT(SYSNAME, pvt.[volume_device_id]) = v.volume_device_id
            WHERE v.processing_time = @processing_time_current
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [logfiles_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();

         -- Identify all of the databases for which we do not have all file/filegroup details because of the current
         -- database status (db is offline, recovering, emergency mode, etc).  Update the state for these databases
         -- to 1 ("not available").
         UPDATE sysutility_ucp_core.databases_internal
         SET state = 1
         FROM sysutility_ucp_core.databases_internal AS db
         WHERE
             -- Case #1: Emergency mode databases are considered 'not available' -- the database is not recovered, and
             -- we can't get correct log file metadata.  We detect this by looking for databases with a log file that
             -- has a size of 0, which is impossible in an available database.
            EXISTS (
                SELECT *
                FROM sysutility_ucp_core.logfiles_internal AS lf
                WHERE lf.server_instance_name = db.server_instance_name
                    AND lf.database_name = db.Name
                    AND lf.Size = 0
                    AND lf.processing_time = @processing_time_current)
            -- Case #2: When a database is in other "not available" states (like recovering, offline, suspect), we
            -- cannot retrieve filegroup or file-level metadata.  We detect this case by looking for databases that seem
            -- to have no filegroups, which is an impossible state for an online & available database.
            OR NOT EXISTS (
                SELECT *
                FROM sysutility_ucp_core.filegroups_internal AS fg
                WHERE fg.server_instance_name = db.server_instance_name
                    AND fg.database_name = db.Name
                    AND fg.processing_time = @processing_time_current);
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Discover unavailable databases: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();


         -----
         ----- Stage 2: Insert into all the measure tables
         -----          cpu_utilization_internal (computers, instances, dacs)
         -----          space_utilization_internal (volumes, instances, databases, filegroups, datafiles, logfiles)
         -----
         -----
         INSERT INTO [sysutility_ucp_core].[cpu_utilization_internal](
              aggregation_type, object_type, processing_time,
              physical_server_name, server_instance_name, database_name,
              percent_total_cpu_utilization)
            SELECT 0,   -- No aggregation
                   1,   -- Computer Object
                   @processing_time_current,
                   physical_server_name,
                   N'',
                   N'',
                   percent_total_cpu_utilization
            FROM [sysutility_ucp_core].[computers_internal]
            WHERE processing_time = @processing_time_current
              UNION ALL
            SELECT 0,   -- No aggregation
                   3,   -- Instance object
                   @processing_time_current,
                   N'',
                   server_instance_name,
                   N'',
                   instance_processor_usage
            FROM [sysutility_ucp_staging].[latest_instance_cpu_utilization]
              UNION ALL
            SELECT 0,   -- No aggregation
                   4,   -- Database/DAC object
                   @processing_time_current,
                   N'',   -- computer_name
                   server_instance_name,
                   dac_name,
                   dac_percent_total_cpu_utilization
            FROM [sysutility_ucp_core].[dacs_internal]
            WHERE processing_time = @processing_time_current
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [cpu_utilization_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);
         SET @task_start_time = GETUTCDATE();

         INSERT INTO [sysutility_ucp_core].[space_utilization_internal] (
               aggregation_type, object_type, processing_time,
               virtual_server_name, volume_device_id,
               server_instance_name, database_name, [filegroup_name], dbfile_name,
               total_space_bytes, allocated_space_bytes, used_space_bytes, available_space_bytes)
            SELECT 0 AS aggregation_type,
                   CASE WHEN group_id = 0 AND [filegroup_name] = N'' THEN 7 -- logfile
                        WHEN group_id = 0 THEN 6 -- datafile
                        WHEN group_id = 1 THEN 5 -- filegroup
                        WHEN group_id = 3 THEN 4 -- database
                        WHEN group_id = 7 THEN 3 -- instance
                        ELSE NULL -- should never get here
                   END as [object_type],
                   @processing_time_current AS processing_time,
                   N'' as virtual_server_name,
                   N'' as volume_device_id,
                   ISNULL(server_instance_name, N''), -- shouldn't ever get to be null
                   ISNULL(database_name, N''),
                   ISNULL([filegroup_name], N''),
                   ISNULL([dbfile_name], N''),
                   CASE WHEN group_id = 0 THEN total_space_kb * 1024 ELSE NULL END,
                   CASE WHEN group_id = 0 THEN allocated_space_kb * 1024 ELSE NULL END,
                   used_space_kb * 1024,
                   CASE WHEN group_id = 0 THEN available_space_kb * 1024 ELSE NULL END
            FROM (
                SELECT server_instance_name, database_name, [filegroup_name], dbfile_name,
                       SUM(MaxSize) AS total_space_kb,  -- Is this right?
                       SUM([Size]) AS allocated_space_kb,
                       SUM(UsedSpace) AS used_space_kb,
                       SUM(available_space) AS available_space_kb,
                       GROUPING_ID(server_instance_name, database_name, [filegroup_name], dbfile_name) AS group_id
                FROM (SELECT server_instance_name, database_name, [filegroup_name], [Name] as dbfile_name,
                             MaxSize, [Size], UsedSpace,
                             [sysutility_ucp_misc].[fn_get_max_size_available]([Size], [MaxSize], [Growth], [GrowthType], [VolumeFreeSpace]) AS available_space
                       FROM [sysutility_ucp_core].[datafiles_internal]
                       WHERE processing_time = @processing_time_current
                     UNION ALL
                      SELECT server_instance_name, database_name, N'' AS [filegroup_name],
                             [Name] AS dbfile_name,
                             MaxSize, [Size], UsedSpace,
                             [sysutility_ucp_misc].[fn_get_max_size_available]([Size], [MaxSize], [Growth], [GrowthType], [VolumeFreeSpace]) AS available_space
                      FROM [sysutility_ucp_core].[logfiles_internal]
                      WHERE processing_time = @processing_time_current) as dbfiles
                GROUP BY GROUPING SETS((server_instance_name),
                                       (server_instance_name, database_name),
                                       (server_instance_name, database_name, [filegroup_name]),
                                       (server_instance_name, database_name, [filegroup_name], [dbfile_name])
                                      )
                 ) AS instance_space_utilizations
            UNION ALL
            SELECT 0 AS aggregation_type,
                   CASE WHEN GROUPING_ID(virtual_server_name, volume_device_id) = 3 THEN 0 -- utility
                        WHEN GROUPING_ID(virtual_server_name, volume_device_id) = 1 THEN 1 -- computer
                        WHEN GROUPING_ID(virtual_server_name, volume_device_id) = 0 THEN 2 -- volume
                        ELSE NULL  -- should never get here
                   END AS object_type,
                   @processing_time_current as processing_time,
                   ISNULL(virtual_server_name, N''),
                   ISNULL(volume_device_id, N'') AS volume_device_id,
                   N'' as server_instance_name,
                   N'' as database_name,
                   N'' as [filegroup_name],
                   N'' as dbfile_name,
                   SUM(total_space_available)*1048576 AS total_space_bytes,
                   SUM(total_space_available)*1048576 AS allocated_space_bytes,
                   SUM(total_space_available - free_space)*1048576  AS used_space_bytes,
                   SUM(free_space)*1048576 AS available_space_bytes
            FROM [sysutility_ucp_core].[volumes_internal]
            WHERE processing_time = @processing_time_current
            GROUP BY GROUPING SETS ((),
                                    (virtual_server_name),
                                    (virtual_server_name, volume_device_id)
                                   )
         SET @row_count = @@ROWCOUNT;
         SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
         RAISERROR ('Insert into [space_utilization_internal]: %d rows, %d ms', 0, 1, @row_count, @task_elapsed_ms);

        --
        -- State changes
        --
        UPDATE [msdb].[dbo].[sysutility_ucp_processing_state_internal]
          SET latest_processing_time = @processing_time_current

        -- Update the snapshot partitions table
        -- Push down the previous snapshot partition values and
        -- store the current max snapshot in the latest (top) record
        UPDATE [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] SET latest_consistent_snapshot_id = (SELECT TOP 1 latest_consistent_snapshot_id FROM [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] WHERE time_id = 1)  WHERE time_id = 2
        UPDATE [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] SET latest_consistent_snapshot_id = (SELECT TOP 1 latest_consistent_snapshot_id FROM [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] WHERE time_id = 0)  WHERE time_id = 1
        UPDATE [msdb].[dbo].[sysutility_ucp_snapshot_partitions_internal] SET latest_consistent_snapshot_id = @max_snapshot_id WHERE time_id = 0

        -- As we have inserted chunk of data in the cache tables, the stats on these tables
        -- get stale there by leading to performance degradation of the health state queries
        -- Force update the stats on these tables so that the QO is able to generate a more
        -- realisitc query execution plan
        SET @task_start_time = GETUTCDATE();
        UPDATE STATISTICS [msdb].[dbo].[sysutility_ucp_processing_state_internal];

        -- Update stats on all dimension and measure cache tables
        DECLARE @schema sysname
        DECLARE @name sysname
        DECLARE @query NVARCHAR(MAX)

        DECLARE cache_tables CURSOR FOR
        SELECT object_schema, [object_name]
        FROM sysutility_ucp_misc.utility_objects_internal
        WHERE utility_object_type IN ('DIMENSION', 'MEASURE');

        OPEN cache_tables;
        FETCH NEXT FROM cache_tables INTO @schema, @name;
        WHILE (@@FETCH_STATUS <> -1)
        BEGIN
            SET @query = 'UPDATE STATISTICS ' + QUOTENAME (@schema) + '.' + QUOTENAME (@name);
            EXEC (@query);
            FETCH NEXT FROM cache_tables INTO @schema, @name;
        END;
        CLOSE cache_tables;
        DEALLOCATE cache_tables;

        SET @task_elapsed_ms = DATEDIFF (ms, @task_start_time, GETUTCDATE());
        RAISERROR ('Update statistics: %d ms', 0, 1, @task_elapsed_ms);
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'PROCEDURE',@level1name=N'sp_copy_live_table_data_into_cache_tables'
GO
