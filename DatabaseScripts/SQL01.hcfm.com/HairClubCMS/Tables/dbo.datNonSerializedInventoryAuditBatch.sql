/* CreateDate: 09/23/2019 12:30:52.687 , ModifyDate: 09/23/2019 12:32:58.603 */
GO
CREATE TABLE [dbo].[datNonSerializedInventoryAuditBatch](
	[NonSerializedInventoryAuditBatchID] [int] IDENTITY(1,1) NOT NULL,
	[NonSerializedInventoryAuditSnapshotID] [int] NOT NULL,
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
 CONSTRAINT [PK_datNonSerializedInventoryAuditBatch] PRIMARY KEY CLUSTERED
(
	[NonSerializedInventoryAuditBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_cfgCenter]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_datEmployee_CompletedByEmployee] FOREIGN KEY([CompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_datEmployee_CompletedByEmployee]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_datEmployee_ReviewedByEmployee] FOREIGN KEY([ReviewCompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_datEmployee_ReviewedByEmployee]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_datNonSerializedInventoryAuditSnapshot] FOREIGN KEY([NonSerializedInventoryAuditSnapshotID])
REFERENCES [dbo].[datNonSerializedInventoryAuditSnapshot] ([NonSerializedInventoryAuditSnapshotID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_datNonSerializedInventoryAuditSnapshot]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_lkpInventoryAuditBatchStatus] FOREIGN KEY([InventoryAuditBatchStatusID])
REFERENCES [dbo].[lkpInventoryAuditBatchStatus] ([InventoryAuditBatchStatusID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditBatch] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditBatch_lkpInventoryAuditBatchStatus]
GO
