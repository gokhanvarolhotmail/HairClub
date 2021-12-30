/* CreateDate: 05/05/2020 17:42:50.720 , ModifyDate: 05/05/2020 17:43:11.203 */
GO
CREATE TABLE [dbo].[datPurchaseOrder](
	[PurchaseOrderGUID] [uniqueidentifier] NOT NULL,
	[VendorID] [int] NOT NULL,
	[PurchaseOrderDate] [datetime] NULL,
	[PurchaseOrderNumber] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
