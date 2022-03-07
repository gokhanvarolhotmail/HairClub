/* CreateDate: 10/04/2010 12:08:45.650 , ModifyDate: 03/04/2022 16:09:12.823 */
GO
CREATE TABLE [dbo].[datInventoryShipmentDetail](
	[InventoryShipmentDetailGUID] [uniqueidentifier] NOT NULL,
	[InventoryShipmentGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[InventoryShipmentDetailStatusID] [int] NOT NULL,
	[InventoryTransferRequestGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[InventoryShipmentReasonID] [int] NULL,
	[PriorityTransferFee] [money] NULL,
	[PriorityHairSystemCenterContractPricingID] [int] NULL,
 CONSTRAINT [PK_datInventoryShipmentDetail] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_datInventoryShipmentDetail_HairSystemOrderGUID_InventoryShipmentGUID] ON [dbo].[datInventoryShipmentDetail]
(
	[InventoryShipmentGUID] ASC,
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryShipmentDetail_HairSystemOrderGUID_InventoryShipmentGUID_InventoryShipmentDetailGUID] ON [dbo].[datInventoryShipmentDetail]
(
	[HairSystemOrderGUID] ASC,
	[InventoryShipmentGUID] ASC,
	[InventoryShipmentDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryShipmentDetail_InventoryTransferRequestGUID] ON [dbo].[datInventoryShipmentDetail]
(
	[InventoryTransferRequestGUID] ASC
)
INCLUDE([InventoryShipmentGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryShipmentDetail_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail] CHECK CONSTRAINT [FK_datInventoryShipmentDetail_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryShipmentDetail_datInventoryShipment] FOREIGN KEY([InventoryShipmentGUID])
REFERENCES [dbo].[datInventoryShipment] ([InventoryShipmentGUID])
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail] CHECK CONSTRAINT [FK_datInventoryShipmentDetail_datInventoryShipment]
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryShipmentDetail_datInventoryTransferRequest] FOREIGN KEY([InventoryTransferRequestGUID])
REFERENCES [dbo].[datInventoryTransferRequest] ([InventoryTransferRequestGUID])
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail] CHECK CONSTRAINT [FK_datInventoryShipmentDetail_datInventoryTransferRequest]
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryShipmentDetail_HairSystemCenterContractPricingID] FOREIGN KEY([PriorityHairSystemCenterContractPricingID])
REFERENCES [dbo].[cfgHairSystemCenterContractPricing] ([HairSystemCenterContractPricingID])
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail] CHECK CONSTRAINT [FK_datInventoryShipmentDetail_HairSystemCenterContractPricingID]
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryShipmentDetail_lkpInventoryShipmentDetailStatus] FOREIGN KEY([InventoryShipmentDetailStatusID])
REFERENCES [dbo].[lkpInventoryShipmentDetailStatus] ([InventoryShipmentDetailStatusID])
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail] CHECK CONSTRAINT [FK_datInventoryShipmentDetail_lkpInventoryShipmentDetailStatus]
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryShipmentDetail_lkpInventoryShipmentReason] FOREIGN KEY([InventoryShipmentReasonID])
REFERENCES [dbo].[lkpInventoryShipmentReason] ([InventoryShipmentReasonID])
GO
ALTER TABLE [dbo].[datInventoryShipmentDetail] CHECK CONSTRAINT [FK_datInventoryShipmentDetail_lkpInventoryShipmentReason]
GO
