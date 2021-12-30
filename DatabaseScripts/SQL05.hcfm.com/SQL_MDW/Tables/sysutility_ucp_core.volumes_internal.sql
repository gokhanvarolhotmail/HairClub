/* CreateDate: 01/03/2014 07:07:53.837 , ModifyDate: 01/03/2014 07:07:53.837 */
GO
CREATE TABLE [sysutility_ucp_core].[volumes_internal](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[virtual_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[volume_device_id] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[volume_name] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[total_space_available] [real] NULL,
	[free_space] [real] NULL,
	[processing_time] [datetimeoffset](7) NOT NULL,
	[batch_time] [datetimeoffset](7) NULL,
	[powershell_path] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_volumes_internal] PRIMARY KEY CLUSTERED
(
	[processing_time] ASC,
	[physical_server_name] ASC,
	[volume_device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'DIMENSION' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'volumes_internal'
GO
