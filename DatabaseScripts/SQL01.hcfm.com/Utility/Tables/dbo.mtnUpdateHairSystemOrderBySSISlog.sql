CREATE TABLE [dbo].[mtnUpdateHairSystemOrderBySSISlog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[RunTime] [datetime] NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderStatus] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CostActual] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FactoryCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SubFactoryCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PodCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceDate] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShipmentMethodCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TrackingNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PurchaseOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderCount] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TotalInvoiceValue] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceGUID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_mtnUpdateHairSystemOrderBySSISlog] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
