/* CreateDate: 03/26/2014 08:12:24.073 , ModifyDate: 12/03/2021 10:24:48.673 */
GO
CREATE TABLE [dbo].[cfgCenterMembershipRuleExclusion](
	[CenterMembershipRuleExclusionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterMembershipID] [int] NOT NULL,
	[MembershipRuleTypeID] [int] NOT NULL,
	[NewMembershipID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgCenterMembershipRuleExclusion] PRIMARY KEY CLUSTERED
(
	[CenterMembershipRuleExclusionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterMembershipRuleExclusion]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipRuleExclusion_cfgCenterMembership] FOREIGN KEY([CenterMembershipID])
REFERENCES [dbo].[cfgCenterMembership] ([CenterMembershipID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipRuleExclusion] CHECK CONSTRAINT [FK_cfgCenterMembershipRuleExclusion_cfgCenterMembership]
GO
ALTER TABLE [dbo].[cfgCenterMembershipRuleExclusion]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipRuleExclusion_cfgMembership] FOREIGN KEY([NewMembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipRuleExclusion] CHECK CONSTRAINT [FK_cfgCenterMembershipRuleExclusion_cfgMembership]
GO
ALTER TABLE [dbo].[cfgCenterMembershipRuleExclusion]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipRuleExclusion_lkpMembershipRuleType] FOREIGN KEY([MembershipRuleTypeID])
REFERENCES [dbo].[lkpMembershipRuleType] ([MembershipRuleTypeID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipRuleExclusion] CHECK CONSTRAINT [FK_cfgCenterMembershipRuleExclusion_lkpMembershipRuleType]
GO
