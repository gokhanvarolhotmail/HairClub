/* CreateDate: 03/03/2022 13:53:55.540 , ModifyDate: 03/07/2022 12:17:15.090 */
GO
CREATE TABLE [SF].[CampaignMemberStatus](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Label] [varchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDefault] [bit] NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
 CONSTRAINT [pk_CampaignMemberStatus] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[CampaignMemberStatus]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[CampaignMemberStatus]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[CampaignMemberStatus]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMemberStatus_Campaign_CampaignId] FOREIGN KEY([CampaignId])
REFERENCES [SF].[Campaign] ([Id])
GO
ALTER TABLE [SF].[CampaignMemberStatus] NOCHECK CONSTRAINT [fk_CampaignMemberStatus_Campaign_CampaignId]
GO
ALTER TABLE [SF].[CampaignMemberStatus]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMemberStatus_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[CampaignMemberStatus] NOCHECK CONSTRAINT [fk_CampaignMemberStatus_User_CreatedById]
GO
ALTER TABLE [SF].[CampaignMemberStatus]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMemberStatus_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[CampaignMemberStatus] NOCHECK CONSTRAINT [fk_CampaignMemberStatus_User_LastModifiedById]
GO
