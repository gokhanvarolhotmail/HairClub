/* CreateDate: 09/23/2019 12:30:42.003 , ModifyDate: 12/03/2021 10:24:48.677 */
GO
CREATE TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized](
	[SerializedInventoryAuditTransactionSerializedID] [int] IDENTITY(1,1) NOT NULL,
	[SerializedInventoryAuditTransactionID] [int] NOT NULL,
	[SerialNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsInTransit] [bit] NOT NULL,
	[SerializedInventoryStatusID] [int] NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InventoryNotScannedReasonID] [int] NULL,
	[InventoryNotScannedNote] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsScannedEntry] [bit] NULL,
	[ScannedDate] [datetime] NULL,
	[ScannedEmployeeGUID] [uniqueidentifier] NULL,
	[ScannedCenterID] [int] NULL,
	[ScannedSerializedInventoryAuditBatchID] [int] NULL,
	[DeviceAddedAfterSnapshotTaken] [bit] NOT NULL,
	[InventoryAdjustmentIdAtTimeOfSnapshot] [int] NULL,
	[IsExcludedFromCorrections] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSerializedInventoryAuditTransactionSerialized] PRIMARY KEY CLUSTERED
(
	[SerializedInventoryAuditTransactionSerializedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_cfgCenter] FOREIGN KEY([ScannedCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_cfgCenter]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datEmployee] FOREIGN KEY([ScannedEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datEmployee]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datInventoryAdjustment] FOREIGN KEY([InventoryAdjustmentIdAtTimeOfSnapshot])
REFERENCES [dbo].[datInventoryAdjustment] ([InventoryAdjustmentID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datInventoryAdjustment]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datSerializedInventoryAuditBatch] FOREIGN KEY([ScannedSerializedInventoryAuditBatchID])
REFERENCES [dbo].[datSerializedInventoryAuditBatch] ([SerializedInventoryAuditBatchID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datSerializedInventoryAuditBatch]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datSerializedInventoryAuditTransaction] FOREIGN KEY([SerializedInventoryAuditTransactionID])
REFERENCES [dbo].[datSerializedInventoryAuditTransaction] ([SerializedInventoryAuditTransactionID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_datSerializedInventoryAuditTransaction]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_lkpInventoryNotScannedReason] FOREIGN KEY([InventoryNotScannedReasonID])
REFERENCES [dbo].[lkpInventoryNotScannedReason] ([InventoryNotScannedReasonID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_lkpInventoryNotScannedReason]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_lkpSerializedInventoryStatus] FOREIGN KEY([SerializedInventoryStatusID])
REFERENCES [dbo].[lkpSerializedInventoryStatus] ([SerializedInventoryStatusID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransactionSerialized_lkpSerializedInventoryStatus]
GO
