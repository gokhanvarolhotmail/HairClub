/* CreateDate: 01/03/2014 07:07:46.620 , ModifyDate: 01/03/2014 07:07:46.620 */
GO
CREATE TABLE [core].[performance_counter_report_group_items](
	[counter_group_item_id] [int] IDENTITY(1,1) NOT NULL,
	[counter_group_id] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[counter_subgroup_id] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[series_name] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_name] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_name_wildcards] [bit] NOT NULL,
	[counter_name] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[instance_name] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[not_instance_name] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[multiply_by] [numeric](28, 10) NOT NULL,
	[divide_by_cpu_count] [bit] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[counter_group_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
