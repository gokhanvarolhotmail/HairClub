/* CreateDate: 10/04/2010 12:08:45.470 , ModifyDate: 01/04/2022 10:56:36.863 */
GO
CREATE TABLE [dbo].[datPurchaseOrder](
	[PurchaseOrderGUID] [uniqueidentifier] NOT NULL,
	[VendorID] [int] NOT NULL,
	[PurchaseOrderDate] [datetime] NULL,
	[PurchaseOrderNumber] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[PurchaseOrderTotal] [money] NULL,
	[PurchaseOrderCount] [int] NULL,
	[PurchaseOrderStatusID] [int] NULL,
	[HairSystemAllocationGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[PurchaseOrderTypeID] [int] NULL,
	[PurchaseOrderNumberOriginal] [int] NULL,
 CONSTRAINT [PK_datPurchaseOrder] PRIMARY KEY CLUSTERED
(
	[PurchaseOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrder_HairSystemAllocationGUID] ON [dbo].[datPurchaseOrder]
(
	[HairSystemAllocationGUID] ASC
)
INCLUDE([PurchaseOrderGUID],[VendorID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrder_PurchaseOrderDate] ON [dbo].[datPurchaseOrder]
(
	[PurchaseOrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrder_VendorID] ON [dbo].[datPurchaseOrder]
(
	[VendorID] ASC
)
INCLUDE([PurchaseOrderGUID],[HairSystemAllocationGUID],[PurchaseOrderTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datPurchaseOrder_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[datPurchaseOrder] CHECK CONSTRAINT [FK_datPurchaseOrder_cfgVendor]
GO
ALTER TABLE [dbo].[datPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datPurchaseOrder_datHairSystemAllocation] FOREIGN KEY([HairSystemAllocationGUID])
REFERENCES [dbo].[datHairSystemAllocation] ([HairSystemAllocationGUID])
GO
ALTER TABLE [dbo].[datPurchaseOrder] CHECK CONSTRAINT [FK_datPurchaseOrder_datHairSystemAllocation]
GO
ALTER TABLE [dbo].[datPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datPurchaseOrder_lkpPurchaseOrderStatus] FOREIGN KEY([PurchaseOrderStatusID])
REFERENCES [dbo].[lkpPurchaseOrderStatus] ([PurchaseOrderStatusID])
GO
ALTER TABLE [dbo].[datPurchaseOrder] CHECK CONSTRAINT [FK_datPurchaseOrder_lkpPurchaseOrderStatus]
GO
ALTER TABLE [dbo].[datPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datPurchaseOrder_lkpPurchaseOrderType] FOREIGN KEY([PurchaseOrderTypeID])
REFERENCES [dbo].[lkpPurchaseOrderType] ([PurchaseOrderTypeID])
GO
ALTER TABLE [dbo].[datPurchaseOrder] CHECK CONSTRAINT [FK_datPurchaseOrder_lkpPurchaseOrderType]
GO
