/* CreateDate: 03/03/2022 13:53:57.510 , ModifyDate: 03/03/2022 22:19:13.800 */
GO
CREATE TABLE [SF].[WorkOrder](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[WorkOrderNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntitlementId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceContractId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssetId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[Subject] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RootWorkOrderId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Priority] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Tax] [decimal](16, 2) NULL,
	[Subtotal] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TotalPrice] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LineItemCount] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pricebook2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Discount] [decimal](3, 2) NULL,
	[GrandTotal] [decimal](16, 2) NULL,
	[ParentWorkOrderId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosed] [bit] NULL,
	[IsStopped] [bit] NULL,
	[StopStartDate] [datetime2](7) NULL,
	[SlaStartDate] [datetime2](7) NULL,
	[SlaExitDate] [datetime2](7) NULL,
	[BusinessHoursId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MilestoneStatus] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Duration] [decimal](16, 2) NULL,
	[DurationType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DurationInMinutes] [decimal](16, 2) NULL,
	[ServiceAppointmentCount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusCategory] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_WorkOrder] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[WorkOrder]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[WorkOrder]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
