/* CreateDate: 01/03/2014 07:07:53.423 , ModifyDate: 01/03/2014 07:07:53.423 */
GO
CREATE TABLE [sysutility_ucp_staging].[consistent_batch_manifests_internal](
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[batch_time] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_consistent_batch_manifests_internal] PRIMARY KEY CLUSTERED
(
	[server_instance_name] ASC,
	[batch_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'STAGING' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_staging', @level1type=N'TABLE',@level1name=N'consistent_batch_manifests_internal'
GO
