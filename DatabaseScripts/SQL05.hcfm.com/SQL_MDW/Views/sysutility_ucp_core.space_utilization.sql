/* CreateDate: 01/03/2014 07:07:54.253 , ModifyDate: 01/03/2014 07:07:54.253 */
GO
CREATE VIEW [sysutility_ucp_core].[space_utilization]
AS
  SELECT aggregation_type,
         processing_time,
         object_type,
         virtual_server_name,
         volume_device_id,
         server_instance_name,
         database_name,
         [filegroup_name],
         dbfile_name,
         total_space_bytes,
         allocated_space_bytes,
         used_space_bytes,
         available_space_bytes
  FROM [sysutility_ucp_core].[space_utilization_internal]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'space_utilization'
GO
