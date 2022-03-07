/* CreateDate: 03/03/2022 13:53:57.293 , ModifyDate: 03/07/2022 12:17:14.993 */
GO
CREATE TABLE [SF].[ServiceTerritoryWorkType](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
	[WorkTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Work_Type_Appointment_Type__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceTerritoryWorkType] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ServiceTerritoryWorkType]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ServiceTerritoryWorkType]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryWorkType_ServiceTerritory_ServiceTerritoryId] FOREIGN KEY([ServiceTerritoryId])
REFERENCES [SF].[ServiceTerritory] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType] NOCHECK CONSTRAINT [fk_ServiceTerritoryWorkType_ServiceTerritory_ServiceTerritoryId]
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryWorkType_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType] NOCHECK CONSTRAINT [fk_ServiceTerritoryWorkType_User_CreatedById]
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryWorkType_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType] NOCHECK CONSTRAINT [fk_ServiceTerritoryWorkType_User_LastModifiedById]
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritoryWorkType_WorkType_WorkTypeId] FOREIGN KEY([WorkTypeId])
REFERENCES [SF].[WorkType] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritoryWorkType] NOCHECK CONSTRAINT [fk_ServiceTerritoryWorkType_WorkType_WorkTypeId]
GO
