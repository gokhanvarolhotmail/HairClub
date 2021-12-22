CREATE TABLE [dbo].[HeadersToProcess](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[CenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[MembershipKey] [int] NULL,
	[MembershipDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipRateKey] [int] NULL,
	[MonthsRemaining] [int] NULL,
 CONSTRAINT [PK_HeadersToProcess] PRIMARY KEY NONCLUSTERED
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [ix_HeadersToProcess_RowID] ON [dbo].[HeadersToProcess]
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
