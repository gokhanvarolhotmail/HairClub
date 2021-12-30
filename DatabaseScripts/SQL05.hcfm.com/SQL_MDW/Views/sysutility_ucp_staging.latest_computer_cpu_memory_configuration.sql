/* CreateDate: 01/03/2014 07:07:53.607 , ModifyDate: 01/03/2014 07:07:53.607 */
GO
CREATE VIEW [sysutility_ucp_staging].[latest_computer_cpu_memory_configuration]
AS
   SELECT *
   FROM
      (
        SELECT
           ROW_NUMBER() OVER (PARTITION BY t.physical_server_name ORDER BY t.batch_time DESC) AS Rank,
           [virtual_server_name], [is_clustered_server],[physical_server_name],
           [num_processors], [cpu_name], [cpu_caption], [cpu_family], [cpu_architecture], [cpu_max_clock_speed], [cpu_clock_speed],
           [l2_cache_size], [l3_cache_size],
           [server_processor_usage],
           t.[batch_time],
           N'Utility[@Name=''' + CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')) + N''']/Computer[@Name=''' + t.physical_server_name + N''']' AS urn,
           N'SQLSERVER:\Utility\'+CASE WHEN 0 = CHARINDEX(N'\', CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')), 1) THEN CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')) + N'\DEFAULT' ELSE @@SERVERNAME END
          +N'\Computers\'+msdb.dbo.fn_encode_sqlname_for_powershell(t.physical_server_name) AS powershell_path
        FROM [snapshots].[sysutility_ucp_cpu_memory_configurations_internal] AS t
             INNER JOIN [sysutility_ucp_staging].[consistent_batch_manifests_internal] cb
             ON t.server_instance_name = cb.server_instance_name AND t.batch_time = cb.batch_time
      ) AS S
   WHERE S.Rank = 1
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'VIEW',@level1name=N'latest_computer_cpu_memory_configuration'
GO
