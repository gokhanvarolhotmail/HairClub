/* CreateDate: 06/11/2013 14:42:26.487 , ModifyDate: 03/29/2014 06:13:51.137 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentsToProcess](
	[DeferredRevenueHeaderKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[NetPayments] [money] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_PaymentsToProcess_DeferredRevenueHeaderKeyClientMembershipKey] ON [dbo].[PaymentsToProcess]
(
	[DeferredRevenueHeaderKey] ASC,
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
