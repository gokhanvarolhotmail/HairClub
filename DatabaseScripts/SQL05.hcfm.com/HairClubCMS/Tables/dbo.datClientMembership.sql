/* CreateDate: 05/05/2020 17:42:45.823 , ModifyDate: 05/05/2020 18:41:00.140 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembership_BeginDate_INCL] ON [dbo].[datClientMembership]
(
	[BeginDate] ASC
)
INCLUDE([ClientGUID],[CenterID],[MembershipID],[ClientMembershipStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [RP_datClientMembership_ClientGUIDINCLMembershipID] ON [dbo].[datClientMembership]
(
	[ClientGUID] ASC
)
INCLUDE([MembershipID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
