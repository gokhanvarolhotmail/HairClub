/* CreateDate: 12/31/2010 13:21:01.047 , ModifyDate: 04/01/2021 08:10:05.453 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datHairSystemOrderTransaction](
	[HairSystemOrderTransactionGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NOT NULL,
	[ClientHomeCenterID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderTransactionDate] [datetime] NOT NULL,
	[HairSystemOrderProcessID] [int] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[PreviousCenterID] [int] NULL,
	[PreviousClientMembershipGUID] [uniqueidentifier] NULL,
	[PreviousHairSystemOrderStatusID] [int] NULL,
	[NewHairSystemOrderStatusID] [int] NULL,
	[InventoryShipmentDetailGUID] [uniqueidentifier] NULL,
	[InventoryTransferRequestGUID] [uniqueidentifier] NULL,
	[PurchaseOrderDetailGUID] [uniqueidentifier] NULL,
	[CostContract] [money] NOT NULL,
	[PreviousCostContract] [money] NOT NULL,
	[CostContractAdjustment]  AS ([CostContract]-[PreviousCostContract]),
	[CostActual] [money] NOT NULL,
	[PreviousCostActual] [money] NOT NULL,
	[CostCostActual]  AS ([CostActual]-[PreviousCostActual]),
	[CenterPrice] [money] NOT NULL,
	[PreviousCenterPrice] [money] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[CostFactoryShipped] [money] NOT NULL,
	[PreviousCostFactoryShipped] [money] NOT NULL,
	[CostFactoryShippedAdjustment]  AS ([CostFactoryShipped]-[PreviousCostFactoryShipped]),
	[CenterPriceAdjustment]  AS ([CenterPrice]-[PreviousCenterPrice]),
	[SalesOrderDetailGuid] [uniqueidentifier] NULL,
	[HairSystemOrderPriorityReasonID] [int] NULL,
 CONSTRAINT [PK_datHairSystemOrderTransaction] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderTransactionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_NewHairSystemOrderStatusID] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderGUID] ASC,
	[NewHairSystemOrderStatusID] ASC
)
INCLUDE([HairSystemOrderTransactionDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrderTrans_NewHairSystemOrderStatusID_IncludeClientGUID_Date] ON [dbo].[datHairSystemOrderTransaction]
(
	[NewHairSystemOrderStatusID] ASC
)
INCLUDE([ClientGUID],[HairSystemOrderTransactionDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrderTransaction_HairSystemOrderTransactionDate] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderTransactionDate] ASC
)
INCLUDE([HairSystemOrderTransactionGUID],[CenterID],[ClientMembershipGUID],[HairSystemOrderProcessID],[HairSystemOrderGUID],[InventoryShipmentDetailGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrderTransaction_HSOTrxDateINCL] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderTransactionDate] ASC
)
INCLUDE([CenterID],[HairSystemOrderProcessID],[HairSystemOrderGUID],[PreviousCenterID],[PreviousHairSystemOrderStatusID],[NewHairSystemOrderStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_datHairSystemOrderTransaction_ClientHomeCenterID_HairSystemOrderTransactionDate] ON [dbo].[datHairSystemOrderTransaction]
(
	[ClientHomeCenterID] ASC,
	[HairSystemOrderTransactionDate] ASC
)
INCLUDE([ClientGUID],[ClientMembershipGUID],[HairSystemOrderProcessID],[HairSystemOrderGUID],[PreviousHairSystemOrderStatusID],[NewHairSystemOrderStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_datHairSystemOrderTransaction_HairSystemOrderTransactionDate_HairSystemOrderProcessID] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderTransactionDate] ASC,
	[HairSystemOrderProcessID] ASC
)
INCLUDE([ClientHomeCenterID],[ClientGUID],[ClientMembershipGUID],[HairSystemOrderGUID],[PreviousHairSystemOrderStatusID],[NewHairSystemOrderStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrderTransaction_HairSystemOrderTransactionDate_HairSystemOrderProcessID_INCLCCHPN] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderTransactionDate] ASC,
	[HairSystemOrderProcessID] ASC
)
INCLUDE([ClientHomeCenterID],[ClientGUID],[HairSystemOrderGUID],[PreviousHairSystemOrderStatusID],[NewHairSystemOrderStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [CostContract]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [PreviousCostContract]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [CostActual]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [PreviousCostActual]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [CenterPrice]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [PreviousCenterPrice]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [CostFactoryShipped]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] ADD  DEFAULT ((0)) FOR [PreviousCostFactoryShipped]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_cfgCenter]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_cfgCenter_ClientHomeCenterID] FOREIGN KEY([ClientHomeCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_cfgCenter_ClientHomeCenterID]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_cfgCenter_PreviousCenterID] FOREIGN KEY([PreviousCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_cfgCenter_PreviousCenterID]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datClient]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership_PreviousClientMembershipGUID] FOREIGN KEY([PreviousClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership_PreviousClientMembershipGUID]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datEmployee]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datInventoryShipmentDetail] FOREIGN KEY([InventoryShipmentDetailGUID])
REFERENCES [dbo].[datInventoryShipmentDetail] ([InventoryShipmentDetailGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datInventoryShipmentDetail]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datInventoryTransferRequest] FOREIGN KEY([InventoryTransferRequestGUID])
REFERENCES [dbo].[datInventoryTransferRequest] ([InventoryTransferRequestGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datInventoryTransferRequest]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datPurchaseOrderDetail] FOREIGN KEY([PurchaseOrderDetailGUID])
REFERENCES [dbo].[datPurchaseOrderDetail] ([PurchaseOrderDetailGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datPurchaseOrderDetail]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datSalesOrderDetail] FOREIGN KEY([SalesOrderDetailGuid])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datSalesOrderDetail]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderPriorityReason] FOREIGN KEY([HairSystemOrderPriorityReasonID])
REFERENCES [dbo].[lkpHairSystemOrderPriorityReason] ([HairSystemOrderPriorityReasonID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderPriorityReason]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderProcess] FOREIGN KEY([HairSystemOrderProcessID])
REFERENCES [dbo].[lkpHairSystemOrderProcess] ([HairSystemOrderProcessID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderProcess]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderStatus_NewHairSystemOrderStatusID] FOREIGN KEY([NewHairSystemOrderStatusID])
REFERENCES [dbo].[lkpHairSystemOrderStatus] ([HairSystemOrderStatusID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderStatus_NewHairSystemOrderStatusID]
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderStatus_PreviousHairSystemOrderStatusID] FOREIGN KEY([PreviousHairSystemOrderStatusID])
REFERENCES [dbo].[lkpHairSystemOrderStatus] ([HairSystemOrderStatusID])
GO
ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_lkpHairSystemOrderStatus_PreviousHairSystemOrderStatusID]
GO
