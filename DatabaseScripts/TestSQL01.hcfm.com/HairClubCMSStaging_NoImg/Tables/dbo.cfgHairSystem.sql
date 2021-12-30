/* CreateDate: 10/04/2010 12:08:45.800 , ModifyDate: 12/28/2021 09:20:54.623 */
GO
CREATE TABLE [dbo].[cfgHairSystem](
	[HairSystemID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemSortOrder] [int] NOT NULL,
	[HairSystemDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemTypeID] [int] NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[UseHairSystemFrontalLaceLengthFlag] [bit] NOT NULL,
	[AllowFashionHairlineHighlightsFlag] [bit] NOT NULL,
	[HairSystemGroupID] [int] NOT NULL,
	[AllowSignatureHairlineFlag] [bit] NOT NULL,
	[AllowCuticleIntactHairFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgHairSystem] PRIMARY KEY CLUSTERED
(
	[HairSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystem_HairSystemDescription] ON [dbo].[cfgHairSystem]
(
	[HairSystemDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystem_HairSystemDescriptionShort] ON [dbo].[cfgHairSystem]
(
	[HairSystemDescriptionShort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystem_HairSystemSortOrder] ON [dbo].[cfgHairSystem]
(
	[HairSystemSortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystem] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgHairSystem] ADD  DEFAULT ((0)) FOR [UseHairSystemFrontalLaceLengthFlag]
GO
ALTER TABLE [dbo].[cfgHairSystem] ADD  DEFAULT ((1)) FOR [AllowFashionHairlineHighlightsFlag]
GO
ALTER TABLE [dbo].[cfgHairSystem]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystem_lkpHairSystemGroup] FOREIGN KEY([HairSystemGroupID])
REFERENCES [dbo].[lkpHairSystemGroup] ([HairSystemGroupID])
GO
ALTER TABLE [dbo].[cfgHairSystem] CHECK CONSTRAINT [FK_cfgHairSystem_lkpHairSystemGroup]
GO
ALTER TABLE [dbo].[cfgHairSystem]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystem_lkpHairSystemType] FOREIGN KEY([HairSystemTypeID])
REFERENCES [dbo].[lkpHairSystemType] ([HairSystemTypeID])
GO
ALTER TABLE [dbo].[cfgHairSystem] CHECK CONSTRAINT [FK_cfgHairSystem_lkpHairSystemType]
GO
