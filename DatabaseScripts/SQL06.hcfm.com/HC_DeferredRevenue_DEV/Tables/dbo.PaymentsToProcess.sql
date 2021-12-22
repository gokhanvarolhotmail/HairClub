/* CreateDate: 06/11/2013 14:42:26.487 , ModifyDate: 02/27/2020 07:31:51.110 */
GO
CREATE TABLE [dbo].[PaymentsToProcess](
	[DeferredRevenueHeaderKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[NetPayments] [money] NULL,
	[ClientKey] [int] NULL,
	[Period] [datetime] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_PaymentsToProcess_DeferredRevenueHeaderKeyClientMembershipKey] ON [dbo].[PaymentsToProcess]
(
	[DeferredRevenueHeaderKey] ASC,
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
