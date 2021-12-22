/* CreateDate: 12/05/2012 11:21:39.777 , ModifyDate: 03/04/2020 00:00:10.020 */
GO
CREATE TABLE [dbo].[FactDeferredRevenueTransactions](
	[DeferredRevenueHeaderKey] [int] NOT NULL,
	[DeferredRevenueTransactionsKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[SalesOrderDetailKey] [int] NOT NULL,
	[SalesOrderDate] [datetime] NOT NULL,
	[SalesCodeKey] [int] NOT NULL,
	[SalesCodeDescriptionShort] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ExtendedPrice] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientKey] [int] NULL,
	[Period] [datetime] NULL,
 CONSTRAINT [PK_FactDeferredRevenueTransactions] PRIMARY KEY CLUSTERED
(
	[DeferredRevenueTransactionsKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactDeferredRevenueTransactions_DeferredRevenueHeaderKey] ON [dbo].[FactDeferredRevenueTransactions]
(
	[DeferredRevenueHeaderKey] ASC
)
INCLUDE([ClientMembershipKey],[SalesOrderDate],[SalesCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactDeferredRevenueTransactions_DeferredRevenueHeaderKeyAddtl] ON [dbo].[FactDeferredRevenueTransactions]
(
	[DeferredRevenueHeaderKey] ASC,
	[ClientMembershipKey] ASC,
	[SalesOrderDetailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactDeferredRevenueTransactions_SalesCodeKey] ON [dbo].[FactDeferredRevenueTransactions]
(
	[SalesCodeKey] ASC
)
INCLUDE([DeferredRevenueHeaderKey],[ClientMembershipKey],[SalesOrderDate],[ExtendedPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactDeferredRevenueTransactions_SalesOrderDate] ON [dbo].[FactDeferredRevenueTransactions]
(
	[SalesOrderDate] ASC
)
INCLUDE([DeferredRevenueHeaderKey],[ClientMembershipKey],[SalesCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactDeferredRevenueTransctions_ClientMembershipKey] ON [dbo].[FactDeferredRevenueTransactions]
(
	[ClientMembershipKey] ASC
)
INCLUDE([SalesCodeKey],[SalesOrderDate],[ExtendedPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
