/* CreateDate: 01/03/2014 07:07:54.070 , ModifyDate: 01/03/2014 07:07:54.070 */
GO
CREATE VIEW [sysutility_ucp_core].[latest_databases]
AS
    SELECT [urn]
        , [powershell_path]
        , [processing_time]
        , [batch_time]
        , [server_instance_name]
        , [parent_urn]
        , [Collation]
        , [CompatibilityLevel]
        , [CreateDate]
        , [EncryptionEnabled]
        , [Name]
        , [RecoveryModel]
        , [Trustworthy]
        , [state]
        FROM [sysutility_ucp_core].[databases_internal] AS SI
        WHERE SI.processing_time =  (SELECT latest_processing_time FROM [msdb].[dbo].[sysutility_ucp_processing_state_internal])
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'CORE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'VIEW',@level1name=N'latest_databases'
GO
