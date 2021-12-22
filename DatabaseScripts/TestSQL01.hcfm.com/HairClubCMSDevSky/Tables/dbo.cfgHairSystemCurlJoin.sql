/* CreateDate: 10/04/2010 12:08:45.927 , ModifyDate: 12/07/2021 16:20:15.827 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemCurlJoin](
	[HairSystemCurlJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemCurlID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemCurlJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemCurlJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemCurlJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemCurlJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemCurlJoin] CHECK CONSTRAINT [FK_cfgHairSystemCurlJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemCurlJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemCurlJoin_lkpHairSystemCurl] FOREIGN KEY([HairSystemCurlID])
REFERENCES [dbo].[lkpHairSystemCurl] ([HairSystemCurlID])
GO
ALTER TABLE [dbo].[cfgHairSystemCurlJoin] CHECK CONSTRAINT [FK_cfgHairSystemCurlJoin_lkpHairSystemCurl]
GO
