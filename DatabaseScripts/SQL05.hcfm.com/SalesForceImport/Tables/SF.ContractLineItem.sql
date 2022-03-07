/* CreateDate: 03/03/2022 13:53:55.883 , ModifyDate: 03/07/2022 12:17:34.010 */
GO
CREATE TABLE [SF].[ContractLineItem](
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
	[ServiceContractId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Product2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssetId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PricebookEntryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quantity] [decimal](10, 2) NULL,
	[UnitPrice] [decimal](16, 2) NULL,
	[Discount] [decimal](3, 2) NULL,
	[ListPrice] [decimal](16, 2) NULL,
	[Subtotal] [decimal](16, 2) NULL,
	[TotalPrice] [decimal](16, 2) NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentContractLineItemId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RootContractLineItemId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ContractLineItem] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ContractLineItem]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ContractLineItem]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[ContractLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_ContractLineItem_ContractLineItem_ParentContractLineItemId] FOREIGN KEY([ParentContractLineItemId])
REFERENCES [SF].[ContractLineItem] ([Id])
GO
ALTER TABLE [SF].[ContractLineItem] NOCHECK CONSTRAINT [fk_ContractLineItem_ContractLineItem_ParentContractLineItemId]
GO
ALTER TABLE [SF].[ContractLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_ContractLineItem_ContractLineItem_RootContractLineItemId] FOREIGN KEY([RootContractLineItemId])
REFERENCES [SF].[ContractLineItem] ([Id])
GO
ALTER TABLE [SF].[ContractLineItem] NOCHECK CONSTRAINT [fk_ContractLineItem_ContractLineItem_RootContractLineItemId]
GO
ALTER TABLE [SF].[ContractLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_ContractLineItem_Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [SF].[Location] ([Id])
GO
ALTER TABLE [SF].[ContractLineItem] NOCHECK CONSTRAINT [fk_ContractLineItem_Location_LocationId]
GO
ALTER TABLE [SF].[ContractLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_ContractLineItem_ServiceContract_ServiceContractId] FOREIGN KEY([ServiceContractId])
REFERENCES [SF].[ServiceContract] ([Id])
GO
ALTER TABLE [SF].[ContractLineItem] NOCHECK CONSTRAINT [fk_ContractLineItem_ServiceContract_ServiceContractId]
GO
ALTER TABLE [SF].[ContractLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_ContractLineItem_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ContractLineItem] NOCHECK CONSTRAINT [fk_ContractLineItem_User_CreatedById]
GO
ALTER TABLE [SF].[ContractLineItem]  WITH NOCHECK ADD  CONSTRAINT [fk_ContractLineItem_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ContractLineItem] NOCHECK CONSTRAINT [fk_ContractLineItem_User_LastModifiedById]
GO
