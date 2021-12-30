/* CreateDate: 01/03/2014 07:07:53.970 , ModifyDate: 01/03/2014 07:07:53.970 */
GO
CREATE TABLE [sysutility_ucp_core].[filegroups_internal](
	[urn] [nvarchar](780) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[powershell_path] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processing_time] [datetimeoffset](7) NOT NULL,
	[batch_time] [datetimeoffset](7) NULL,
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[database_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_urn] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_filegroups_internal] PRIMARY KEY CLUSTERED
(
	[processing_time] ASC,
	[server_instance_name] ASC,
	[database_name] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'DIMENSION' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'filegroups_internal'
GO
