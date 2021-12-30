/* CreateDate: 10/04/2010 12:08:45.940 , ModifyDate: 12/28/2021 09:20:54.440 */
GO
CREATE TABLE [dbo].[cfgHairSystemStyleJoin](
	[HairSystemStyleJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemStyleID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemStyleJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemStyleJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemStyleJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemStyleJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemStyleJoin] CHECK CONSTRAINT [FK_cfgHairSystemStyleJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemStyleJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemStyleJoin_lkpHairSystemStyle] FOREIGN KEY([HairSystemStyleID])
REFERENCES [dbo].[lkpHairSystemStyle] ([HairSystemStyleID])
GO
ALTER TABLE [dbo].[cfgHairSystemStyleJoin] CHECK CONSTRAINT [FK_cfgHairSystemStyleJoin_lkpHairSystemStyle]
GO
