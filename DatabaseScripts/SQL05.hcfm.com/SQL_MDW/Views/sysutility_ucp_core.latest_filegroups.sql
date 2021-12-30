/* CreateDate: 01/03/2014 07:07:54.080 , ModifyDate: 01/03/2014 07:07:54.080 */
GO
CREATE VIEW [sysutility_ucp_core].[latest_filegroups]
AS
    SELECT [urn]
        , [powershell_path]
        , [processing_time]
        , [batch_time]
        , [server_instance_name]
        , [database_name]
        , [parent_urn]
        , [Name]
        FROM [sysutility_ucp_core].[filegroups_internal] AS SI
        WHERE SI.processing_time =  (SELECT latest_processing_time FROM [msdb].[dbo].[sysutility_ucp_processing_state_internal])
            -- Suppress for "not available" databases (state=1). We lack full filegroup/file hierarchy metadata for these databases.
            AND EXISTS (
                SELECT * FROM sysutility_ucp_core.latest_databases AS db
                WHERE db.server_instance_name = SI.server_instance_name AND db.Name = SI.database_name AND db.state = 0)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'latest_filegroups'
GO
