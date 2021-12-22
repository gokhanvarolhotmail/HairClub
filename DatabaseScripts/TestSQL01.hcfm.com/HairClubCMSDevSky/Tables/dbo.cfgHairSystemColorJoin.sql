/* CreateDate: 05/31/2012 20:45:21.380 , ModifyDate: 12/07/2021 16:20:16.067 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemColorJoin](
	[HairSystemColorJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemHairColorID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemColorJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemColorJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemColorJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemColorJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemColorJoin] CHECK CONSTRAINT [FK_cfgHairSystemColorJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemColorJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemColorJoin_lkpHairSystemHairColor] FOREIGN KEY([HairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[cfgHairSystemColorJoin] CHECK CONSTRAINT [FK_cfgHairSystemColorJoin_lkpHairSystemHairColor]
GO
