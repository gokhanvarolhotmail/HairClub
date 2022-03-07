/* CreateDate: 03/03/2022 13:53:57.580 , ModifyDate: 03/07/2022 12:17:13.663 */
GO
CREATE TABLE [SF].[WorkOrderLineItem](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[LineItemNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[WorkOrderId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentWorkOrderLineItemId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Product2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssetId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RootWorkOrderLineItemId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PricebookEntryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quantity] [decimal](10, 2) NULL,
	[UnitPrice] [decimal](16, 2) NULL,
	[Discount] [decimal](3, 2) NULL,
	[ListPrice] [decimal](16, 2) NULL,
	[Subtotal] [decimal](16, 2) NULL,
	[TotalPrice] [decimal](16, 2) NULL,
	[Duration] [decimal](16, 2) NULL,
	[DurationType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DurationInMinutes] [decimal](16, 2) NULL,
	[WorkTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [decimal](25, 15) NULL,
	[Longitude] [decimal](25, 15) NULL,
	[GeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusCategory] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosed] [bit] NULL,
	[Priority] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceAppointmentCount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_WorkOrderLineItem] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[WorkOrderLineItem]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[WorkOrderLineItem]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [SF].[Location] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_Location_LocationId]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_Order_OrderId] FOREIGN KEY([OrderId])
REFERENCES [SF].[Order] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_Order_OrderId]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_ServiceTerritory_ServiceTerritoryId] FOREIGN KEY([ServiceTerritoryId])
REFERENCES [SF].[ServiceTerritory] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_ServiceTerritory_ServiceTerritoryId]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_User_CreatedById]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_User_LastModifiedById]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_WorkOrder_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [SF].[WorkOrder] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_WorkOrder_WorkOrderId]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_WorkOrderLineItem_ParentWorkOrderLineItemId] FOREIGN KEY([ParentWorkOrderLineItemId])
REFERENCES [SF].[WorkOrderLineItem] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_WorkOrderLineItem_ParentWorkOrderLineItemId]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_WorkOrderLineItem_RootWorkOrderLineItemId] FOREIGN KEY([RootWorkOrderLineItemId])
REFERENCES [SF].[WorkOrderLineItem] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_WorkOrderLineItem_RootWorkOrderLineItemId]
GO
ALTER TABLE [SF].[WorkOrderLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkOrderLineItem_WorkType_WorkTypeId] FOREIGN KEY([WorkTypeId])
REFERENCES [SF].[WorkType] ([Id])
GO
ALTER TABLE [SF].[WorkOrderLineItem] NOCHECK CONSTRAINT [fk_WorkOrderLineItem_WorkType_WorkTypeId]
GO
