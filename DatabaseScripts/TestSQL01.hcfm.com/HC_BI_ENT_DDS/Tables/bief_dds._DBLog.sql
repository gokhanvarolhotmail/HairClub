/* CreateDate: 05/03/2010 12:08:47.520 , ModifyDate: 09/16/2019 09:25:18.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bief_dds].[_DBLog](
	[DBLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
