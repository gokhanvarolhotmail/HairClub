CREATE TABLE [dbo].[cfgHairSystemHighLightJoin](
	[HairSystemHighLightJoin] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemHighLightID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemHighLightJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemHighLightJoin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemHighLightJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemHighLightJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemHighLightJoin] CHECK CONSTRAINT [FK_cfgHairSystemHighLightJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemHighLightJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemHighLightJoin_lkpHairSystemHighLight] FOREIGN KEY([HairSystemHighLightID])
REFERENCES [dbo].[lkpHairSystemHighlight] ([HairSystemHighlightID])
GO
ALTER TABLE [dbo].[cfgHairSystemHighLightJoin] CHECK CONSTRAINT [FK_cfgHairSystemHighLightJoin_lkpHairSystemHighLight]
