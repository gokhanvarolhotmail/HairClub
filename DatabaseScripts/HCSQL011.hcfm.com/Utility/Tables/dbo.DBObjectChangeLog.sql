/* CreateDate: 12/21/2014 20:56:49.380 , ModifyDate: 12/21/2014 20:56:49.380 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBObjectChangeLog](
	[Run Time] [datetime] NOT NULL,
	[Server Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DBNameFromID] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartTime] [datetime] NULL,
	[Event Class Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Event SubClass Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectTypeDesc] [varchar](58) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ObjectID] [int] NULL,
	[ObjectName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HostName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NTDomainName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NTUserName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SessionLoginName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Server Principal Name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
