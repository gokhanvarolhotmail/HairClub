/* CreateDate: 01/03/2014 07:07:53.923 , ModifyDate: 01/03/2014 07:07:53.967 */
GO
CREATE TABLE [sysutility_ucp_core].[databases_internal](
	[urn] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[powershell_path] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processing_time] [datetimeoffset](7) NOT NULL,
	[batch_time] [datetimeoffset](7) NULL,
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_urn] [nvarchar](320) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Collation] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompatibilityLevel] [smallint] NULL,
	[CreateDate] [datetime] NULL,
	[EncryptionEnabled] [bit] NULL,
	[Name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RecoveryModel] [smallint] NULL,
	[Trustworthy] [bit] NULL,
	[state] [tinyint] NULL,
 CONSTRAINT [PK_databases_internal] PRIMARY KEY CLUSTERED
(
	[processing_time] ASC,
	[server_instance_name] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [sysutility_ucp_core].[databases_internal]  WITH CHECK ADD  CONSTRAINT [chk_databases_internal_state] CHECK  (([state]>=(0) AND [state]<=(1)))
GO
ALTER TABLE [sysutility_ucp_core].[databases_internal] CHECK CONSTRAINT [chk_databases_internal_state]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'DIMENSION' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'databases_internal'
GO
