/* CreateDate: 03/03/2022 13:53:56.293 , ModifyDate: 03/07/2022 12:17:31.403 */
GO
CREATE TABLE [SF].[OpportunityContactRole](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OpportunityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Role] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPrimary] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_OpportunityContactRole] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[OpportunityContactRole]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[OpportunityContactRole]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[OpportunityContactRole]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityContactRole_Contact_ContactId] FOREIGN KEY([ContactId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[OpportunityContactRole] NOCHECK CONSTRAINT [fk_OpportunityContactRole_Contact_ContactId]
GO
ALTER TABLE [SF].[OpportunityContactRole]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityContactRole_Opportunity_OpportunityId] FOREIGN KEY([OpportunityId])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[OpportunityContactRole] NOCHECK CONSTRAINT [fk_OpportunityContactRole_Opportunity_OpportunityId]
GO
ALTER TABLE [SF].[OpportunityContactRole]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityContactRole_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[OpportunityContactRole] NOCHECK CONSTRAINT [fk_OpportunityContactRole_User_CreatedById]
GO
ALTER TABLE [SF].[OpportunityContactRole]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityContactRole_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[OpportunityContactRole] NOCHECK CONSTRAINT [fk_OpportunityContactRole_User_LastModifiedById]
GO
