/* CreateDate: 10/01/2018 08:53:16.787 , ModifyDate: 10/02/2019 09:19:06.113 */
GO
CREATE TABLE [dbo].[recurring](
	[token] [bigint] NOT NULL,
	[user_id] [int] NOT NULL,
	[m_type] [int] NOT NULL,
	[status] [int] NOT NULL,
	[cardtype] [int] NOT NULL,
	[abaroute] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[account] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last4] [int] NOT NULL,
	[expdate] [int] NOT NULL,
	[cardholdername] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[street] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[descr] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clientref] [bigint] NOT NULL,
	[bdate] [bigint] NOT NULL,
	[edate] [bigint] NOT NULL,
	[frequency] [int] NOT NULL,
	[installment_total] [int] NOT NULL,
	[amount] [int] NOT NULL,
	[last_run] [bigint] NOT NULL,
	[last_run_success] [bigint] NOT NULL,
	[last_run_id] [bigint] NOT NULL,
	[next_run] [bigint] NOT NULL,
	[installment_num] [int] NOT NULL,
	[origamount] [int] NOT NULL,
	[nextamount] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_last4] ON [dbo].[recurring]
(
	[last4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_type_stat_run] ON [dbo].[recurring]
(
	[m_type] ASC,
	[status] ASC,
	[next_run] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_user_exp] ON [dbo].[recurring]
(
	[user_id] ASC,
	[expdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_user_ref] ON [dbo].[recurring]
(
	[user_id] ASC,
	[clientref] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_user_status] ON [dbo].[recurring]
(
	[user_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_user_token] ON [dbo].[recurring]
(
	[user_id] ASC,
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_user_type] ON [dbo].[recurring]
(
	[user_id] ASC,
	[m_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
