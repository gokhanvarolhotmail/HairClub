CREATE TABLE [dbo].[cfgHairSystemDensityJoin](
	[HairSystemDensityJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemDensityID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemDensityJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemDensityJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemDensityJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemDensityJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemDensityJoin] CHECK CONSTRAINT [FK_cfgHairSystemDensityJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemDensityJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemDensityJoin_lkpHairSystemDensity] FOREIGN KEY([HairSystemDensityID])
REFERENCES [dbo].[lkpHairSystemDensity] ([HairSystemDensityID])
GO
ALTER TABLE [dbo].[cfgHairSystemDensityJoin] CHECK CONSTRAINT [FK_cfgHairSystemDensityJoin_lkpHairSystemDensity]
