/* CreateDate: 01/03/2014 07:07:53.690 , ModifyDate: 01/03/2014 07:07:53.690 */
GO
CREATE VIEW [sysutility_ucp_staging].[latest_volumes] AS
   SELECT [virtual_server_name],
          [physical_server_name],
          [volume_device_id],
          [volume_name],
          [total_space_available],  -- in MB
          [free_space], -- in MB
          N'SQLSERVER:\Utility\'+ CASE WHEN 0 = CHARINDEX(N'\', CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')), 1)
                                        THEN CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName')) + N'\DEFAULT'
                                        ELSE CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName'))
                                    END
          +N'\Computers\'+msdb.dbo.fn_encode_sqlname_for_powershell(physical_server_name)
          +N'\Volumes\'+msdb.dbo.fn_encode_sqlname_for_powershell(volume_name) AS powershell_path,
          [batch_time],
          [snapshot_id]
      FROM
      (
      SELECT
         [virtual_server_name],
         [physical_server_name],
         [volume_device_id],
         [volume_name],
         [total_space_available],
         [free_space],
         V.[batch_time],
         [snapshot_id],
         ROW_NUMBER() OVER (PARTITION BY physical_server_name,volume_device_id ORDER BY V.batch_time DESC) rk
      FROM [snapshots].[sysutility_ucp_volumes_internal] AS V
           INNER JOIN [sysutility_ucp_staging].[consistent_batch_manifests_internal] cb
           ON V.server_instance_name = cb.server_instance_name AND V.batch_time = cb.batch_time
      ) AS T
      WHERE T.rk = 1
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'VIEW',@level1name=N'latest_volumes'
GO
