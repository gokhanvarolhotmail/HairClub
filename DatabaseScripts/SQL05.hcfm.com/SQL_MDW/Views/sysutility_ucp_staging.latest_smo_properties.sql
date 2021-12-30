/* CreateDate: 01/03/2014 07:07:53.533 , ModifyDate: 01/03/2014 07:07:53.533 */
GO
CREATE VIEW [sysutility_ucp_staging].[latest_smo_properties]
AS
   SELECT s.physical_server_name, s.server_instance_name, s.urn, s.object_type,
          s.property_name,s.property_value, s.snapshot_id, s.batch_time
   FROM [snapshots].[sysutility_ucp_smo_properties_internal] AS s
         INNER JOIN [sysutility_ucp_staging].[consistent_batch_manifests_internal] cb
         ON s.server_instance_name = cb.server_instance_name AND s.batch_time = cb.batch_time
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'VIEW',@level1name=N'latest_smo_properties'
GO
