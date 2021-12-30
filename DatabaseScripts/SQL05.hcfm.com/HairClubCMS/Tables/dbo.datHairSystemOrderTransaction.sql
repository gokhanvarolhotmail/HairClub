/* CreateDate: 05/05/2020 17:42:50.907 , ModifyDate: 04/01/2021 19:47:06.567 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_NewHairSystemOrderStatusID] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderGUID] ASC,
	[NewHairSystemOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrderTransaction_HSOTrxDateINCL] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderTransactionDate] ASC
)
INCLUDE([CenterID],[HairSystemOrderProcessID],[HairSystemOrderGUID],[PreviousCenterID],[PreviousHairSystemOrderStatusID],[NewHairSystemOrderStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrderTransaction_HairSystemOrderTransactionDate_HairSystemOrderProcessID_INCLCCHPN] ON [dbo].[datHairSystemOrderTransaction]
(
	[HairSystemOrderTransactionDate] ASC,
	[HairSystemOrderProcessID] ASC
)
INCLUDE([ClientHomeCenterID],[ClientGUID],[HairSystemOrderGUID],[PreviousHairSystemOrderStatusID],[NewHairSystemOrderStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
