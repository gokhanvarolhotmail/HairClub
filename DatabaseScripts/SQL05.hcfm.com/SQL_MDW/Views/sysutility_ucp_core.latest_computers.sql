/* CreateDate: 01/03/2014 07:07:53.823 , ModifyDate: 01/03/2014 07:07:53.823 */
GO
CREATE VIEW [sysutility_ucp_core].[latest_computers] AS
  SELECT [id],
         virtual_server_name,
         physical_server_name,
         is_clustered_server,
         num_processors,
         cpu_name,
         cpu_caption,
         cpu_family,
         cpu_architecture,
         cpu_max_clock_speed,
         cpu_clock_speed,
         l2_cache_size,
         l3_cache_size,
         urn,
         powershell_path,
         processing_time,
         batch_time,
         percent_total_cpu_utilization
  FROM [sysutility_ucp_core].[computers_internal]
  WHERE processing_time = (SELECT latest_processing_time FROM [msdb].[dbo].[sysutility_ucp_processing_state_internal]);
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'latest_computers'
GO
