/* CreateDate: 03/26/2009 12:21:04.290 , ModifyDate: 12/07/2021 16:20:15.887 */
GO
CREATE TABLE [dbo].[datClientMembership](
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[Member1_ID_Temp] [int] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [int] NULL,
	[ContractPrice] [money] NULL,
	[ContractPaidAmount] [money] NULL,
	[MonthlyFee] [money] NULL,
	[BeginDate] [date] NULL,
	[EndDate] [date] NULL,
	[MembershipCancelReasonID] [int] NULL,
	[CancelDate] [datetime] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IsRenewalFlag] [bit] NULL,
	[IsMultipleSurgeryFlag] [bit] NULL,
	[RenewalCount] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipCancelReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasInHousePaymentPlan] [bit] NOT NULL,
	[NationalMonthlyFee] [money] NULL,
	[MembershipProfileTypeID] [int] NULL,
 CONSTRAINT [PK_datClientMembership] PRIMARY KEY CLUSTERED
(
	[ClientMembershipGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_CenterID] ON [dbo].[datClientMembership]
(
	[CenterID] ASC,
	[ClientMembershipIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_ClientGUID_IsActiveFlag_BeginDate] ON [dbo].[datClientMembership]
(
	[ClientGUID] ASC,
	[IsActiveFlag] DESC,
	[BeginDate] DESC
)
INCLUDE([MembershipID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_ClientMembershipGUID_MonthlyFee_MembershipID] ON [dbo].[datClientMembership]
(
	[ClientMembershipGUID] ASC,
	[MonthlyFee] ASC,
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_ClientMembershipIdentifier] ON [dbo].[datClientMembership]
(
	[ClientMembershipIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_ClientMembershipStatusID_ClientMembershipGUID_CenterID_MembershipID_ClientGUID] ON [dbo].[datClientMembership]
(
	[ClientMembershipStatusID] ASC,
	[ClientMembershipGUID] ASC,
	[CenterID] ASC,
	[MembershipID] ASC,
	[ClientGUID] ASC
)
INCLUDE([BeginDate],[EndDate],[MonthlyFee],[ContractPrice],[ContractPaidAmount],[HasInHousePaymentPlan]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_EndDate] ON [dbo].[datClientMembership]
(
	[EndDate] ASC
)
INCLUDE([ClientMembershipGUID],[ClientGUID],[MembershipID],[ClientMembershipStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_MembershipID] ON [dbo].[datClientMembership]
(
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_Misc] ON [dbo].[datClientMembership]
(
	[CenterID] ASC,
	[MembershipID] ASC,
	[ClientMembershipGUID] ASC,
	[ClientGUID] ASC,
	[BeginDate] ASC
)
INCLUDE([ContractPrice],[ContractPaidAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datClientMembership_ClientGUIDINCLMembershipID] ON [dbo].[datClientMembership]
(
	[ClientGUID] ASC
)
INCLUDE([MembershipID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  CONSTRAINT [DF_datClientMembership_ContractPrice]  DEFAULT ((0)) FOR [ContractPrice]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  CONSTRAINT [DF_datClientMembership_ContractPaidAmount]  DEFAULT ((0)) FOR [ContractPaidAmount]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  CONSTRAINT [DF_datClientMembership_MonthlyFee]  DEFAULT ((0)) FOR [MonthlyFee]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  CONSTRAINT [DF_datClientMembership_IsGuaranteeFlag]  DEFAULT ((0)) FOR [IsGuaranteeFlag]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  CONSTRAINT [DF_datClientMembership_IsRenewalFlag]  DEFAULT ((0)) FOR [IsRenewalFlag]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  CONSTRAINT [DF_datClientMembership_IsMultipleSurgeryFlag]  DEFAULT ((0)) FOR [IsMultipleSurgeryFlag]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  CONSTRAINT [DF_datClientMembership_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[datClientMembership] ADD  DEFAULT ((0)) FOR [HasInHousePaymentPlan]
GO
ALTER TABLE [dbo].[datClientMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_ClientMembership_Client] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_ClientMembership_Client]
GO
ALTER TABLE [dbo].[datClientMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientMembership_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_cfgCenter]
GO
ALTER TABLE [dbo].[datClientMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientMembership_cfgMembership] FOREIGN KEY([MembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_cfgMembership]
GO
ALTER TABLE [dbo].[datClientMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientMembership_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_datClient]
GO
ALTER TABLE [dbo].[datClientMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientMembership_lkpClientMembershipStatus] FOREIGN KEY([ClientMembershipStatusID])
REFERENCES [dbo].[lkpClientMembershipStatus] ([ClientMembershipStatusID])
GO
ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_lkpClientMembershipStatus]
GO
ALTER TABLE [dbo].[datClientMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientMembership_lkpMembershipOrderReason] FOREIGN KEY([MembershipCancelReasonID])
REFERENCES [dbo].[lkpMembershipOrderReason] ([MembershipOrderReasonID])
GO
ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_lkpMembershipOrderReason]
GO
ALTER TABLE [dbo].[datClientMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientMembership_MembershipProfileTypeID] FOREIGN KEY([MembershipProfileTypeID])
REFERENCES [dbo].[lkpMembershipProfileType] ([MembershipProfileTypeID])
GO
ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_MembershipProfileTypeID]
GO
