/* CreateDate: 05/05/2020 17:42:40.367 , ModifyDate: 05/05/2020 18:40:59.300 */
GO
CREATE TABLE [dbo].[cfgMembership](
	[MembershipID] [int] NOT NULL,
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
	[UpdateStamp] [binary](8) NULL,
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
 CONSTRAINT [PK_cfgMembership_1] PRIMARY KEY NONCLUSTERED
(
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cfgMembership] ON [dbo].[cfgMembership]
(
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembership_MembershipDescription] ON [dbo].[cfgMembership]
(
	[MembershipDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembership_MembershipDescriptionShort] ON [dbo].[cfgMembership]
(
	[MembershipDescriptionShort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgMembership_MembershipSortOrder] ON [dbo].[cfgMembership]
(
	[MembershipSortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
