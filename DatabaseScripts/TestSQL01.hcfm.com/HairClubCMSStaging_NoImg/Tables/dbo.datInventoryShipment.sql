/* CreateDate: 10/04/2010 12:08:45.620 , ModifyDate: 12/03/2021 10:24:48.680 */
GO
CREATE TABLE [dbo].[datInventoryShipment](
	[InventoryShipmentGUID] [uniqueidentifier] NOT NULL,
	[InventoryShipmentTypeID] [int] NOT NULL,
	[InventoryShipmentStatusID] [int] NOT NULL,
	[ShipmentNumber] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[ShipFromVendorID] [int] NULL,
	[ShipFromCenterID] [int] NULL,
	[ShipToVendorID] [int] NULL,
	[ShipToCenterID] [int] NULL,
	[ShipDate] [datetime] NULL,
	[ReceiveDate] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceTotal] [money] NULL,
	[InvoiceCount] [int] NULL,
	[TrackingNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShipmentMethodID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[InvoiceActualTotal] [money] NULL,
	[InvoiceActualCount] [int] NULL,
	[InvoiceVarianceTotal]  AS (isnull([InvoiceTotal],(0))-isnull([InvoiceActualTotal],(0))),
	[InvoiceVarianceCount]  AS (isnull([InvoiceCount],(0))-isnull([InvoiceActualCount],(0))),
 CONSTRAINT [PK_datInventoryShipment] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryShipment_InventoryShipmentTypeID_ShipToCenterID] ON [dbo].[datInventoryShipment]
(
	[InventoryShipmentTypeID] ASC,
	[ShipToCenterID] ASC
)
INCLUDE([InventoryShipmentGUID],[InventoryShipmentStatusID],[ShipmentNumber],[ShipFromVendorID],[ShipFromCenterID],[ShipToVendorID],[ShipDate],[ReceiveDate],[CloseDate],[InvoiceNumber],[InvoiceTotal],[InvoiceCount],[TrackingNumber],[ShipmentMethodID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[InvoiceActualTotal],[InvoiceActualCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryShipment_InvoiceNumber] ON [dbo].[datInventoryShipment]
(
	[InvoiceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryShipment_ShipFromCenterID] ON [dbo].[datInventoryShipment]
(
	[ShipFromCenterID] ASC
)
INCLUDE([CloseDate],[CreateDate],[CreateUser],[InventoryShipmentGUID],[InventoryShipmentStatusID],[InventoryShipmentTypeID],[InvoiceActualCount],[InvoiceActualTotal],[InvoiceCount],[InvoiceNumber],[InvoiceTotal],[LastUpdate],[LastUpdateUser],[ReceiveDate],[ShipDate],[ShipFromVendorID],[ShipmentMethodID],[ShipmentNumber],[ShipToCenterID],[ShipToVendorID],[TrackingNumber],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryShipment_ShipToCenterID] ON [dbo].[datInventoryShipment]
(
	[ShipToCenterID] ASC
)
INCLUDE([CloseDate],[CreateDate],[CreateUser],[InventoryShipmentGUID],[InventoryShipmentStatusID],[InventoryShipmentTypeID],[InvoiceActualCount],[InvoiceActualTotal],[InvoiceCount],[InvoiceNumber],[InvoiceTotal],[LastUpdate],[LastUpdateUser],[ReceiveDate],[ShipDate],[ShipFromCenterID],[ShipFromVendorID],[ShipmentMethodID],[ShipmentNumber],[ShipToVendorID],[TrackingNumber],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInventoryShipment] ADD  DEFAULT ((0)) FOR [InvoiceActualTotal]
GO
ALTER TABLE [dbo].[datInventoryShipment] ADD  DEFAULT ((0)) FOR [InvoiceActualCount]
GO
ALTER TABLE [dbo].[datInventoryShipment]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryShipment_cfgCenter] FOREIGN KEY([ShipFromCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInventoryShipment] CHECK CONSTRAINT [FK_datInventoryShipment_cfgCenter]
GO
ALTER TABLE [dbo].[datInventoryShipment]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryShipment_cfgCenter1] FOREIGN KEY([ShipToCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInventoryShipment] CHECK CONSTRAINT [FK_datInventoryShipment_cfgCenter1]
GO
ALTER TABLE [dbo].[datInventoryShipment]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryShipment_cfgVendor] FOREIGN KEY([ShipFromVendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[datInventoryShipment] CHECK CONSTRAINT [FK_datInventoryShipment_cfgVendor]
GO
ALTER TABLE [dbo].[datInventoryShipment]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryShipment_cfgVendor1] FOREIGN KEY([ShipToVendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[datInventoryShipment] CHECK CONSTRAINT [FK_datInventoryShipment_cfgVendor1]
GO
ALTER TABLE [dbo].[datInventoryShipment]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryShipment_lkpInventoryShipmentStatus] FOREIGN KEY([InventoryShipmentStatusID])
REFERENCES [dbo].[lkpInventoryShipmentStatus] ([InventoryShipmentStatusID])
GO
ALTER TABLE [dbo].[datInventoryShipment] CHECK CONSTRAINT [FK_datInventoryShipment_lkpInventoryShipmentStatus]
GO
ALTER TABLE [dbo].[datInventoryShipment]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryShipment_lkpInventoryShipmentType] FOREIGN KEY([InventoryShipmentTypeID])
REFERENCES [dbo].[lkpInventoryShipmentType] ([InventoryShipmentTypeID])
GO
ALTER TABLE [dbo].[datInventoryShipment] CHECK CONSTRAINT [FK_datInventoryShipment_lkpInventoryShipmentType]
GO
ALTER TABLE [dbo].[datInventoryShipment]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryShipment_lkpShipmentMethod] FOREIGN KEY([ShipmentMethodID])
REFERENCES [dbo].[lkpShipmentMethod] ([ShipmentMethodID])
GO
ALTER TABLE [dbo].[datInventoryShipment] CHECK CONSTRAINT [FK_datInventoryShipment_lkpShipmentMethod]
GO
