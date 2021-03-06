/* CreateDate: 10/01/2018 08:53:16.047 , ModifyDate: 10/01/2018 08:53:16.057 */
GO
CREATE TABLE [dbo].[users](
	[id] [int] NOT NULL,
	[subuserid] [bigint] NOT NULL,
	[m_username] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[m_password] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[m_active] [int] NOT NULL,
	[profile_id] [bigint] NOT NULL,
	[ismaster] [int] NOT NULL,
	[trantypes] [bigint] NOT NULL,
	[admintypes] [bigint] NOT NULL,
	[flags] [int] NOT NULL,
	[upd_ts] [bigint] NOT NULL,
	[lock_ts] [bigint] NOT NULL,
	[is_history] [int] NOT NULL,
	[num_failures] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[subuserid] ASC,
	[upd_ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_users_id] ON [dbo].[users]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_users_id_hist] ON [dbo].[users]
(
	[id] ASC,
	[is_history] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [i_users_user] ON [dbo].[users]
(
	[m_username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
