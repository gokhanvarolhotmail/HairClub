/* CreateDate: 03/03/2022 13:53:56.477 , ModifyDate: 03/07/2022 12:17:13.537 */
GO
CREATE TABLE [SF].[OpportunityTeamMember](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OpportunityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](361) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TeamMemberRole] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunityAccessLevel] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [pk_OpportunityTeamMember] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[OpportunityTeamMember]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[OpportunityTeamMember]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[OpportunityTeamMember]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityTeamMember_Opportunity_OpportunityId] FOREIGN KEY([OpportunityId])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[OpportunityTeamMember] NOCHECK CONSTRAINT [fk_OpportunityTeamMember_Opportunity_OpportunityId]
GO
ALTER TABLE [SF].[OpportunityTeamMember]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityTeamMember_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[OpportunityTeamMember] NOCHECK CONSTRAINT [fk_OpportunityTeamMember_User_CreatedById]
GO
ALTER TABLE [SF].[OpportunityTeamMember]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityTeamMember_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[OpportunityTeamMember] NOCHECK CONSTRAINT [fk_OpportunityTeamMember_User_LastModifiedById]
GO
ALTER TABLE [SF].[OpportunityTeamMember]  WITH NOCHECK ADD  CONSTRAINT [fk_OpportunityTeamMember_User_UserId] FOREIGN KEY([UserId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[OpportunityTeamMember] NOCHECK CONSTRAINT [fk_OpportunityTeamMember_User_UserId]
GO
