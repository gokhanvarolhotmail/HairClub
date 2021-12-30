/* CreateDate: 09/30/2019 07:07:32.973 , ModifyDate: 10/01/2021 12:11:10.120 */
GO
CREATE TABLE [dbo].[token_updates](
	[token] [bigint] NOT NULL,
	[user_id] [int] NULL,
	[group_id] [bigint] NULL,
	[update_ts] [bigint] NOT NULL,
	[update_type] [smallint] NOT NULL,
	[subuserid] [bigint] NULL,
	[abaroute] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[account] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last4] [int] NULL,
	[expdate] [int] NULL,
	[flags] [bigint] NULL,
PRIMARY KEY CLUSTERED
(
	[token] ASC,
	[update_ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_token_updates_group_ts_type] ON [dbo].[token_updates]
(
	[group_id] ASC,
	[update_ts] ASC,
	[update_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_token_updates_ts_type] ON [dbo].[token_updates]
(
	[update_ts] ASC,
	[update_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_token_updates_user_ts_type] ON [dbo].[token_updates]
(
	[user_id] ASC,
	[update_ts] ASC,
	[update_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
