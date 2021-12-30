/* CreateDate: 01/03/2014 07:07:53.877 , ModifyDate: 01/03/2014 07:07:53.877 */
GO
CREATE VIEW [sysutility_ucp_core].[latest_volumes]
   AS
   SELECT [ID],
          [virtual_server_name],
          [physical_server_name],
          [volume_device_id],
          [volume_name],
          [powershell_path],
          [processing_time],
          [batch_time],
          [total_space_available],
          (total_space_available - free_space) AS [total_space_utilized],
          (CASE WHEN total_space_available = 0 THEN 0 ELSE (100 * (total_space_available - free_space))/total_space_available END) AS  [percent_total_space_utilization]
   FROM [sysutility_ucp_core].[volumes_internal]
   WHERE processing_time = (SELECT latest_processing_time FROM [msdb].[dbo].[sysutility_ucp_processing_state_internal])
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'latest_volumes'
GO
