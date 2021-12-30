/* CreateDate: 07/08/2019 12:59:20.797 , ModifyDate: 07/08/2019 12:59:20.797 */
GO
CREATE TABLE [dbo].[datInventoryAdjustmentDetail_PreSplit](
	[InventoryAdjustmentDetailID] [int] NOT NULL,
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
	[InventoryAuditTransactionID] [int] NULL,
 CONSTRAINT [PK_datInventoryAdjustmentDetail] PRIMARY KEY CLUSTERED
(
	[InventoryAdjustmentDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
