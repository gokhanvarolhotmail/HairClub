CREATE TABLE [dbo].[cfgCenterMembership](
	[CenterMembershipID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[MembershipID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ContractPriceMale] [money] NULL,
	[ContractPriceFemale] [money] NULL,
	[NumRenewalDays] [int] NULL,
	[AgreementID] [int] NULL,
	[CanUseInHousePaymentPlan] [bit] NOT NULL,
	[DownpaymentMinimumAmount] [money] NULL,
	[MinNumberOfPayments] [int] NULL,
	[MaxNumberOfPayments] [int] NULL,
	[MinimumPaymentPlanAmount] [money] NULL,
	[DoesNewBusinessHairOrderRestrictionsApply] [bit] NOT NULL,
	[ValuationPrice] [money] NULL,
 CONSTRAINT [PK_cfgCenterMembership] PRIMARY KEY CLUSTERED
(
	[CenterMembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgCenterMembership_CenterID] ON [dbo].[cfgCenterMembership]
(
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgCenterMembership_MembershipID] ON [dbo].[cfgCenterMembership]
(
	[MembershipID] ASC
)
INCLUDE([CenterID],[ContractPriceMale],[ContractPriceFemale]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterMembership] ADD  DEFAULT ((0)) FOR [CanUseInHousePaymentPlan]
GO
ALTER TABLE [dbo].[cfgCenterMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembership_cfgAgreement] FOREIGN KEY([AgreementID])
REFERENCES [dbo].[cfgAgreement] ([AgreementID])
GO
ALTER TABLE [dbo].[cfgCenterMembership] CHECK CONSTRAINT [FK_cfgCenterMembership_cfgAgreement]
GO
ALTER TABLE [dbo].[cfgCenterMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembership_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterMembership] CHECK CONSTRAINT [FK_cfgCenterMembership_cfgCenter]
GO
ALTER TABLE [dbo].[cfgCenterMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembership_cfgMembership] FOREIGN KEY([MembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgCenterMembership] CHECK CONSTRAINT [FK_cfgCenterMembership_cfgMembership]
