/* CreateDate: 01/19/2009 15:39:33.117 , ModifyDate: 12/07/2021 16:20:16.007 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgMembership](
	[MembershipID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MembershipSortOrder] [int] NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegmentID] [int] NULL,
	[RevenueGroupID] [int] NULL,
	[GenderID] [int] NULL,
	[DurationMonths] [int] NULL,
	[ContractPrice] [money] NULL,
	[MonthlyFee] [money] NULL,
	[IsTaxableFlag] [bit] NULL,
	[IsDefaultMembershipFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsHairSystemOrderRushFlag] [bit] NOT NULL,
	[HairSystemGeneralLedgerID] [int] NULL,
	[DefaultPaymentSalesCodeID] [int] NOT NULL,
	[NumRenewalDays] [int] NULL,
	[NumDaysAfterCancelBeforeNew] [int] NULL,
	[CanCheckinForConsultation] [bit] NOT NULL,
	[MaximumHairSystemHairLengthValue] [int] NULL,
	[ExpectedConversionDays] [int] NULL,
	[MinimumAge] [int] NULL,
	[MaximumAge] [int] NULL,
	[MaximumLongHairAddOnHairLengthValue] [int] NULL,
	[BOSSalesTypeCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cfgMembership] PRIMARY KEY CLUSTERED
(
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembership_MembershipDescription] ON [dbo].[cfgMembership]
(
	[MembershipDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembership_MembershipDescriptionShort] ON [dbo].[cfgMembership]
(
	[MembershipDescriptionShort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembership_MembershipSortOrder] ON [dbo].[cfgMembership]
(
	[MembershipSortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  CONSTRAINT [DF_cfgMembership_ContractPrice]  DEFAULT ((0)) FOR [ContractPrice]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  CONSTRAINT [DF_cfgMembership_MonthlyFee]  DEFAULT ((0)) FOR [MonthlyFee]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  CONSTRAINT [DF_cfgMembership_IsTaxableFlag]  DEFAULT ((0)) FOR [IsTaxableFlag]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  CONSTRAINT [DF_cfgMembership_IsDefaultMembershipFlag]  DEFAULT ((0)) FOR [IsDefaultMembershipFlag]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  CONSTRAINT [DF_cfgMembership_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  DEFAULT ((0)) FOR [IsHairSystemOrderRushFlag]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  DEFAULT ((349)) FOR [DefaultPaymentSalesCodeID]
GO
ALTER TABLE [dbo].[cfgMembership] ADD  CONSTRAINT [DF_cfgMembership_CanCheckinForConsultation]  DEFAULT ((0)) FOR [CanCheckinForConsultation]
GO
ALTER TABLE [dbo].[cfgMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembership_cfgSalesCode] FOREIGN KEY([DefaultPaymentSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgMembership] CHECK CONSTRAINT [FK_cfgMembership_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembership_lkpBusinessSegment] FOREIGN KEY([BusinessSegmentID])
REFERENCES [dbo].[lkpBusinessSegment] ([BusinessSegmentID])
GO
ALTER TABLE [dbo].[cfgMembership] CHECK CONSTRAINT [FK_cfgMembership_lkpBusinessSegment]
GO
ALTER TABLE [dbo].[cfgMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembership_lkpGender] FOREIGN KEY([GenderID])
REFERENCES [dbo].[lkpGender] ([GenderID])
GO
ALTER TABLE [dbo].[cfgMembership] CHECK CONSTRAINT [FK_cfgMembership_lkpGender]
GO
ALTER TABLE [dbo].[cfgMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembership_lkpGeneralLedger] FOREIGN KEY([HairSystemGeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgMembership] CHECK CONSTRAINT [FK_cfgMembership_lkpGeneralLedger]
GO
ALTER TABLE [dbo].[cfgMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembership_lkpRevenueGroup] FOREIGN KEY([RevenueGroupID])
REFERENCES [dbo].[lkpRevenueGroup] ([RevenueGroupID])
GO
ALTER TABLE [dbo].[cfgMembership] CHECK CONSTRAINT [FK_cfgMembership_lkpRevenueGroup]
GO
