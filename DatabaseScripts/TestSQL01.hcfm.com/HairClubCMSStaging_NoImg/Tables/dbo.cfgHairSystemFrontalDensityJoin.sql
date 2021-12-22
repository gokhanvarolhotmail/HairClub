/* CreateDate: 10/04/2010 12:08:45.850 , ModifyDate: 12/03/2021 10:24:48.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemFrontalDensityJoin](
	[HairSystemFrontalDensityJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemFrontalDensityID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemFrontalDensityJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemFrontalDensityJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDensityJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemFrontalDensityJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDensityJoin] CHECK CONSTRAINT [FK_cfgHairSystemFrontalDensityJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDensityJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemFrontalDensityJoin_lkpHairSystemFrontalDensity] FOREIGN KEY([HairSystemFrontalDensityID])
REFERENCES [dbo].[lkpHairSystemFrontalDensity] ([HairSystemFrontalDensityID])
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDensityJoin] CHECK CONSTRAINT [FK_cfgHairSystemFrontalDensityJoin_lkpHairSystemFrontalDensity]
GO
