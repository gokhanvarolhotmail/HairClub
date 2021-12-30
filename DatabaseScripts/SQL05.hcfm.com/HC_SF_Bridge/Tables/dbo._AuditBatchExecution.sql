/* CreateDate: 10/27/2017 09:37:09.857 , ModifyDate: 10/27/2017 09:37:13.480 */
GO
CREATE TABLE [dbo].[_AuditBatchExecution](
	[BatchExecKey] [int] IDENTITY(1,1) NOT NULL,
	[DateKey]  AS (CONVERT([int],CONVERT([char](8),[ExecStartDT],(112)),(0))) PERSISTED,
	[TimeOfDayKey]  AS (((3600)*datepart(hour,[ExecStartDT])+(60)*datepart(minute,[ExecStartDT]))+datepart(second,[ExecStartDT])) PERSISTED,
	[ExecutionInstanceGUID] [uniqueidentifier] NULL,
	[ApplicationName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EnvironmentName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExecStartDT] [datetime] NULL,
	[ExecStopDT] [datetime] NULL,
	[BatchDuration] [int] NULL,
	[ExecDuration_sec]  AS (datediff(second,[ExecStartDT],[ExecStopDT])) PERSISTED,
	[ExecDuration_min]  AS (datediff(minute,[ExecStartDT],[ExecStopDT])) PERSISTED,
	[Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusDT] [datetime] NULL,
 CONSTRAINT [PK__AuditBatchExecution] PRIMARY KEY CLUSTERED
(
	[BatchExecKey] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'BatchExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'BatchExecKey' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'BatchExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'BatchExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the environment' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'EnvironmentName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Environment Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'EnvironmentName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Development, Production, Test' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'EnvironmentName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Datetime batch execution began' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'ExecStartDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExecStartDT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'ExecStartDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Datetime batch execution ended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'ExecStopDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExecStopDT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'ExecStopDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Status of batch execution' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Active, Complete, Failed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Receives a row each time an Integration Services package is executed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'_AuditBatchExecution' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'Table Type', @value=N'Audit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'Used in schemas', @value=N'All' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'View Name', @value=N'vw__AuditBatchExecution' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_AuditBatchExecution'
GO
