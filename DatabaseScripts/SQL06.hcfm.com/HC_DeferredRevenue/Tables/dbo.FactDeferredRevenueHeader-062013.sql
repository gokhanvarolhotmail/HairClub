/* CreateDate: 06/04/2013 14:17:59.173 , ModifyDate: 06/04/2013 14:17:59.173 */
GO
CREATE TABLE [dbo].[FactDeferredRevenueHeader-062013](
	[DeferredRevenueHeaderKey] [int] IDENTITY(1,1) NOT NULL,
	[DeferredRevenueTypeID] [int] NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipRateKey] [int] NULL,
	[MonthsRemaining] [int] NULL,
	[Deferred] [money] NULL,
	[Revenue] [money] NULL,
	[DeferredToDate] [money] NULL,
	[RevenueToDate] [money] NULL,
	[TransferDeferredBalance] [bit] NULL,
	[DeferredBalanceTransferred] [money] NULL,
	[MembershipCancelled] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Client_No] [int] NULL,
	[Member1_ID] [int] NULL
) ON [PRIMARY]
GO
