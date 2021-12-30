/* CreateDate: 05/03/2010 12:19:26.550 , ModifyDate: 03/22/2017 21:16:22.240 */
GO
CREATE TABLE [bief_meta].[AuditPkgExecution](
	[PkgExecKey] [int] IDENTITY(1,1) NOT NULL,
	[ParentPkgExecKey] [int] NULL,
	[BatchExecKey] [int] NULL,
	[DateKey]  AS (CONVERT([int],CONVERT([char](8),[ExecStartDT],(112)),(0))) PERSISTED,
	[TimeOfDayKey]  AS (((3600)*datepart(hour,[ExecStartDT])+(60)*datepart(minute,[ExecStartDT]))+datepart(second,[ExecStartDT])) PERSISTED,
	[ExecutionInstanceGUID] [uniqueidentifier] NULL,
	[PkgName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PkgGUID] [uniqueidentifier] NULL,
	[PkgVersionGUID] [uniqueidentifier] NULL,
	[PkgVersionMajor] [smallint] NULL,
	[PkgVersionMinor] [smallint] NULL,
	[ExecStartDT] [datetime] NULL,
	[ExecStopDT] [datetime] NULL,
	[PkgDuration] [int] NULL,
	[ExecDuration_sec]  AS (datediff(second,[ExecStartDT],[ExecStopDT])) PERSISTED,
	[ExecDuration_msec]  AS (datediff(millisecond,[ExecStartDT],[ExecStopDT])) PERSISTED,
	[ExecDuration_min]  AS (datediff(minute,[ExecStartDT],[ExecStopDT])) PERSISTED,
	[Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusDT] [datetime] NULL,
 CONSTRAINT [PK_AuditPkgExecution] PRIMARY KEY CLUSTERED
(
	[PkgExecKey] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bief_meta].[AuditPkgExecution]  WITH CHECK ADD  CONSTRAINT [FK_AuditPkgExecution_ParentPkgExecKey] FOREIGN KEY([ParentPkgExecKey])
REFERENCES [bief_meta].[AuditPkgExecution] ([PkgExecKey])
GO
ALTER TABLE [bief_meta].[AuditPkgExecution] CHECK CONSTRAINT [FK_AuditPkgExecution_ParentPkgExecKey]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgExecKey' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3.' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Link to the row for the master package execution that called this package' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ParentPkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'ParentPkgExecKey' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ParentPkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ParentPkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'FK To', @value=N'AuditPkgExecution.PkgExecKey' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ParentPkgExecKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the package' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgName' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Dim_Product_ETL' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'GUID for the package' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgGUID'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgGUID' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgGUID'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Package version GUID' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionGUID'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgVersionGUID' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionGUID'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Package major version' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionMajor'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgVersionMajor' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionMajor'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionMajor'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Package minor version' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionMinor'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgVersionMinor' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionMinor'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'PkgVersionMinor'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Datetime package execution began' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ExecStartDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExecStartDT' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ExecStartDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Datetime package execution ended' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ExecStopDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExecStopDT' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'ExecStopDT'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Status of package execution' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Active, Complete, Failed' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Receives a row each time an Integration Services package is executed' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'AuditPkgExecution' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'Table Type', @value=N'Audit' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'Used in schemas', @value=N'All' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution'
GO
EXEC sys.sp_addextendedproperty @name=N'View Name', @value=N'vw_AuditPkgExecution' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditPkgExecution'
GO
