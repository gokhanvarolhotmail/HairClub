/* CreateDate: 01/03/2014 07:07:54.200 , ModifyDate: 01/03/2014 07:07:54.200 */
GO
CREATE VIEW [sysutility_ucp_core].[cpu_utilization]
AS
  SELECT aggregation_type, processing_time, object_type,
         physical_server_name, server_instance_name, database_name,
         percent_total_cpu_utilization
  FROM [sysutility_ucp_core].[cpu_utilization_internal]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'cpu_utilization'
GO
