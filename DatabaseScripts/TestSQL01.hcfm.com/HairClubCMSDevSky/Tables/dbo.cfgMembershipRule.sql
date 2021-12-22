/* CreateDate: 02/12/2009 08:56:02.023 , ModifyDate: 12/07/2021 16:20:16.130 */
GO
CREATE TABLE [dbo].[cfgMembershipRule](
	[MembershipRuleID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MembershipRuleSortOrder] [int] NULL,
	[MembershipRuleTypeID] [int] NULL,
	[CurrentMembershipID] [int] NULL,
	[NewMembershipID] [int] NULL,
	[SalesCodeID] [int] NULL,
	[Interval] [int] NULL,
	[UnitOfMeasureID] [int] NULL,
	[MembershipScreen1ID] [int] NULL,
	[MembershipScreen2ID] [int] NULL,
	[MembershipScreen3ID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[UpdateStamp] [timestamp] NULL,
	[CurrentMembershipStatusID] [int] NULL,
	[NewMembershipStatusID] [int] NULL,
	[MembershipCancelRuleID] [int] NULL,
	[MembershipCancelSalesCodeID] [int] NULL,
	[AdditionalNewMembershipID] [int] NULL,
	[CenterBusinessTypeID] [int] NOT NULL,
	[FromCancelledMembershipSalesCodeID] [int] NULL,
	[AddOnID] [int] NULL,
	[ReplaceCurrentClientMembershipStatusID] [int] NULL,
	[AssociatedAddOnSalesCodeID] [int] NULL,
	[AssociatedAddOnNewClientMembershipAddOnStatusID] [int] NULL,
 CONSTRAINT [PK_cfgMembershipBusinessRule] PRIMARY KEY CLUSTERED
(
	[MembershipRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembershipRule_CurrentMembershipID] ON [dbo].[cfgMembershipRule]
(
	[CurrentMembershipID] ASC
)
INCLUDE([MembershipRuleTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembershipRule_MembershipRuleTypeID_NewMembershipID_IsActiveFlag_CenterBusinessTypeID] ON [dbo].[cfgMembershipRule]
(
	[MembershipRuleTypeID] ASC,
	[NewMembershipID] ASC,
	[IsActiveFlag] DESC,
	[CenterBusinessTypeID] ASC
)
INCLUDE([MembershipRuleID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgMembershipRule] ADD  CONSTRAINT [DF_cfgMembershipRule_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgMembershipRule] ADD  CONSTRAINT [DF_cfgMembershipRule_CenterBusinessTypeID]  DEFAULT ((3)) FOR [CenterBusinessTypeID]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipBusinessRule_cfgMembership] FOREIGN KEY([CurrentMembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipBusinessRule_cfgMembership]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipBusinessRule_cfgSalesCodeMembership] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipBusinessRule_cfgSalesCodeMembership]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgAddOn] FOREIGN KEY([AddOnID])
REFERENCES [dbo].[cfgAddOn] ([AddOnID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgAddOn]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgMembership] FOREIGN KEY([NewMembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgMembership]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgMembership1] FOREIGN KEY([AdditionalNewMembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgMembership1]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgMembershipRule] FOREIGN KEY([MembershipRuleID])
REFERENCES [dbo].[cfgMembershipRule] ([MembershipRuleID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgMembershipRule]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgSalesCode] FOREIGN KEY([FromCancelledMembershipSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgSalesCode1] FOREIGN KEY([MembershipCancelSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgSalesCode1]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgSalesCode2] FOREIGN KEY([AssociatedAddOnSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgSalesCode2]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_lkpCenterBusinessType] FOREIGN KEY([CenterBusinessTypeID])
REFERENCES [dbo].[lkpCenterBusinessType] ([CenterBusinessTypeID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_lkpCenterBusinessType]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipAddOnStatus] FOREIGN KEY([AssociatedAddOnNewClientMembershipAddOnStatusID])
REFERENCES [dbo].[lkpClientMembershipAddOnStatus] ([ClientMembershipAddOnStatusID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipAddOnStatus]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipStatus] FOREIGN KEY([CurrentMembershipStatusID])
REFERENCES [dbo].[lkpClientMembershipStatus] ([ClientMembershipStatusID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipStatus]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipStatus_ReplaceCurrent] FOREIGN KEY([ReplaceCurrentClientMembershipStatusID])
REFERENCES [dbo].[lkpClientMembershipStatus] ([ClientMembershipStatusID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipStatus_ReplaceCurrent]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipStatus1] FOREIGN KEY([NewMembershipStatusID])
REFERENCES [dbo].[lkpClientMembershipStatus] ([ClientMembershipStatusID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_lkpClientMembershipStatus1]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipRule_lkpMembershipRuleType] FOREIGN KEY([MembershipRuleTypeID])
REFERENCES [dbo].[lkpMembershipRuleType] ([MembershipRuleTypeID])
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_lkpMembershipRuleType]
GO
