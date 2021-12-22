/* CreateDate: 06/11/2013 14:53:05.947 , ModifyDate: 02/27/2020 07:27:31.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientsToProcess](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DeferredRevenueHeaderKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[MembershipKey] [int] NULL,
	[MembershipDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeferredAmount] [money] NULL,
	[MonthsRemaining] [int] NULL,
	[ClientMembershipStartDate] [datetime] NULL,
	[MembershipRateKey] [int] NULL,
	[MembershipRate] [money] NULL,
	[CenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[Period] [datetime] NULL,
 CONSTRAINT [PK_ClientsToProcess] PRIMARY KEY NONCLUSTERED
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [ix_ClientsToProcess_RowID] ON [dbo].[ClientsToProcess]
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
