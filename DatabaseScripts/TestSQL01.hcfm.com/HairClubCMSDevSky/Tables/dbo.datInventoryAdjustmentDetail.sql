/* CreateDate: 05/28/2018 22:15:34.667 , ModifyDate: 12/05/2021 08:46:38.123 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datInventoryAdjustmentDetail](
	[InventoryAdjustmentDetailID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryAdjustmentID] [int] NOT NULL,
	[DistributorPurchaseOrderDetailID] [int] NULL,
	[SalesOrderDetailGUID] [uniqueidentifier] NULL,
	[SalesCodeID] [int] NOT NULL,
	[QuantityAdjustment] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SerializedInventoryAuditTransactionID] [int] NULL,
	[NonSerializedInventoryAuditTransactionID] [int] NULL,
 CONSTRAINT [PK_datInventoryAdjustmentDetail] PRIMARY KEY CLUSTERED
(
	[InventoryAdjustmentDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryAdjustmentDetail_InventoryAdjustmentID] ON [dbo].[datInventoryAdjustmentDetail]
(
	[InventoryAdjustmentID] ASC
)
INCLUDE([SalesOrderDetailGUID],[SalesCodeID],[QuantityAdjustment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryAdjustmentDetail_SalesOrderDetailGUID] ON [dbo].[datInventoryAdjustmentDetail]
(
	[SalesOrderDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetail_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetail_cfgSalesCode]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetail_datDistributorPurchaseOrderDetail] FOREIGN KEY([DistributorPurchaseOrderDetailID])
REFERENCES [dbo].[datDistributorPurchaseOrderDetail] ([DistributorPurchaseOrderDetailID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetail_datDistributorPurchaseOrderDetail]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetail_datInventoryAdjustment] FOREIGN KEY([InventoryAdjustmentID])
REFERENCES [dbo].[datInventoryAdjustment] ([InventoryAdjustmentID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetail_datInventoryAdjustment]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetail_datNonSerializedInventoryAuditTransaction] FOREIGN KEY([NonSerializedInventoryAuditTransactionID])
REFERENCES [dbo].[datNonSerializedInventoryAuditTransaction] ([NonSerializedInventoryAuditTransactionID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetail_datNonSerializedInventoryAuditTransaction]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetail_datSalesOrderDetail] FOREIGN KEY([SalesOrderDetailGUID])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetail_datSalesOrderDetail]
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustmentDetail_datSerializedInventoryAuditTransaction] FOREIGN KEY([SerializedInventoryAuditTransactionID])
REFERENCES [dbo].[datSerializedInventoryAuditTransaction] ([SerializedInventoryAuditTransactionID])
GO
ALTER TABLE [dbo].[datInventoryAdjustmentDetail] CHECK CONSTRAINT [FK_datInventoryAdjustmentDetail_datSerializedInventoryAuditTransaction]
GO
