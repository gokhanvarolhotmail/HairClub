/* CreateDate: 01/03/2014 07:07:47.347 , ModifyDate: 01/03/2014 07:07:47.700 */
GO
CREATE TABLE [snapshots].[trace_data](
	[trace_info_id] [int] NOT NULL,
	[snapshot_id] [int] NOT NULL,
	[TextData] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BinaryData] [varbinary](max) NULL,
	[DatabaseID] [int] NULL,
	[TransactionID] [bigint] NULL,
	[LineNumber] [int] NULL,
	[NTUserName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NTDomainName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HostName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientProcessID] [int] NULL,
	[ApplicationName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SPID] [int] NULL,
	[Duration] [bigint] NULL,
	[StartTime] [datetimeoffset](7) NULL,
	[EndTime] [datetimeoffset](7) NULL,
	[Reads] [bigint] NULL,
	[Writes] [bigint] NULL,
	[CPU] [int] NULL,
	[Permissions] [bigint] NULL,
	[Severity] [int] NULL,
	[EventSubClass] [int] NULL,
	[ObjectID] [int] NULL,
	[Success] [int] NULL,
	[IndexID] [int] NULL,
	[IntegerData] [int] NULL,
	[ServerName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EventClass] [int] NULL,
	[ObjectType] [int] NULL,
	[NestLevel] [int] NULL,
	[State] [int] NULL,
	[Error] [int] NULL,
	[Mode] [int] NULL,
	[Handle] [int] NULL,
	[ObjectName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RoleName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TargetUserName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DBUserName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginSid] [varbinary](max) NULL,
	[TargetLoginName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TargetLoginSid] [varbinary](max) NULL,
	[ColumnPermissions] [int] NULL,
	[LinkedServerName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProviderName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MethodName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RowCounts] [bigint] NULL,
	[RequestID] [int] NULL,
	[XactSequence] [bigint] NULL,
	[EventSequence] [bigint] NOT NULL,
	[BigintData1] [bigint] NULL,
	[BigintData2] [bigint] NULL,
	[GUID] [uniqueidentifier] NULL,
	[IntegerData2] [int] NULL,
	[ObjectID2] [bigint] NULL,
	[Type] [int] NULL,
	[OwnerID] [int] NULL,
	[ParentName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSystem] [int] NULL,
	[Offset] [int] NULL,
	[SourceDatabaseID] [int] NULL,
	[SqlHandle] [varbinary](64) NULL,
	[SessionLoginName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanHandle] [varbinary](64) NULL,
	[GroupID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IDX_trace_data_EventSequence] ON [snapshots].[trace_data]
(
	[snapshot_id] ASC,
	[EventSequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_trace_data_StartTime_EventClass] ON [snapshots].[trace_data]
(
	[StartTime] ASC,
	[EventClass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_trace_data_trace_info_id] ON [snapshots].[trace_data]
(
	[trace_info_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[trace_data]  WITH CHECK ADD  CONSTRAINT [FK_trace_data_snapshot_id] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[trace_data] CHECK CONSTRAINT [FK_trace_data_snapshot_id]
GO
ALTER TABLE [snapshots].[trace_data]  WITH CHECK ADD  CONSTRAINT [FK_trace_data_trace_info_id] FOREIGN KEY([trace_info_id])
REFERENCES [snapshots].[trace_info] ([trace_info_id])
GO
ALTER TABLE [snapshots].[trace_data] CHECK CONSTRAINT [FK_trace_data_trace_info_id]
GO
ALTER TABLE [snapshots].[trace_data]  WITH CHECK ADD  CONSTRAINT [CHK_trace_data_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[trace_data] CHECK CONSTRAINT [CHK_trace_data_check_operator]
GO
