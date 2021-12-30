/* CreateDate: 01/03/2014 07:07:46.780 , ModifyDate: 01/03/2014 07:07:46.870 */
GO
CREATE TABLE [snapshots].[performance_counter_instances](
	[performance_counter_id] [int] IDENTITY(1,1) NOT NULL,
	[path] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_name] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[counter_name] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[instance_name] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[counter_type] [int] NOT NULL,
 CONSTRAINT [PK_performance_counter_instances] PRIMARY KEY CLUSTERED
(
	[performance_counter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UN_performance_counter_path] UNIQUE NONCLUSTERED
(
	[path] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_performance_counter_instances1] ON [snapshots].[performance_counter_instances]
(
	[object_name] ASC,
	[counter_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
