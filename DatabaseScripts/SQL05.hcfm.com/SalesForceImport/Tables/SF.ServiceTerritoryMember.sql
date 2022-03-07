/* CreateDate: 03/03/2022 13:53:57.210 , ModifyDate: 03/07/2022 12:17:14.840 */
GO
CREATE TABLE [SF].[ServiceTerritoryMember](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[MemberNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ServiceTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceResourceId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TerritoryType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EffectiveStartDate] [datetime2](7) NULL,
	[EffectiveEndDate] [datetime2](7) NULL,
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
	[OperatingHoursId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Role] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceTerritoryMember] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ServiceTerritoryMember]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ServiceTerritoryMember]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[ServiceTerritoryMember]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryMember_ServiceResource_ServiceResourceId] FOREIGN KEY([ServiceResourceId])
REFERENCES [SF].[ServiceResource] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryMember] NOCHECK CONSTRAINT [fk_ServiceTerritoryMember_ServiceResource_ServiceResourceId]
GO
ALTER TABLE [SF].[ServiceTerritoryMember]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryMember_ServiceTerritory_ServiceTerritoryId] FOREIGN KEY([ServiceTerritoryId])
REFERENCES [SF].[ServiceTerritory] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryMember] NOCHECK CONSTRAINT [fk_ServiceTerritoryMember_ServiceTerritory_ServiceTerritoryId]
GO
ALTER TABLE [SF].[ServiceTerritoryMember]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryMember_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryMember] NOCHECK CONSTRAINT [fk_ServiceTerritoryMember_User_CreatedById]
GO
ALTER TABLE [SF].[ServiceTerritoryMember]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryMember_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryMember] NOCHECK CONSTRAINT [fk_ServiceTerritoryMember_User_LastModifiedById]
GO
