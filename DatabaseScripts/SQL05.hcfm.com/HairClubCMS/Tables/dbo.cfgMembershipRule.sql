/* CreateDate: 05/05/2020 17:42:44.590 , ModifyDate: 05/05/2020 18:28:47.067 */
GO
CREATE TABLE [dbo].[cfgMembershipRule](
	[MembershipRuleID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
ALTER TABLE [dbo].[cfgMembershipRule]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgMembershipRule_cfgMembershipRule] FOREIGN KEY([MembershipRuleID])
REFERENCES [dbo].[cfgMembershipRule] ([MembershipRuleID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[cfgMembershipRule] CHECK CONSTRAINT [FK_cfgMembershipRule_cfgMembershipRule]
GO
