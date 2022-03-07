/* CreateDate: 03/03/2022 13:53:56.950 , ModifyDate: 03/07/2022 12:17:13.750 */
GO
CREATE TABLE [SF].[ServiceResource](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[RelatedRecordId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResourceType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActive] [bit] NULL,
	[LocationId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceResource] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ServiceResource]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ServiceResource]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[ServiceResource]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceResource_Account_AccountId] FOREIGN KEY([AccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[ServiceResource] NOCHECK CONSTRAINT [fk_ServiceResource_Account_AccountId]
GO
ALTER TABLE [SF].[ServiceResource]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceResource_Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [SF].[Location] ([Id])
GO
ALTER TABLE [SF].[ServiceResource] NOCHECK CONSTRAINT [fk_ServiceResource_Location_LocationId]
GO
ALTER TABLE [SF].[ServiceResource]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceResource_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceResource] NOCHECK CONSTRAINT [fk_ServiceResource_User_CreatedById]
GO
ALTER TABLE [SF].[ServiceResource]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceResource_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceResource] NOCHECK CONSTRAINT [fk_ServiceResource_User_LastModifiedById]
GO
ALTER TABLE [SF].[ServiceResource]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceResource_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceResource] NOCHECK CONSTRAINT [fk_ServiceResource_User_OwnerId]
GO
ALTER TABLE [SF].[ServiceResource]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceResource_User_RelatedRecordId] FOREIGN KEY([RelatedRecordId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceResource] NOCHECK CONSTRAINT [fk_ServiceResource_User_RelatedRecordId]
GO
