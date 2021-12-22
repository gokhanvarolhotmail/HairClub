/* CreateDate: 02/07/2011 21:37:22.760 , ModifyDate: 12/03/2021 10:24:48.593 */
GO
CREATE TABLE [dbo].[cfgHairSystemMembershipJoin](
	[HairSystemMembershipJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[MembershipID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemMembershipJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemMembershipJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemMembershipJoin_HairSystemID_MembershipID] ON [dbo].[cfgHairSystemMembershipJoin]
(
	[HairSystemID] ASC,
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemMembershipJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemMembershipJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemMembershipJoin] CHECK CONSTRAINT [FK_cfgHairSystemMembershipJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemMembershipJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemMembershipJoin_cfgMembership] FOREIGN KEY([MembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgHairSystemMembershipJoin] CHECK CONSTRAINT [FK_cfgHairSystemMembershipJoin_cfgMembership]
GO
