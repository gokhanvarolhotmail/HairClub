/* CreateDate: 03/08/2011 22:13:51.210 , ModifyDate: 12/03/2021 10:24:48.673 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemFactoryNoteJoin](
	[HairSystemFactoryNoteJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemFactoryNoteID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemFactoryNoteJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemFactoryNoteJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemFactoryNoteJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemFactoryNoteJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemFactoryNoteJoin] CHECK CONSTRAINT [FK_cfgHairSystemFactoryNoteJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemFactoryNoteJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemFactoryNoteJoin_lkpHairSystemFactoryNote] FOREIGN KEY([HairSystemFactoryNoteID])
REFERENCES [dbo].[lkpHairSystemFactoryNote] ([HairSystemFactoryNoteID])
GO
ALTER TABLE [dbo].[cfgHairSystemFactoryNoteJoin] CHECK CONSTRAINT [FK_cfgHairSystemFactoryNoteJoin_lkpHairSystemFactoryNote]
GO
