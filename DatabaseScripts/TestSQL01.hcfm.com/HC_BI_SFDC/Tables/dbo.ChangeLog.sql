/* CreateDate: 04/24/2018 16:13:25.950 , ModifyDate: 01/21/2022 14:26:44.780 */
GO
CREATE TABLE [dbo].[ChangeLog](
	[ChangeLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SessionID] [uniqueidentifier] NULL,
	[ObjectName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ObjectKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ColumnName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OldValue] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewValue] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ChangeLog] PRIMARY KEY CLUSTERED
(
	[ChangeLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_ChangeLog_SessionID] ON [dbo].[ChangeLog]
(
	[SessionID] ASC,
	[ObjectName] ASC,
	[OldValue] ASC,
	[NewValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChangeLog] ADD  CONSTRAINT [DF_ChangeLog_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[ChangeLog] ADD  CONSTRAINT [DF_ChangeLog_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
