/* CreateDate: 06/13/2013 13:19:48.377 , ModifyDate: 03/29/2014 06:13:43.203 */
GO
CREATE TABLE [dbo].[FactDeferredRevenueDetails](
	[DeferredRevenueHeaderKey] [int] NOT NULL,
	[DeferredRevenueDetailsKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Period] [datetime] NOT NULL,
	[Deferred] [money] NULL,
	[DeferredToDate] [money] NULL,
	[Revenue] [money] NULL,
	[RevenueToDate] [money] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Client_No] [int] NULL,
	[Member1_ID] [int] NULL,
	[CenterSSID] [int] NULL,
 CONSTRAINT [PK_FactDeferredRevenueDetails] PRIMARY KEY CLUSTERED
(
	[DeferredRevenueDetailsKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactDeferredRevenueDetails_Period] ON [dbo].[FactDeferredRevenueDetails]
(
	[Period] ASC
)
INCLUDE([DeferredRevenueHeaderKey],[Deferred],[Revenue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
