/* CreateDate: 05/03/2010 12:09:20.120 , ModifyDate: 03/22/2017 21:17:12.633 */
GO
CREATE TABLE [bief_meta].[AuditDataPkgDetail](
	[DataPkgDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NOT NULL,
	[TableName] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TableInitialRowCnt] [bigint] NULL,
	[TableFinalRowCnt] [bigint] NULL,
	[ExtractCnt] [bigint] NULL,
	[CleanupCnt] [bigint] NULL,
	[ExceptionRowCnt] [bigint] NULL,
	[IgnoreRowCnt] [bigint] NULL,
	[InsertRowCnt] [bigint] NULL,
	[UpdateRowCnt] [bigint] NULL,
	[InsertNewRowCnt] [bigint] NULL,
	[InsertInferredRowCnt] [bigint] NULL,
	[InsertSCD2RowCnt] [bigint] NULL,
	[UpdateInferredRowCnt] [bigint] NULL,
	[UpdateSCD1RowCnt] [bigint] NULL,
	[UpdateSCD2RowCnt] [bigint] NULL,
	[DeletedRowCnt] [bigint] NULL,
	[DuplicateRowCnt] [bigint] NULL,
	[HealthyRowCnt] [bigint] NULL,
	[RejectedRowCnt] [bigint] NULL,
	[AllowedRowCnt] [bigint] NULL,
	[FixedRowCnt] [bigint] NULL,
	[IsExtracted] [tinyint] NULL,
	[IsTransformed] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[IsCleanedup] [tinyint] NULL,
	[Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusDT] [datetime] NULL,
	[ExtractionBeginRange] [datetime] NULL,
	[ExtractionEndRange] [datetime] NULL,
	[ExtractionRange_min]  AS (datediff(minute,[ExtractionBeginRange],[ExtractionEndRange])) PERSISTED,
	[ExtractionRange_hour]  AS (datediff(hour,[ExtractionBeginRange],[ExtractionEndRange])) PERSISTED,
	[ExtractStartDT] [datetime] NULL,
	[ExtractStopDT] [datetime] NULL,
	[ExtractDuration_sec]  AS (datediff(second,[ExtractStartDT],[ExtractStopDT])) PERSISTED,
	[ExtractDuration_msec]  AS (datediff(millisecond,[ExtractStartDT],[ExtractStopDT])) PERSISTED,
	[TransformStartDT] [datetime] NULL,
	[TransformStopDT] [datetime] NULL,
	[TransformDuration_sec]  AS (datediff(second,[TransformStartDT],[TransformStopDT])) PERSISTED,
	[TrandformDuration_msec]  AS (datediff(millisecond,[TransformStartDT],[TransformStopDT])) PERSISTED,
	[ValidateStartDT] [datetime] NULL,
	[ValidateStopDT] [datetime] NULL,
	[ValidateDuration_sec]  AS (datediff(second,[ValidateStartDT],[ValidateStopDT])) PERSISTED,
	[ValidateDuration_msec]  AS (datediff(millisecond,[ValidateStartDT],[ValidateStopDT])) PERSISTED,
	[LoadStartDT] [datetime] NULL,
	[LoadStopDT] [datetime] NULL,
	[LoadDuration_sec]  AS (datediff(second,[LoadStartDT],[LoadStopDT])) PERSISTED,
	[LoadDuration_msec]  AS (datediff(millisecond,[LoadStartDT],[LoadStopDT])) PERSISTED,
	[CleanupStartDT] [datetime] NULL,
	[CleanupStopDT] [datetime] NULL,
	[CleanupDuration_sec]  AS (datediff(second,[CleanupStartDT],[CleanupStopDT])) PERSISTED,
	[CleanupDuration_msec]  AS (datediff(millisecond,[CleanupStartDT],[CleanupStopDT])) PERSISTED,
 CONSTRAINT [PK_AuditDataPkgExecution] PRIMARY KEY CLUSTERED
(
	[DataPkgDetailKey] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bief_meta].[AuditDataPkgDetail]  WITH CHECK ADD  CONSTRAINT [FK_AuditDataPkgDetail_AuditDataPkg_DataPkgKey] FOREIGN KEY([DataPkgKey])
REFERENCES [bief_meta].[AuditDataPkg] ([DataPkgKey])
GO
ALTER TABLE [bief_meta].[AuditDataPkgDetail] CHECK CONSTRAINT [FK_AuditDataPkgDetail_AuditDataPkg_DataPkgKey]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail', @level2type=N'COLUMN',@level2name=N'DataPkgDetailKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DataPkgKey' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail', @level2type=N'COLUMN',@level2name=N'DataPkgDetailKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3.' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail', @level2type=N'COLUMN',@level2name=N'DataPkgDetailKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Status of batch execution' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Active, Complete, Failed' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Receives a row each time an Integration Services package is executed' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'AuditDataPkgExecution' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'Table Type', @value=N'Audit' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'AuditDataPkgDetail'
GO
