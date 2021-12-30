/* CreateDate: 08/07/2018 23:38:54.037 , ModifyDate: 08/07/2018 23:38:54.037 */
GO
CREATE TABLE [dbo].[IndexesProcessed201808](
	[DatabaseName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchemaName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IndexName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumRows] [int] NULL,
	[FirstRun] [datetime] NULL,
	[LastRun] [datetime] NULL
) ON [PRIMARY]
GO
