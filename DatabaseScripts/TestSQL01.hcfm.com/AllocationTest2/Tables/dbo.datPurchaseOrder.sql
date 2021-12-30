/* CreateDate: 10/31/2019 20:53:48.133 , ModifyDate: 11/01/2019 09:57:48.993 */
GO
CREATE TABLE [dbo].[datPurchaseOrder](
	[PurchaseOrderGUID] [uniqueidentifier] NOT NULL,
	[VendorID] [int] NOT NULL,
	[PurchaseOrderDate] [datetime] NULL,
	[PurchaseOrderNumber] [int] IDENTITY(10000,1) NOT NULL,
	[PurchaseOrderTotal] [money] NULL,
	[PurchaseOrderCount] [int] NULL,
	[PurchaseOrderStatusID] [int] NULL,
	[HairSystemAllocationGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PurchaseOrderTypeID] [int] NULL,
	[PurchaseOrderNumberOriginal] [int] NULL
) ON [PRIMARY]
GO
