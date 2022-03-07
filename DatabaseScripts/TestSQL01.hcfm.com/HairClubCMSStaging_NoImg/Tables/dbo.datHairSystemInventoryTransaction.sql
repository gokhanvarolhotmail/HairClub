/* CreateDate: 05/31/2016 07:49:05.190 , ModifyDate: 03/04/2022 16:09:12.493 */
GO
CREATE TABLE [dbo].[datHairSystemInventoryTransaction](
	[HairSystemInventoryTransactionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemInventoryBatchID] [int] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderStatusID] [int] NOT NULL,
	[IsInTransit] [bit] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[ClientHomeCenterID] [int] NOT NULL,
	[ScannedDate] [datetime] NULL,
	[ScannedEmployeeGUID] [uniqueidentifier] NULL,
	[ScannedCenterID] [int] NULL,
	[ScannedHairSystemInventoryBatchID] [int] NULL,
	[IsExcludedFromCorrections] [bit] NOT NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsScannedEntry] [bit] NOT NULL,
 CONSTRAINT [PK_datHairSystemInventoryTransaction] PRIMARY KEY CLUSTERED
(
	[HairSystemInventoryTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemInventoryTransaction_HairSystemOrderNumber] ON [dbo].[datHairSystemInventoryTransaction]
(
	[HairSystemOrderNumber] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] ADD  DEFAULT ((0)) FOR [IsScannedEntry]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_cfgCenter] FOREIGN KEY([ScannedCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_cfgCenter]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_cfgCenter2] FOREIGN KEY([ClientHomeCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_cfgCenter2]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datClient]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datClientMembership]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datEmployee] FOREIGN KEY([ScannedEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datEmployee]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryBatch] FOREIGN KEY([HairSystemInventoryBatchID])
REFERENCES [dbo].[datHairSystemInventoryBatch] ([HairSystemInventoryBatchID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryBatch]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryBatch_Scanned] FOREIGN KEY([ScannedHairSystemInventoryBatchID])
REFERENCES [dbo].[datHairSystemInventoryBatch] ([HairSystemInventoryBatchID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryBatch_Scanned]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction] FOREIGN KEY([HairSystemInventoryTransactionID])
REFERENCES [dbo].[datHairSystemInventoryTransaction] ([HairSystemInventoryTransactionID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction1] FOREIGN KEY([HairSystemInventoryTransactionID])
REFERENCES [dbo].[datHairSystemInventoryTransaction] ([HairSystemInventoryTransactionID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction1]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction2] FOREIGN KEY([HairSystemInventoryTransactionID])
REFERENCES [dbo].[datHairSystemInventoryTransaction] ([HairSystemInventoryTransactionID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction2]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction3] FOREIGN KEY([HairSystemInventoryTransactionID])
REFERENCES [dbo].[datHairSystemInventoryTransaction] ([HairSystemInventoryTransactionID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemInventoryTransaction3]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemInventoryTransaction_lkpHairSystemOrderStatus] FOREIGN KEY([HairSystemOrderStatusID])
REFERENCES [dbo].[lkpHairSystemOrderStatus] ([HairSystemOrderStatusID])
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] CHECK CONSTRAINT [FK_datHairSystemInventoryTransaction_lkpHairSystemOrderStatus]
GO
