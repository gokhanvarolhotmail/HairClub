/* CreateDate: 03/03/2022 13:53:55.357 , ModifyDate: 03/07/2022 12:17:22.417 */
GO
CREATE TABLE [SF].[AssignedResource](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[AssignedResourceNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[ServiceAppointmentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceResourceId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRequiredResource] [bit] NULL,
	[Role] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EventId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceResourceId__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_AssignedResource] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[AssignedResource]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[AssignedResource]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[AssignedResource]  WITH NOCHECK ADD  CONSTRAINT [fk_AssignedResource_Event_EventId] FOREIGN KEY([EventId])
REFERENCES [SF].[Event] ([Id])
GO
ALTER TABLE [SF].[AssignedResource] NOCHECK CONSTRAINT [fk_AssignedResource_Event_EventId]
GO
ALTER TABLE [SF].[AssignedResource]  WITH NOCHECK ADD  CONSTRAINT [fk_AssignedResource_ServiceAppointment_ServiceAppointmentId] FOREIGN KEY([ServiceAppointmentId])
REFERENCES [SF].[ServiceAppointment] ([Id])
GO
ALTER TABLE [SF].[AssignedResource] NOCHECK CONSTRAINT [fk_AssignedResource_ServiceAppointment_ServiceAppointmentId]
GO
ALTER TABLE [SF].[AssignedResource]  WITH NOCHECK ADD  CONSTRAINT [fk_AssignedResource_ServiceResource_ServiceResourceId] FOREIGN KEY([ServiceResourceId])
REFERENCES [SF].[ServiceResource] ([Id])
GO
ALTER TABLE [SF].[AssignedResource] NOCHECK CONSTRAINT [fk_AssignedResource_ServiceResource_ServiceResourceId]
GO
ALTER TABLE [SF].[AssignedResource]  WITH NOCHECK ADD  CONSTRAINT [fk_AssignedResource_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[AssignedResource] NOCHECK CONSTRAINT [fk_AssignedResource_User_CreatedById]
GO
ALTER TABLE [SF].[AssignedResource]  WITH NOCHECK ADD  CONSTRAINT [fk_AssignedResource_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[AssignedResource] NOCHECK CONSTRAINT [fk_AssignedResource_User_LastModifiedById]
GO
