/* CreateDate: 04/26/2021 12:28:48.983 , ModifyDate: 04/26/2021 12:28:48.990 */
GO
CREATE TABLE [dbo].[skylink_limits](
	[user_id] [int] NOT NULL,
	[ts] [bigint] NOT NULL,
	[is_current] [tinyint] NOT NULL,
	[cnt] [bigint] NOT NULL,
	[request_user] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED
(
	[user_id] ASC,
	[ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_skylink_limits_user_current] ON [dbo].[skylink_limits]
(
	[user_id] ASC,
	[is_current] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
