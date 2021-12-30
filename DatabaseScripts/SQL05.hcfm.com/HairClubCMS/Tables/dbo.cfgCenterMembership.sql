/* CreateDate: 05/05/2020 17:42:40.420 , ModifyDate: 05/26/2020 17:20:18.263 */
GO
CREATE TABLE [dbo].[cfgCenterMembership](
	[CenterMembershipID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgCenterMembership_CenterID_MembershipID] ON [dbo].[cfgCenterMembership]
(
	[CenterID] ASC,
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
