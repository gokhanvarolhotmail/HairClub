/* CreateDate: 10/27/2017 09:37:13.440 , ModifyDate: 10/27/2017 09:37:17.940 */
GO
CREATE TABLE [dbo].[_AuditDataPkg](
	[DataPkgKey] [int] IDENTITY(1,1) NOT NULL,
	[BatchExecKey] [int] NULL,
	[Process] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateKey]  AS (CONVERT([int],CONVERT([char](8),[ExecStartDT],(112)),(0))) PERSISTED,
	[TimeOfDayKey]  AS (((3600)*datepart(hour,[ExecStartDT])+(60)*datepart(minute,[ExecStartDT]))+datepart(second,[ExecStartDT])) PERSISTED,
	[ExecStartDT] [datetime] NULL,
	[ExecStopDT] [datetime] NULL,
	[ExecDuration_sec]  AS (datediff(second,[ExecStartDT],[ExecStopDT])) PERSISTED,
	[ExecDuration_min]  AS (datediff(minute,[ExecStartDT],[ExecStopDT])) PERSISTED,
	[Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusDT] [datetime] NULL,
 CONSTRAINT [PK__AuditDataPkg] PRIMARY KEY CLUSTERED
(
	[DataPkgKey] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[_AuditDataPkg]  WITH CHECK ADD  CONSTRAINT [FK_AuditDataPkg_AuditBatchExecution_BatchExecKey] FOREIGN KEY([BatchExecKey])
REFERENCES [dbo].[_AuditBatchExecution] ([BatchExecKey])
GO
ALTER TABLE [dbo].[_AuditDataPkg] CHECK CONSTRAINT [FK_AuditDataPkg_AuditBatchExecution_BatchExecKey]
GO
