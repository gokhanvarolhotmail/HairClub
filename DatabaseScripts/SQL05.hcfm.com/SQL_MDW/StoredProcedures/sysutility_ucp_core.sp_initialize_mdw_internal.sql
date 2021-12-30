/* CreateDate: 01/03/2014 07:07:54.520 , ModifyDate: 01/03/2014 07:07:54.520 */
GO
CREATE PROCEDURE sysutility_ucp_core.sp_initialize_mdw_internal
AS
BEGIN
   IF (msdb.dbo.fn_sysutility_ucp_get_edition_is_ucp_capable_internal() = 1)
   BEGIN
      RAISERROR ('Instance is able to be used as a Utility Control Point.', 0, 1) WITH NOWAIT;
   END
   ELSE BEGIN
      DECLARE @edition nvarchar(128);
      SELECT @edition = CONVERT(nvarchar(128), SERVERPROPERTY('Edition'));
      RAISERROR(37004, -1, -1, @edition);
      RETURN(1);
   END;

   -- The Utility schema uses two Enterprise-only engine features: compression and partitioning.
   -- Utility is an Enterprise-only feature, but we share instmdw.sql and the MDW database with other
   -- features that are not Enterprise only.  Therefore we can't include the following things as part
   -- of the CREATE TABLE statements because instmdw.sql would fail when run on a non-Enterprise SKU.
   -- To work around this, we defer this part of the UCP schema creation until Create UCP is run.
   IF (3 = CONVERT (int, SERVERPROPERTY('EngineEdition'))) -- Enterprise/Enterprise Eval/Developer/Data Center
   BEGIN
      -- Enable data compression on tables that benefit from it the most
      RAISERROR ('Enabling compression on MDW tables', 0, 1) WITH NOWAIT;
      ALTER TABLE [snapshots].[sysutility_ucp_smo_properties_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);
      ALTER TABLE [sysutility_ucp_core].[smo_servers_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);
      ALTER TABLE [sysutility_ucp_core].[databases_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);
      ALTER TABLE [sysutility_ucp_core].[filegroups_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);
      ALTER TABLE [sysutility_ucp_core].[datafiles_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);
      ALTER TABLE [sysutility_ucp_core].[logfiles_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);
      ALTER TABLE [sysutility_ucp_core].[cpu_utilization_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);
      ALTER TABLE [sysutility_ucp_core].[space_utilization_internal] REBUILD WITH (DATA_COMPRESSION = PAGE);

      -- Partitioning (and compression) on measure tables

      -- Create a partitioning scheme based on aggregationType. In effect, we'd like
      -- each aggregation-level to get its own partition. Currently, we only support
      -- 3 aggregation levels.
      --
      -- FUTURE: It would be nice to support composite partitioning in the future.
      --   1. We could further create a sub-partition for each object-type (computer etc.)
      --   2. If we could have sliding partitions, we could avoid deletes altogether, and
      --      instead work with truncate/drop-partition style operations
      --
      IF NOT EXISTS (SELECT name FROM sys.partition_functions WHERE name = N'sysutility_ucp_aggregation_type_partition_function')
      BEGIN
         RAISERROR ('Creating partition function [sysutility_ucp_aggregation_type_partition_function]', 0, 1) WITH NOWAIT;
         -- Use dynamic SQL here (and in the next create stmt) b/c otherwise SQL will fail the creation of this
         -- proc on Workgroup or Standard edition.
         EXEC ('
            CREATE PARTITION FUNCTION [sysutility_ucp_aggregation_type_partition_function](TINYINT)
               AS RANGE LEFT
               FOR VALUES(0, 1, 2)');
      END;

      IF NOT EXISTS (SELECT name FROM sys.partition_schemes WHERE name = N'sysutility_ucp_aggregation_type_partition_scheme')
      BEGIN
         RAISERROR ('Creating partition scheme [sysutility_ucp_aggregation_type_partition_scheme]', 0, 1) WITH NOWAIT;
         EXEC ('
            CREATE PARTITION SCHEME [sysutility_ucp_aggregation_type_partition_scheme]
               AS PARTITION [sysutility_ucp_aggregation_type_partition_function]
               ALL TO ([PRIMARY])');
      END;

      -- ALTER INDEX can't change partition scheme.  Instead we must drop and recreate the clustered PKs.
      IF OBJECT_ID ('[sysutility_ucp_core].[pk_cpu_utilization_internal]') IS NOT NULL
      BEGIN
         RAISERROR ('Dropping primary key [sysutility_ucp_core].[cpu_utilization_internal].[pk_cpu_utilization_internal]', 0, 1) WITH NOWAIT;
         ALTER TABLE [sysutility_ucp_core].[cpu_utilization_internal] DROP CONSTRAINT [pk_cpu_utilization_internal];
      END;
      RAISERROR ('Creating partitioned primary key [sysutility_ucp_core].[cpu_utilization_internal].[pk_cpu_utilization_internal]', 0, 1) WITH NOWAIT;
      ALTER TABLE [sysutility_ucp_core].[cpu_utilization_internal] ADD
         CONSTRAINT pk_cpu_utilization_internal
            PRIMARY KEY CLUSTERED (aggregation_type, processing_time, object_type, physical_server_name, server_instance_name, database_name)
            WITH (DATA_COMPRESSION = PAGE)
            ON [sysutility_ucp_aggregation_type_partition_scheme](aggregation_type);

      IF OBJECT_ID ('[sysutility_ucp_core].[pk_storage_utilization]') IS NOT NULL
      BEGIN
         RAISERROR ('Dropping primary key [sysutility_ucp_core].[space_utilization_internal].[pk_storage_utilization]', 0, 1) WITH NOWAIT;
         ALTER TABLE [sysutility_ucp_core].[space_utilization_internal] DROP CONSTRAINT [pk_storage_utilization];
      END;
      RAISERROR ('Creating partitioned primary key [sysutility_ucp_core].[space_utilization_internal].[pk_storage_utilization]', 0, 1) WITH NOWAIT;
      ALTER TABLE [sysutility_ucp_core].[space_utilization_internal] ADD
         CONSTRAINT pk_storage_utilization
            PRIMARY KEY CLUSTERED(
               aggregation_type,
               processing_time,
               object_type,
               virtual_server_name,
               volume_device_id,
               server_instance_name,
               database_name,
               [filegroup_name],
               dbfile_name)
            WITH (DATA_COMPRESSION = PAGE)
            ON [sysutility_ucp_aggregation_type_partition_scheme](aggregation_type);
   END;
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'PROCEDURE',@level1name=N'sp_initialize_mdw_internal'
GO
