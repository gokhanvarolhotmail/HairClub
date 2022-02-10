/* CreateDate: 02/10/2022 10:04:02.407 , ModifyDate: 02/10/2022 10:04:02.637 */
GO
CREATE TABLE [Admin].[DDLLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SchemaName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ObjectName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ObjectID] [int] NULL,
	[PostTime] [datetime] NOT NULL,
	[HostName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ApplicationName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SystemUser] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LoginName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ObjectType] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EventType] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SPID] [int] NOT NULL,
	[ServerName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DatabaseName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CommandText] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_ADMIN_CREATE_TABLE_LOG] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1],
 CONSTRAINT [UNIQUE_ADMIN_CREATE_TABLE_LOG] UNIQUE NONCLUSTERED
(
	[SchemaName] ASC,
	[ObjectName] ASC,
	[PostTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1] TEXTIMAGE_ON [FG1]
GO
