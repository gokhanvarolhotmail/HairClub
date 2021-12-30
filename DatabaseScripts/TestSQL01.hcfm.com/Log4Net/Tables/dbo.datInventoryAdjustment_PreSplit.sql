/* CreateDate: 07/08/2019 12:58:12.720 , ModifyDate: 07/08/2019 12:58:12.720 */
GO
CREATE TABLE [dbo].[datInventoryAdjustment_PreSplit](
	[InventoryAdjustmentID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[TransferToCenterID] [int] NULL,
	[TransferFromCenterID] [int] NULL,
	[DistributorPurchaseOrderID] [int] NULL,
	[InventoryAdjustmentTypeID] [int] NOT NULL,
	[InventoryAdjustmentDate] [datetime] NOT NULL,
	[Note] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[InventoryAuditBatchID] [int] NULL,
 CONSTRAINT [PK_datInventoryAdjustment] PRIMARY KEY CLUSTERED
(
	[InventoryAdjustmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
