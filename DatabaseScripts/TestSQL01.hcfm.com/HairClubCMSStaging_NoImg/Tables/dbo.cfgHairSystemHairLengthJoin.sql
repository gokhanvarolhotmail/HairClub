/* CreateDate: 10/04/2010 12:08:45.907 , ModifyDate: 01/04/2022 10:56:36.963 */
GO
CREATE TABLE [dbo].[cfgHairSystemHairLengthJoin](
	[HairSystemHairLengthJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemHairLengthID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemHairLengthJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemHairLengthJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemHairLengthJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemHairLengthJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemHairLengthJoin] CHECK CONSTRAINT [FK_cfgHairSystemHairLengthJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemHairLengthJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemHairLengthJoin_lkpHairSystemHairLength] FOREIGN KEY([HairSystemHairLengthID])
REFERENCES [dbo].[lkpHairSystemHairLength] ([HairSystemHairLengthID])
GO
ALTER TABLE [dbo].[cfgHairSystemHairLengthJoin] CHECK CONSTRAINT [FK_cfgHairSystemHairLengthJoin_lkpHairSystemHairLength]
GO
