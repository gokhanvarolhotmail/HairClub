/* CreateDate: 09/23/2019 12:30:41.860 , ModifyDate: 12/29/2021 15:38:46.330 */
GO
CREATE TABLE [dbo].[datSerializedInventoryAuditBatch](
	[SerializedInventoryAuditBatchID] [int] IDENTITY(1,1) NOT NULL,
	[SerializedInventoryAuditSnapshotID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[InventoryAuditBatchStatusID] [int] NOT NULL,
	[CompleteDate] [datetime] NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NULL,
	[IsReviewCompleted] [bit] NOT NULL,
	[ReviewCompleteDate] [datetime] NULL,
	[ReviewCompletedByEmployeeGUID] [uniqueidentifier] NULL,
	[IsAdjustmentCompleted] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSerializedInventoryAuditBatch] PRIMARY KEY CLUSTERED
(
	[SerializedInventoryAuditBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditBatch_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datSerializedInventoryAuditBatch_cfgCenter]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditBatch_datEmployee_CompletedByEmployee] FOREIGN KEY([CompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datSerializedInventoryAuditBatch_datEmployee_CompletedByEmployee]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditBatch_datEmployee_ReviewedByEmployee] FOREIGN KEY([ReviewCompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datSerializedInventoryAuditBatch_datEmployee_ReviewedByEmployee]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditBatch_datSerializedInventoryAuditSnapshot] FOREIGN KEY([SerializedInventoryAuditSnapshotID])
REFERENCES [dbo].[datSerializedInventoryAuditSnapshot] ([SerializedInventoryAuditSnapshotID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datSerializedInventoryAuditBatch_datSerializedInventoryAuditSnapshot]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditBatch_lkpInventoryAuditBatchStatus] FOREIGN KEY([InventoryAuditBatchStatusID])
REFERENCES [dbo].[lkpInventoryAuditBatchStatus] ([InventoryAuditBatchStatusID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datSerializedInventoryAuditBatch_lkpInventoryAuditBatchStatus]
GO
