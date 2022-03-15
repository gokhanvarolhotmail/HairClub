/* CreateDate: 10/04/2010 12:08:45.260 , ModifyDate: 03/04/2022 16:09:12.683 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorRanking](
	[HairSystemVendorRankingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[Ranking1VendorID] [int] NULL,
	[Ranking2VendorID] [int] NULL,
	[Ranking3VendorID] [int] NULL,
	[Ranking4VendorID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Ranking5VendorID] [int] NULL,
	[Ranking6VendorID] [int] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorRanking] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorRankingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking] CHECK CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor] FOREIGN KEY([Ranking1VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking] CHECK CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor1] FOREIGN KEY([Ranking2VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking] CHECK CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor1]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor2] FOREIGN KEY([Ranking3VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking] CHECK CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor2]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor3] FOREIGN KEY([Ranking4VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking] CHECK CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor3]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor5] FOREIGN KEY([Ranking5VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking] CHECK CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor5]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor6] FOREIGN KEY([Ranking6VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorRanking] CHECK CONSTRAINT [FK_cfgHairSystemVendorRanking_cfgVendor6]
GO
