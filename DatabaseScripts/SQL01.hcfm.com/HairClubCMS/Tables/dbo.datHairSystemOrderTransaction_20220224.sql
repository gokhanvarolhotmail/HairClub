/* CreateDate: 02/24/2022 14:35:18.730 , ModifyDate: 02/24/2022 14:35:18.730 */
GO
CREATE TABLE [dbo].[datHairSystemOrderTransaction_20220224](
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
	[CostContractAdjustment] [money] NULL,
	[CostActual] [money] NOT NULL,
	[PreviousCostActual] [money] NOT NULL,
	[CostCostActual] [money] NULL,
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
	[CostFactoryShippedAdjustment] [money] NULL,
	[CenterPriceAdjustment] [money] NULL,
	[SalesOrderDetailGuid] [uniqueidentifier] NULL,
	[HairSystemOrderPriorityReasonID] [int] NULL
) ON [PRIMARY]
GO
