/* CreateDate: 10/01/2018 08:53:16.800 , ModifyDate: 10/01/2018 08:53:16.807 */
GO
CREATE TABLE [dbo].[recurring_hist](
	[id] [bigint] NOT NULL,
	[token] [bigint] NOT NULL,
	[ts] [bigint] NOT NULL,
	[ttid] [bigint] NOT NULL,
	[code] [int] NOT NULL,
	[phard_code] [int] NOT NULL,
	[msoft_code] [int] NOT NULL,
	[verbiage] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_hist_token] ON [dbo].[recurring_hist]
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_hist_user] ON [dbo].[recurring_hist]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
