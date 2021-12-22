/* CreateDate: 05/03/2010 12:08:47.507 , ModifyDate: 09/16/2019 09:25:18.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bief_dds].[_DBErrorLog](
	[DBErrorLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[UserName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [nvarchar](126) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorDetails] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__DBErrorLog_DBErrorLogID] PRIMARY KEY NONCLUSTERED
(
	[DBErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bief_dds].[_DBErrorLog] ADD  CONSTRAINT [DF__DBErrorLog_ErrorTime]  DEFAULT (getdate()) FOR [ErrorTime]
GO
ALTER TABLE [bief_dds].[_DBErrorLog] ADD  CONSTRAINT [DF__DBErrorLog_ErrorDetails]  DEFAULT ('') FOR [ErrorDetails]
GO
