/* CreateDate: 05/28/2018 22:15:34.480 , ModifyDate: 11/29/2018 22:41:55.413 */
GO
CREATE TABLE [dbo].[datDistributorPurchaseOrderDetail](
	[DistributorPurchaseOrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[DistributorPurchaseOrderID] [int] NOT NULL,
	[SalesCodeDistributorID] [int] NOT NULL,
	[UnitOfMeasureID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[IsSerialized] [bit] NOT NULL,
	[ExtendedCenterCost] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datDistributorPurchaseOrderDetail] PRIMARY KEY CLUSTERED
(
	[DistributorPurchaseOrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrderDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrderDetail_cfgSalesCodeDistributor] FOREIGN KEY([SalesCodeDistributorID])
REFERENCES [dbo].[cfgSalesCodeDistributor] ([SalesCodeDistributorID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrderDetail] CHECK CONSTRAINT [FK_datDistributorPurchaseOrderDetail_cfgSalesCodeDistributor]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrderDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrderDetail_datDistributorPurchaseOrder] FOREIGN KEY([DistributorPurchaseOrderID])
REFERENCES [dbo].[datDistributorPurchaseOrder] ([DistributorPurchaseOrderID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrderDetail] CHECK CONSTRAINT [FK_datDistributorPurchaseOrderDetail_datDistributorPurchaseOrder]
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrderDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_datDistributorPurchaseOrderDetail_lkpUnitOfMeasure] FOREIGN KEY([UnitOfMeasureID])
REFERENCES [dbo].[lkpUnitOfMeasure] ([UnitOfMeasureID])
GO
ALTER TABLE [dbo].[datDistributorPurchaseOrderDetail] CHECK CONSTRAINT [FK_datDistributorPurchaseOrderDetail_lkpUnitOfMeasure]
GO
