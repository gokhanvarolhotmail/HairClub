/* CreateDate: 03/03/2022 13:53:56.177 , ModifyDate: 03/03/2022 22:19:12.167 */
GO
CREATE TABLE [SF].[Location](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[LocationType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [decimal](25, 15) NULL,
	[Longitude] [decimal](25, 15) NULL,
	[Location] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DrivingDirections] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeZone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentLocationId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PossessionDate] [date] NULL,
	[ConstructionStartDate] [date] NULL,
	[ConstructionEndDate] [date] NULL,
	[OpenDate] [date] NULL,
	[CloseDate] [date] NULL,
	[RemodelStartDate] [date] NULL,
	[RemodelEndDate] [date] NULL,
	[IsMobile] [bit] NULL,
	[IsInventoryLocation] [bit] NULL,
	[RootLocationId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationLevel] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalReference] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LogoId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Location] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Location]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Location]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
