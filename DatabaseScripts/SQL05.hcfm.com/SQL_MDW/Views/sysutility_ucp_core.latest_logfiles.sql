/* CreateDate: 01/03/2014 07:07:54.103 , ModifyDate: 01/03/2014 07:07:54.103 */
GO
CREATE VIEW [sysutility_ucp_core].[latest_logfiles]
AS
 SELECT [urn]
        , [powershell_path]
        , [processing_time]
        , [batch_time]
        , [server_instance_name]
        , [database_name]
        , [parent_urn]
        , [physical_server_name]
        , [volume_name]
        , [volume_device_id]
        , [Growth]
        , [GrowthType]
        , [MaxSize]
        , [Name]
        , [Size]
        , [UsedSpace]
        , [FileName]
        , [VolumeFreeSpace]
        , [sysutility_ucp_misc].[fn_get_max_size_available]([Size], [MaxSize], [Growth], [GrowthType], [VolumeFreeSpace]) AS [available_space]
        FROM [sysutility_ucp_core].[logfiles_internal] AS SI
        WHERE SI.processing_time =  (SELECT latest_processing_time FROM [msdb].[dbo].[sysutility_ucp_processing_state_internal])
            -- Suppress for "not available" databases (state=1). We lack full filegroup/file hierarchy metadata for these databases.
            AND EXISTS (
                SELECT * FROM sysutility_ucp_core.latest_databases AS db
                WHERE db.server_instance_name = SI.server_instance_name AND db.Name = SI.database_name AND db.state = 0)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'latest_logfiles'
GO
