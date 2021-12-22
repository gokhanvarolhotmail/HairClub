/* CreateDate: 10/31/2019 20:53:45.370 , ModifyDate: 11/01/2019 09:57:48.993 */
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
	[CostActual] [money] NOT NULL,
	[PreviousCostActual] [money] NOT NULL,
	[CenterPrice] [money] NOT NULL,
	[PreviousCenterPrice] [money] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CostFactoryShipped] [money] NOT NULL,
	[PreviousCostFactoryShipped] [money] NOT NULL,
	[SalesOrderDetailGuid] [uniqueidentifier] NULL,
	[HairSystemOrderPriorityReasonID] [int] NULL
) ON [PRIMARY]
GO
