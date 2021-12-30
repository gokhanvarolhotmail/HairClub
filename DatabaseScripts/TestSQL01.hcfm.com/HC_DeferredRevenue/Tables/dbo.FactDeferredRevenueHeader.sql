/* CreateDate: 02/26/2013 16:56:51.900 , ModifyDate: 05/01/2015 23:16:15.820 */
GO
CREATE TABLE [dbo].[FactDeferredRevenueHeader](
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
	[Member1_ID] [int] NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [idx_FactDeferredRevenueHeader_DeferredRevenueHeaderKey] ON [dbo].[FactDeferredRevenueHeader]
(
	[DeferredRevenueHeaderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_FactDeferredRevenueHeader_DeferredRevenueTypeID] ON [dbo].[FactDeferredRevenueHeader]
(
	[DeferredRevenueTypeID] ASC,
	[CenterSSID] ASC,
	[ClientKey] ASC,
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
