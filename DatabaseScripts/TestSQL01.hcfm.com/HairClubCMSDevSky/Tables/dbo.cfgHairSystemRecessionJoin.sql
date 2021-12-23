/* CreateDate: 10/04/2010 12:08:45.887 , ModifyDate: 12/07/2021 16:20:16.273 */
GO
CREATE TABLE [dbo].[cfgHairSystemRecessionJoin](
	[HairSystemRecessionJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemRecessionID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemRecessionJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemRecessionJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemRecessionJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemRecessionJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemRecessionJoin] CHECK CONSTRAINT [FK_cfgHairSystemRecessionJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemRecessionJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemRecessionJoin_lkpHairSystemRecession] FOREIGN KEY([HairSystemRecessionID])
REFERENCES [dbo].[lkpHairSystemRecession] ([HairSystemRecessionID])
GO
ALTER TABLE [dbo].[cfgHairSystemRecessionJoin] CHECK CONSTRAINT [FK_cfgHairSystemRecessionJoin_lkpHairSystemRecession]
GO
