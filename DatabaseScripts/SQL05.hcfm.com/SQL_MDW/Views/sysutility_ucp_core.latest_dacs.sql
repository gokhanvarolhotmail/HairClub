/* CreateDate: 01/03/2014 07:07:53.793 , ModifyDate: 01/03/2014 07:07:53.793 */
GO
CREATE VIEW [sysutility_ucp_core].[latest_dacs]
AS
   SELECT
      dac_id,
      server_instance_name,
      dac_name,
      physical_server_name,
      dac_deploy_date,
      dac_description,
      urn,
      powershell_path,
      processing_time,
      batch_time,
      dac_percent_total_cpu_utilization
      FROM [sysutility_ucp_core].[dacs_internal] S
      WHERE S.processing_time =  (SELECT latest_processing_time FROM [msdb].[dbo].[sysutility_ucp_processing_state_internal])
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'latest_dacs'
GO
