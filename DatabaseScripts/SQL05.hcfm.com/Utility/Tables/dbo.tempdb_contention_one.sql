/* CreateDate: 09/19/2014 23:49:23.790 , ModifyDate: 09/19/2014 23:49:23.790 */
GO
CREATE TABLE [dbo].[tempdb_contention_one](
	[Run Date] [datetime] NOT NULL,
	[Server Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_id] [smallint] NULL,
	[wait_type] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wait_duration_ms] [bigint] NULL,
	[blocking_session_id] [smallint] NULL,
	[resource_description] [nvarchar](3072) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResourceType] [varchar](29) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
