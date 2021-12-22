CREATE TABLE [dbo].[DetailsToProcess](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DeferredRevenueHeaderKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[SalesOrderDetailKey] [int] NULL,
	[SalesOrderDate] [datetime] NULL,
	[SalesCodeKey] [int] NULL,
	[SalesCodeDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExtendedPrice] [money] NULL,
 CONSTRAINT [PK_DetailsToProcess] PRIMARY KEY NONCLUSTERED
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [ix_DetailsToProcess_RowID] ON [dbo].[DetailsToProcess]
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
