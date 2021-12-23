/* CreateDate: 10/04/2010 12:08:45.860 , ModifyDate: 12/07/2021 16:20:16.243 */
GO
CREATE TABLE [dbo].[cfgHairSystemMatrixColorJoin](
	[HairSystemMatrixColorJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemMatrixColorID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemMatrixColorJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemMatrixColorJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemMatrixColorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemMatrixColorJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemMatrixColorJoin] CHECK CONSTRAINT [FK_cfgHairSystemMatrixColorJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemMatrixColorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemMatrixColorJoin_lkpHairSystemMatrixColor] FOREIGN KEY([HairSystemMatrixColorID])
REFERENCES [dbo].[lkpHairSystemMatrixColor] ([HairSystemMatrixColorID])
GO
ALTER TABLE [dbo].[cfgHairSystemMatrixColorJoin] CHECK CONSTRAINT [FK_cfgHairSystemMatrixColorJoin_lkpHairSystemMatrixColor]
GO
