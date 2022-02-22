/* CreateDate: 05/05/2020 17:42:51.150 , ModifyDate: 02/18/2022 19:37:06.333 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
