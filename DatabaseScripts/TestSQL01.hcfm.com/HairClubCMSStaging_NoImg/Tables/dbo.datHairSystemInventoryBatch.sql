/* CreateDate: 05/31/2016 07:49:04.927 , ModifyDate: 01/04/2022 10:56:36.947 */
GO
CREATE TABLE [dbo].[datHairSystemInventoryBatch](
	[HairSystemInventoryBatchID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemInventorySnapshotID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[HairSystemInventoryBatchStatusID] [int] NOT NULL,
	[ScanCompleteDate] [datetime] NULL,
	[ScanCompleteEmployeeGUID] [uniqueidentifier] NULL,
	[IsAdjustmentCompleted] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datHairSystemInventoryBatch] PRIMARY KEY CLUSTERED
(
	[HairSystemInventoryBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch] ADD  CONSTRAINT [DF_datHairSystemInventoryBatch_HairSystemInventorySnapshotID]  DEFAULT ((1)) FOR [HairSystemInventorySnapshotID]
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch] ADD  CONSTRAINT [DF_datHairSystemInventoryBatch_IsAdjustmentCompleted]  DEFAULT ((0)) FOR [IsAdjustmentCompleted]
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryBatch_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch] CHECK CONSTRAINT [FK_datHairSystemInventoryBatch_cfgCenter]
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryBatch_datEmployee] FOREIGN KEY([ScanCompleteEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch] CHECK CONSTRAINT [FK_datHairSystemInventoryBatch_datEmployee]
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryBatch_datHairSystemInventoryBatch] FOREIGN KEY([HairSystemInventoryBatchID])
REFERENCES [dbo].[datHairSystemInventoryBatch] ([HairSystemInventoryBatchID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch] CHECK CONSTRAINT [FK_datHairSystemInventoryBatch_datHairSystemInventoryBatch]
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryBatch_datHairSystemInventorySnapshot] FOREIGN KEY([HairSystemInventorySnapshotID])
REFERENCES [dbo].[datHairSystemInventorySnapshot] ([HairSystemInventorySnapshotID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch] CHECK CONSTRAINT [FK_datHairSystemInventoryBatch_datHairSystemInventorySnapshot]
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryBatch_lkpHairSystemInventoryBatchStatus] FOREIGN KEY([HairSystemInventoryBatchStatusID])
REFERENCES [dbo].[lkpHairSystemInventoryBatchStatus] ([HairSystemInventoryBatchStatusID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryBatch] CHECK CONSTRAINT [FK_datHairSystemInventoryBatch_lkpHairSystemInventoryBatchStatus]
GO
