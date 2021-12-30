/* CreateDate: 05/05/2020 17:42:46.667 , ModifyDate: 05/05/2020 17:43:05.470 */
GO
CREATE TABLE [dbo].[datInventoryShipment](
	[InventoryShipmentGUID] [uniqueidentifier] NOT NULL,
	[InventoryShipmentTypeID] [int] NOT NULL,
	[InventoryShipmentStatusID] [int] NOT NULL,
	[ShipmentNumber] [int] NOT NULL,
	[ShipFromVendorID] [int] NULL,
	[ShipFromCenterID] [int] NULL,
	[ShipToVendorID] [int] NULL,
	[ShipToCenterID] [int] NULL,
	[ShipDate] [datetime] NULL,
	[ReceiveDate] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceTotal] [money] NULL,
	[InvoiceCount] [int] NULL,
	[TrackingNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShipmentMethodID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[InvoiceActualTotal] [money] NULL,
	[InvoiceActualCount] [int] NULL,
	[InvoiceVarianceTotal]  AS (isnull([InvoiceTotal],(0))-isnull([InvoiceActualTotal],(0))),
	[InvoiceVarianceCount]  AS (isnull([InvoiceCount],(0))-isnull([InvoiceActualCount],(0))),
 CONSTRAINT [PK_datInventoryShipment] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
