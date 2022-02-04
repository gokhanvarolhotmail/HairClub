/* CreateDate: 04/23/2012 11:36:45.310 , ModifyDate: 01/14/2022 07:31:59.773 */
GO
CREATE TABLE [dbo].[datInvoiceDetail](
	[InvoiceDetailGUID] [uniqueidentifier] NOT NULL,
	[InvoiceGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderNumber] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datInvoiceDetail] PRIMARY KEY NONCLUSTERED
(
	[InvoiceDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datInvoiceDetail_InvoiceGUID_HairSystemOrderNumber] ON [dbo].[datInvoiceDetail]
(
	[InvoiceGUID] ASC,
	[HairSystemOrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInvoiceDetail_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datInvoiceDetail] CHECK CONSTRAINT [FK_datInvoiceDetail_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datInvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_datInvoiceDetail_datInvoice] FOREIGN KEY([InvoiceGUID])
REFERENCES [dbo].[datInvoice] ([InvoiceGUID])
GO
ALTER TABLE [dbo].[datInvoiceDetail] CHECK CONSTRAINT [FK_datInvoiceDetail_datInvoice]
GO
