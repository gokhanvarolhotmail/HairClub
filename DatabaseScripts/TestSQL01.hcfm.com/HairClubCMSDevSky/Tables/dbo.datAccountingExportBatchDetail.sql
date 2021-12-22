/* CreateDate: 12/31/2010 13:21:02.413 , ModifyDate: 12/07/2021 16:20:15.933 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datAccountingExportBatchDetail](
	[AccountingExportBatchDetailGUID] [uniqueidentifier] NOT NULL,
	[AccountingExportBatchGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderTransactionGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[FreightAmount] [money] NULL,
	[InventoryShipmentGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
 CONSTRAINT [PK_datAccountingExportBatchDetail] PRIMARY KEY CLUSTERED
(
	[AccountingExportBatchDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountingExportBatchDetail_AccountExportBatchUID] ON [dbo].[datAccountingExportBatchDetail]
(
	[AccountingExportBatchGUID] ASC,
	[InventoryShipmentGUID] ASC,
	[AccountingExportBatchDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountingExportBatchDetail_AccountingExportBatchGUID_INCLHairSystemOrderTransactionGUID] ON [dbo].[datAccountingExportBatchDetail]
(
	[AccountingExportBatchGUID] ASC
)
INCLUDE([HairSystemOrderTransactionGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountingExportBatchDetail_AcctgExpBatchGUID] ON [dbo].[datAccountingExportBatchDetail]
(
	[AccountingExportBatchGUID] ASC,
	[HairSystemOrderTransactionGUID] ASC
)
INCLUDE([FreightAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountingExportBatchDetail_HairSystemOrderGUID] ON [dbo].[datAccountingExportBatchDetail]
(
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail]  WITH CHECK ADD  CONSTRAINT [FK_datAccountingExportBatchDetail_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail] CHECK CONSTRAINT [FK_datAccountingExportBatchDetail_cfgCenter]
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail]  WITH CHECK ADD  CONSTRAINT [FK_datAccountingExportBatchDetail_datAccountingExportBatch] FOREIGN KEY([AccountingExportBatchGUID])
REFERENCES [dbo].[datAccountingExportBatch] ([AccountingExportBatchGUID])
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail] CHECK CONSTRAINT [FK_datAccountingExportBatchDetail_datAccountingExportBatch]
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail]  WITH CHECK ADD  CONSTRAINT [FK_datAccountingExportBatchDetail_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail] CHECK CONSTRAINT [FK_datAccountingExportBatchDetail_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail]  WITH CHECK ADD  CONSTRAINT [FK_datAccountingExportBatchDetail_datInventoryShipment] FOREIGN KEY([InventoryShipmentGUID])
REFERENCES [dbo].[datInventoryShipment] ([InventoryShipmentGUID])
GO
ALTER TABLE [dbo].[datAccountingExportBatchDetail] CHECK CONSTRAINT [FK_datAccountingExportBatchDetail_datInventoryShipment]
GO
