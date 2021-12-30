/* CreateDate: 01/03/2014 07:07:53.643 , ModifyDate: 01/03/2014 07:07:53.643 */
GO
CREATE VIEW [sysutility_ucp_staging].[latest_instance_cpu_utilization]
AS
   SELECT t.[server_instance_name],
          [instance_processor_usage],
          t.[batch_time]
   FROM [snapshots].[sysutility_ucp_cpu_memory_configurations_internal] AS t
        INNER JOIN [sysutility_ucp_staging].[consistent_batch_manifests_internal] cb
        ON t.server_instance_name = cb.server_instance_name AND t.batch_time = cb.batch_time
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'VIEW',@level1name=N'latest_instance_cpu_utilization'
GO
