/* CreateDate: 03/03/2022 13:53:57.150 , ModifyDate: 03/07/2022 12:17:15.423 */
GO
CREATE TABLE [SF].[ServiceTerritory_ZipCode__c](
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
	[Zip_Code_Center__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceTerritory_ZipCode__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ServiceTerritory_ZipCode__c]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ServiceTerritory_ZipCode__c]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritory_ZipCode__c_ServiceTerritory_Service_Territory__c] FOREIGN KEY([Service_Territory__c])
REFERENCES [SF].[ServiceTerritory] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c] NOCHECK CONSTRAINT [fk_ServiceTerritory_ZipCode__c_ServiceTerritory_Service_Territory__c]
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritory_ZipCode__c_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c] NOCHECK CONSTRAINT [fk_ServiceTerritory_ZipCode__c_User_CreatedById]
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritory_ZipCode__c_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c] NOCHECK CONSTRAINT [fk_ServiceTerritory_ZipCode__c_User_LastModifiedById]
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c]  WITH NOCHECK ADD  CONSTRAINT [fk_ServiceTerritory_ZipCode__c_ZipCode__c_Zip_Code_Center__c] FOREIGN KEY([Zip_Code_Center__c])
REFERENCES [SF].[ZipCode__c] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SF].[ServiceTerritory_ZipCode__c] NOCHECK CONSTRAINT [fk_ServiceTerritory_ZipCode__c_ZipCode__c_Zip_Code_Center__c]
GO
