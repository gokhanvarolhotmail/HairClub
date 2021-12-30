/* CreateDate: 05/05/2020 17:42:51.100 , ModifyDate: 05/05/2020 18:27:59.677 */
GO
CREATE TABLE [dbo].[datInvoice](
	[InvoiceGUID] [uniqueidentifier] NOT NULL,
	[InvoiceNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InvoiceDate] [datetime] NULL,
	[InvoiceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderCount] [int] NULL,
	[TotalInvoiceValue] [money] NULL,
	[ShipmentMethodID] [int] NULL,
	[TrackingNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PurchaseOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_Shipment] PRIMARY KEY NONCLUSTERED
(
	[InvoiceGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
