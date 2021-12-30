/* CreateDate: 01/03/2014 07:07:53.473 , ModifyDate: 01/03/2014 07:07:53.473 */
GO
CREATE VIEW [sysutility_ucp_staging].[latest_dac_cpu_utilization]
AS
  SELECT physical_server_name, ds.server_instance_name, dac_db, dac_deploy_date, dac_description, dac_name,
         lifetime_cpu_time_ms, interval_cpu_pct AS latest_cpu_pct, interval_cpu_time_ms AS latest_interval_cpu_time_ms,
         interval_start_time AS latest_interval_start_time, interval_end_time AS latest_interval_end_time,
         ds.batch_time,
         N'Utility[@Name=''' + CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')) + N''']/DeployedDac[@Name=''' + ds.dac_name + N''' and @ServerInstanceName=''' + ds.server_instance_name + N''']' AS urn,
         N'SQLSERVER:\Utility\'+CASE WHEN 0 = CHARINDEX(N'\', CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')), 1) THEN CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')) + N'\DEFAULT' ELSE CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')) END
        +N'\DeployedDacs\'+msdb.dbo.fn_encode_sqlname_for_powershell(ds.dac_name+'.'+ds.server_instance_name) AS powershell_path
  FROM [snapshots].[sysutility_ucp_dac_collected_execution_statistics_internal] ds
        INNER JOIN [sysutility_ucp_staging].[consistent_batch_manifests_internal] cb
        ON ds.server_instance_name = cb.server_instance_name AND ds.batch_time = cb.batch_time
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'VIEW',@level1name=N'latest_dac_cpu_utilization'
GO
