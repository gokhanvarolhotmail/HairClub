/* CreateDate: 11/01/2019 09:34:53.423 , ModifyDate: 02/02/2022 08:14:50.343 */
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
