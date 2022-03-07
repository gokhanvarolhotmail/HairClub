/* CreateDate: 11/29/2018 22:41:55.127 , ModifyDate: 11/29/2018 22:41:55.403 */
GO
CREATE TABLE [dbo].[datDistributorPurchaseOrder](
	[DistributorPurchaseOrderID] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseOrderNumber]  AS ((right('0000'+CONVERT([nvarchar](4),[CenterID]),(4))+'-')+right('0000000'+CONVERT([nvarchar](7),[DistributorPurchaseOrderID]),(7))) PERSISTED,
	[DistributorCenterID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[PurchaseOrderDate] [datetime] NOT NULL,
	[DistributorPurchaseOrderTypeID] [int] NOT NULL,
	[DistributorPurchaseOrderStatusID] [int] NOT NULL,
	[StatusAtDistributor] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DistributorOrderReference] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DistributorPurchaseOrderStatusDate] [datetime] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[TrackingNumber] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Carrier] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datDistributorPurchaseOrder] PRIMARY KEY CLUSTERED
(
	[DistributorPurchaseOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrder_cfgCenter] FOREIGN KEY([DistributorCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder] CHECK CONSTRAINT [FK_datDistributorPurchaseOrder_cfgCenter]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrder_cfgCenter1] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder] CHECK CONSTRAINT [FK_datDistributorPurchaseOrder_cfgCenter1]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrder_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder] CHECK CONSTRAINT [FK_datDistributorPurchaseOrder_datEmployee]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrder_lkpDistributorPurchaseOrderStatus] FOREIGN KEY([DistributorPurchaseOrderStatusID])
REFERENCES [dbo].[lkpDistributorPurchaseOrderStatus] ([DistributorPurchaseOrderStatusID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder] CHECK CONSTRAINT [FK_datDistributorPurchaseOrder_lkpDistributorPurchaseOrderStatus]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrder_lkpDistributorPurchaseOrderType] FOREIGN KEY([DistributorPurchaseOrderTypeID])
REFERENCES [dbo].[lkpDistributorPurchaseOrderType] ([DistributorPurchaseOrderTypeID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrder] CHECK CONSTRAINT [FK_datDistributorPurchaseOrder_lkpDistributorPurchaseOrderType]
GO
