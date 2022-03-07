/* CreateDate: 03/03/2022 13:54:34.773 , ModifyDate: 03/03/2022 22:19:09.353 */
GO
CREATE TABLE [SFStaging].[OrderItem](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Product2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[OrderId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PricebookEntryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OriginalOrderItemId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AvailableQuantity] [decimal](16, 2) NULL,
	[Quantity] [decimal](16, 2) NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UnitPrice] [decimal](16, 2) NULL,
	[ListPrice] [decimal](16, 2) NULL,
	[TotalPrice] [decimal](16, 2) NULL,
	[ServiceDate] [date] NULL,
	[EndDate] [date] NULL,
	[Description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[OrderItemNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_OrderItem] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
