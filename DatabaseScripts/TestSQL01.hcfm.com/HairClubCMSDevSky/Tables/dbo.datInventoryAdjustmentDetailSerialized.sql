/* CreateDate: 05/28/2018 22:15:34.710 , ModifyDate: 02/02/2022 09:26:26.693 */
GO
CREATE TABLE [dbo].[datInventoryAdjustmentDetailSerialized](
	[InventoryAdjustmentDetailSerializedID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryAdjustmentDetailID] [int] NOT NULL,
	[SerialNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NewSerializedInventoryStatusID] [int] NOT NULL,
	[IsScannedEntry] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SerializedInventoryAuditTransactionSerializedID] [int] NULL,
 CONSTRAINT [PK_datInventoryAdjustmentDetailSerialized] PRIMARY KEY CLUSTERED
(
	[InventoryAdjustmentDetailSerializedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryAdjustmentDetailSerialized_SerialNumber] ON [dbo].[datInventoryAdjustmentDetailSerialized]
(
	[SerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetailSerialized]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetailSerialized_datInventoryAdjustmentDetail] FOREIGN KEY([InventoryAdjustmentDetailID])
REFERENCES [dbo].[datInventoryAdjustmentDetail] ([InventoryAdjustmentDetailID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetailSerialized] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetailSerialized_datInventoryAdjustmentDetail]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetailSerialized]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetailSerialized_datSerializedInventoryAuditTransactionSerialized] FOREIGN KEY([SerializedInventoryAuditTransactionSerializedID])
REFERENCES [dbo].[datSerializedInventoryAuditTransactionSerialized] ([SerializedInventoryAuditTransactionSerializedID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetailSerialized] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetailSerialized_datSerializedInventoryAuditTransactionSerialized]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetailSerialized]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetailSerialized_lkpSerializedInventoryStatus] FOREIGN KEY([NewSerializedInventoryStatusID])
REFERENCES [dbo].[lkpSerializedInventoryStatus] ([SerializedInventoryStatusID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetailSerialized] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetailSerialized_lkpSerializedInventoryStatus]
GO
