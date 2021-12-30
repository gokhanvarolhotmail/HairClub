/* CreateDate: 10/30/2008 09:09:19.060 , ModifyDate: 12/29/2021 15:38:46.423 */
GO
CREATE TABLE [dbo].[cfgResource](
	[ResourceID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ResourceSortOrder] [int] NULL,
	[ResourceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResourceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[ResourceTypeID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgResource] PRIMARY KEY CLUSTERED
(
	[ResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgResource_ResourceDescription] ON [dbo].[cfgResource]
(
	[ResourceDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgResource_ResourceDescriptionShort] ON [dbo].[cfgResource]
(
	[ResourceDescriptionShort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgResource_ResourceSortOrder] ON [dbo].[cfgResource]
(
	[ResourceSortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgResource] ADD  CONSTRAINT [DF_cfgResource_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgResource]  WITH CHECK ADD  CONSTRAINT [FK_cfgResource_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgResource] CHECK CONSTRAINT [FK_cfgResource_cfgCenter]
GO
ALTER TABLE [dbo].[cfgResource]  WITH CHECK ADD  CONSTRAINT [FK_cfgResource_lkpResourceType] FOREIGN KEY([ResourceTypeID])
REFERENCES [dbo].[lkpResourceType] ([ResourceTypeID])
GO
ALTER TABLE [dbo].[cfgResource] CHECK CONSTRAINT [FK_cfgResource_lkpResourceType]
GO
