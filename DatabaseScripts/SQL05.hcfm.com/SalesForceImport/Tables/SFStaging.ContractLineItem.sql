/* CreateDate: 03/03/2022 13:54:34.073 , ModifyDate: 03/05/2022 13:04:27.190 */
GO
CREATE TABLE [SFStaging].[ContractLineItem](
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
