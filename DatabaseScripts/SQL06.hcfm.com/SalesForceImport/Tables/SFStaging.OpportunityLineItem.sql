/* CreateDate: 03/03/2022 13:54:34.520 , ModifyDate: 03/08/2022 08:42:47.450 */
GO
CREATE TABLE [SFStaging].[OpportunityLineItem](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OpportunityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PricebookEntryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Product2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProductCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](376) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quantity] [decimal](10, 2) NULL,
	[TotalPrice] [decimal](16, 2) NULL,
	[UnitPrice] [decimal](16, 2) NULL,
	[ListPrice] [decimal](16, 2) NULL,
	[ServiceDate] [date] NULL,
	[HasRevenueSchedule] [bit] NULL,
	[HasQuantitySchedule] [bit] NULL,
	[Description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasSchedule] [bit] NULL,
	[CanUseQuantitySchedule] [bit] NULL,
	[CanUseRevenueSchedule] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
 CONSTRAINT [pk_OpportunityLineItem] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
