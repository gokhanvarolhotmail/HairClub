/* CreateDate: 07/30/2012 09:03:35.863 , ModifyDate: 01/31/2022 08:32:31.700 */
GO
CREATE TABLE [dbo].[cfgHairSystemHairMaterialJoin](
	[HairSystemHairMaterialJoin] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemHairMaterialID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemHairMaterialJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemHairMaterialJoin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemHairMaterialJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemHairMaterialJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemHairMaterialJoin] CHECK CONSTRAINT [FK_cfgHairSystemHairMaterialJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemHairMaterialJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemHairMaterialJoin_lkpHairSystemHairMaterial] FOREIGN KEY([HairSystemHairMaterialID])
REFERENCES [dbo].[lkpHairSystemHairMaterial] ([HairSystemHairMaterialID])
GO
ALTER TABLE [dbo].[cfgHairSystemHairMaterialJoin] CHECK CONSTRAINT [FK_cfgHairSystemHairMaterialJoin_lkpHairSystemHairMaterial]
GO
