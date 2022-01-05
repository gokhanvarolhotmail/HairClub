/* CreateDate: 04/23/2012 11:36:45.210 , ModifyDate: 01/04/2022 10:56:36.903 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInvoice]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_lkpShipmentMethod] FOREIGN KEY([ShipmentMethodID])
REFERENCES [dbo].[lkpShipmentMethod] ([ShipmentMethodID])
GO
ALTER TABLE [dbo].[datInvoice] CHECK CONSTRAINT [FK_Invoice_lkpShipmentMethod]
GO
