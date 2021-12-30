/* CreateDate: 05/03/2010 12:19:13.020 , ModifyDate: 05/03/2010 12:19:13.367 */
GO
CREATE TABLE [bief_dq].[_DBLog](
	[DBLogID] [int] IDENTITY(1,1) NOT NULL,
	[PostTime] [datetime] NOT NULL,
	[DatabaseUser] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Event] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Schema] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Object] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TSQL] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[XmlEvent] [xml] NOT NULL,
 CONSTRAINT [PK__DBLog_DBLogID] PRIMARY KEY NONCLUSTERED
(
	[DBLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for _DBLog records.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'DBLogID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time the DDL change occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'PostTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The user who implemented the DDL change.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'DatabaseUser'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of DDL statement that was executed.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'Event'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The schema to which the changed object belongs.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'Schema'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The object that was changed by the DDL statment.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'Object'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The exact Transact-SQL statement that was executed.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'TSQL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The raw XML data generated by database trigger.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog', @level2type=N'COLUMN',@level2name=N'XmlEvent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Audit table tracking all DDL changes made to the Reporting database. Data is captured by the database trigger ddlDatabaseTriggerLog.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBLog'
GO
