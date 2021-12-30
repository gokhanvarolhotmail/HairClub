/* CreateDate: 01/03/2014 07:07:53.983 , ModifyDate: 01/03/2014 07:07:53.983 */
GO
CREATE TABLE [sysutility_ucp_core].[datafiles_internal](
	[urn] [nvarchar](1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[powershell_path] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processing_time] [datetimeoffset](7) NOT NULL,
	[batch_time] [datetimeoffset](7) NULL,
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[database_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[filegroup_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_urn] [nvarchar](780) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[volume_name] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[volume_device_id] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Growth] [real] NULL,
	[GrowthType] [smallint] NULL,
	[MaxSize] [real] NULL,
	[Name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Size] [real] NULL,
	[UsedSpace] [real] NULL,
	[FileName] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VolumeFreeSpace] [bigint] NULL,
 CONSTRAINT [PK_datafiles_internal] PRIMARY KEY CLUSTERED
(
	[processing_time] ASC,
	[server_instance_name] ASC,
	[database_name] ASC,
	[filegroup_name] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'DIMENSION' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'datafiles_internal'
GO
